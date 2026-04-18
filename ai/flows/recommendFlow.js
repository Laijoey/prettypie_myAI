// flows/recommendFlow.js
import { ai } from '../ai.js';
import { z } from 'zod';

const GEMINI_MODEL = process.env.GEMINI_MODEL || 'googleai/gemini-2.5-flash';

const recommendInputSchema = z.object({
  income: z.number(),
  age: z.number(),
  has_vehicle: z.boolean().optional().default(false),
  employment_status: z.string().optional().default('unknown'),
});

const recommendationSchema = z.object({
  service: z.string(),
  reason: z.string(),
  route: z.string(),
  priority: z.enum(['high', 'medium', 'low']),
});

const recommendOutputSchema = z.object({
  recommendations: z.array(recommendationSchema),
});

const serviceKnowledgeTool = ai.defineTool(
  {
    name: 'serviceKnowledgeLookup',
    description:
      'Get latest program details from Vertex AI Search knowledge source for recommendation rationale',
    inputSchema: z.object({ query: z.string() }),
    outputSchema: z.object({ snippet: z.string(), source: z.string() }),
  },
  async ({ query }) => {
    const endpoint = process.env.VERTEX_SEARCH_ENDPOINT;
    const token = process.env.VERTEX_SEARCH_BEARER_TOKEN;
    if (!endpoint || !token) {
      return {
        snippet:
          'Knowledge source not configured. Use static rules as fallback recommendation logic.',
        source: 'vertex-search-not-configured',
      };
    }
    try {
      const res = await fetch(endpoint, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${token}`,
        },
        body: JSON.stringify({ query }),
      });
      if (!res.ok) {
        return {
          snippet: `Lookup failed with status ${res.status}.`,
          source: 'vertex-search-error',
        };
      }
      const data = await res.json();
      return {
        snippet:
          data?.summary ||
          data?.answer ||
          data?.results?.[0]?.snippet ||
          'No additional policy notes found.',
        source: data?.results?.[0]?.source || 'vertex-ai-search',
      };
    } catch (error) {
      return {
        snippet: `Lookup failed: ${error.message}`,
        source: 'vertex-search-error',
      };
    }
  }
);

export async function recommendFlow(input) {
  const { income, age, has_vehicle, employment_status } =
    recommendInputSchema.parse(input);
  const response = await ai.generate({
    model: GEMINI_MODEL,
    tools: [serviceKnowledgeTool],
    prompt: `
      You are a Malaysian government services advisor.

      Citizen profile:
      - Monthly income: RM ${income}
      - Age: ${age}
      - Has vehicle: ${has_vehicle}
      - Employment status: ${employment_status}

      Based on real Malaysian government programs, recommend the most relevant services.
      
      Rules to follow:
      - STR aid → income below RM5000
      - eKasih → income below RM2000
      - RON95 subsidy → has vehicle
      - PTPTN → age between 18-40
      - Voter registration → age 18 and above
      - SOCSO claim → if unemployed or injured

      For uncertain policy details, call serviceKnowledgeLookup().
      Reply ONLY with a valid JSON array, no extra text:
      [
        {
          "service": "service name",
          "reason": "one sentence why this applies to them",
          "route": "/services/route",
          "priority": "high or medium or low"
        }
      ]
    `,
  });

  const text = response.text;
  const jsonMatch = text.match(/\[[\s\S]*\]/);
  let recommendations = [];
  try {
    if (jsonMatch) recommendations = z.array(recommendationSchema).parse(JSON.parse(jsonMatch[0]));
  } catch {}

  return recommendOutputSchema.parse({ recommendations });
}