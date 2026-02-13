# Proposal: Remove abc/ from Template + Replace with Progressive Gate Chain

**Date:** 2026-02-13
**Work-Item:** 2026-02-12-remove-abc-from-template
**Status:** AWAITING APPROVAL

---

## Summary

Remove the `abc/` directory from `template/project/` and replace the single `forge_entry` gate with a progressive 4-gate lifecycle chain. A.B.C is pre-project intake that occurs before spawning — it should not ship inside spawned projects. The new gate model enforces readiness at each FORGE phase (PRD Lock, Architecture Lock, Coherence Review, Execution Loop) with human-bypassable checkpoints.

---

## What Changes

| File | Action | Summary |
|------|--------|---------|
| `template/project/abc/*` | DELETE | Remove 4 files (README.md, 3 templates) and directory |
| `template/project/FORGE-AUTONOMY.yml` | UPDATE | Remove `forge_entry` section, add `lifecycle_gates` schema |
| `template/project/CLAUDE.md` | UPDATE | Remove abc/ references, document 4-gate model |
| `method/agents/forge-g-operating-guide.md` | UPDATE | Replace forge_entry logic with lifecycle_gates enforcement |
| `method/agents/forge-e-operating-guide.md` | UPDATE | Check Gate 4 (packet approved), not abc/FORGE-ENTRY.md |
| `.claude/skills/forge-f/SKILL.md` | UPDATE | Add Gate 1 enforcement (PRD Lock) |
| `.claude/skills/forge-o/SKILL.md` | UPDATE | Add Gate 2 enforcement (Architecture Lock) |
| `.claude/skills/forge-r/SKILL.md` | UPDATE | Add Gate 3 enforcement (Coherence Review) |
| `.claude/skills/forge-g/SKILL.md` | UPDATE | Replace forge_entry with 4-gate routing logic |
| `.claude/skills/forge-e/SKILL.md` | UPDATE | Enforce Gate 4 (packet approved) |
| `projects/.gitignore` | CREATE | Prevent project data syncing to FORGE repo |

---

## Gate Design

**Gate 0 — Spawn (Implicit)**
- Trigger: Project spawned from template
- Effect: FORGE agents available

**Gate 1 — PRD Lock**
- Owner: @F
- Artifact: `docs/constitution/PRODUCT.md`
- Requirements: description, actors, use_cases, mvp, success_criteria sections complete
- Blocks: @O cannot proceed until Gate 1 passes
- Bypass: "skip Gate 1"

**Gate 2 — Architecture Lock**
- Owner: @O
- Prerequisite: Gate 1 passed
- Artifact: `docs/constitution/TECH.md`
- Requirements: stack, data_model, build_plan sections complete
- Blocks: @R cannot proceed until Gate 2 passes
- Bypass: "skip Gate 2"

**Gate 3 — Coherence Review**
- Owner: @R
- Prerequisite: Gate 2 passed
- Requirements: PRODUCT ↔ TECH alignment verified, no unresolved conflicts
- Blocks: @G/@E cannot proceed until Gate 3 passes
- Bypass: "skip Gate 3"

**Gate 4 — Execution Loop**
- Owner: @G (creation) + @E (execution)
- Prerequisite: Gate 3 passed
- Artifact: Approved packet in `_forge/inbox/active/[slug]/packet.yml` with `approved: true`
- Blocks: @E cannot execute until packet approved
- Bypass: "skip Gate 4"

---

## Implementation Order

1. **DELETE abc/ directory** — Remove `template/project/abc/` (4 files)
2. **UPDATE FORGE-AUTONOMY.yml schema** — Remove `forge_entry` section, add `lifecycle_gates` schema
3. **UPDATE template CLAUDE.md** — Remove abc/ references, document 4-gate model
4. **UPDATE @F skill** — Add Gate 1 enforcement (PRD Lock)
5. **UPDATE @O skill** — Add Gate 2 enforcement (Architecture Lock)
6. **UPDATE @R skill** — Add Gate 3 enforcement (Coherence Review)
7. **UPDATE @G operating guide + skill** — Replace forge_entry with lifecycle_gates, add gate prerequisites to transitions
8. **UPDATE @E operating guide + skill** — Replace abc/FORGE-ENTRY.md with Gate 4 (packet approved)
9. **CREATE projects/.gitignore** — Prevent local project data syncing to FORGE repo

