/**
 * Stakeholder AI Edge Function
 *
 * Stakeholder Interface AI (Foundational) - Day One constrained AI
 * See FORGE method documentation for the Stakeholder Interface extension.
 *
 * [CUSTOMIZE: Implement per project requirements]
 */

import { serve } from 'https://deno.land/std@0.177.0/http/server.ts';

// =============================================================================
// CONFIGURATION
// =============================================================================

const SYSTEM_PROMPT = `You are the Stakeholder Interface AI for this project.

Your role is to help stakeholders understand the project and capture their feedback.

You CAN:
- Explain the project's North Star and current status
- Answer questions about how features work
- Help stakeholders submit feedback, bugs, or feature requests
- Remember context from this conversation

You CANNOT:
- Execute any actions or tasks
- Access internal team documents
- Make promises about timelines or priorities
- Modify any data except capturing feedback

If asked to do something outside your capabilities, politely explain what you can help with instead.`;

// =============================================================================
// HANDLER
// =============================================================================

serve(async (req: Request) => {
  // CORS preflight
  if (req.method === 'OPTIONS') {
    return new Response(null, {
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'POST, OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
      },
    });
  }

  // Only allow POST
  if (req.method !== 'POST') {
    return new Response(JSON.stringify({ error: 'Method not allowed' }), {
      status: 405,
      headers: { 'Content-Type': 'application/json' },
    });
  }

  try {
    // [CUSTOMIZE: Add authentication check]
    // const authHeader = req.headers.get('Authorization');
    // if (!authHeader) {
    //   return new Response(JSON.stringify({ error: 'Unauthorized' }), {
    //     status: 401,
    //     headers: { 'Content-Type': 'application/json' },
    //   });
    // }

    // Parse request
    const { conversation_id, message } = await req.json();

    if (!message || typeof message !== 'string') {
      return new Response(JSON.stringify({ error: 'Message is required' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' },
      });
    }

    // [CUSTOMIZE: Implement LLM call]
    // This is a placeholder response
    const response = {
      conversation_id: conversation_id || crypto.randomUUID(),
      message: {
        role: 'assistant',
        content:
          'This is the Stakeholder AI placeholder. Implement LLM integration per project requirements.',
      },
    };

    return new Response(JSON.stringify(response), {
      status: 200,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
      },
    });
  } catch (error) {
    console.error('Stakeholder AI error:', error);
    return new Response(JSON.stringify({ error: 'Internal server error' }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
});
