# Stakeholder Portal

**First-party visibility and feedback interface.**

---

## Overview

The Stakeholder Portal provides stakeholders with:
- Project visibility (North Star, phases, milestones)
- Feedback submission (bugs, features, questions)
- AI assistance for questions
- Upvote-based voting

See FORGE method documentation for the Stakeholder Interface extension.

---

## Page Structure

```
src/app/portal/
├── README.md           ← You are here
├── page.tsx            ← Portal dashboard
├── layout.tsx          ← Portal layout (auth gated)
├── feedback/
│   ├── page.tsx        ← Feedback list
│   └── new/
│       └── page.tsx    ← New submission form
├── ai/
│   └── page.tsx        ← AI assistant interface
└── (components)/
    └── ...             ← Portal-specific components
```

---

## Access Control

Portal access requires:
1. Authenticated user (identity phase)
2. Organization context (context phase)
3. Any role in the organization

All stakeholders can:
- View portal content
- Submit feedback
- Vote on submissions
- Chat with AI assistant

---

## AI Assistant

The portal includes the **Stakeholder Interface AI (Foundational)** — a constrained AI that:

| Allowed | NOT Allowed |
|---------|-------------|
| Explain North Star, phases, milestones | Execute tasks |
| Answer stakeholder questions | Activate work or prioritize |
| Capture feedback | Access internal docs |
| Learn stakeholder context | Mutate data (except feedback) |

The AI is explanatory + intake only. Execution capabilities (FAI) are separate and maturity-gated.

---

## Feedback Lifecycle

```
Created → Open → Triaged → Planned → Resolved
                       ↘ Won't Fix
```

| Status | Meaning |
|--------|---------|
| **Open** | New submission, not yet reviewed |
| **Triaged** | Team has reviewed, categorized |
| **Planned** | Scheduled for implementation |
| **Resolved** | Completed or addressed |
| **Won't Fix** | Declined with explanation |

---

## Implementation Notes

1. **Org-scoped:** All portal data is scoped to current organization
2. **RLS enforced:** Database policies control access
3. **Upvote only:** No downvotes; simple signal aggregation
4. **All submissions visible:** Stakeholders see all org submissions

---

*Implements FORGE Stakeholder Interface extension*
