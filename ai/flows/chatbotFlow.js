import { ai } from '../ai.js';
import { z } from 'zod';
import { knowledgeFlow } from './knowledgeFlow.js';

const GEMINI_MODEL = process.env.GEMINI_MODEL || 'googleai/gemini-2.5-flash';

const chatbotInputSchema = z.object({
  message: z.string().min(1),
  userProfile: z
    .object({
      fullName: z.string().optional(),
      icNumber: z.string().optional(),
      income: z.number().optional(),
      age: z.number().optional(),
    })
    .optional()
    .default({}),
});

const chatbotOutputSchema = z.object({
  reply: z.string(),
  toolsUsed: z.array(z.string()).default([]),
  action_label: z.string().nullable().default(null),
  action_route: z.string().nullable().default(null),
  workflow: z
    .object({
      current_step: z.enum(['chat', 'eligibility', 'apply']),
      eligibility: z
        .object({
          checked: z.boolean(),
          eligible: z.boolean().nullable(),
          reason: z.string().nullable(),
        })
        .default({ checked: false, eligible: null, reason: null }),
      application: z
        .object({
          submitted: z.boolean(),
          application_id: z.string().nullable(),
        })
        .default({ submitted: false, application_id: null }),
    })
    .default({
      current_step: 'chat',
      eligibility: { checked: false, eligible: null, reason: null },
      application: { submitted: false, application_id: null },
    }),
});

const knowledgeAnswerSchema = z.object({
  snippet: z.string(),
  source: z.string(),
});

function isKnowledgeQuestion(message = '') {
  const lower = message.toLowerCase();
  const patterns = [
    'what',
    'how',
    'requirement',
    'requirements',
    'eligible',
    'eligibility',
    'apply',
    'process',
    'document',
    'documents',
    't&c',
    'waiv',
    'clause',
    'syarat',
    'cara',
    'permohonan',
  ];
  return patterns.some((token) => lower.includes(token));
}

function inferActionFromQuery(message = '') {
  const lower = message.toLowerCase();
  if (lower.includes('ptptn') || lower.includes('loan') || lower.includes('student')) {
    return { label: 'PTPTN Loan Payment', route: '/services' };
  }
  if (lower.includes('license') || lower.includes('lesen') || lower.includes('jpj')) {
    return { label: 'License Renewal', route: '/services' };
  }
  if (lower.includes('summons') || lower.includes('saman') || lower.includes('traffic') || lower.includes('fine')) {
    return { label: 'Summons Payment', route: '/services' };
  }
  if (lower.includes('epf') || lower.includes('kwsp') || lower.includes('retirement')) {
    return { label: 'EPF Management', route: '/services' };
  }
  if (lower.includes('health') || lower.includes('medical') || lower.includes('clinic') || lower.includes('hospital')) {
    return { label: 'Health Services', route: '/services' };
  }
  if (lower.includes('str') || lower.includes('ekasih') || lower.includes('e-kasih')) {
    return { label: 'Open Services', route: '/services' };
  }
  return { label: null, route: null };
}

function stripMarkdownCodeFences(rawText) {
  const text = (rawText || '').trim();
  const fenced = text.match(/^```(?:json)?\s*([\s\S]*?)\s*```$/i);
  if (fenced) return fenced[1].trim();
  return text;
}

function extractJsonObject(rawText) {
  const cleaned = stripMarkdownCodeFences(rawText);
  const directObjectMatch = cleaned.match(/\{[\s\S]*\}/);
  return directObjectMatch ? directObjectMatch[0] : cleaned;
}

async function queryVertexSearch(query, userProfile = {}) {
  try {
    // Use our enhanced knowledge flow
    const result = await knowledgeFlow({ query, userProfile });
    return {
      snippet: result.answer,
      source: `Knowledge Base - ${(result.sources && result.sources[0]) || 'Government Services'}`,
      suggestedService: result.suggestedService,
    };
  } catch (error) {
    console.error('Knowledge search error:', error);
    return {
      snippet:
        'I encountered an issue retrieving information. Please try asking about STR, eKasih, PTPTN, License Renewal, or Summons Payment.',
      source: 'knowledge-search-error',
      suggestedService: null,
    };
  }
}

