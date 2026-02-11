# FORGE Hardening Diff Report

**Date:** 2026-02-10
**Work-Item:** forge-system-hardening
**Pipeline:** forge-rd (canon mode)
**Audit log:** `_workspace/99_archive/2026-02-10-forge-system-hardening/audit-log.md`
**Status:** Implemented, verified, archived. NOT committed.

---

## A. Executive Summary

This hardening release addresses 4 systemic failures discovered during the RecallTech BOLO project foundations reset:

1. **Stakeholder Portal Drift** — Agents combined stakeholders and product users into a single super-user plane instead of requiring an explicit architecture decision.
2. **Tests-First Canon Violation** — Multiple PRs shipped with zero test infrastructure. Sacred Four passed vacuously (zero tests = zero failures = "passing").
3. **Missing Structural Signals** — A project was created outside `FORGE/projects/` with no agent warning.
4. **Implicit vs Explicit Canon** — Agents optimized for forward motion without verifying preconditions.

**Root cause:** FORGE had strong declarative rules ("tests are mandatory") but weak procedural enforcement (no agent actually checked). The methodology told agents what to produce but not what to verify before producing.

**Solution:** 3 interlocking enforcement mechanisms:

| Mechanism | What It Does | Where Enforced |
|-----------|-------------|----------------|
| **Law 5a: Preconditions Are Hard Stops** | Agents must verify inputs before producing outputs | `forge-core.md` (canon law) |
| **@G Structural Verification** | Automatic scaffold check after @C, before @F | `forge-operations.md`, `forge-g` guide + skill |
| **Enforcement Matrix** | Single reference table: rule, agent, trigger, failure mode, bypass | `forge-operations.md` (14 rules) |

**Impact:** 16 files modified, 4 new templates, 727 insertions, 6 deletions. Backward-compatible via grandfathering policy.

---

## B. File-by-File Diff Highlights

### Canon (Highest Authority)

#### `method/core/forge-core.md` — v1.2 → v1.3 (+36 lines)

| Change | Lines | Purpose |
|--------|-------|---------|
| **Law 5a: Preconditions Are Hard Stops** | +19 | New canon law. "Precondition unknown = precondition failed. Zero tests = test gate failure, not pass." |
| **Explicit Architecture Decisions rule** | +10 | Auth planes, role scoping, stakeholder separation, test infra MUST have documented ADRs before implementation. |
| **Required Extensions enhancement** | +2 | Auth/RBAC now requires ADR. Stakeholder Interface now requires STAKEHOLDER-MODEL if planes differ. |
| **Version history entry** | +1 | v1.3 changelog line |

**Key quote (Law 5a):**
> An agent that cannot verify its preconditions MUST STOP. "Precondition unknown" is equivalent to "precondition failed." Zero tests is a test gate failure, not a test gate pass.

---

#### `method/core/forge-operations.md` — v1.1 → v1.3 (+139 lines)

| Change | Lines | Purpose |
|--------|-------|---------|
| **Section 1.4: @G Structural Verification** | +31 | 13-item checklist. Auto after @C, before @F. Produces preflight-checklist.md on pass, failure-report on fail. |
| **Section 2.1: Zero-test enforcement** | +2 | "The test step MUST execute at least one test. Zero tests is a Sacred Four FAILURE." |
| **Part 13: Enforcement Matrix** | +79 | 14-rule table (rule, agent, trigger, failure mode, bypass). Timeline diagram. Grandfathering policy. |
| **Grandfathering Policy** | +22 | Effective 2026-02-10. Existing projects exempt from new gates. Sacred Four zero-test NOT grandfathered. |
| **Version history entry** | +1 | v1.3 changelog line |

---

### Agent Operating Guides

#### `method/agents/forge-e-operating-guide.md` (+64 lines)

**Added Section 5.5: Pre-Flight Verification.** Four sequential checks before @E accepts any handoff:

| Check | Gate Type | Bypass |
|-------|-----------|--------|
| 1. Structure (CLAUDE.md, FORGE-AUTONOMY.yml, docs/, inbox/) | HARD STOP | None |
| 2. Test Infrastructure (framework, config, executing tests) | HARD STOP | `is_test_setup: true` (PR-000 only) |
| 3. Auth Readiness (ADR exists, stakeholder model if applicable) | HARD STOP | N/A if no auth in handoff |
| 4. Sacred Four Dry Run | WARN only | N/A |

