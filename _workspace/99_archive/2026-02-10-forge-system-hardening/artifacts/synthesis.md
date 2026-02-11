---
title: FORGE System Hardening — Synthesis
date: 2026-02-10
version: v1.0
status: Draft
author: SpecWriter Agent
tags: [forge, hardening, enforcement, canon, governance]
work-item: 2026-02-10-forge-system-hardening
---

# FORGE System Hardening — Synthesis

## 1. Feature Summary

This feature hardens FORGE's enforcement mechanisms to prevent four systemic failures that occurred during a project foundations reset: (1) stakeholder portal drift due to missing auth architecture decision gates, (2) tests-first canon violations due to zero-test bypass loophole, (3) missing structural signals due to lack of project location and structure verification, and (4) implicit vs explicit canon due to prohibition-based (MUST NOT) constraints instead of precondition-based (MUST VERIFY) gates.

The solution adds @G-driven Phase 0 scaffold verification between @C and @F, extends Law 5 with explicit precondition verification requirements, adds four mandatory templates (STAKEHOLDER-MODEL, AUTH-ARCHITECTURE ADR, TEST-INFRASTRUCTURE, PREFLIGHT-CHECKLIST), implements comprehensive pre-flight checks across all agents, and closes the Sacred Four zero-test loophole. All changes preserve the F.O.R.G.E acronym and existing lifecycle semantics.

---

## 2. Decisions Made

| Decision ID | Question | Answer | Rationale |
|-------------|----------|--------|-----------|
| D1 | Phase 0 semantics | Automatic @G verification step after @C completes, not a new phase | Preserves F.O.R.G.E acronym, aligns with @G's gating role, avoids lifecycle model change |
| D2 | Backward compatibility | Grandfather existing projects; new gates apply only to new projects | Prevents disruption to active work, allows voluntary migration, focuses enforcement on greenfield |
| D3 | STAKEHOLDER-MODEL requirement | Required only if stakeholder actors exist in PRODUCT.md | Avoids ceremony for projects without stakeholders, enforces where needed |
| D4 | Zero-test detection | Check both file existence AND test runner output | Prevents false positives from "no tests found" success, ensures real test execution |
| D5 | Test setup exception (PR-000) | Identified by `is_test_setup: true` flag in handoff packet | Explicit opt-in mechanism, prevents circular dependency for test infrastructure PRs |
| D6 | Preflight report generation | @G auto-generates preflight reports after running checks | Reduces manual ceremony, creates audit trail, standardizes format |
| D7 | STAKEHOLDER-MODEL validation | Schema validation (required fields must be present and non-empty) | Ensures completeness, machine-checkable, prevents half-filled templates |
| D8 | Auth architecture ADR scope | Required only for multi-user or multi-role projects | Avoids over-specification for simple auth (e.g., admin-only tools), enforces where complexity exists |
| D9 | Phase 0 failure recovery | @G produces failure report and STOPS; human decides next action | Prevents auto-fix loops, surfaces structural issues clearly, human-in-the-loop for critical failures |
| D10 | Enforcement rule location | Core enforcement rules in forge-core.md (canon), detailed matrix in forge-operations.md (operational) | Canon defines principles, operations manual defines mechanics, separation of concerns |

---

## 3. Requirements

### 3.1 Canon Changes (method/core/)

**REQ-001: Extend Law 5 with Precondition Verification**
- **File:** `method/core/forge-core.md`
- **Section:** Law 5 (Hard Stops Are Non-Negotiable)
- **Change:** Add Law 5a with precondition verification language from draft canon (system-review-analysis.md lines 666-687)
- **Traceability:** Root cause finding: prohibition-based vs precondition-based enforcement model

**REQ-002: Define Phase 0 in Lifecycle Narrative**
- **File:** `method/core/forge-core.md`
- **Section:** F.O.R.G.E Lifecycle overview
- **Change:** Add text clarifying that @G performs automatic scaffold verification after @C completion and before @F begins (NOT a new phase, but a @G verification step)
- **Traceability:** Recon recommendation to preserve F.O.R.G.E acronym while adding structural verification

**REQ-003: Clarify Sacred Four Zero-Test Handling**
- **File:** `method/core/forge-operations.md`
- **Section:** Sacred Four definition
- **Change:** Add explicit rule: "Zero tests = Sacred Four FAILURE. Test runner must execute at least one test. 'No tests found' is not 'tests passing.'"
- **Traceability:** Root cause finding: zero tests = zero failures = false gate pass

**REQ-004: Add Explicit Architecture Decision Rule**
- **File:** `method/core/forge-core.md`
- **Section:** After Law 5a (new section)
- **Change:** Add "Explicit Over Implicit" rule from draft canon (system-review-analysis.md lines 691-704)
- **Traceability:** Root cause finding: implicit assumptions allowed stakeholder portal drift