// ── Define Tools (functions the AI can CALL) ──────────────
const checkEligibilityTool = ai.defineTool(
  {
    name: 'checkEligibility',
    description: 'Check if a citizen is eligible for a government aid or service',
    inputSchema: z.object({
      service: z.string().describe('Service name e.g. STR, eKasih, RON95'),
      income: z.number().describe('Monthly income in RM'),
      age: z.number().describe('Age of citizen'),
    }),
    outputSchema: z.object({
      eligible: z.boolean(),
      reason: z.string(),
    }),
  },
  async ({ service, income, age }) => {
    // Simulate eligibility logic (Person 1 will replace with real DB call)
    if (service === 'STR' && income < 5000) {
      return { eligible: true, reason: `Income RM${income} is below RM5000 threshold` };
    }
    if (service === 'eKasih' && income < 2000) {
      return { eligible: true, reason: `Income RM${income} qualifies for hardcore poor aid` };
    }
    return { eligible: false, reason: `Does not meet criteria for ${service}` };
  }
);

const submitApplicationTool = ai.defineTool(
  {
    name: 'submitApplication',
    description: 'Submit a government service application on behalf of the citizen',
    inputSchema: z.object({
      service: z.string(),
      icNumber: z.string(),
      fullName: z.string(),
    }),
    outputSchema: z.object({
      applicationId: z.string(),
      status: z.string(),
      message: z.string(),
    }),
  },
  async ({ service, icNumber, fullName }) => {
    // Simulate submission (Person 1 replaces with real DB call)
    const appId = `APP-${Date.now()}`;
    return {
      applicationId: appId,
      status: 'pending',
      message: `Application ${appId} submitted for ${fullName} — ${service}`,
    };
  }
);

const checkSummonsTool = ai.defineTool(
  {
    name: 'checkSummons',
    description: 'Check outstanding summons for a vehicle or IC number',
    inputSchema: z.object({
      icOrPlate: z.string().describe('IC number or vehicle plate'),
    }),
    outputSchema: z.object({
      total: z.number(),
      summons: z.array(z.object({ id: z.string(), amount: z.number(), reason: z.string() })),
    }),
  },
  async ({ icOrPlate }) => {
    // Mock data — Person 4 replaces with real API
    return {
      total: 2,
      summons: [
        { id: 'SUM-001', amount: 150, reason: 'Speeding 80km/h in 60 zone' },
        { id: 'SUM-002', amount: 50, reason: 'Parking offence' },
      ],
    };
  }
);

const knowledgeSearchTool = ai.defineTool(
  {
    name: 'knowledgeSearch',
    description:
      'Retrieve government policy and service information from the knowledge base',
    inputSchema: z.object({
      query: z.string().describe('Question to search in the policy knowledge base'),
    }),
    outputSchema: z.object({
      snippet: z.string(),
      source: z.string(),
      suggestedService: z.string().nullable(),
    }),
  },
  async ({ query }, context) => {
    const userProfile = context?.userProfile || {};
    return queryVertexSearch(query, userProfile);
  }
);

