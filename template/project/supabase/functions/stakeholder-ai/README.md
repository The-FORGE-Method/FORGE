# Stakeholder AI Edge Function

**Stakeholder Interface AI (Foundational) — Day One AI capability.**

---

## Overview

This edge function provides the constrained AI assistant available to stakeholders from Day One. It implements the Stakeholder Interface AI per the FORGE method documentation.

---

## Capability Boundary

### Allowed (Day One)

| Capability | Description |
|------------|-------------|
| **Explain** | North Star, phases, milestones, current status |
| **Answer** | Stakeholder questions (read-only) |
| **Capture** | Feedback, bugs, features, questions |
| **Learn** | Stakeholder profile and context |

### NOT Allowed (Constrained)

| Restriction | Reason |
|-------------|--------|
| Execute tasks | Execution requires FAI (maturity-gated) |
| Activate work | Humans prioritize |
| Access internal docs | Stakeholder-facing only |
| Mutate data | Except feedback capture |

---

## Endpoint

```
POST /functions/v1/stakeholder-ai
```

### Request

```json
{
  "conversation_id": "uuid (optional, creates new if omitted)",
  "message": "User message text"
}
```

### Response

```json
{
  "conversation_id": "uuid",
  "message": {
    "role": "assistant",
    "content": "AI response text"
  }
}
```

---

## System Prompt

The AI operates under a constrained system prompt:

```
You are the Stakeholder Interface AI for [Project Name].

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

If asked to do something outside your capabilities, politely explain what you can help with instead.
```

---

## Implementation

### Files

| File | Purpose |
|------|---------|
| `index.ts` | Edge function entrypoint |
| `system-prompt.ts` | System prompt configuration |
| `context.ts` | Project context loader |

### Dependencies

- Supabase client for auth and data
- OpenAI/Anthropic API for LLM
- Project constitution for context

---

## Configuration

Environment variables required:

```env
# LLM Provider
OPENAI_API_KEY=sk-...
# or
ANTHROPIC_API_KEY=sk-ant-...

# Project context
PROJECT_NAME="Your Project"
```

---

## Security

1. **Auth Required:** User must be authenticated
2. **Org Context:** Must have valid org_id in session
3. **Role Check:** Any org role grants access
4. **Rate Limiting:** Implement per-user rate limits
5. **Audit Logging:** Log all conversations for review

---

*Implements FORGE Stakeholder Interface AI (Foundational)*
