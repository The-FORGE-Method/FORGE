# Recon Report: forge-system-hardening

**Date:** 2026-02-10
**Recon Agent:** forge-recon-runner
**Work-Item:** _workspace/04_proposals/work-items/2026-02-10-forge-system-hardening

---

## 1. Summary

This work-item proposes comprehensive hardening of FORGE's enforcement mechanisms to prevent four systemic failures identified during a project foundations reset. The analysis is thorough, well-evidenced, and targets procedural gaps rather than declarative ones. The proposals are primarily additive (new precondition checks, new Phase 0, new templates) with some extensions to existing canon (Law 5). Evidence quality is high — 31KB root cause analysis with specific failure patterns and proposed corrections. The work-item proposes changes to both canon (method/core/) and operational files (templates, agent guides, skills).

---

## 2. Source Material Inventory

| File | Type | Size | Description |
|------|------|------|-------------|
| README.md | Problem statement | 1.9 KB | Summary of 4 systemic gaps and proposed approach |
| threads/system-review-analysis.md | Root cause analysis | 31.8 KB | Comprehensive failure analysis with findings, recommendations, draft canon language, enforcement matrix |

**Total:** 2 files, 33.7 KB

---

## 3. Canon Cross-Reference

### Proposal vs Current Canon: Item-by-Item

#### 1. Law 5 Extension (Preconditions Are Hard Stops)

**Proposal:** Add Law 5a with precondition verification language.

**Current Canon:** Law 5 exists in `forge-core.md` v1.2 as "Hard Stops Are Non-Negotiable" but focuses on escalation and decisiveness, not preconditions.

**Assessment:** COMPATIBLE. This is an extension, not a replacement. Law 5a adds precondition-first thinking to existing hard-stop philosophy.

**Conflict:** None.

#### 2. Phase 0: Scaffold Verification (New Phase)

**Proposal:** Insert Phase 0 between @C (Commit) and @F (Frame) for structural verification.

**Current Canon:** `forge-core.md` defines F.O.R.G.E as five phases. `forge-operations.md` shows @C-to-@F as direct transition.

**Assessment:** REQUIRES DECISION. This either:
- Becomes a 6-phase model (A.B.C -> 0 -> F.O.R.G.E), OR
- Becomes a sub-phase of @G (Govern does Phase 0 before routing to @F), OR
- Becomes @C's exit gate (Commit doesn't complete until Phase 0 passes)

**Concern:** HIGH. This is a structural change to the methodology. Need to decide if it's a phase, a gate, or a sub-routine.

**Recommendation:** Make it @G's first action after @C completion. Not a new phase, but a @G verification step. This preserves F.O.R.G.E acronym and aligns with @G's gating role.

#### 3. Test Infrastructure Gate (Zero Tests = Failure)

**Proposal:** Sacred Four fails if zero tests exist.

**Current Canon:** `forge-template-testing-requirements.md` says "Tests are required" and "tests-later is FORBIDDEN" but Sacred Four definition in operations doesn't specify zero-test handling.

**Assessment:** CLARIFICATION, NOT CHANGE. This makes explicit what was implicit.

**Conflict:** None. Aligns with tests-first canon.

#### 4. Auth Architecture Decision Gate

**Proposal:** @F must explicitly decide auth planes before completion. @O must produce AUTH-ARCHITECTURE ADR.

**Current Canon:** `forge-core.md` v1.2 lists "Auth/RBAC" and "Stakeholder Interface" as Required Extensions but provides no template or decision gate.

**Assessment:** FILLS GAP. Current canon mentions auth but doesn't enforce architecture decisions.

**Concern:** MEDIUM. Need to clarify: for ALL projects or only those with auth?

**Recommendation:** Make conditional on auth presence in PRODUCT.md.

#### 5. Structural Integrity Checks

**Proposal:** All agents verify project location (FORGE/projects/) and structure before proceeding.

**Current Canon:** No explicit requirement. `forge-template-repository-scaffold.md` defines structure but doesn't mandate verification.

**Assessment:** NEW REQUIREMENT. Defensive — agents verify environment before acting.

**Conflict:** None.

#### 6. Agent Pre-Flight Checks

**Proposal:** @E, @G, @F, @O all run startup checks before work.

**Current Canon:** Agent skill files currently check only `abc/FORGE-ENTRY.md` existence.

**Assessment:** EXPANSION. Current gating is minimal; this adds comprehensive pre-flight.

**Conflict:** None. Extends existing gate logic.

### Canon Conflict Summary

**No proposals contradict existing Five Laws or F.O.R.G.E lifecycle.** All proposals are clarifications, extensions, or gap-fills.

---

## 4. Gap Analysis

### Gaps in Source Material

