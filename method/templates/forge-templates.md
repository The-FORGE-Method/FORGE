# FORGE Templates

**First-Class Artifacts for The FORGE Method™**

**Version:** 1.1  
**Status:** Operational Reference

---

## Overview

Templates are not appendices — they are how FORGE is actually used. Each template includes:
- When to use it
- What problem it prevents
- Common failure modes

---

## Template 1: Task Brief

### When to Use
Every FORGE Cycle iteration. Quality Gate creates one task brief per PR.

### What Problem It Prevents
- Vague implementations
- Scope creep
- Missing functionality
- Rework cycles

### Template

```markdown
# Task Brief: PR-[XX] — [Name]

**Created:** [YYYY-MM-DD]
**Author:** [Quality Gate agent]
**Status:** Active

---

## Objective
[One sentence: what this PR accomplishes. Be specific.]

## Pre-Flight Checklist
- [ ] Previous PR merged to main
- [ ] Local branch created from latest main
- [ ] All dependencies available
- [ ] No blocking issues from previous work
- [ ] Constitutional docs reviewed for relevant sections

## Context
[2-3 sentences of background. What exists now? What's changing?]

### Relevant Specs
- API Contract: `docs/constitution/api-contract.md#[section]`
- Data Model: `docs/constitution/data-model.md#[section]`
- [Other relevant constitutional docs]