---

## Acceptance Criteria

**Deletion**
- [ ] `template/project/abc/` does NOT exist
- [ ] `ls template/project/abc/` returns "No such file or directory"

**FORGE-AUTONOMY.yml**
- [ ] `forge_entry` section removed
- [ ] `lifecycle_gates` section exists with 4 gates (gate_1_prd, gate_2_architecture, gate_3_coherence, gate_4_execution)
- [ ] YAML parses without errors

**Template CLAUDE.md**
- [ ] No references to `abc/`
- [ ] "Progressive Lifecycle Gates" section exists with all 4 gates documented
- [ ] Bypass mechanism documented
- [ ] Agent Lanes table includes @A, @B, @C (preserved)

**Agent Operating Guides**
- [ ] @G guide Section 6.1 shows `lifecycle_gates` schema (not `forge_entry`)
- [ ] @G guide Section 7.1a checklists check PRODUCT.md (not abc/FORGE-ENTRY.md)
- [ ] @G guide Section 7.4 transitions include Gate 1, Gate 2, Gate 3 prerequisites
- [ ] @E guide Section 5.5 checks Gate 4 (packet approved), not abc/FORGE-ENTRY.md
- [ ] No references to `abc/FORGE-ENTRY.md` in either guide

**Agent Skills**
- [ ] @F skill has "Gate 1 Enforcement" section
- [ ] @O skill has "Gate 2 Enforcement" section with Gate 1 prerequisite check
- [ ] @R skill has "Gate 3 Enforcement" section with Gate 2 prerequisite check
- [ ] @G skill describes 4-gate model, no reference to abc/FORGE-ENTRY.md
- [ ] @E skill enforces Gate 4 (packet approved), no reference to abc/FORGE-ENTRY.md

**projects/.gitignore**
- [ ] File exists with wildcard `*` and exceptions for `.gitignore`, `README.md`, `_registry.json`
- [ ] Test: Create `projects/test.txt` → `git status` does NOT show test.txt

**Preservation**
- [ ] A.B.C agents exist in `.claude/agents/`
- [ ] A.B.C skills exist in `.claude/skills/`
- [ ] No changes to `method/core/`

**Smoke Test**
- [ ] Spawn template → @F blocks if PRODUCT.md incomplete
- [ ] @O blocks if Gate 1 not met
- [ ] @R blocks if Gate 2 not met
- [ ] @G blocks if Gate 3 not met
- [ ] @E blocks if packet not approved
- [ ] Bypass works: "skip Gate N" allows progression

---

## Risks

| Risk | Mitigation |
|------|------------|
| **Gate logic creates deadlocks** | Gates are progressive (each requires previous), not circular. Gate 0 (spawn) is implicit. Bypass mechanism always available. |
| **A.B.C agents mistakenly removed** | Preserve `.claude/agents/forge-[abc].md` and `.claude/skills/forge-[abc]/`. Add preservation criteria to acceptance checklist. A.B.C agents remain for feature-level intake. |
| **Existing projects break** | Changes only affect `template/project/`. Existing projects in `projects/` are grandfathered (keep abc/ if present). No backward-incompatible changes. |

---

## Out of Scope

- NO changes to `method/core/` (canon)
- NO deletion of A.B.C agents or skills (preserved for feature-level intake)
- NO changes to `template/project/src/`, `tests/`, or `supabase/`
- NO runtime YAML parsing (gates enforced via hardcoded logic; YAML is documentation)
- NO migration of existing projects (grandfathered)
- NO changes to A.B.C workflow or output formats
- NO updates to `.claude/agents/` files (gating logic lives in skills)

---

## Decision Required

**Approve** to implement this proposal.

**Reject** with feedback if any requirement is unclear or needs revision.

Approval unlocks 9-phase implementation with 15 binary PASS/FAIL acceptance criteria.
