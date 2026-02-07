# FORGE Template: Frame Artifact

**The Output of the Frame Phase**

**Version:** 1.2
**Status:** First-Class Artifact

---

## Purpose

Frame is the first FORGE phase. It answers: "What are we building and why?"

The Frame Artifact is the concrete output of this phase - a single document that captures intent before any technical work begins.

---

## When to Create

Create during **Frame phase**, before Orchestrate begins.

Frame is complete when:
- [ ] This document exists and is approved by Human Lead
- [ ] You can explain the product to a stranger in 60 seconds
- [ ] Non-goals are explicit (at least 3 items)
- [ ] Success criteria are measurable

---

## What Problem It Prevents

- Building the wrong thing
- Scope creep from day one
- Misaligned stakeholder expectations
- Technical decisions without business context
- "I thought we agreed..." conversations later

---

## Template

```markdown
# Frame: [Project Name]

**Version:** 1.0
**Date:** [YYYY-MM-DD]
**Status:** Draft | Under Review | Approved
**Author:** [Strategist agent or Human Lead]
**Approved By:** [Human Lead, date]

---

## The Problem

### What problem are we solving?
[2-3 sentences describing the pain point. Be specific about who feels this pain.]

### Why does this problem matter?
[Economic, operational, or human impact. Quantify if possible.]

### What happens if we don't solve it?
[The cost of inaction - status quo consequences.]

---

## The Solution

### What are we building?
[2-3 sentences describing the product/system. Focus on what it DOES, not how it works.]

### How does it solve the problem?
[Connect the solution directly to the problem statement above.]

### What makes this approach right?
[Why this solution vs. alternatives. Brief justification.]

---

## Users & Stakeholders

### Primary Users
| User Type | Description | Primary Need |
|-----------|-------------|--------------|
| [Type 1] | [Who they are] | [What they need from this] |
| [Type 2] | [Who they are] | [What they need from this] |

### Secondary Stakeholders
| Stakeholder | Interest |
|-------------|----------|
| [Stakeholder 1] | [What they care about] |
| [Stakeholder 2] | [What they care about] |

### Who is this NOT for?
- [Explicitly excluded user type 1]
- [Explicitly excluded user type 2]
- [Explicitly excluded user type 3]

---

## Scope

### What's IN (MVP)
| Capability | Description | Priority |
|------------|-------------|----------|
| [Capability 1] | [What it does] | Must Have |
| [Capability 2] | [What it does] | Must Have |
| [Capability 3] | [What it does] | Should Have |

### What's OUT (Explicit Non-Goals)
| Excluded Item | Reason |
|---------------|--------|
| [Feature/capability 1] | [Why it's out - be specific] |
| [Feature/capability 2] | [Why it's out - be specific] |
| [Feature/capability 3] | [Why it's out - be specific] |

### Scope Guardrails
These phrases trigger scope discussion, not automatic inclusion:
- "While we're at it..."
- "It would be easy to add..."
- "Users might also want..."
- "Future-proofing for..."

---

## Success Criteria

### How do we know it's working?

| Metric | Target | Measurement Method |
|--------|--------|-------------------|
| [Metric 1] | [Specific target] | [How we'll measure] |
| [Metric 2] | [Specific target] | [How we'll measure] |

### Definition of Done (MVP)
- [ ] [Concrete deliverable 1]
- [ ] [Concrete deliverable 2]
- [ ] [Concrete deliverable 3]
- [ ] Deployed to production
- [ ] Primary user can complete core workflow

---

## Constraints & Assumptions

### Known Constraints
| Constraint | Impact |
|------------|--------|
| [Technical constraint] | [How it affects scope/approach] |
| [Business constraint] | [How it affects scope/approach] |
| [Timeline constraint] | [How it affects scope/approach] |

### Key Assumptions
| Assumption | Risk if Wrong |
|------------|---------------|
| [Assumption 1] | [What happens if this is false] |
| [Assumption 2] | [What happens if this is false] |

---

## Open Questions

Questions that must be answered before Refine begins:

| Question | Owner | Due |
|----------|-------|-----|
| [Question 1] | [Who answers] | [When] |
| [Question 2] | [Who answers] | [When] |

---

## Business Context (Optional)

### Why now?
[Market timing, competitive pressure, opportunity window]

### Economic model
[How this creates or captures value - brief]

### Risk factors
| Risk | Likelihood | Mitigation |
|------|------------|------------|
| [Risk 1] | High/Med/Low | [How we address it] |

---

## Project Type & FORGE Adaptation

**Project Type:** [software | content | business | real_estate]

**Constitutional Documents Needed:**
[List based on project type]

- For **Software:** North Star, System Architecture, Data Model, API Contract, Engineering Playbook, Execution Plan
- For **Content:** North Star, Content Architecture, Chapter Specs, Style Guide, Production Plan
- For **Business:** North Star, Deliverable Spec, Production Plan
- For **Real Estate:** North Star, Deal Thesis, Project Scope, Financial Model, Execution Plan

---

## Approval

### Sign-off
- [ ] Human Lead has reviewed and approved
- [ ] All open questions are answered or deferred with rationale
- [ ] Scope is locked for Orchestrate/Refine phases

**Approved by:** ____________________
**Date:** ____________________

---

*Frame complete. Ready to proceed to Orchestrate.*
```

