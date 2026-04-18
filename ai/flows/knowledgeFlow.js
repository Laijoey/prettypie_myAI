// flows/knowledgeFlow.js
// Knowledge base and search for government service FAQs and policies
import { ai } from '../ai.js';
import { z } from 'zod';

const GEMINI_MODEL = process.env.GEMINI_MODEL || 'googleai/gemini-2.5-flash';

// Knowledge base for Malaysian government services
const KNOWLEDGE_BASE = {
  str: {
    title: 'STR (Sumbangan Tunai Rakyat) - Cash Assistance',
    requirements: [
      'Monthly household income: RM4,000 or less',
      'Permanent resident or citizen with MyKad',
      'Age 18 years and above',
      'Not receiving other welfare assistance from government',
    ],
    benefits: 'RM200 cash assistance per eligible household member',
    application: 'Apply through online portal or at Community Centre',
    documents: 'MyKad, household income proof (payslip, bank statement)',
    duration: 'One-time assistance',
    contact: 'Visit e-Kasih or STR official portal',
  },
  ekasih: {
    title: 'eKasih - Welfare Assistance Programme',
    requirements: [
      'Household income below RM2,000 per month',
      'Malaysian citizen with valid MyKad',
      'Age 18 and above',
      'Not receiving other welfare benefits (B40 category)',
    ],
    benefits: 'RM300-500 monthly assistance, assistance for children/elderly',
    application: 'Register on eKasih portal with MyKad number',
    documents: 'MyKad, bank account details, household income proof',
    duration: 'Ongoing until income exceeds threshold',
    contact: 'https://www.eKasih.gov.my or Ministry of Women, Family & Community Development',
  },
  ptptn: {
    title: 'PTPTN Loan - Student Loan Programme',
    requirements: [
      'Full-time study in public/private universities or institutions',
      'Malaysian citizen',
      'Age 18-45 years',
      'SPM or equivalent qualification',
    ],
    benefits: 'Educational loan up to RM100,000 depending on course',
    repayment: 'Flexible repayment starting 6 months after graduation',
    waiving: {
      'Permanent disability': 'Full loan waived upon medical certification',
      'Lower income': 'Income-based repayment scheme (SKIM)',
      'Death': 'Loan waived for beneficiary',
      'Unemployment': 'Deferment up to 2 years if registered with JobsMalaysia',
    },
    application: 'Apply online through PTPTN portal during intake periods',
    documents: 'MyKad, academic records, parent income proof',
    contact: 'PTPTN Call Centre: 1300-88-5900 or https://www.ptptn.gov.my',
  },
  license: {
    title: 'Driving Licence Renewal (JPJ)',
    requirements: [
      'Current valid driving licence or expired less than 3 years',
      'Age 18+ for Class D/E, older for other classes',
      'Valid medical fitness (if required by age)',
      'No outstanding traffic summons',
    ],
    validity: {
      'Class D (Auto)': '5 years',
      'Class E (Motorcycle)': '5 years',
      'International': '3 years',
    },
    fee: 'RM60-90 depending on licence class and validity period',
    application: 'Apply at JPJ Counter or selected authorized agents',
    documents: 'Current licence, MyKad, passport/travel document, medical form (if required)',
    duration: '5 years for car/motorcycle, 3 years for international',
    contact: 'JPJ Headquarters: 03-7986 6666 or nearest JPJ office',
  },
  summons: {
    title: 'Traffic Summons Payment',
    requirements: [
      'Valid MyKad number',
      'Reference/summons number',
      'Being registered vehicle owner',
    ],
    payment: {
      'Online': 'JPJ portal, Pos Malaysia, Bank Islam, Maybank2u',
      'Counter': 'JPJ office, Post office',
      'E-payment': 'FPX, credit card, e-wallet via official portal',
    },
    lateFee: 'Additional late charges apply if payment overdue',
    discountPeriod: 'Up to 50% discount if paid within 30 days of issuance',
    convictionImpact: 'Non-payment may result in license suspension or vehicle impoundment',
    appeal: 'Appeal must be filed within 30 days of summons date at JPJ',
    contact: 'JPJ Traffic Enforcement: 03-7986 6666',
  },
  epf: {
    title: 'EPF (KWSP) - Employees Provident Fund',
    requirements: [
      'Malaysian citizen or permanent resident',
      'Age 18-60 years',
      'Employed and contributing to EPF',
      'Valid employee contribution account',
    ],
    benefits: 'Retirement savings, disability/death benefit, dividend payouts',
    contribution: 'Employee: 8%, Employer: 12% of monthly salary',
    withdrawal: {
      'Retirement (55+)': 'Full withdrawal of Account 1 (savings)',
      'Early withdrawal': 'Account 2 allowed for first home, education, medical',
      'i-Lestari': 'Special withdrawal scheme for those affected by pandemic',
    },
    interest: 'Annual dividend declared and credited to account',
    application: 'Registered automatically if employed',
    documents: 'MyKad, employment letter, bank account details',
    contact: 'KWSP Customer Service: 1300-55-5959 or https://www.kwsp.gov.my',
  },
  health: {
    title: 'Healthcare Services & Registration',
    requirements: [
      'Valid MyKad or travel document',
      'Age requirements vary by service',
      'No specific income requirement (subsidized by government)',
    ],
    services: [
      'Free government clinics and hospitals (subsidized)',
      'Vaccination programs',
      'Antenatal and postnatal care',
      'Chronic disease management (diabetes, hypertension)',
    ],
    coverage: 'Outpatient and inpatient services subsidized by government',
    registration: 'Register at nearest government clinic/health center',
    documents: 'MyKad, passport (for non-citizens)',
    emergency: 'Visit nearest hospital emergency department for urgent care',
    contact: 'Nearest government clinic/hospital or Health Ministry hotline',
  },
};