**REQ-005: Define Structural Integrity Requirement**
- **File:** `method/core/forge-operations.md`
- **Section:** After Phase 0 definition
- **Change:** Add structural integrity rule from draft canon (system-review-analysis.md line 103)
- **Traceability:** Root cause finding: projects executing outside FORGE/projects/ without warning

### 3.2 Agent Behavior Changes

**REQ-006: @E Pre-Flight Verification**
- **Files:** `.claude/skills/forge-e/SKILL.md`, `method/agents/forge-e-operating-guide.md`
- **Change:** Add pre-flight checklist from system-review-analysis.md lines 708-733 to agent startup sequence (before any coding)
- **Checks:** Structure gate, test infrastructure gate (with PR-000 exception), auth readiness gate (conditional), Sacred Four dry run
- **Traceability:** Root cause finding: @E optimized for production, not verification

**REQ-007: @G Structural Verification**
- **Files:** `.claude/skills/forge-g/SKILL.md`, `method/agents/forge-g-operating-guide.md`
- **Change:** Add Phase 0 scaffold verification checklist and transition validation from system-review-analysis.md lines 441-470
- **Behavior:** After @C completes, automatically run Phase 0 checks before routing to @F; validate structure on every transition
- **Output:** Auto-generate PREFLIGHT-REPORT.md in docs/router-events/
- **Traceability:** Decision D1 (Phase 0 = automatic @G step) + D6 (auto-generated reports)

**REQ-008: @F Mandatory Auth Plane Decision**
- **Files:** `.claude/skills/forge-f/SKILL.md`, `method/agents/forge-f-operating-guide.md`
- **Change:** Add completion gate requiring explicit auth plane decision from system-review-analysis.md lines 480-496
- **Gate:** PRODUCT.md not complete until all actors have explicit plane assignments and stakeholder decision is answered
- **Traceability:** Root cause finding: no decision gate for "how many auth planes?"

**REQ-009: @O Auth Architecture ADR Requirement**
- **Files:** `.claude/skills/forge-o/SKILL.md`, `method/agents/forge-o-operating-guide.md`
- **Change:** Add completion gate requiring auth architecture ADR for multi-user/multi-role projects from system-review-analysis.md lines 503-524
- **Gate:** TECH.md not complete until AUTH-ARCHITECTURE ADR exists (when applicable) and test architecture is specified
- **Traceability:** Root cause finding: no mandatory auth architecture artifact before implementation

**REQ-010: Universal Project Location Check**
- **Files:** All agent SKILL.md files (forge-a, forge-b, forge-c, forge-f, forge-g, forge-o, forge-e, forge-r)
- **Change:** Add universal startup check from system-review-analysis.md lines 532-545 to every agent
- **Check:** Verify project is under FORGE/projects/ OR has `external_project: true` waiver in FORGE-AUTONOMY.yml
- **Traceability:** Root cause finding: no agent checks project location

**REQ-011: @G Transition Gates Enhancement**
- **Files:** `.claude/skills/forge-g/SKILL.md`, `method/agents/forge-g-operating-guide.md`
- **Change:** Add transition-specific validation from system-review-analysis.md lines 447-470
- **Gates:**
  - @C→@F: Structure valid
  - @F→@O: Actor planes assigned
  - @O→@E: Auth ADR exists (if applicable), test infra configured, handoff packet exists
- **Traceability:** Root cause finding: @G validates transitions but not preconditions

### 3.3 New Templates

**REQ-012: STAKEHOLDER-MODEL Template**
- **File:** `template/project/docs/constitution/STAKEHOLDER-MODEL.md.template`
- **Content:** Template from system-review-analysis.md lines 203-234
- **Validation:** Schema check for required fields (auth planes table, decision checkboxes, role architecture, actor mapping)
- **Traceability:** Root cause finding: no stakeholder architecture template despite Required Extensions mention

**REQ-013: AUTH-ARCHITECTURE ADR Template**
- **File:** `template/project/docs/adr/001-auth-architecture.md.template`
- **Content:** Template from system-review-analysis.md lines 237-257
- **Validation:** Validation checklist included in template
- **Traceability:** Root cause finding: no mandatory auth architecture decision record

**REQ-014: TEST-INFRASTRUCTURE Template**
- **File:** `template/project/docs/ops/test-infrastructure.md.template`
- **Content:** Template from system-review-analysis.md lines 260-288
- **Purpose:** Document test framework, configuration, Sacred Four commands, coverage thresholds
- **Traceability:** Root cause finding: test requirements implicit, not explicit

**REQ-015: PREFLIGHT-CHECKLIST Template**
- **File:** `template/project/docs/ops/preflight-checklist.md.template`
- **Content:** Template from system-review-analysis.md lines 291-319
- **Purpose:** @G uses this template to auto-generate Phase 0 verification reports
- **Traceability:** Decision D6 (auto-generated preflight reports)

