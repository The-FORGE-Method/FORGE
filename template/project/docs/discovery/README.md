# Discovery Pack

**Structured discovery-to-spec methodology for this project.**

---

## Overview

Every FORGE project begins with Discovery. This folder captures the structured process of transforming raw inputs into actionable specifications.

> **FORGE Invariant:** "Every project has discovery; not every project has software."

---

## Stages

| Stage | Purpose | Output |
|-------|---------|--------|
| **1. Intake** | Capture all raw inputs | `intake/` folder populated |
| **2. Structure** | Organize into themes | `themes/` folder with categorized items |
| **3. Iterate** | Refine with stakeholder | Validated, prioritized themes |
| **4. Handoff** | Produce spec pack | `handoff/spec-pack.md` |

---

## Folder Structure

```
docs/discovery/
├── README.md              ← You are here
├── intake/                ← Raw inputs (transcripts, notes, screenshots)
│   └── .gitkeep
├── themes/                ← Organized themes
│   └── .gitkeep
└── handoff/               ← Final spec pack
    └── .gitkeep
```

---

## Intake

Place raw discovery inputs here:

| Input Type | What to Capture |
|------------|-----------------|
| Transcripts | Meeting notes, call recordings, chat logs |
| Sketches | Wireframes, napkin drawings, whiteboard photos |
| Screenshots | Existing systems, competitors, inspiration |
| Documents | Requirements docs, emails, briefs |
| Voice memos | Recorded thoughts, stakeholder interviews |

**Naming convention:** `YYYY-MM-DD-<source>-<brief-description>.<ext>`

Example: `2026-01-23-leo-kickoff-call-notes.md`

---

## Themes

After intake, organize into themes:

| Theme Type | Examples |
|------------|----------|
| **Features** | User stories, capabilities, workflows |
| **Constraints** | Technical limits, budget, timeline |
| **Unknowns** | Questions needing answers, assumptions to validate |
| **Risks** | Potential blockers, dependencies, concerns |

Create one file per major theme: `theme-<name>.md`

---

## Handoff

The handoff stage produces the **Spec Pack** — the exit artifact that enables implementation.

### Spec Pack Contents

```markdown
# Spec Pack: [Project Name]

## 1. North Star
[Single paragraph: what are we building and why]

## 2. Scope
### In Scope
- [Feature 1]
- [Feature 2]

### Explicitly Out of Scope
- [Non-goal 1]
- [Non-goal 2]

## 3. Key Decisions
[Numbered list of locked decisions with rationale]

## 4. Open Questions
[Any unresolved items requiring Human Lead input]

## 5. Readiness Checklist
- [ ] North Star approved
- [ ] Scope locked
- [ ] Key decisions documented
- [ ] Open questions resolved or explicitly deferred
- [ ] Human Lead greenlight obtained
```

---

## Readiness Checklist

Discovery is complete when:

- [ ] All intake materials processed
- [ ] Themes organized and validated
- [ ] Spec pack produced
- [ ] Human Lead has approved handoff
- [ ] Constitution documents are ready (for software projects)

**Do not proceed to Execute until this checklist is complete.**

---

## Agent Guidance

### Who Does What

| Role | Discovery Responsibility |
|------|-------------------------|
| **Human Lead** | Provides inputs, validates themes, approves handoff |
| **Strategist** | Helps structure themes, identifies gaps |
| **Quality Gate (CC)** | May assist with organization, does NOT make decisions |

### AI Assistance

Discovery is **agent-assisted, human-gated**:
- AI helps organize and categorize
- AI surfaces patterns and gaps
- AI does NOT make scope decisions
- Human Lead approves every stage transition

---

## Project-Specific Notes

[CUSTOMIZE: Add any project-specific discovery context here]

---

*This folder implements the FORGE Discovery Pack extension — see FORGE method documentation*