On failure: produces `docs/ops/preflight-failure-[handoff-id].md`, returns to @G with status `blocked`.

---

#### `method/agents/forge-g-operating-guide.md` (+95 lines)

**Added Section 7.1a: Structural Verification After @C.** Full action sequence:
1. Check grandfathering (before 2026-02-10)
2. If grandfathered → skip, log, proceed
3. If not → run 13-item checklist
4. Pass → auto-generate `preflight-checklist.md`, route to @F
5. Fail → auto-generate `preflight-failure-report.md`, STOP

**Added Section 7.4: Transition-Specific Validation.** Per-transition gates:
- @C→@F: structural verification passed
- @F→@O: actor planes assigned, auth model decided
- @O→@E: auth ADR (if auth), test infra, handoff packet
- Universal: project location, router-events/, FORGE-AUTONOMY.yml

---

#### `method/agents/forge-o-operating-guide.md` (+41 lines)

**Added Completion Gate: Auth Architecture.** Two mandatory sections before TECH.md is complete:
1. Auth Architecture ADR (multi-user/multi-role projects)
2. Test Architecture (framework, coverage, Sacred Four commands, thresholds)

Exception: Single-user/single-role projects may skip auth ADR with documented rationale.

---

#### `method/agents/forge-product-strategist-guide.md` (+27 lines)

**Added Completion Gate: Required Decisions.** PRODUCT.md is NOT complete until:
- Every actor has explicit auth plane assignment
- "Are stakeholders and product users in the same auth plane?" is explicitly answered
- STAKEHOLDER-MODEL.md started if stakeholders exist

HARD STOP if auth plane decision not answered.

---

### Agent Skills (8 files)

#### All 8 agents: `forge-{a,b,c,e,f,g,o,r}/SKILL.md` (+18 lines each)

**Universal Startup Check** added to all agents:
1. Is project under `FORGE/projects/<slug>/`? If not, check for `external_project: true` waiver. No waiver → HARD STOP.
2. Does `FORGE-AUTONOMY.yml` exist? No → HARD STOP.

Exception: @A runs this as planning verification (not a gate).

#### Additional per-agent changes:

| Agent Skill | Extra Changes |
|-------------|---------------|
| `forge-e` | +13 lines: Pre-flight verification gates (structure, test infra, auth, Sacred Four) |
| `forge-f` | +12 lines: Auth plane completion gate (HARD STOP if incomplete) |
| `forge-g` | +18 lines: Structural verification after @C + transition-specific validation |
| `forge-o` | +13 lines: Auth ADR + test architecture completion gate |

---

### Templates (Method)

#### `method/templates/forge-template-testing-requirements.md` (+87 lines)

**Section 1.4: Zero-Test Clarification.** Explicit FAILURE/PASS examples showing:
- "No test files found" = FAILURE
- "0 tests found" = FAILURE
- Test runner executes and passes = PASS

**Section 1.5: PR-000 Exception.** First PR gets `is_test_setup: true` flag in handoff packet. Only PR-000 may use this. Delivery requirements: framework installed, one passing test, Sacred Four functional, test-infrastructure.md created.

---

#### `method/templates/forge-template-repository-scaffold.md` (+44 lines)