### Similar Existing Code
- `src/path/to/similar/implementation.ts` — [why it's relevant]

## Implementation Steps
1. [Specific, actionable step]
2. [Specific, actionable step]
3. [Specific, actionable step]
4. [Continue as needed]

## Files to Create
| File Path | Purpose |
|-----------|---------|
| `src/path/to/new/file.ts` | [What it does] |
| `src/path/to/another/file.ts` | [What it does] |

## Files to Modify
| File Path | Changes |
|-----------|---------|
| `src/path/to/existing/file.ts` | [What changes] |

## Acceptance Criteria
- [ ] [Specific, verifiable criterion]
- [ ] [Specific, verifiable criterion]
- [ ] [Specific, verifiable criterion]
- [ ] All TypeScript types pass
- [ ] All tests pass
- [ ] Build succeeds
- [ ] Lint passes with no new errors

## HAT (Human Acceptance Test)
After implementation, Human will verify by:
1. [Step Human takes]
2. [Expected result]
3. [Step Human takes]
4. [Expected result]

## Do NOT
- Do not modify files outside the scope listed above
- Do not add new dependencies without explicit approval
- Do not refactor unrelated code
- Do not implement features not specified in this brief
- Do not change existing test structure
- [Add project-specific constraints]

## Notes
[Any additional context, warnings, or considerations]

---

**End of Brief**
```

### Common Failure Modes

| Failure | Symptom | Prevention |
|---------|---------|------------|
| Vague objective | Implementation doesn't match intent | One specific sentence |
| Missing "Do NOT" | Scope creep, unexpected changes | Always include constraints |
| No file list | Wrong files modified | Explicit paths |
| No similar code reference | Inconsistent patterns | Point to examples |
| Missing acceptance criteria | Unclear when done | Checkboxes for each criterion |

**[UNIVERSAL]**

---

## Template 2: Build Plan

### When to Use
One per project. Quality Gate maintains throughout Execute phase.

### What Problem It Prevents
- Lost state between sessions
- Duplicate work
- Skipped PRs
- Unclear progress

### Template

```markdown
# Build Plan — [Project Name]

**Last Updated:** [YYYY-MM-DD HH:MM]
**Current PR:** PR-[XX]
**Maintained By:** Quality Gate

---

## Quick Status
| Metric | Value |
|--------|-------|
| Total PRs | [N] |
| Completed | [N] |
| In Progress | [1] |
| Remaining | [N] |
| Blocked | [0/N] |

## Changelog
| Date | PR | Action | Notes |
|------|-----|--------|-------|
| [YYYY-MM-DD] | PR-01 | ✅ Merged | [Brief note] |
| [YYYY-MM-DD] | PR-02 | 🔄 Started | [Brief note] |

---

## PR Sequence

### Phase 0: Foundation
| PR | Name | Status | Dependencies | Estimate | Actual |
|----|------|--------|--------------|----------|--------|
| 0A | [Name] | ✅ | None | 1h | 45m |
| 0B | [Name] | ✅ | 0A | 1h | 1h |

### Phase 1: Core Features
| PR | Name | Status | Dependencies | Estimate | Actual |
|----|------|--------|--------------|----------|--------|
| 01 | [Name] | ✅ | 0B | 2h | 2h |
| 02 | [Name] | 🔄 | 01 | 2h | — |
| 03 | [Name] | ➡️ | 02 | 1.5h | — |
| 04 | [Name] | ⏳ | 03 | 2h | — |

### Phase 2: [Phase Name]
| PR | Name | Status | Dependencies | Estimate | Actual |
|----|------|--------|--------------|----------|--------|
| 05 | [Name] | ⏳ | 04 | 2h | — |

---

## Current Focus

### PR-02: [Name]
**Objective:** [What this PR accomplishes]
**Brief:** `inbox/active/pr-02-[slug].md`
**Started:** [YYYY-MM-DD HH:MM]
**Blockers:** None

**Progress:**
- [x] Task brief written
- [x] Implementation started
- [ ] Implementation complete
- [ ] Verification passed
- [ ] PR created
- [ ] Merged

---

## Blocked Items

| PR | Blocker | Since | Waiting On |
|----|---------|-------|------------|
| — | — | — | — |

*(None currently)*

---

## Decisions Log

| Date | Decision | Rationale | Made By |
|------|----------|-----------|---------|
| [Date] | [Decision] | [Why] | [Human/Agent] |

---

## Backlog (Unscheduled)

| Item | Priority | Notes |
|------|----------|-------|
| [Feature] | Medium | [Context] |

---

## Status Legend
| Marker | Meaning |
|--------|---------|
| ✅ | Complete and merged |
| 🔄 | In progress (current) |
| ➡️ | Next up |
| ⏳ | Pending |
| 🔴 | Blocked |
| ⚠️ | At risk |

---

**End of Build Plan**
```

### Common Failure Modes

| Failure | Symptom | Prevention |
|---------|---------|------------|
| Stale status | Wrong PR marked current | Update at each cycle start |
| Missing changelog | Lost history | Log every status change |
| No blockers section | Issues hidden | Explicit blocked items table |
| Unclear dependencies | Wrong order attempted | Explicit dependency column |

**[UNIVERSAL - status markers are CONTEXTUAL]**

---

## Template 3: Handoff Note

### When to Use
Implementation Engine creates after completing task brief. Bridges to Quality Gate.

### What Problem It Prevents
- Quality Gate doesn't know what was done
- Verification misses areas
- Context lost in handoff

### Template

```markdown
## Implementation Complete: PR-[XX] — [Name]

**Completed:** [YYYY-MM-DD HH:MM]
**Brief Reference:** `inbox/active/pr-[xx]-[slug].md`

---

### Summary
[2-3 sentences: What was built and any notable decisions]

### What Was Built
1. [Component/feature 1]
   - [Key detail]
2. [Component/feature 2]
   - [Key detail]
3. [Component/feature 3]

### Quality Checks Performed
| Check | Status | Notes |
|-------|--------|-------|
| TypeScript | ✅ Pass | No errors |
| Lint | ⚠️ Warnings | [N] pre-existing warnings |
| Tests | ✅ Pass | [N] tests, all passing |
| Build | ✅ Pass | — |

### Files Created
| File | Purpose |
|------|---------|
| `src/path/file.ts` | [Purpose] |

### Files Modified
| File | Changes |
|------|---------|
| `src/path/existing.ts` | [What changed] |

### Decisions Made During Implementation
- [Decision 1]: [Why]
- [Decision 2]: [Why]

### Potential Concerns
- [Any areas Quality Gate should examine closely]
- [Any deviations from brief]
- [Any assumptions made]

### Items NOT Implemented
- [Anything from brief that was skipped, with reason]

### Ready for Quality Gate Review
✅ Implementation complete per task brief
✅ All local checks passing
✅ Code committed and pushed

---

**End of Handoff**
```

### Common Failure Modes

| Failure | Symptom | Prevention |
|---------|---------|------------|
| "All tests pass" (false) | Quality Gate finds failures | Always run checks before claiming |
| Missing file list | Quality Gate reviews wrong files | Explicit created/modified tables |
| No decisions documented | Context lost | Log decisions made during implementation |
| Hidden concerns | Issues discovered late | Explicit "Potential Concerns" section |

**[UNIVERSAL]**

---

## Template 4: Escalation Note

### When to Use
When a blocker requires Human decision. Use for complex issues; simple escalations can be conversational.

### What Problem It Prevents
- Unclear what's being asked
- Missing context for decision
- No record of resolution

### Template

```markdown
## Escalation: [Brief Title]

**From:** [Agent role]
**To:** [Human Lead]
**Date:** [YYYY-MM-DD]
**Blocking:** PR-[XX] — [Name]
**Severity:** 🔴 Blocker | 🟠 High | 🟡 Medium

---

### Issue
[Clear, specific description of the problem]

### Context
[Background information needed to understand the issue]

### What I've Tried
1. [Attempted solution 1] — [Result]
2. [Attempted solution 2] — [Result]

### Options

**Option A: [Name]**
- Description: [What this option entails]
- Pros: [Benefits]
- Cons: [Drawbacks]
- Effort: [Low/Medium/High]

**Option B: [Name]**
- Description: [What this option entails]
- Pros: [Benefits]
- Cons: [Drawbacks]
- Effort: [Low/Medium/High]

**Option C: [Do nothing / Defer]**
- Description: [What happens if we defer]
- Pros: [Benefits]
- Cons: [Drawbacks]

### My Recommendation
[Which option I recommend and why]

### Decision Needed
[Specific question requiring yes/no or choice answer]

---

### Resolution
**Decision:** [To be filled by Human]
**Rationale:** [To be filled by Human]
**Date:** [To be filled]

---

**End of Escalation**
```

### Common Failure Modes

| Failure | Symptom | Prevention |
|---------|---------|------------|
| Vague issue | Human can't understand | Specific description |
| No options | Human must do analysis | Always provide options |
| Missing recommendation | Human guesses your preference | State your recommendation |
| No resolution captured | Decision lost | Fill in resolution section |

**[SITUATIONAL - formal template for complex issues, conversational for simple]**

---

## Template 5: Decision Log Entry

### When to Use
When Human makes a decision that affects implementation, especially if it differs from or clarifies constitutional documents.

### What Problem It Prevents
- Forgotten decisions
- Repeated discussions
- Inconsistent implementation

### Template

```markdown
## Decision: [Brief Title]

**Date:** [YYYY-MM-DD]
**Made By:** [Human Lead name]
**Context:** PR-[XX] or [General]
**Status:** ✅ Active | 🔄 Superseded by [ref]

### Question
[What question was asked]

### Decision
[The decision made]

### Rationale
[Why this decision was made]

### Implications
- [What this means for implementation]
- [What this means for future work]

### Affected Documents
- [ ] Update needed: [document name]
- [x] No document updates needed

---
```

### Common Failure Modes

| Failure | Symptom | Prevention |
|---------|---------|------------|
| No rationale | Can't understand why later | Always capture reasoning |
| Orphaned decision | Not linked to context | Include PR/context reference |
| No implications | Downstream confusion | Spell out what it means |

**[UNIVERSAL]**

---

## Template 6: Context Recovery Checklist

### When to Use
Start of every new session for Quality Gate agent.

### What Problem It Prevents
- Working on wrong PR
- Missing recent changes
- Duplicate work
- Lost context

### Template

```markdown
## Session Start Checklist

**Date:** [YYYY-MM-DD HH:MM]
**Agent:** [Quality Gate]

### 1. Identity Check (30 sec)
- [ ] Read project README / CLAUDE.md
- [ ] Confirm project name and purpose
- [ ] Note key commands

### 2. State Check (10 sec)
- [ ] Open build plan
- [ ] Identify current PR (🔄)
- [ ] Note what's next (➡️)

### 3. History Check (10 sec)
```bash
git log --oneline -5
```
- [ ] Confirm recent merges
- [ ] Verify on correct branch

### 4. Active Work Check (30 sec)
- [ ] Check `inbox/active/` for current brief
- [ ] Read brief if exists
- [ ] Check for pending handoff

### 5. Ready State
- [ ] I know what project this is
- [ ] I know what PR is current
- [ ] I know what to do next
- [ ] Total time: ~90 seconds

---

**Ready to proceed: ✅**
```

### Common Failure Modes

| Failure | Symptom | Prevention |
|---------|---------|------------|
| Skip identity check | Wrong project assumptions | Always read README first |
| Skip history check | Work on merged PR | Always check git log |
| Skip active work check | Miss in-progress task | Always check active/ folder |

**[UNIVERSAL]**

---

## Using These Templates

### Adaptation Guidelines

Templates are starting points. Adapt to your context:

- **Add sections** for project-specific needs
- **Remove sections** that don't apply
- **Modify language** to match your team's style
- **Preserve structure** for consistency

### What Not to Change

- The presence of "Do NOT" section in task briefs
- The verification checklist pattern
- The explicit file listing
- The status marker system (though markers can change)

### Version Control

Templates should be versioned with your project:
- Store in `inbox/templates/`
- Update when you learn better patterns
- Note changes in template headers

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-03 | Initial release |
| 1.1 | 2026-01-04 | Extracted as standalone artifact; added failure modes; added Context Recovery Checklist |

---

**© 2026 FORGE Contributors. All rights reserved.**

**FORGE™** is a trademark of its contributors.
