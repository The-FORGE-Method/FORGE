# Build Plan

**Project:** [PROJECT_NAME]
**Architecture Packet:** `inbox/20_architecture-plan/[SLUG]/`
**Status:** [DRAFT | APPROVED | IN_PROGRESS | COMPLETE]
**Last Updated:** [DATE]

---

## Overview

[Brief description of what this Build Plan covers]

---

## Phases

### Phase 1: [PR-001 Title]

**Goal:** [One sentence]

**Files:**
- CREATE: `path/to/new/file.ts`
- MODIFY: `path/to/existing/file.ts`

**Dependencies:** None

**Approval Gate:** Phase completion confirmation

**Status:** [ ] Pending | [ ] In Progress | [ ] Complete

---

### Phase 2: [PR-002 Title]

**Goal:** [One sentence]

**Files:**
- CREATE: `path/to/file.ts`
- MODIFY: `path/to/file.ts`

**Dependencies:** PR-001 merged

**Approval Gate:** Phase completion confirmation

**Status:** [ ] Pending | [ ] In Progress | [ ] Complete

---

## Quality Gates

All phases must pass before PR merge approval:

- [ ] Typecheck (`npm run typecheck`)
- [ ] Lint (`npm run lint`)
- [ ] Tests (`npm run test`)
- [ ] Build (`npm run build`)

---

## Approval History

| Date | Checkpoint | Decision | Notes |
|------|------------|----------|-------|
| | Build Plan Approval | | |
| | Phase 1 Completion | | |
| | Phase 2 Completion | | |
| | Final PR Merge | | |

---

## Notes

[Any additional context, constraints, or considerations]

---

*Build Plan created by Ops Agent (G)*