1. **Phase 0 execution mechanics:** Who invokes Phase 0? Is it automatic on @C-to-@G transition, or explicit?
2. **Waiver mechanism:** How does `external_project: true` work in FORGE-AUTONOMY.yml? What gates still apply?
3. **Test infrastructure exception:** "Exception: If this IS the test infrastructure setup handoff (PR-000)" — how is PR-000 identified?
4. **Preflight failure recovery:** If Phase 0 fails, what's the remediation path?
5. **Auth plane decision timing:** Does @F STOP mid-Frame, or is it a completion gate check?
6. **Backward compatibility:** Do existing projects need migration? Or grandfathered?
7. **Non-code projects:** Do test infrastructure gates apply to documentation-only projects?
8. **Zero tests definition:** Is "zero test files" different from "test framework configured but no tests written"?
9. **Agent compliance verification:** How do we verify agents actually run pre-flight checks?
10. **Migration path:** If existing projects don't comply, what's the upgrade process?

---

## 5. Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Bureaucracy creep | Medium | High | Automate checks where possible; keep manual ceremony minimal |
| Agent non-compliance | High | Medium | Startup checks must be in skill SKILL.md files, not just guides |
| Backward incompatibility | High | High | Grandfather existing projects; mandatory only for new |
| Zero-test false positives | Medium | Medium | Check both file existence AND test runner output |
| Auth plane over-specification | Low | Medium | Make STAKEHOLDER-MODEL conditional on actor presence |
| Phase 0 duplication with @A | Low | Low | @A creates structure, Phase 0 verifies it — different roles |
| Template maintenance burden | Medium | Low | Four new templates; extract common patterns |

---

## 6. Dependencies

| Must Happen First | Before | Reason |
|-------------------|--------|--------|
| Phase 0 semantics decision | Implementation | Determines where checks live |
| Backward compatibility decision | All agent updates | Determines scope of enforcement |
| Auth gate scope decision | @F/@O changes | Determines when gates trigger |
| FORGE-AUTONOMY.yml schema update | Waiver mechanism | Needs `external_project` field |

---

## 7. Open Questions (Requiring Human Answers)

| ID | Question | Options | Default |
|----|----------|---------|---------|
| Q1 | Should Phase 0 be @G's automatic first step after @C, or explicitly invoked? | A: Automatic (every @C-to-@F triggers it), B: Explicit (`@G phase0` command), C: Human-initiated | A |
| Q2 | Are existing projects required to comply with new gates? | A: Yes, migrate all, B: No, grandfather existing, C: Opt-in migration | B |
| Q3 | Is STAKEHOLDER-MODEL required if project has auth but no stakeholders? | A: Yes always, B: No, only if stakeholders exist, C: Optional but recommended | B |
| Q4 | Should "zero tests = failure" check for test files, test execution, or both? | A: File existence only, B: Test runner output only, C: Both | C |
| Q5 | How is the test infrastructure exception (PR-000) identified? | A: `is_test_setup: true` flag in handoff, B: Manual @E decision, C: @G identifies from Build Plan | A |
| Q6 | Should Phase 0 preflight reports be auto-generated by @G? | A: Yes auto-generated, B: Manual, C: Template-based | A |
| Q7 | What validation level for STAKEHOLDER-MODEL? | A: Schema validation (required fields), B: Manual review only, C: No validation | A |
| Q8 | Auth architecture ADR required for ALL projects or only multi-user/role projects? | A: All with any auth, B: Only multi-user/role projects, C: Only when stakeholders exist | B |
| Q9 | If Phase 0 fails, who fixes it? | A: @C re-runs scaffolding, B: Human fixes manually, C: @G reports + stops (human decides) | C |
| Q10 | Should enforcement matrix live in canon or operations manual? | A: Core canon, B: Operations manual, C: Core rules in canon, details in operations | C |

---

## 8. Evidence Quality

**Rating:** EXCELLENT

**Strengths:**
- 31KB root cause analysis with specific failure patterns
- Each failure traced to missing enforcement mechanism
- Proposed fixes are specific, actionable, and prioritized
- Draft canon language provided
- Enforcement matrix with agent/trigger/failure-mode

**Weaknesses:**
- No alternative solutions explored (single path per fix)
- No cost/benefit analysis
- Backward compatibility not addressed in detail

---

## 9. Recommendation

**Readiness:** NEEDS_CLARIFICATION

**Next Phase:** CLARIFYING_QUESTIONS (10 questions for Human Lead)

**Rationale:** Analysis is excellent but 10 scoping and mechanics questions need human answers before synthesis can proceed. These are not ambiguities in the problem — they are design decisions that only the Human Lead can make.

---

*Generated by forge-recon-runner*