const knowledgeInputSchema = z.object({
  query: z.string().min(1).describe('User question about government services'),
  userProfile: z.record(z.any()).optional().describe('Optional user profile for personalized answers'),
});

// Match user query to relevant knowledge base category
function findRelevantTopics(query) {
  const lower = query.toLowerCase();
  const topicKeywords = {
    str: ['str', 'cash assistance', 'sumbangan tunai', 'rm200'],
    ekasih: ['ekasih', 'e-kasih', 'welfare', 'b40', 'rm2000', 'assistance'],
    ptptn: ['ptptn', 'loan', 'student', 'waiv', 'deferment', 'education'],
    license: ['license', 'lesen', 'driving', 'jpj', 'renewal', 'validity'],
    summons: ['summons', 'saman', 'traffic', 'ticket', 'fine', 'payment'],
    epf: ['epf', 'kwsp', 'provident', 'retirement', 'withdrawal', 'contribution'],
    health: ['health', 'medical', 'clinic', 'hospital', 'vaccine', 'healthcare'],
  };

  const matches = [];
  for (const [topic, keywords] of Object.entries(topicKeywords)) {
    if (keywords.some((kw) => lower.includes(kw))) {
      matches.push(topic);
    }
  }

  return matches.length > 0 ? matches : ['str', 'ekasih', 'ptptn']; // Default to welfare topics
}

// Format knowledge base entries into readable text
function formatKnowledgeEntry(topic) {
  const entry = KNOWLEDGE_BASE[topic];
  if (!entry) return null;

  let text = `**${entry.title}**\n\n`;

  if (entry.requirements) {
    text += `**Requirements:**\n`;
    entry.requirements.forEach((req) => {
      text += `• ${req}\n`;
    });
    text += '\n';
  }

  if (entry.benefits) {
    text += `**Benefits:** ${entry.benefits}\n\n`;
  }

  if (entry.fee) {
    text += `**Fee:** ${entry.fee}\n\n`;
  }

  if (entry.repayment) {
    text += `**Repayment:** ${entry.repayment}\n\n`;
  }

  if (entry.waiving) {
    text += `**Loan Waiving Conditions:**\n`;
    Object.entries(entry.waiving).forEach(([condition, description]) => {
      text += `• ${condition}: ${description}\n`;
    });
    text += '\n';
  }

  if (entry.application) {
    text += `**How to Apply:** ${entry.application}\n\n`;
  }

  if (entry.documents) {
    text += `**Required Documents:** ${entry.documents}\n\n`;
  }

  if (entry.contact) {
    text += `**Contact:** ${entry.contact}\n`;
  }

  return text;
}

export async function knowledgeFlow(input) {
  const { query, userProfile } = knowledgeInputSchema.parse(input);

  try {
    // 1. Find relevant knowledge base topics
    const relevantTopics = findRelevantTopics(query);
    
    // 2. Prepare knowledge context
    let knowledgeContext = '';
    for (const topic of relevantTopics) {
      const formatted = formatKnowledgeEntry(topic);
      if (formatted) {
        knowledgeContext += formatted + '\n---\n';
      }
    }

    // 3. Use AI to generate contextual answer
    const systemPrompt = `You are a helpful Malaysian government services assistant. 
Answer user questions about government services using the provided knowledge base.
Be accurate, friendly, and concise. If information is not in the knowledge base, say "I don't have this information, please contact the relevant department."
Format responses clearly with bullet points for lists.`;

    const response = await ai.generate({
      model: GEMINI_MODEL,
      system: systemPrompt,
      prompt: [
        {
          text: `Knowledge Base:\n\n${knowledgeContext}`,
        },
        {
          text: `User Question: ${query}\n\nProvide a clear, helpful answer based on the knowledge base.`,
        },
      ],
    });

    const answer = response.text.trim();

    // 4. Optionally suggest related service if applicable
    let suggestedService = null;
    const topicMap = {
      str: 'STR Application',
      ekasih: 'eKasih Assistance',
      ptptn: 'PTPTN Loan',
      license: 'License Renewal',
      summons: 'Summons Payment',
      epf: 'EPF Management',
      health: 'Health Services',
    };

    if (relevantTopics.length > 0) {
      suggestedService = topicMap[relevantTopics[0]];
    }

    return {
      answer,
      sources: relevantTopics.map((t) => KNOWLEDGE_BASE[t]?.title || t),
      suggestedService,
      confidence: relevantTopics.length > 0 ? 'high' : 'medium',
    };
  } catch (error) {
    console.error('Knowledge flow error:', error);
    return {
      answer:
        "I couldn't process your question. Please try asking about a specific service like STR, eKasih, PTPTN, or license renewal.",
      sources: [],
      suggestedService: null,
      confidence: 'low',
    };
  }
}