// ── Agentic Chatbot Flow ──────────────────────────────────
export async function chatbotFlow(input) {
  const { message, userProfile } = chatbotInputSchema.parse(input);

  // Deterministic path for service/policy questions.
  // This guarantees the user gets an actual answer, not only a route suggestion.
  if (isKnowledgeQuestion(message)) {
    const knowledge = await queryVertexSearch(message, userProfile || {});
    const action = inferActionFromQuery(message);
    return chatbotOutputSchema.parse({
      reply: knowledge.snippet,
      toolsUsed: ['knowledgeSearch'],
      action_label: action.label,
      action_route: action.route,
      workflow: {
        current_step: 'chat',
        eligibility: { checked: false, eligible: null, reason: null },
        application: { submitted: false, application_id: null },
      },
    });
  }
  
  // Build service routing suggestions based on profile
  let serviceHint = '';
  const income = userProfile?.income || 0;
  const age = userProfile?.age || 0;
  
  if (income > 0 && income < 2000) {
    serviceHint = '\n- eKasih (welfare for income < RM2000)';
  }
  if (income > 0 && income < 5000) {
    serviceHint += '\n- STR (cash assistance for income < RM5000)';
  }
  if (age >= 18 && age <= 40) {
    serviceHint += '\n- PTPTN (student loan for age 18-40)';
  }
  if (age >= 18) {
    serviceHint += '\n- License Renewal (age 18+)';
  }
  
  const response = await ai.generate({
    model: GEMINI_MODEL,
    tools: [
      checkEligibilityTool,
      submitApplicationTool,
      checkSummonsTool,
      knowledgeSearchTool,
    ],
    prompt: `
      You are a smart Malaysian government assistant for SmartGOV portal.
      Your role: Help citizens with government services, answer policy questions, and guide them.
      
      User profile: ${JSON.stringify(userProfile)}
      User message: "${message}"
      
      Relevant services for this user:${serviceHint || '\n- All government services'}
      
      ROUTING LOGIC:
      1. If user asks "what", "how", "requirement", "T&C", "waiv", "clause", "eligible for", "process", "need", "apply for" → ALWAYS USE knowledgeSearch() tool FIRST
      2. Then in your reply, INCLUDE the full knowledge base answer from knowledgeSearch result
      3. If user also needs eligibility check → ALSO USE checkEligibility() tool
      4. If user mentions summons, traffic fine, or vehicle → USE checkSummons() tool
      5. After checks, if user wants to apply → suggest action_route to the service form
      
      SERVICE ROUTE MAPPING (for action_route field):
      - "STR" service → use "Loan Payment" form (Tax Filing has STR help)
      - "eKasih" service → use "Health Services" form or general /services
      - "PTPTN" or "student loan" → "/services" with label "PTPTN Loan Payment"
      - "license" or "license renewal" → "/services" with label "License Renewal"
      - "summons" or "traffic fine" → "/services" with label "Summons Payment"
      - "EPF" or "retirement" → "/services" with label "EPF Management"
      - "health" → "/services" with label "Health Services"
      
      EXAMPLES:
      - User: "what is STR requirement?" 
        → knowledgeSearch("STR requirement") 
        → reply includes full policy details from knowledge base
        → suggest "/services" with action_label "View STR Info"
      - User: "tell me about PTPTN waiving"
        → knowledgeSearch("PTPTN waiving conditions")
        → include full waiving conditions in reply
        → suggest "/services" with action_label "PTPTN Loan Payment"
      - User: "am I eligible for eKasih?"
        → knowledgeSearch("eKasih requirements") 
        → checkEligibility("eKasih", income, age)
        → reply includes both knowledge AND eligibility check result
      
      RESPONSE FORMAT (strict JSON, no code fences):
      {
        "reply": "Your helpful response to the user. MUST include full details from knowledge search if tool was used",
        "toolsUsed": ["toolName"],
        "action_label": "Button label to suggest action (or null)",
        "action_route": "Route to navigate or null",
        "workflow": {
          "current_step": "chat|eligibility|apply",
          "eligibility": {"checked": bool, "eligible": bool|null, "reason": string|null},
          "application": {"submitted": bool, "application_id": string|null}
        }
      }
      
      IMPORTANT:
      - Return ONLY valid JSON, no markdown or code fences
      - When using knowledgeSearch, MUST include the full answer from the tool result in your reply
      - DO NOT just return the service name - provide complete policy information
      - Match user language (English or Malay)
      - Proactively suggest relevant services based on profile
      - Use tool results to enhance your answer with actual details
      - Be empathetic and encouraging
    `,
  });

  const rawText = response.text ?? '{}';
  const text = extractJsonObject(rawText);
  let parsed;
  try {
    parsed = chatbotOutputSchema.parse(JSON.parse(text));
  } catch {
    parsed = chatbotOutputSchema.parse({
      reply: stripMarkdownCodeFences(rawText),
      toolsUsed: response.toolRequests?.map((t) => t.name) ?? [],
      action_label: null,
      action_route: null,
      workflow: {
        current_step: 'chat',
        eligibility: { checked: false, eligible: null, reason: null },
        application: { submitted: false, application_id: null },
      },
    });
  }

  if ((!parsed.toolsUsed || parsed.toolsUsed.length === 0) && response.toolRequests) {
    parsed.toolsUsed = response.toolRequests.map((t) => t.name);
  }

  return parsed;
}