### 3.4 Template Enhancements

**REQ-016: Enhanced PRODUCT.md Template Guidance**
- **File:** `method/templates/forge-template-frame.md`
- **Change:** Add section requiring actor taxonomy with plane assignment, auth model decision (single/multi-plane), stakeholder access model, data ownership boundaries
- **Traceability:** Root cause finding: PRODUCT.md had actors but no plane assignments

**REQ-017: Enhanced TECH.md Guidance**
- **File:** `method/templates/forge-template-orchestrate.md` (or new file if doesn't exist)
- **Change:** Add requirement for AUTH-ARCHITECTURE section (or reference to ADR), test infrastructure specification
- **Traceability:** Root cause finding: TECH.md lacked mandatory auth and test architecture sections

**REQ-018: Enhanced CLAUDE.md Project Identity Template**
- **File:** `method/templates/forge-template-project-identity.md`
- **Change:** Add Non-Negotiables section from system-review-analysis.md lines 362-385 (pre-flight gate, structural integrity)
- **Traceability:** Root cause finding: project CLAUDE.md didn't enforce FORGE structure discipline

### 3.5 Scaffold Changes

**REQ-019: Enhanced Repository Scaffold Documentation**
- **File:** `method/templates/forge-template-repository-scaffold.md`
- **Change:** Add "Required Structure Verification" section from system-review-analysis.md lines 324-356
- **Content:** List of mandatory directories/files with conditional requirements (auth projects, code projects)
- **Traceability:** Root cause finding: scaffold defines structure but doesn't mandate verification

**REQ-020: Template Project Scaffold Updates**
- **Files:** `template/project/` directory structure
- **Changes:**
  - Create `docs/constitution/STAKEHOLDER-MODEL.md.template`
  - Create `docs/adr/001-auth-architecture.md.template`
  - Create `docs/ops/test-infrastructure.md.template`
  - Create `docs/ops/preflight-checklist.md.template`
- **Traceability:** REQ-012 through REQ-015 template creation requirements

### 3.6 Enforcement Matrix Documentation

**REQ-021: Complete Enforcement Matrix**
- **File:** `method/core/forge-operations.md` (create new section)
- **Content:** Enforcement matrix from system-review-analysis.md lines 553-568
- **Purpose:** Machine-readable reference for what agent enforces what rule at what trigger point
- **Traceability:** Decision D10 (enforcement details in operations manual)

**REQ-022: Enforcement Timeline Diagram**
- **File:** `method/core/forge-operations.md` (append to enforcement section)
- **Content:** Enforcement timeline from system-review-analysis.md lines 572-622
- **Purpose:** Visual representation of when checks occur in lifecycle
- **Traceability:** Decision D1 (Phase 0 = automatic @G step after @C)

### 3.7 FORGE-AUTONOMY.yml Schema Update

**REQ-023: Add external_project Field**
- **File:** `method/templates/forge-template-autonomy.md` (or governance schema doc)
- **Change:** Add `external_project: boolean` field to FORGE-AUTONOMY.yml schema
- **Purpose:** Allow projects outside FORGE/projects/ to explicitly waive location check
- **Default:** `false`
- **Traceability:** REQ-010 universal location check needs waiver mechanism

### 3.8 Testing Requirements Update

**REQ-024: Zero-Test Clarification**
- **File:** `method/templates/forge-template-testing-requirements.md`
- **Change:** Add explicit rule: "Sacred Four test step must execute at least one test. Zero tests = gate FAILURE. Test runner must produce test execution output, not 'no tests found' message."
- **Traceability:** Root cause finding: Sacred Four zero-test loophole

**REQ-025: PR-000 Exception Documentation**
- **File:** `method/templates/forge-template-testing-requirements.md`
- **Change:** Add section documenting PR-000 test infrastructure setup exception with `is_test_setup: true` handoff packet flag
- **Traceability:** Decision D5 (explicit flag-based exception mechanism)

### 3.9 Grandfathering Mechanism

**REQ-026: Backward Compatibility Documentation**
- **File:** `method/core/forge-operations.md` (new section after enforcement matrix)
- **Change:** Document grandfathering policy: "Projects existing before 2026-02-10 are exempt from new enforcement gates. New gates apply only to projects created after Phase 0 enforcement is implemented. Existing projects MAY voluntarily migrate."
- **Traceability:** Decision D2 (grandfather existing projects)

---

## 4. Affected Files

| File Path | Change Type | Purpose |
|-----------|-------------|---------|
| `method/core/forge-core.md` | MODIFY | REQ-001 (Law 5a), REQ-002 (Phase 0 definition), REQ-004 (Explicit Over Implicit rule) |
| `method/core/forge-operations.md` | MODIFY | REQ-003 (Sacred Four zero-test), REQ-005 (structural integrity), REQ-021 (enforcement matrix), REQ-022 (enforcement timeline), REQ-026 (grandfathering) |
| `.claude/skills/forge-e/SKILL.md` | MODIFY | REQ-006 (@E pre-flight checks), REQ-010 (location check) |
| `method/agents/forge-e-operating-guide.md` | MODIFY | REQ-006 (@E pre-flight checks expanded documentation) |
| `.claude/skills/forge-g/SKILL.md` | MODIFY | REQ-007 (Phase 0 + structural verification), REQ-010 (location check), REQ-011 (transition gates) |
| `method/agents/forge-g-operating-guide.md` | MODIFY | REQ-007 (Phase 0 expanded documentation), REQ-011 (transition gates documentation) |
| `.claude/skills/forge-f/SKILL.md` | MODIFY | REQ-008 (mandatory auth plane decision), REQ-010 (location check) |
| `method/agents/forge-f-operating-guide.md` | MODIFY | REQ-008 (auth plane decision expanded documentation) |
| `.claude/skills/forge-o/SKILL.md` | MODIFY | REQ-009 (auth ADR requirement), REQ-010 (location check) |
| `method/agents/forge-o-operating-guide.md` | MODIFY | REQ-009 (auth ADR expanded documentation) |
| `.claude/skills/forge-a/SKILL.md` | MODIFY | REQ-010 (location check) |
| `.claude/skills/forge-b/SKILL.md` | MODIFY | REQ-010 (location check) |
| `.claude/skills/forge-c/SKILL.md` | MODIFY | REQ-010 (location check) |
| `.claude/skills/forge-r/SKILL.md` | MODIFY | REQ-010 (location check) |
| `template/project/docs/constitution/STAKEHOLDER-MODEL.md.template` | CREATE | REQ-012 (stakeholder model template) |
| `template/project/docs/adr/001-auth-architecture.md.template` | CREATE | REQ-013 (auth ADR template) |
| `template/project/docs/ops/test-infrastructure.md.template` | CREATE | REQ-014 (test infrastructure template) |
| `template/project/docs/ops/preflight-checklist.md.template` | CREATE | REQ-015 (preflight checklist template) |
| `method/templates/forge-template-frame.md` | MODIFY | REQ-016 (enhanced PRODUCT.md guidance) |
| `method/templates/forge-template-orchestrate.md` | MODIFY or CREATE | REQ-017 (enhanced TECH.md guidance) |
| `method/templates/forge-template-project-identity.md` | MODIFY | REQ-018 (enhanced CLAUDE.md Non-Negotiables) |
| `method/templates/forge-template-repository-scaffold.md` | MODIFY | REQ-019 (required structure verification section) |
| `method/templates/forge-template-autonomy.md` | MODIFY | REQ-023 (external_project field) |
| `method/templates/forge-template-testing-requirements.md` | MODIFY | REQ-024 (zero-test clarification), REQ-025 (PR-000 exception) |

**Total: 23 files modified, 4 files created**

---

## 5. Implementation Sequence

### Batch 1: Canon Foundation (CRITICAL PATH)
**Prerequisite:** None
**Must complete before:** All other batches

1. **REQ-001:** Add Law 5a to `method/core/forge-core.md`
2. **REQ-004:** Add Explicit Over Implicit rule to `method/core/forge-core.md`
3. **REQ-002:** Define Phase 0 semantics in `method/core/forge-core.md`
4. **REQ-005:** Add structural integrity requirement to `method/core/forge-operations.md`
5. **REQ-003:** Clarify Sacred Four zero-test handling in `method/core/forge-operations.md`
6. **REQ-026:** Document grandfathering policy in `method/core/forge-operations.md`

**Rationale:** Canon must be updated first because agent changes reference canon rules.

---

### Batch 2: Templates (PARALLEL TO BATCH 3)
**Prerequisite:** Batch 1 complete
**Must complete before:** Batch 4

7. **REQ-012:** Create STAKEHOLDER-MODEL.md.template
8. **REQ-013:** Create AUTH-ARCHITECTURE ADR template
9. **REQ-014:** Create TEST-INFRASTRUCTURE template
10. **REQ-015:** Create PREFLIGHT-CHECKLIST template
11. **REQ-020:** Add templates to `template/project/` scaffold

**Rationale:** Templates must exist before agent behavior references them.

---

### Batch 3: Template Guidance Updates (PARALLEL TO BATCH 2)
**Prerequisite:** Batch 1 complete
**Must complete before:** Batch 4

12. **REQ-016:** Enhance PRODUCT.md template guidance
13. **REQ-017:** Enhance TECH.md template guidance
14. **REQ-018:** Enhance CLAUDE.md project identity template
15. **REQ-019:** Add required structure verification to repository scaffold
16. **REQ-023:** Add external_project field to FORGE-AUTONOMY.yml schema
17. **REQ-024:** Add zero-test clarification to testing requirements
18. **REQ-025:** Document PR-000 exception in testing requirements

**Rationale:** Template guidance updates can happen in parallel with template creation.

---

### Batch 4: Agent Behavior Changes (CRITICAL PATH)
**Prerequisite:** Batches 2 and 3 complete
**Must complete before:** Batch 5

19. **REQ-010:** Add universal location check to all 8 agent SKILL.md files
20. **REQ-007:** Add Phase 0 verification and transition gates to @G
21. **REQ-006:** Add pre-flight verification to @E
22. **REQ-008:** Add mandatory auth plane decision to @F
23. **REQ-009:** Add auth ADR requirement to @O
24. **REQ-011:** Enhance @G transition gates

**Rationale:** All agents must be updated together to prevent inconsistent enforcement. Phase 0 (@G) must be implemented before @E pre-flight checks reference it.

---

### Batch 5: Enforcement Documentation (FINAL)
**Prerequisite:** Batches 1-4 complete
**Must complete before:** None (documentation)

25. **REQ-021:** Add enforcement matrix to `method/core/forge-operations.md`
26. **REQ-022:** Add enforcement timeline diagram to `method/core/forge-operations.md`

**Rationale:** Documentation synthesizes all changes into reference tables. Best done last to reflect actual implementation.

---

## 6. Acceptance Criteria

Each criterion must be verifiable with PASS or FAIL.

### AC-001: Law 5a Exists
**Test:** Read `method/core/forge-core.md`, search for "5a. Preconditions Are Hard Stops"
**Pass:** Section exists with language matching draft canon (system-review-analysis.md lines 666-687)
**Fail:** Section missing or incomplete

### AC-002: Phase 0 Defined as @G Step
**Test:** Read `method/core/forge-core.md`, verify Phase 0 is described as @G automatic verification step after @C, NOT as a new phase
**Pass:** Text explicitly states "@G performs Phase 0 verification between @C completion and @F start"
**Fail:** Phase 0 described as new phase OR missing

### AC-003: Sacred Four Zero-Test Clarified
**Test:** Read `method/core/forge-operations.md`, search for Sacred Four definition
**Pass:** Definition includes "Zero tests = Sacred Four FAILURE" language
**Fail:** Zero-test handling not mentioned or ambiguous

### AC-004: Explicit Over Implicit Rule Exists
**Test:** Read `method/core/forge-core.md`, search for "Explicit Architecture Decisions" or "Explicit Over Implicit"
**Pass:** Rule exists with auth planes, role scoping, stakeholder separation, test infrastructure as mandatory decisions
**Fail:** Rule missing or incomplete

### AC-005: @E Pre-Flight Checks Implemented
**Test:** Read `.claude/skills/forge-e/SKILL.md`, verify startup sequence includes structure gate, test infrastructure gate, auth readiness gate
**Pass:** All three gates present with HARD STOP failure mode, PR-000 exception documented
**Fail:** Any gate missing or failure mode not HARD STOP

### AC-006: @G Phase 0 Verification Implemented
**Test:** Read `.claude/skills/forge-g/SKILL.md`, verify Phase 0 checklist exists and auto-generates PREFLIGHT-REPORT.md
**Pass:** Checklist matches system-review-analysis.md lines 115-127, report generation documented
**Fail:** Checklist missing, incomplete, or no auto-generation

### AC-007: @F Auth Plane Decision Gate Implemented
**Test:** Read `.claude/skills/forge-f/SKILL.md`, verify completion gate requires explicit actor plane assignments
**Pass:** Gate blocks PRODUCT.md completion until all actors have plane assignments
**Fail:** Gate missing or optional

### AC-008: @O Auth ADR Requirement Implemented
**Test:** Read `.claude/skills/forge-o/SKILL.md`, verify completion gate requires AUTH-ARCHITECTURE ADR for multi-user/multi-role projects
**Pass:** Gate exists with conditional logic (only multi-user/role), HARD STOP on failure
**Fail:** Gate missing, not conditional, or not HARD STOP

### AC-009: Universal Location Check Implemented
**Test:** Check all 8 agent SKILL.md files for universal startup check (FORGE/projects/ or external_project waiver)
**Pass:** All 8 agents have location check with waiver logic
**Fail:** Any agent missing check

### AC-010: STAKEHOLDER-MODEL Template Exists
**Test:** Check `template/project/docs/constitution/STAKEHOLDER-MODEL.md.template` file exists
**Pass:** File exists with content matching system-review-analysis.md lines 203-234
**Fail:** File missing or incomplete

### AC-011: AUTH-ARCHITECTURE Template Exists
**Test:** Check `template/project/docs/adr/001-auth-architecture.md.template` file exists
**Pass:** File exists with content matching system-review-analysis.md lines 237-257
**Fail:** File missing or incomplete

### AC-012: TEST-INFRASTRUCTURE Template Exists
**Test:** Check `template/project/docs/ops/test-infrastructure.md.template` file exists
**Pass:** File exists with content matching system-review-analysis.md lines 260-288
**Fail:** File missing or incomplete

### AC-013: PREFLIGHT-CHECKLIST Template Exists
**Test:** Check `template/project/docs/ops/preflight-checklist.md.template` file exists
**Pass:** File exists with content matching system-review-analysis.md lines 291-319
**Fail:** File missing or incomplete

### AC-014: Enhanced PRODUCT.md Guidance
**Test:** Read `method/templates/forge-template-frame.md`, verify actor plane assignment section exists
**Pass:** Template guidance includes actor taxonomy with plane assignment requirements
**Fail:** Section missing or incomplete

### AC-015: Enhanced TECH.md Guidance
**Test:** Read `method/templates/forge-template-orchestrate.md`, verify auth and test architecture sections exist
**Pass:** Template guidance requires AUTH-ARCHITECTURE and test infrastructure sections
**Fail:** Sections missing or optional

### AC-016: Enhanced CLAUDE.md Non-Negotiables
**Test:** Read `method/templates/forge-template-project-identity.md`, verify pre-flight gate and structural integrity sections exist
**Pass:** Non-Negotiables section includes content from system-review-analysis.md lines 362-385
**Fail:** Sections missing or incomplete

### AC-017: Enhanced Repository Scaffold Documentation
**Test:** Read `method/templates/forge-template-repository-scaffold.md`, verify required structure verification section exists
**Pass:** Section includes mandatory directories/files with conditional requirements
**Fail:** Section missing or incomplete

### AC-018: FORGE-AUTONOMY.yml Schema Updated
**Test:** Read `method/templates/forge-template-autonomy.md`, verify external_project field documented
**Pass:** Field exists with type boolean, default false, waiver semantics explained
**Fail:** Field missing or undocumented

### AC-019: Testing Requirements Updated
**Test:** Read `method/templates/forge-template-testing-requirements.md`, verify zero-test clarification and PR-000 exception exist
**Pass:** Both sections present with unambiguous language
**Fail:** Either section missing or ambiguous

### AC-020: Enforcement Matrix Exists
**Test:** Read `method/core/forge-operations.md`, verify enforcement matrix table exists
**Pass:** Table matches system-review-analysis.md lines 553-568 structure
**Fail:** Table missing or incomplete

### AC-021: Enforcement Timeline Exists
**Test:** Read `method/core/forge-operations.md`, verify enforcement timeline diagram exists
**Pass:** Diagram shows Phase 0 as @G step between @C and @F
**Fail:** Diagram missing or Phase 0 incorrectly positioned

### AC-022: Grandfathering Policy Documented
**Test:** Read `method/core/forge-operations.md`, verify grandfathering section exists
**Pass:** Section states existing projects exempt, new gates for new projects only
**Fail:** Section missing or ambiguous

### AC-023: @G Transition Gates Enhanced
**Test:** Read `.claude/skills/forge-g/SKILL.md`, verify transition-specific gates exist
**Pass:** Gates for @C→@F, @F→@O, @O→@E match requirements in system-review-analysis.md lines 447-470
**Fail:** Any gate missing or incorrect

### AC-024: All Four Templates in Project Scaffold
**Test:** Check `template/project/` directory structure
**Pass:** All four new templates (STAKEHOLDER-MODEL, AUTH-ARCHITECTURE, TEST-INFRASTRUCTURE, PREFLIGHT-CHECKLIST) exist in correct locations
**Fail:** Any template missing or in wrong location

### AC-025: Failure Prevention Verification
**Test:** Trace each original failure from system-review-analysis.md Appendix to enforcement mechanism
**Pass:** All four failures (stakeholder drift, tests-first violation, missing structural signals, implicit canon) have documented prevention mechanism
**Fail:** Any failure lacks prevention mechanism

---

## 7. Risks and Mitigations

### Risk 1: Bureaucracy Creep
**Description:** Excessive ceremony slows agent velocity, frustrates users with checklist fatigue
**Likelihood:** Medium
**Impact:** High
**Mitigation:**
- Automate Phase 0 checks (@G auto-generates reports, no human input required)
- Use templates to reduce manual effort (pre-filled sections, checkboxes)
- Apply gates conditionally (auth ADR only for multi-user/role projects, stakeholder model only if stakeholders exist)
- Grandfather existing projects to focus enforcement on greenfield

### Risk 2: Agent Non-Compliance
**Description:** Agents ignore pre-flight checks, proceed without verification
**Likelihood:** High (if checks are in guides only)
**Impact:** Medium
**Mitigation:**
- Place all startup checks in SKILL.md files (agents load these before acting)
- Use HARD STOP language with explicit failure reports (no silent bypass)
- Test each agent with negative cases (missing test infra, missing auth ADR) during implementation
- Document enforcement matrix so humans can audit agent behavior

### Risk 3: Backward Incompatibility Breaking Active Work
**Description:** New gates block existing projects mid-flight, forcing disruptive migration
**Likelihood:** High (without grandfathering)
**Impact:** High
**Mitigation:**
- REQ-026 (grandfathering policy): Existing projects exempt from new gates
- Voluntary migration path for projects that want new enforcement
- Clear documentation of exemption criteria (project creation date before 2026-02-10)

### Risk 4: Zero-Test False Positives
**Description:** "No tests found" succeeds in some test runners, bypassing gate
**Likelihood:** Medium
**Impact:** Medium
**Mitigation:**
- REQ-024 (zero-test clarification): Check BOTH file existence AND test runner output
- Require test runner to produce test execution output (not just exit code)
- @E pre-flight checks for at least one .test. or .spec. file before running Sacred Four

### Risk 5: Auth Plane Over-Specification
**Description:** Simple projects (admin-only tools) forced to produce complex auth ADRs
**Likelihood:** Low
**Impact:** Medium
**Mitigation:**
- Decision D8: Auth ADR required only for multi-user or multi-role projects
- Decision D3: STAKEHOLDER-MODEL only if stakeholders exist
- Template guidance includes "simple auth" example ADR (single plane, admin only)

### Risk 6: Phase 0 Duplication with @A
**Description:** @A creates scaffold, Phase 0 verifies it — seems redundant
**Likelihood:** Low
**Impact:** Low
**Mitigation:**
- Distinct roles: @A = creation, Phase 0 = verification
- Phase 0 catches issues from manual project setup or external scaffolding
- Auto-generated Phase 0 reports create audit trail (compliance evidence)

### Risk 7: Template Maintenance Burden
**Description:** Four new templates increase maintenance surface area
**Likelihood:** Medium
**Impact:** Low
**Mitigation:**
- Extract common patterns (all four use markdown checklist format)
- Templates are .template files (clear distinction from active docs)
- Templates include validation sections (self-documenting completeness criteria)

### Risk 8: Circular Dependency for Test Infrastructure
**Description:** PR-000 test setup blocked by "no tests exist" gate
**Likelihood:** High (without exception)
**Impact:** High
**Mitigation:**
- Decision D5: `is_test_setup: true` flag in handoff packet bypasses test infrastructure gate
- Explicit exception documented in REQ-025
- @E checks for flag before running test infrastructure gate

---

## 8. Out of Scope

### Explicitly NOT Included in This Feature

**OS-001: Migration Tooling for Existing Projects**
This feature does NOT include automated migration scripts for bringing existing projects into compliance with new gates. Existing projects are grandfathered; migration is voluntary and manual.

**OS-002: Agent Self-Healing or Auto-Fix**
When pre-flight checks fail, agents report failures and STOP. This feature does NOT include logic for agents to auto-fix missing structure, auto-generate missing templates, or auto-remediate gate failures.

**OS-003: CI/CD Pipeline Integration**
This feature hardens FORGE agent enforcement but does NOT add Sacred Four checks to GitHub Actions workflows or other CI/CD systems. CI enforcement is project-specific and outside FORGE methodology scope.

**OS-004: Non-Code Project Adaptations**
Documentation-only projects, research projects, and non-code projects are NOT in scope. This feature assumes code projects with test infrastructure. Adapting gates for non-code projects is future work.

**OS-005: Agent Compliance Verification System**
This feature does NOT include a meta-agent or monitoring system to audit whether agents are actually running pre-flight checks. Compliance verification is manual (read agent SKILL.md files, check for startup checks).

**OS-006: FORGE-AUTONOMY.yml Validation Tool**
This feature adds the `external_project` field to the schema but does NOT include a validation tool to check FORGE-AUTONOMY.yml syntax or semantics. Validation remains manual or editor-based (JSON Schema).

**OS-007: Alternative Phase 0 Mechanisms**
Decision D1 selected "automatic @G step after @C." This feature does NOT implement alternative mechanisms (explicit `/phase0` command, human-initiated verification, @C exit gate).

**OS-008: Waiver Request Workflow**
Projects can set `external_project: true` to waive location checks, but this feature does NOT include a formal waiver request/approval workflow. Waivers are self-service (edit FORGE-AUTONOMY.yml).

**OS-009: Test Coverage Enforcement Changes**
This feature closes the zero-test loophole but does NOT change coverage thresholds, delta requirements, or Sacred Four paths coverage rules. Those remain as defined in existing testing requirements.

**OS-010: Stakeholder Model Validation Logic**
Decision D7 specifies schema validation (required fields present and non-empty) but this feature does NOT implement the validator. Validation is @F's responsibility using template checklist.

**OS-011: Auth Architecture Best Practices Guide**
This feature creates the AUTH-ARCHITECTURE ADR template but does NOT include a best practices guide for auth architecture decisions (when to use multi-plane, how to scope roles, etc.).

**OS-012: Enforcement Matrix Automation**
REQ-021 creates the enforcement matrix as documentation but does NOT include automation to enforce the matrix (e.g., a tool that reads the matrix and verifies agent behavior matches it).

**OS-013: FORGE Version Compatibility**
This feature does NOT include version metadata to track which projects use which FORGE enforcement model. All enforcement changes are breaking changes with no backward compatibility layer beyond grandfathering.

**OS-014: Phase 0 Failure Remediation Playbook**
Decision D9 specifies that Phase 0 failures produce a report and STOP, but this feature does NOT include a remediation playbook (e.g., "if Phase 0 fails with missing tests/, do X").

**OS-015: Inter-Agent Communication Protocol**
This feature adds pre-flight checks and gates but does NOT change how agents communicate (still routed through @G with packets). No new agent-to-agent messaging protocol.

---

**End of Synthesis Document**

---

## Appendix: Traceability Matrix

| Requirement | Root Cause Finding | Q&A Decision | Recon Recommendation |
|-------------|-------------------|--------------|---------------------|
| REQ-001 | Failure 4: Implicit vs explicit canon, prohibition-based vs precondition-based | - | Draft canon lines 666-687 |
| REQ-002 | - | D1: Phase 0 = automatic @G step | Recon: preserve F.O.R.G.E acronym |
| REQ-003 | Failure 2: Tests-first canon violation, zero tests = zero failures | D4: Check both file + runner | Line 59: Sacred Four zero-test fix |
| REQ-004 | Failure 1: Stakeholder portal drift, implicit assumptions | - | Draft canon lines 691-704 |
| REQ-005 | Failure 3: Missing structural signals, no location check | - | Line 103: Structural integrity rule |
| REQ-006 | Failure 2, 4: @E optimized for production not verification | D5: PR-000 flag exception | Lines 708-733: @E pre-flight checklist |
| REQ-007 | Failure 3: No structural verification | D1: Auto @G step, D6: Auto reports | Lines 441-470: @G verification |
| REQ-008 | Failure 1: No auth plane decision gate | D3: Conditional on stakeholders | Lines 480-496: @F completion gate |
| REQ-009 | Failure 1: No auth architecture ADR | D8: Multi-user/role only | Lines 503-524: @O completion gate |
| REQ-010 | Failure 3: No project location check | D2: Grandfathering | Lines 532-545: Universal startup |
| REQ-011 | Failure 3: @G doesn't audit preconditions | - | Lines 447-470: @G transition gates |
| REQ-012 | Failure 1: No stakeholder template | D3: Conditional on stakeholders, D7: Schema validation | Lines 203-234: Template content |
| REQ-013 | Failure 1: No auth ADR template | D8: Multi-user/role only | Lines 237-257: Template content |
| REQ-014 | Failure 2: Test requirements implicit | - | Lines 260-288: Template content |
| REQ-015 | - | D6: Auto-generated by @G | Lines 291-319: Template content |
| REQ-016 | Failure 1: PRODUCT.md had actors but no planes | - | Lines 132-141: Enhanced Frame |
| REQ-017 | Failure 1: TECH.md lacked auth section | - | Lines 145-153: Enhanced Orchestrate |
| REQ-018 | Failure 3: Project CLAUDE.md didn't enforce structure | - | Lines 362-385: Non-Negotiables |
| REQ-019 | Failure 3: Scaffold defines but doesn't mandate | - | Lines 324-356: Verification section |
| REQ-020 | All four templates must be in scaffold | - | REQ-012 through REQ-015 |
| REQ-021 | All failures: no enforcement matrix | D10: Details in operations | Lines 553-568: Matrix table |
| REQ-022 | - | D1: Phase 0 = @G step | Lines 572-622: Timeline diagram |
| REQ-023 | REQ-010 needs waiver mechanism | - | Line 538: external_project waiver |
| REQ-024 | Failure 2: Zero tests bypass loophole | D4: Both file + runner | Line 59: Zero-test = failure |
| REQ-025 | Test infra can't be set up if tests required | D5: is_test_setup flag | Line 417: PR-000 exception |
| REQ-026 | Risk: Breaking active work | D2: Grandfather existing | Recon Q2 default: grandfather |

---

*Generated by spec-writer agent — 2026-02-10*
