# FORGE Template: CP Handoff Packet

**The Bridge from Genesis to Constitutional Documents**

**Version:** 1.0  
**Status:** First-Class Artifact  
**For:** Jordan's Project Genesis Knowledge Base

---

## Purpose

The CP Handoff Packet is what Genesis delivers to CP when Frame is complete. It contains everything CP needs to begin producing constitutional documents without returning to Genesis for clarification.

**A good handoff packet = CP can start Refine immediately.**

---

## When to Create

Create this packet when:
- [ ] Frame Artifact is complete and Leo-approved
- [ ] Leo says "ready for CP," "hand this to CP," or equivalent
- [ ] All critical open questions are resolved or documented

---

## Template

```markdown
# CP Handoff Packet: [Project Name]

**Date:** [YYYY-MM-DD]  
**From:** Jordan (Project Genesis)  
**To:** CP (Claude Project)  
**Status:** Ready for Refine

---

## 1. Project Identity

| Field | Value |
|-------|-------|
| **Project Name** | [Name] |
| **Project Type** | software / content / business / real_estate |
| **Codename** (if any) | [Optional internal name] |
| **Target Completion** | [Timeline if known] |
| **Leo Priority** | High / Medium / Low |

---

## 2. Frame Artifact

[Insert complete, approved Frame Artifact here — or link if stored elsewhere]

**Frame Version:** [e.g., 1.0]  
**Approved By:** Leo  
**Approval Date:** [YYYY-MM-DD]

---

## 3. Constitutional Documents Required

Based on project type, CP should produce:

### For Software Projects:
- [ ] North Star
- [ ] System Architecture  
- [ ] Data Model
- [ ] API Contract
- [ ] Engineering Playbook
- [ ] Execution Plan

### For Content Projects:
- [ ] North Star
- [ ] Content Architecture
- [ ] Chapter/Section Specs
- [ ] Style Guide
- [ ] Production Plan

### For Business Projects:
- [ ] North Star
- [ ] Deliverable Spec
- [ ] Production Plan

### For Real Estate Projects:
- [ ] North Star
- [ ] Deal Thesis
- [ ] Project Scope
- [ ] Financial Model
- [ ] Execution Plan

**Selected Set:** [List the specific docs needed for this project]

---

## 4. Key Decisions Made

Decisions locked during Frame that CP should treat as constraints:

| Decision | Rationale | Date |
|----------|-----------|------|
| [Decision 1] | [Why we chose this] | [Date] |
| [Decision 2] | [Why we chose this] | [Date] |
| [Decision 3] | [Why we chose this] | [Date] |

---

## 5. Constraints Identified

| Constraint | Type | Impact on Refine |
|------------|------|------------------|
| [Constraint 1] | Technical / Business / Timeline | [How it affects specs] |
| [Constraint 2] | Technical / Business / Timeline | [How it affects specs] |

---

## 6. Risks Flagged

| Risk | Likelihood | Mitigation Approach |
|------|------------|---------------------|
| [Risk 1] | High / Med / Low | [How to address] |
| [Risk 2] | High / Med / Low | [How to address] |

---

## 7. Open Questions for CP

Questions that need resolution during Refine:

| Question | Context | Suggested Owner |
|----------|---------|-----------------|
| [Question 1] | [Why it matters] | CP / Leo |
| [Question 2] | [Why it matters] | CP / Leo |

---

## 8. Research Summary

### Validation Performed
[Brief description of Perplexity research conducted, if any]

### Key Findings
- [Finding 1]
- [Finding 2]
- [Finding 3]

### Assumptions Validated
- [Assumption that research confirmed]

### Assumptions Still Unvalidated
- [Assumption we're proceeding with despite lack of validation]

---

## 9. Stakeholder Context

| Stakeholder | Role | Key Concern |
|-------------|------|-------------|
| [Person/Entity 1] | [Their role] | [What they care about] |
| [Person/Entity 2] | [Their role] | [What they care about] |

---

## 10. Tech Stack Preferences (Software Projects Only)

If Leo expressed preferences during Frame:

| Layer | Preference | Reason |
|-------|------------|--------|
| Framework | [e.g., Next.js 15] | [Why] |
| Database | [e.g., Supabase] | [Why] |
| Auth | [e.g., Supabase Auth] | [Why] |
| Hosting | [e.g., Vercel] | [Why] |
| Styling | [e.g., Tailwind + shadcn] | [Why] |

*Note: CP may refine these during System Architecture. These are starting points, not constraints unless marked as such.*

---

## 11. Related Projects

| Project | Relationship | Implication |
|---------|--------------|-------------|
| [Project name] | [How it relates] | [What CP should know] |

---

## 12. Handoff Checklist

Before sending to CP, verify:

- [ ] Frame Artifact is complete (all required sections)
- [ ] Frame Artifact is approved by Leo
- [ ] Project type is specified
- [ ] Constitutional docs list is correct for type
- [ ] Key decisions are documented
- [ ] Open questions have context
- [ ] No execution assumptions embedded

---

## 13. Next Steps

1. **CP:** Review this packet and confirm understanding
2. **CP:** Begin Refine phase — produce constitutional documents
3. **CP:** Escalate to Leo if Frame ambiguity blocks progress
4. **Leo:** Review and approve constitutional documents
5. **CP:** Prepare CC handoff when Refine is complete

---

## 14. Contact Protocol

**During Refine:**
- CP may request clarification from Jordan via Leo
- Jordan does NOT modify Frame Artifact without Leo approval
- Leo remains final authority on all scope questions

---

*Packet complete. CP may begin Refine.*
```

---

## Section Guide

### Required Sections (Always Include)
1. Project Identity
2. Frame Artifact
3. Constitutional Documents Required
4. Key Decisions Made
5. Open Questions for CP
6. Handoff Checklist
7. Next Steps

### Conditional Sections (Include If Applicable)
- Constraints Identified — If non-obvious constraints exist
- Risks Flagged — If risks were identified during Frame
- Research Summary — If Perplexity validation was performed
- Stakeholder Context — If external stakeholders are involved
- Tech Stack Preferences — Software projects only
- Related Projects — If interdependencies exist

---

## Quality Standards

A good CP Handoff Packet:

| Quality | Test |
|---------|------|
| **Complete** | CP can start Refine without asking Genesis basics |
| **Unambiguous** | No "it depends" without resolution path |
| **Constrained** | Decisions are clearly locked vs. open |
| **Typed** | Project type drives constitutional doc requirements |
| **Traceable** | Decisions have rationale documented |

---

## Common Failure Modes

| Failure | Symptom | Prevention |
|---------|---------|------------|
| Missing project type | CP doesn't know which docs to create | Always specify type |
| Unapproved Frame | Scope changes mid-Refine | Confirm Leo approval |
| Vague decisions | CP re-opens closed questions | Document rationale |
| No open questions section | CP assumes everything is resolved | Always include, even if empty |
| Tech stack as constraint | Locks CP unnecessarily | Mark as preference unless truly required |

---

## After Handoff

**Genesis responsibilities:**
- Remain available for clarification
- Do NOT modify Frame without Leo approval
- Do NOT begin new Frame for same project

**CP responsibilities:**
- Confirm receipt and understanding
- Begin Refine phase
- Escalate ambiguity to Leo, not Genesis

---

**© 2026 FORGE Contributors. All rights reserved.**

**FORGE™** is a trademark of its contributors.
