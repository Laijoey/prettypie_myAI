// flows/ocrFlow.js
import { ai } from '../ai.js';
import { z } from 'zod';

const GEMINI_MODEL = process.env.GEMINI_MODEL || 'googleai/gemini-2.5-flash';

function normalizeBase64(value) {
  return value
    .replace(/\u0000/g, '')
    .replace(/\s+/g, '')
    .replace(/[^A-Za-z0-9+/=]/g, '');
}

const ocrInputSchema = z.object({
  imageBase64: z
    .union([
      z.string(),
      z.object({
        value: z.string(),
      }),
    ])
    .transform((val) => (typeof val === 'string' ? val : val.value))
    .transform((val) => normalizeBase64(val))
    .pipe(z.string().min(1)),
  mimeType: z.string().min(1).transform((v) => v.trim()),
});

const extractedDocSchema = z.object({
  ic_number: z.string().nullable(),
  full_name: z.string().nullable(),
  address: z.string().nullable(),
  income: z.string().nullable(),
  dob: z.string().nullable(),
  phone: z.string().nullable(),
  email: z.string().nullable(),
  gender: z.string().nullable(),
  nationality: z.string().nullable(),
  tax_id: z.string().nullable(),
  employer_name: z.string().nullable(),
  document_number: z.string().nullable(),
});

async function callDocumentAI({ imageBase64, mimeType }) {
  const endpoint = process.env.DOCUMENT_AI_ENDPOINT;
  const token = process.env.DOCUMENT_AI_BEARER_TOKEN;
  if (!endpoint || !token) return null;

  try {
    const res = await fetch(endpoint, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify({
        rawDocument: {
          mimeType,
          content: imageBase64,
        },
      }),
    });
    if (!res.ok) return null;
    const data = await res.json();
    return data?.document || null;
  } catch {
    return null;
  }
}

function mapDocAiToFields(document) {
  const entities = Array.isArray(document?.entities) ? document.entities : [];
  const getEntity = (keys) => {
    const hit = entities.find((e) => keys.includes((e.type || '').toLowerCase()));
    return hit?.mentionText ?? null;
  };
  return extractedDocSchema.parse({
    ic_number: getEntity(['ic_number', 'nric', 'id_number']),
    full_name: getEntity(['full_name', 'name']),
    address: getEntity(['address']),
    income: getEntity(['income', 'salary']),
    dob: getEntity(['date_of_birth', 'dob']),
    phone: getEntity(['phone', 'phone_number', 'mobile']),
    email: getEntity(['email']),
    gender: getEntity(['gender', 'sex']),
    nationality: getEntity(['nationality']),
    tax_id: getEntity(['tax_id', 'tin', 'tax_identification_number']),
    employer_name: getEntity(['employer', 'employer_name', 'company_name']),
    document_number: getEntity(['document_number', 'reference_number']),
  });
}

export async function ocrFlow(input) {
  const { imageBase64, mimeType } = ocrInputSchema.parse(input);
  const docAiDocument = await callDocumentAI({ imageBase64, mimeType });
  let extracted = {
    ic_number: null,
    full_name: null,
    address: null,
    income: null,
    dob: null,
    phone: null,
    email: null,
    gender: null,
    nationality: null,
    tax_id: null,
    employer_name: null,
    document_number: null,
  };

  if (docAiDocument) {
    extracted = mapDocAiToFields(docAiDocument);
  } else {
  const response = await ai.generate({
    model: GEMINI_MODEL,
    prompt: [
      {
        media: {
          contentType: mimeType,
          url: `data:${mimeType};base64,${imageBase64}`,
        },
      },
      {
        text: `
          This is a Malaysian government document (IC or payslip).
          Extract all available fields and reply ONLY with this exact JSON, no extra text:
          {
            "ic_number": "XXXXXX-XX-XXXX or null",
            "full_name": "name or null",
            "address": "full address or null",
            "income": "RM amount or null",
            "dob": "date of birth or null",
            "phone": "phone number or null",
            "email": "email or null",
            "gender": "gender or null",
            "nationality": "nationality or null",
            "tax_id": "tax id / tin or null",
            "employer_name": "employer name or null",
            "document_number": "document/reference number or null"
          }
        `,
      },
    ],
  });

  const text = response.text;
  const jsonMatch = text.match(/\{[\s\S]*\}/);
  try {
      if (jsonMatch) extracted = extractedDocSchema.parse(JSON.parse(jsonMatch[0]));
  } catch {}
  }

  // Auto-fill object used by frontend forms and application APIs
  const autoFill = {
    applicant_name: extracted.full_name,
    applicant_ic: extracted.ic_number,
    applicant_address: extracted.address,
    applicant_income: extracted.income,
    applicant_dob: extracted.dob,
    applicant_phone: extracted.phone,
    applicant_email: extracted.email,
    applicant_gender: extracted.gender,
    applicant_nationality: extracted.nationality,
    applicant_tax_id: extracted.tax_id,
    applicant_employer_name: extracted.employer_name,
    applicant_document_number: extracted.document_number,
  };

  return {
    provider: docAiDocument ? 'document-ai' : 'gemini-vision-fallback',
    extracted,
    autoFill,
  };
}