**Required Structure Verification section.** Lists mandatory directories/files:
- Mandatory (all): abc/FORGE-ENTRY.md, docs/constitution/, docs/adr/, docs/ops/state.md, router-events/, inbox/*, CLAUDE.md, FORGE-AUTONOMY.yml
- Mandatory (auth): STAKEHOLDER-MODEL.md, auth-architecture ADR
- Mandatory (code): tests/, test config, at least one test file, CI workflow, test-infrastructure.md

Grandfathering note included.

---

### Project Scaffold Templates (4 NEW files, 292 lines total)

| File | Lines | Purpose |
|------|-------|---------|
| `template/project/docs/constitution/STAKEHOLDER-MODEL.md.template` | 54 | Auth planes table, single vs multi-plane decision, role architecture, actor→plane mapping |
| `template/project/docs/adr/001-auth-architecture.md.template` | 88 | ADR format for auth decisions with validation checklist |
| `template/project/docs/ops/test-infrastructure.md.template` | 90 | Test framework, coverage, Sacred Four commands, thresholds |
| `template/project/docs/ops/preflight-checklist.md.template` | 60 | @G auto-generated structural verification report |

---

## C. New/Changed Enforcement Gates

### New Gates (14 total in Enforcement Matrix)

| # | Rule | Enforcing Agent | Failure Mode | Bypass |
|---|------|----------------|--------------|--------|
| 1 | Project under FORGE/projects/ | ALL (startup) | HARD STOP | `external_project: true` waiver |
| 2 | Template scaffold structure valid | @G | HARD STOP | None |
| 3 | Test framework installed | @E | HARD STOP | `is_test_setup: true` (PR-000) |
| 4 | At least one test exists | @E | HARD STOP | `is_test_setup: true` (PR-000) |
| 5 | Sacred Four passes with real tests | @E | HARD STOP | None |
| 6 | Auth architecture ADR exists | @G | HARD STOP | N/A if no auth |
| 7 | Stakeholder model defined | @F | HARD STOP | N/A if no stakeholders |
| 8 | Actor plane assignment explicit | @F | HARD STOP | None |
| 9 | Role scoping documented | @O | HARD STOP | None |
| 10 | Handoff packet exists | @E | HARD STOP | None |
| 11 | PR packet produced | @E | HARD STOP | None |
| 12 | Router events logged | @G | WARN | None |
| 13 | Coverage delta >= 0 | @E + CI | HARD STOP | None |
| 14 | FORGE-AUTONOMY.yml exists | ALL | HARD STOP | None |

### New Transition Gates (per-transition)

| Transition | Gate | New? |
|-----------|------|------|
| @C → @F | Structural verification passed | NEW |
| @F → @O | Actor planes assigned, auth model decided | NEW |
| @O → @E | Auth ADR, test infra, handoff packet | NEW |
| Universal | Project location, router-events, FORGE-AUTONOMY.yml | NEW |

---

## D. Risk Scan: Possible Friction / False Positives

### Risk 1: Auth gates on non-auth projects

**Concern:** Auth architecture ADR is mandatory for "multi-user or multi-role" projects. Could a simple two-user app trigger this unnecessarily?

**Mitigation:** Gate is conditional — single-user/single-role projects MAY skip with documented rationale. The conditional logic is explicit in @O's completion gate. @F only triggers if stakeholders exist.

**Friction level:** Low. The gate asks "is this multi-user?" — if no, skip with one line of documentation.

### Risk 2: Structural verification on rapid prototyping

**Concern:** 13-item structural checklist could slow down fast iterations early in a project.

**Mitigation:** Grandfathering exempts all existing projects. For new projects, @A (Acquire) creates the scaffold from `template/project/`, which already has all required directories. The check catches drift, not normal use.

**Friction level:** Low for template-scaffolded projects. Medium if someone creates a project manually without @A.

### Risk 3: Zero-test false positives

**Concern:** What if a legitimate project has no testable code yet (e.g., pure docs or config)?

**Mitigation:** PR-000 exception (`is_test_setup: true`) handles the bootstrap case. The Sacred Four zero-test rule applies to "projects with code" — pure documentation projects would not have a test step in Sacred Four.

**Friction level:** Low. The only edge case is a code project that ships config-only PRs, which should still have tests.

### Risk 4: HARD STOP fatigue

**Concern:** 13 of 14 enforcement rules are HARD STOP. Could this create "boy who cried wolf" syndrome?

**Mitigation:** Each HARD STOP produces a specific failure report with actionable items. The gates are sequenced so early gates (structure) catch problems before later gates (auth, tests) ever fire. In practice, a well-scaffolded project will pass all gates silently.

**Friction level:** Medium on first encounter. Low after the team internalizes the template scaffold.

### Risk 5: Duplicate section numbering in forge-g-operating-guide.md

**Concern:** The diff adds Section 7.4 "Transition-Specific Validation" but the file already has a Section 7.4 "Session Continuity." This creates two sections with the same number.

**Mitigation:** Cosmetic issue. The content is correct and non-conflicting. Should be renumbered in a follow-up (Session Continuity → 7.5).

**Friction level:** None (no behavioral impact).

---

## E. Backwards Compatibility Notes

### Grandfathering Policy

**Effective date:** 2026-02-10

**Exempt (existing projects):**
- Structural verification step (@G after @C)
- @F auth plane decision gate
- @O auth architecture ADR requirement
- @E pre-flight checks (structure, test infra, auth readiness)
- Universal project location check

**NOT exempt (applies to ALL projects, retroactive):**
- Sacred Four zero-test clarification (zero tests = FAILURE)
- Enforcement matrix (operational reference only, no behavioral change for compliant projects)

**Migration path:** Voluntary. Existing projects can adopt by:
1. Running @G structural verification manually
2. Adding missing templates (STAKEHOLDER-MODEL, AUTH-ARCHITECTURE ADR)
3. Updating project CLAUDE.md

**Impact on active projects:** Only the zero-test rule has retroactive effect. Any project already running real tests is unaffected. Projects with zero tests will now correctly fail Sacred Four instead of falsely passing.

---

## F. Validation Commands

### Verify all modified files exist and are non-empty

```bash
# From FORGE root
for f in \
  method/core/forge-core.md \
  method/core/forge-operations.md \
  method/agents/forge-e-operating-guide.md \
  method/agents/forge-g-operating-guide.md \
  method/agents/forge-o-operating-guide.md \
  method/agents/forge-product-strategist-guide.md \
  method/templates/forge-template-testing-requirements.md \
  method/templates/forge-template-repository-scaffold.md \
  .claude/skills/forge-a/SKILL.md \
  .claude/skills/forge-b/SKILL.md \
  .claude/skills/forge-c/SKILL.md \
  .claude/skills/forge-e/SKILL.md \
  .claude/skills/forge-f/SKILL.md \
  .claude/skills/forge-g/SKILL.md \
  .claude/skills/forge-o/SKILL.md \
  .claude/skills/forge-r/SKILL.md; do
  [ -s "$f" ] && echo "OK: $f" || echo "MISSING: $f"
done
```

### Verify new template files exist

```bash
for f in \
  template/project/docs/constitution/STAKEHOLDER-MODEL.md.template \
  template/project/docs/adr/001-auth-architecture.md.template \
  template/project/docs/ops/test-infrastructure.md.template \
  template/project/docs/ops/preflight-checklist.md.template; do
  [ -s "$f" ] && echo "OK: $f" || echo "MISSING: $f"
done
```

### Check diff statistics

```bash
git diff --stat
# Expected: 16 files changed, 727 insertions(+), 6 deletions(-)
```

### Verify HARD STOP enforcement language is consistent

```bash
grep -rn "HARD STOP" method/ .claude/skills/ --include="*.md" | grep -v _workspace | wc -l
# Expected: ~30+ occurrences across canon, guides, and skills
```

### Verify grandfathering references

```bash
grep -rn "2026-02-10" method/ .claude/skills/ --include="*.md" | grep -v _workspace | wc -l
# Expected: ~8 occurrences (operations, scaffold, g-guide, g-skill)
```

### Review full diff

```bash
git diff                    # All changes
git diff -- method/core/    # Canon changes only
git diff -- method/agents/  # Agent guide changes only
git diff -- .claude/skills/ # Skill changes only
```

### Verify archived work-item

```bash
ls _workspace/99_archive/2026-02-10-forge-system-hardening/
# Expected: state.json, audit-log.md, artifacts/
ls _workspace/99_archive/2026-02-10-forge-system-hardening/artifacts/
# Expected: manifest.json, inventory.md, recon-report.md, questions.md,
#           synthesis.md, proposal.md, verification-report.md
```

---

## Summary Statistics

| Metric | Value |
|--------|-------|
| Files modified | 16 |
| New files | 4 templates |
| Lines added | 727 |
| Lines removed | 6 |
| New canon laws | 1 (Law 5a) |
| New canon rules | 1 (Explicit Architecture Decisions) |
| Enforcement matrix rules | 14 |
| HARD STOP gates | 13 of 14 rules |
| New @G verification steps | 2 (structural + transition) |
| New @E pre-flight checks | 4 (structure, test, auth, Sacred Four) |
| New @F completion gates | 2 (actor planes, stakeholder decision) |
| New @O completion gates | 2 (auth ADR, test architecture) |
| Agents with Universal Startup Check | 8 of 8 |

---

*Report generated for Jordan review. Changes are staged in working tree but NOT committed.*