---

## Section Requirements

### Required (Must Include)
- The Problem
- The Solution
- Users & Stakeholders (including "NOT for")
- Scope (IN and OUT)
- Success Criteria
- Approval

### Conditional (Include If Applicable)
- Constraints & Assumptions - Include if non-obvious constraints exist
- Open Questions - Include if questions remain
- Business Context - Include for stakeholder-facing or investment projects
- Project Type & FORGE Adaptation - Always include for CP handoff

---

## Quality Checks Before Submission

Run through this checklist before presenting for approval:

- [ ] Problem section written first (before solution)
- [ ] "Who is NOT for" has at least 2 entries
- [ ] "What's OUT" has at least 3 entries
- [ ] Success criteria have specific, measurable targets
- [ ] Open questions have assigned owners
- [ ] Can explain in 60 seconds to a stranger

---

## Sizing Guidance

| Project Complexity | Frame Length |
|-------------------|--------------|
| Simple | 2-3 pages |
| Medium | 3-4 pages |
| Complex | 4-6 pages |

If longer than 6 pages, you're probably doing Refine work. Stop and check with Human Lead.

---

## Common Failure Modes

| Failure | Symptom | Prevention |
|---------|---------|------------|
| No explicit non-goals | Everything feels in scope | Force 3+ items in "What's OUT" |
| Vague success criteria | Can't tell when done | Require measurable targets |
| Missing "Who is NOT for" | Trying to serve everyone | Force explicit user exclusions |
| Solution before problem | Building wrong thing | Write problem section first |
| No approval gate | Scope creeps immediately | Require sign-off before Orchestrate |
| Open questions ignored | Surprises in Refine | List and assign owners |

---

## Transition to Orchestrate

When Frame is approved, the next steps are:

1. **Orchestrate** - Configure agents, establish roles
2. **Refine** - Produce constitutional documents
3. Frame Artifact becomes reference for all future scope discussions

The Frame Artifact is **read-only after approval**. Scope changes require:
1. Explicit Human Lead approval
2. Frame Artifact amendment with rationale
3. Impact assessment on downstream docs

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-04 | Initial template |
| 1.1 | 2026-01-04 | Added scope guardrails, failure modes, transition guidance |
| 1.2 | 2026-01-07 | Consolidated from forge-template-frame.md and forge-template-frame-artifact.md; added Project Type section, Quality Checks, Sizing Guidance |

---

**[UNIVERSAL]**

**(c) 2026 FORGE Contributors. All rights reserved.**

**FORGE(TM)** is a trademark of its contributors.
