---
title: FORGE System Hardening — Implementation-Ready Proposal
date: 2026-02-10
version: v1.0
status: Ready for Review
author: spec-writer (Ralph)
canon_mode: true
work_item: 2026-02-10-forge-system-hardening
---

# FORGE System Hardening — Implementation-Ready Proposal

## 1. Summary

This proposal hardens FORGE's enforcement mechanisms to prevent four systemic failures identified during a project foundations reset. The changes address:

1. **Stakeholder portal drift** — Missing auth architecture decision gates allowed implicit assumptions about auth plane separation
2. **Tests-first canon violations** — Zero-test bypass loophole in Sacred Four enforcement
3. **Missing structural signals** — No agent verified project location or structure before execution
4. **Implicit vs explicit canon** — Agents optimized for production (artifact creation) instead of verification (precondition checking)

The solution adds @G-driven structural verification as an explicit step after @C completion, extends Law 5 with precondition requirements, adds four mandatory templates (STAKEHOLDER-MODEL, AUTH-ARCHITECTURE ADR, TEST-INFRASTRUCTURE, PREFLIGHT-CHECKLIST), implements comprehensive pre-flight checks across all agents, and closes the Sacred Four zero-test loophole. All changes preserve the F.O.R.G.E acronym and existing lifecycle semantics.

Implementation impacts 23 files (19 modifications, 4 new templates). Changes are backward-compatible via grandfathering: existing projects are exempt from new gates; enforcement applies only to projects created after implementation.

---

## 2. Root Cause Summary

### Failure 1: Stakeholder Portal Drift

**What happened:** Stakeholder portal implemented as combined super-user role in the product auth system instead of a distinct second plane. Roles stored on profiles instead of scoped memberships. No early decision point for "how many auth planes?"

**Root causes:**
- Required Extensions mention "Auth/RBAC" and "Stakeholder Interface" but provide no template, no checklist, no mandatory artifact
- @F (Frame) defines actors but does not require explicit auth plane assignments
- @O (Orchestrate) designs architecture but has no mandatory auth architecture decision record gate
- The expectation that stakeholder and product concerns are separate planes exists nowhere in canon — it was a human assumption, not an enforced requirement

### Failure 2: Tests-First Canon Violation

**What happened:** Multiple PRs shipped with zero test infrastructure despite canon mandating tests-first, Sacred Four, and 80%+ coverage.

**Root causes:**
- Sacred Four is reactive (fails at PR time) not proactive (blocks execution start without test infra)
- @E checks "do tests pass?" but not "does test infrastructure exist?" — zero tests = zero failures = Sacred Four "passes"
- CI/CD workflow templates exist but no enforcement that they are set up before PR-001
- @G validates transitions but does not audit whether test infrastructure is configured before approving execution handoffs
- `forge-template-testing-requirements.md` says "Tests are required" but @E's startup checks only verify `FORGE-ENTRY.md` exists, not test readiness

### Failure 3: Missing Structural Signals

**What happened:** Project lived outside `FORGE/projects/`, inbox packets and PR packets absent, archival discipline missing. FORGE execution continued without warning.

**Root causes:**
- No agent checks whether the project is under `FORGE/projects/`
- Agents check for `FORGE-ENTRY.md` but not for project structure (inbox/, docs/, tests/)
- @G does not audit for inbox packets, PR packets, or router-event logs during transitions
- No canon rule states "FORGE execution is only valid within FORGE/projects/" — it is implied by templates but not enforced

### Failure 4: Implicit vs Explicit Canon

**What happened:** Critical assumptions (tests-first, role scoping, stakeholder separation) were implicit. Agents optimized for forward motion. No hard STOP until human intervention.

**Root causes:**
- Agent constraints are defined as "MUST NOT" prohibitions, not "MUST VERIFY" preconditions — agents check what they cannot do, not what must be true before they start
- No "pre-flight checklist" mechanism exists for any agent
- @E's definition has 5 MUST rules and 5 MUST NOT rules but zero pre-execution verification steps
- FORGE agents are optimized for production (make artifacts, advance phases) not verification (confirm preconditions before acting)

---

## 3. Design Decisions

| Decision ID | Question | Answer | Rationale |
|-------------|----------|--------|-----------|
| D1 | Structural verification semantics | Automatic @G verification step after @C completes, NOT a new phase | Preserves F.O.R.G.E acronym, aligns with @G's gating role, avoids lifecycle model change |
| D2 | Backward compatibility | Grandfather existing projects; new gates apply only to new projects | Prevents disruption to active work, allows voluntary migration, focuses enforcement on greenfield |
| D3 | STAKEHOLDER-MODEL requirement | Required only if stakeholder actors exist in PRODUCT.md | Avoids ceremony for projects without stakeholders, enforces where needed |
| D4 | Zero-test detection | Check both file existence AND test runner output | Prevents false positives from "no tests found" success, ensures real test execution |
| D5 | Test setup exception (PR-000) | Identified by `is_test_setup: true` flag in handoff packet | Explicit opt-in mechanism, prevents circular dependency for test infrastructure PRs |
| D6 | Preflight report generation | @G auto-generates preflight reports after running checks | Reduces manual ceremony, creates audit trail, standardizes format |
| D7 | STAKEHOLDER-MODEL validation | Schema validation (required fields must be present and non-empty) | Ensures completeness, machine-checkable, prevents half-filled templates |
| D8 | Auth architecture ADR scope | Required only for multi-user or multi-role projects | Avoids over-specification for simple auth (e.g., admin-only tools), enforces where complexity exists |
| D9 | Structural verification failure recovery | @G produces failure report and STOPS; human decides next action | Prevents auto-fix loops, surfaces structural issues clearly, human-in-the-loop for critical failures |
| D10 | Enforcement rule location | Core enforcement rules in forge-core.md (canon), detailed matrix in forge-operations.md (operational) | Canon defines principles, operations manual defines mechanics, separation of concerns |

---

## 4. Canon Changes (EXACT TEXT)

### 4.1 forge-core.md Changes

**File:** `/Users/leonardknight/kv-projects/FORGE/method/core/forge-core.md`

**Version:** 1.2 → 1.3

#### Change 1: Law 5a — Preconditions Are Hard Stops

**Location:** After Law 5 (Hard Stops Are Non-Negotiable), before "Agent Roles & Authority" section (after line 153)

**Insert exactly:**

```markdown
### Law 5a: Preconditions Are Hard Stops

Every agent MUST verify its preconditions before producing artifacts. Preconditions are not advisory — they are gates.

**Universal preconditions (all agents):**
- Project is under FORGE governance (FORGE/projects/ or explicit waiver)
- FORGE-AUTONOMY.yml exists and is valid
- Required upstream artifacts exist

**Phase-specific preconditions:**
- @F: FORGE-ENTRY.md exists, structural verification passed
- @O: PRODUCT.md exists with actor plane assignments
- @E: Test infrastructure configured, handoff packet exists, auth ADR exists (if auth in scope)
- @G: Project structure valid, router-events directory writable

**Enforcement:**
An agent that cannot verify its preconditions MUST STOP. "Precondition unknown" is equivalent to "precondition failed." Zero tests is a test gate failure, not a test gate pass.
```

#### Change 2: Explicit Architecture Decisions Rule

**Location:** After Law 5a, before "Agent Roles & Authority" section

**Insert exactly:**

```markdown
### Rule: Explicit Architecture Decisions

For the following concerns, FORGE requires an explicit, documented decision before implementation begins. Implicit defaults are canon violations:

1. **Auth planes:** How many auth systems? Who belongs to which?
2. **Role scoping:** Profile-level or membership-level?
3. **Stakeholder separation:** Same plane as product users or different?
4. **Test infrastructure:** What framework? What coverage tool? What thresholds?

These decisions are captured in Architecture Decision Records (ADRs) in `docs/adr/`. @O produces them. @G verifies them. @E refuses to proceed without them.
```

#### Change 3: Required Extensions Enhancement

**Location:** Within "Extensions" section, "Required Extensions" subsection (after line 318)

**Find existing text:**

```markdown
**For Software Projects:**
- **[Auth/RBAC](../docs/extensions/auth-rbac.md)** — Identity and permission foundation. Ships Day One.
- **[Stakeholder Interface](../docs/extensions/stakeholder-interface.md)** — First-party visibility, feedback, and AI assistance. Ships Day One.
```

**Replace with:**

```markdown
**For Software Projects:**
- **[Auth/RBAC](../docs/extensions/auth-rbac.md)** — Identity and permission foundation. Ships Day One. Auth architecture decisions MUST be documented in an ADR before implementation begins.
- **[Stakeholder Interface](../docs/extensions/stakeholder-interface.md)** — First-party visibility, feedback, and AI assistance. Ships Day One. If stakeholders are distinct from product users, a STAKEHOLDER-MODEL MUST define the plane separation.
```

---

### 4.2 forge-operations.md Changes

**File:** `/Users/leonardknight/kv-projects/FORGE/method/core/forge-operations.md`

**Version:** 1.2 → 1.3

#### Change 1: Sacred Four Zero-Test Clarification

**Location:** Within Part 2 (The Verification Sequence), Section 2.1 (The Sacred Four), after the table (after line 130)

**Find existing text:**

```markdown
**Critical:** All four must pass. Tests passing does not mean build passes. Build catches route conflicts, missing exports, and bundle issues that tests miss.
```

**Replace with:**

```markdown
**Critical:** All four must pass. Tests passing does not mean build passes. Build catches route conflicts, missing exports, and bundle issues that tests miss.

**Zero-test enforcement:** The test step MUST execute at least one test. Zero tests is a Sacred Four FAILURE, not a pass. Test runner output showing "no tests found" is a gate failure. @E MUST verify that test files exist AND that the test runner executes tests before claiming Sacred Four success.
```

#### Change 2: @G Structural Verification Step

**Location:** Within Part 1 (The FORGE Cycle), after Section 1.3 (Cycle Timing), before Part 2 (The Verification Sequence)

**Insert new section:**

```markdown
### 1.4 Structural Verification (@G Step)

After @C completes and before @F begins, @G performs an automatic structural verification step. This is NOT a new phase — it is a @G verification action that ensures the project scaffold is valid before FORGE execution begins.

**When it runs:** Immediately after @C produces `abc/FORGE-ENTRY.md`, before routing to @F.

**What @G verifies:**

```
Structure Gate Checklist:
[ ] Project exists under FORGE/projects/<slug>/ OR has `external_project: true` in FORGE-AUTONOMY.yml
[ ] abc/FORGE-ENTRY.md exists
[ ] docs/constitution/ directory exists
[ ] docs/adr/ directory exists
[ ] docs/ops/ directory exists with state.md
[ ] docs/router-events/ directory exists
[ ] inbox/00_drop/ directory exists
[ ] inbox/10_product-intent/ directory exists
[ ] inbox/20_architecture-plan/ directory exists
[ ] inbox/30_ops/handoffs/ directory exists
[ ] tests/ directory exists (for code projects)
[ ] CLAUDE.md exists at project root
[ ] FORGE-AUTONOMY.yml exists and is valid
```

**On success:** @G logs verification success to router events, auto-generates `docs/ops/preflight-checklist.md` with results, proceeds to route to @F (per autonomy tier).

**On failure:** @G logs verification failure, produces failure report at `docs/ops/preflight-failure-report.md`, STOPS. Human MUST address structural issues before FORGE execution can begin.

**Grandfathering:** Projects with `abc/FORGE-ENTRY.md` created before 2026-02-10 are exempt from structural verification. Verification applies only to new projects.
```

#### Change 3: Enforcement Matrix (Core Rules Portion)

**Location:** At end of document, before Version History, create new section

**Insert new section:**

```markdown
---

## Part 13: Enforcement Matrix

This matrix defines what agent enforces what rule at what trigger point. It is the operational reference for FORGE enforcement mechanisms.

### Core Enforcement Rules

| Rule | Enforcing Agent | Trigger Point | Failure Mode | Bypass |
|------|----------------|---------------|--------------|--------|
| Project under FORGE/projects/ | ALL agents (startup) | Agent invocation | HARD STOP (unless waiver) | `external_project: true` in FORGE-AUTONOMY.yml |
| Template scaffold structure valid | @G | Structural verification step after @C | HARD STOP | None |
| Test framework installed | @E | Before first PR | HARD STOP | `is_test_setup: true` flag in handoff (PR-000 only) |
| At least one test exists | @E | Before every PR | HARD STOP | `is_test_setup: true` flag in handoff (PR-000 only) |
| Sacred Four passes with real tests | @E | Before every PR merge | HARD STOP | None |
| Auth architecture ADR exists | @G | Before first auth-related @E handoff | HARD STOP | N/A if no auth in scope |
| Stakeholder model defined | @F | Frame completion gate | HARD STOP | N/A if no stakeholders |
| Actor plane assignment explicit | @F | Frame completion gate | HARD STOP | None |
| Role scoping documented | @O | Orchestrate completion gate | HARD STOP | None |
| Handoff packet exists | @E | Before starting handoff work | HARD STOP | None |
| PR packet produced | @E | Before PR creation | HARD STOP | None |
| Router events logged | @G | Every transition | WARN (degraded governance) | None |
| Coverage delta >= 0 | @E + CI | Every PR | HARD STOP | None |
| FORGE-AUTONOMY.yml exists | ALL agents | Agent invocation | HARD STOP | None |

### Enforcement Timeline

```
Project Lifecycle with Enforcement Points:

  @A (Acquire)
  ├── CHECK: Project will be created under FORGE/projects/ ← NEW
  └── OUTPUT: abc/INTAKE.md

  @C (Commit)
  ├── CHECK: abc/INTAKE.md exists
  └── OUTPUT: abc/FORGE-ENTRY.md  [EXISTING GATE]

  ──── STRUCTURAL VERIFICATION (@G STEP) ──── [NEW]
  │
  │  @G verifies:
  │  ├── Project structure matches template
  │  ├── FORGE-AUTONOMY.yml exists
  │  ├── docs/ structure exists
  │  ├── inbox/ structure exists
  │  ├── tests/ directory exists
  │  └── OUTPUT: docs/ops/preflight-checklist.md [PASS or HARD STOP]
  │

  @F (Frame)
  ├── CHECK: Structural verification passed ← NEW
  ├── CHECK: Preflight checklist exists ← NEW
  ├── MANDATORY DECISION: Auth planes ← NEW
  ├── MANDATORY DECISION: Stakeholder model ← NEW
  └── OUTPUT: PRODUCT.md (enhanced)

  @O (Orchestrate)
  ├── CHECK: Actor planes assigned in PRODUCT.md ← NEW
  ├── MANDATORY OUTPUT: Auth architecture ADR ← NEW
  ├── MANDATORY OUTPUT: Test architecture spec ← NEW
  └── OUTPUT: TECH.md (enhanced)

  @G (Transition to Execute)
  ├── CHECK: Auth ADR exists (if auth in scope) ← NEW
  ├── CHECK: Test infrastructure configured ← NEW
  ├── CHECK: Handoff packet in inbox/30_ops/handoffs/ ← NEW
  └── APPROVE or HARD STOP

  @E (Execute)
  ├── PRE-FLIGHT: Structure check ← NEW
  ├── PRE-FLIGHT: Test infra check ← NEW
  ├── PRE-FLIGHT: Auth readiness check ← NEW
  ├── PRE-FLIGHT: Sacred Four dry run ← NEW
  ├── WORK: Tests-first implementation [EXISTING]
  ├── CHECK: Coverage gate [EXISTING, now verified]
  ├── CHECK: PR packet produced ← NEW enforcement
  └── OUTPUT: PR + Completion Packet
```
```

#### Change 4: Grandfathering Policy

**Location:** After Enforcement Matrix section, before Version History

**Insert exactly:**

```markdown
### Grandfathering Policy

**Effective date:** 2026-02-10

**Policy:** Projects with `abc/FORGE-ENTRY.md` created before 2026-02-10 are exempt from new enforcement gates introduced in this hardening release. New gates apply only to projects created after structural verification enforcement is implemented.

**What is grandfathered:**
- Structural verification step (@G after @C)
- @F auth plane decision gate
- @O auth architecture ADR requirement
- @E pre-flight checks (structure, test infra, auth readiness)
- Universal project location check

**What is NOT grandfathered (applies to all projects):**
- Sacred Four zero-test clarification (applies retroactively)
- Enforcement matrix documentation (operational reference only)

**Migration:** Existing projects MAY voluntarily adopt new enforcement gates by:
1. Running structural verification manually via @G
2. Adding missing templates (STAKEHOLDER-MODEL, AUTH-ARCHITECTURE ADR, etc.)
3. Updating project CLAUDE.md to reflect new non-negotiables

Migration is optional. Grandfathered projects remain fully valid FORGE projects.
```

---

## 5. New Templates (COMPLETE CONTENT)

### 5.1 STAKEHOLDER-MODEL Template

**File:** `/Users/leonardknight/kv-projects/FORGE/template/project/docs/constitution/STAKEHOLDER-MODEL.md.template`

**Action:** CREATE

**Content:**

```markdown
# Stakeholder Model

**Project:** [PROJECT_NAME]
**Date:** [YYYY-MM-DD]
**Author:** @F (Frame)
**Status:** [DRAFT | ACCEPTED]

---

## Auth Planes

| Plane | Description | Auth Provider | Role Scoping |
|-------|-------------|---------------|--------------|
| [Product/Stakeholder/Admin] | | | |

## Decision

- [ ] Single-plane auth (all actors share one auth system)
- [ ] Multi-plane auth (actors are separated into distinct systems)

**Rationale:** [Why this choice]

## Role Architecture

- [ ] Roles on user profile (flat, per-user)
- [ ] Roles via scoped membership (per-organization/per-project)
- [ ] Hybrid

**Rationale:** [Why this choice]

## Actor → Plane Mapping

| Actor | Plane | Roles | Scoping |
|-------|-------|-------|---------|
| | | | |

---

## Validation Checklist

This template is complete when:

- [ ] All auth planes are defined with description, provider, and scoping
- [ ] Single-plane OR multi-plane decision is checked (exactly one)
- [ ] Rationale for plane decision is provided
- [ ] Role architecture decision is checked (at least one)
- [ ] Rationale for role architecture is provided
- [ ] Actor → Plane Mapping table is populated with all actors from PRODUCT.md
- [ ] Every actor has explicit plane assignment
- [ ] Every actor has role scoping defined

**Required by:** @F completion gate (if stakeholders exist in PRODUCT.md)

**Validated by:** @F (schema check), @G (artifact existence check before @O handoff)
```

---

### 5.2 AUTH-ARCHITECTURE ADR Template

**File:** `/Users/leonardknight/kv-projects/FORGE/template/project/docs/adr/001-auth-architecture.md.template`

**Action:** CREATE

**Content:**

```markdown
# ADR-001: Authentication Architecture

**Project:** [PROJECT_NAME]
**Date:** [YYYY-MM-DD]
**Author:** @O (Orchestrate)
**Status:** [PROPOSED | ACCEPTED | SUPERSEDED]

---

## Context

[What is the auth challenge for this project? Who are the users? What are the sensitivity/compliance requirements?]

## Decision

### Auth Planes

[How many auth planes exist? What is the rationale?]

**Planes:**
1. [Plane 1 name] — [Description]
2. [Plane 2 name] — [Description, if multi-plane]

### Role Scoping Mechanism

- [ ] Roles on user profile (flat, per-user)
- [ ] Roles via scoped membership (per-organization/per-project)
- [ ] Hybrid

**Implementation:** [How roles are stored and retrieved]

### Auth Provider

[Supabase Auth / Auth0 / Clerk / Custom / etc.]

### RLS Policy Mapping

[How do RLS policies map to this architecture?]

Example:
```sql
-- Product users can only see their own data
CREATE POLICY "product_users_own_data" ON public.profiles
  FOR ALL USING (auth.uid() = id);

-- Stakeholders can see all data in their organizations
CREATE POLICY "stakeholders_see_org_data" ON public.organizations
  FOR SELECT USING (
    auth.uid() IN (
      SELECT user_id FROM stakeholder_memberships
      WHERE organization_id = organizations.id
    )
  );
```

---

## Consequences

**Positive:**
- [What this decision enables]

**Negative:**
- [What this decision constrains or complicates]

**Mitigations:**
- [How negative consequences are addressed]

---

## Validation Checklist

This ADR is complete when:

- [ ] Context explains the auth challenge
- [ ] Number of auth planes is explicitly stated (1, 2, or more)
- [ ] Each plane has a name and description
- [ ] Role scoping mechanism is defined (profile vs membership vs hybrid)
- [ ] Auth provider is specified
- [ ] RLS policy mapping is documented with examples
- [ ] Each actor from STAKEHOLDER-MODEL has a plane assignment
- [ ] Stakeholder access is not conflated with product access (if multi-plane)
- [ ] Consequences (positive and negative) are documented
- [ ] Mitigations for negative consequences are provided

**Required by:** @O completion gate (if multi-user or multi-role project)

**Validated by:** @O (completeness check), @G (artifact existence check before @E handoff)
```

---

### 5.3 TEST-INFRASTRUCTURE Template

**File:** `/Users/leonardknight/kv-projects/FORGE/template/project/docs/ops/test-infrastructure.md.template`

**Action:** CREATE

**Content:**

```markdown
# Test Infrastructure

**Project:** [PROJECT_NAME]
**Date:** [YYYY-MM-DD]
**Author:** @E (Execute — PR-000 test setup)
**Status:** [DRAFT | CONFIGURED | OPERATIONAL]

---

## Framework

- **Unit:** [Vitest/Jest/etc.]
- **Integration:** [Vitest/Jest/etc.]
- **E2E:** [Playwright/Cypress/etc.]
- **Coverage:** [c8/istanbul/etc.]

## Configuration

- [ ] Test framework installed (check package.json or equivalent)
- [ ] Test config file exists (vitest.config.ts, jest.config.ts, etc.)
- [ ] Coverage configured with thresholds
- [ ] CI workflow includes Sacred Four
- [ ] At least one passing test exists

## Sacred Four Commands

```bash
# Typecheck
[COMMAND]

# Lint
[COMMAND]

# Test
[COMMAND]

# Build
[COMMAND]
```

**All four commands MUST pass before any PR merge.**

## Coverage Thresholds

- **Default:** 70% line coverage
- **Sacred Four paths:** 100% coverage required
  - Authentication flows
  - Payment processing (Stripe)
  - Data integrity operations (create/update/delete with validation)
  - Security-sensitive paths (authorization, RLS policies)

## Test Execution

**Local:**
```bash
[COMMAND to run tests locally]
```

**CI:**
```bash
[COMMAND run by GitHub Actions or equivalent]
```

## Coverage Reports

**Local:**
```bash
[COMMAND to generate coverage report]
```

**CI:**
- Coverage reports published to [LOCATION]
- PRs blocked if coverage delta < 0

---

## Validation Checklist

This template is complete when:

- [ ] All framework types are specified (unit, integration, E2E, coverage)
- [ ] Configuration checklist is fully checked
- [ ] Sacred Four commands are documented with exact syntax
- [ ] Coverage thresholds are defined (default + Sacred Four paths)
- [ ] Test execution commands are provided (local + CI)
- [ ] Coverage report generation is documented

**Required by:** @E pre-flight checks (before PR-001)

**Validated by:** @E (test execution verification), @G (artifact existence check)
```

---

### 5.4 PREFLIGHT-CHECKLIST Template

**File:** `/Users/leonardknight/kv-projects/FORGE/template/project/docs/ops/preflight-checklist.md.template`

**Action:** CREATE

**Content:**

```markdown
# Pre-Flight Checklist

**Project:** [PROJECT_NAME]
**Date:** [YYYY-MM-DD]
**Generated by:** @G (Govern — Structural Verification)
**Status:** [PASS | FAIL]

---

## Structure Verification

- [ ] Project under FORGE/projects/<slug>/ OR has `external_project: true` waiver
- [ ] abc/FORGE-ENTRY.md exists
- [ ] docs/constitution/ populated
- [ ] docs/adr/ initialized
- [ ] docs/ops/state.md exists
- [ ] inbox/00_drop/ exists
- [ ] inbox/10_product-intent/ exists
- [ ] inbox/20_architecture-plan/ exists
- [ ] inbox/30_ops/handoffs/ exists
- [ ] docs/router-events/ exists
- [ ] tests/ directory exists (for code projects)
- [ ] CLAUDE.md exists at project root
- [ ] FORGE-AUTONOMY.yml valid

## Test Readiness (for code projects)

- [ ] Test framework installed
- [ ] Test config file exists
- [ ] At least one test passes
- [ ] Sacred Four runs without error
- [ ] CI/CD workflows configured

## Auth Readiness (if applicable)

- [ ] Auth architecture ADR exists (for multi-user/multi-role projects)
- [ ] Stakeholder model defined (if stakeholders exist)
- [ ] Role scoping decided
- [ ] Plane assignments complete

---

## Verification Result

**Overall Status:** [PASS | FAIL]

**Verified By:** @G

**Verification Date:** [YYYY-MM-DD HH:MM:SS UTC]

**Failures (if any):**
- [List of failed checks]

**Next Steps:**
- [If PASS] Proceed to @F (Frame)
- [If FAIL] Human MUST address failures before FORGE execution can begin

---

**This report is auto-generated by @G during structural verification. It is not modified after creation.**
```

---

## 6. Template Enhancements

### 6.1 Enhanced PRODUCT.md Template Guidance

**File:** `/Users/leonardknight/kv-projects/FORGE/method/templates/forge-template-frame.md`

**Action:** MODIFY (if file exists) or CREATE (if it does not exist)

**Location:** Within "Required Sections" or equivalent, after "Actors" section

**Insert exactly:**

```markdown
### Actor Taxonomy with Plane Assignment (NEW)

For each actor identified in the Actors section, the following MUST be defined:

| Actor | Auth Plane | Role Scoping | Data Boundaries |
|-------|-----------|--------------|-----------------|
| [Actor 1] | [Product/Stakeholder/Admin] | [Profile-level/Membership-level] | [What can they see/do?] |
| [Actor 2] | [Product/Stakeholder/Admin] | [Profile-level/Membership-level] | [What can they see/do?] |

**Auth Model Decision:**

- [ ] Single-plane auth (all actors share one auth system)
- [ ] Multi-plane auth (actors are separated into distinct systems)

**Rationale:** [Why this choice?]

**Stakeholder Access Model (if multi-plane):**
- [How do stakeholders access the system?]
- [What is different from product users?]

**Data Ownership Boundaries:**
- [What data does each actor own?]
- [What data can each actor access?]

**Mandatory:** If stakeholders exist, STAKEHOLDER-MODEL.md MUST be started during Frame and completed during Orchestrate.

**Gate:** @F MUST NOT complete until all actors have explicit plane assignments and the auth model decision is answered.
```

---

### 6.2 Enhanced TECH.md Guidance

**File:** `/Users/leonardknight/kv-projects/FORGE/method/templates/forge-template-orchestrate.md`

**Action:** MODIFY (if file exists) or CREATE (if it does not exist)

**Location:** Within "Required Sections" or equivalent

**Insert exactly:**

```markdown
### Auth Architecture Section (MANDATORY for projects with auth)

TECH.md MUST include an Auth Architecture section OR reference an AUTH-ARCHITECTURE ADR in `docs/adr/`.

**Minimum content:**
- Number of auth planes
- Auth provider (Supabase Auth, Auth0, Clerk, custom, etc.)
- Role scoping mechanism (profile-level vs membership-level)
- RLS policy mapping strategy
- Stakeholder vs product boundary definition (if multi-plane)

**Delivery:** @O MUST produce AUTH-ARCHITECTURE ADR (docs/adr/001-auth-architecture.md) before completion if the project has multi-user or multi-role requirements.

**Gate:** @O MUST NOT complete until AUTH-ARCHITECTURE ADR exists (when applicable).

---

### Test Infrastructure Section (MANDATORY for projects with code)

TECH.md MUST specify test infrastructure:

**Minimum content:**
- Test framework (Vitest, Jest, Playwright, etc.)
- Coverage tool (c8, istanbul, etc.)
- Sacred Four commands (typecheck, lint, test, build)
- Coverage thresholds (default + Sacred Four paths)
- CI/CD integration approach

**Delivery:** @O specifies test architecture; @E implements during PR-000 test setup handoff.

**Gate:** @G MUST verify test infrastructure is configured before approving any @E handoff.
```

---

### 6.3 Enhanced CLAUDE.md Project Identity Template

**File:** `/Users/leonardknight/kv-projects/FORGE/method/templates/forge-template-project-identity.md`

**Action:** MODIFY

**Location:** Within "Non-Negotiables" section (or create section if missing)

**Insert exactly:**

```markdown
### Pre-Flight Gate (NEW)

Before any PR is created, @E MUST verify:

1. **Test framework runs and produces output** — "No tests found" is a gate failure
2. **At least one test exists and passes** — Zero tests = zero verification
3. **Auth architecture ADR exists** (if auth features are in scope)
4. **Stakeholder model is defined** (if stakeholder features exist)
5. **Sacred Four completes without error** — Not just without failure, but with actual test execution

**Exception:** PR-000 (test infrastructure setup) may bypass test checks via `is_test_setup: true` flag in handoff packet.

### Structural Integrity (NEW)

This project MUST maintain FORGE structure:

- All handoff packets in `inbox/30_ops/handoffs/`
- All router events in `docs/router-events/`
- All ADRs in `docs/adr/`
- All completion packets in designated location
- All constitutional documents in `docs/constitution/`

**Verification:** @G audits structure during transitions. Deviation from structure is a governance violation.

**Recovery:** If structure is found invalid, @G STOPS and produces failure report. Human MUST restore structure before FORGE execution can continue.
```

---

### 6.4 Enhanced Repository Scaffold Documentation

**File:** `/Users/leonardknight/kv-projects/FORGE/method/templates/forge-template-repository-scaffold.md`

**Action:** MODIFY

**Location:** After scaffold directory tree, before any "Optional" sections

**Insert exactly:**

```markdown
## Required Structure Verification (NEW)

The following directories and files MUST exist before @E begins execution. @G verifies this checklist during structural verification after @C completes.

### Mandatory (all projects)

- `abc/FORGE-ENTRY.md` — Gate artifact for FORGE unlock
- `docs/constitution/` — Product intent and governance documents
- `docs/adr/` — Architecture decision records
- `docs/ops/state.md` — Execution state narrative
- `docs/ops/preflight-checklist.md` — Structural verification results
- `docs/router-events/` — Append-only router event logs
- `inbox/00_drop/` — Discovery input
- `inbox/10_product-intent/` — Product strategist outputs
- `inbox/20_architecture-plan/` — Architect outputs
- `inbox/30_ops/handoffs/` — Execution handoff packets
- `CLAUDE.md` — Project identity and constraints
- `FORGE-AUTONOMY.yml` — Autonomy policy configuration

### Mandatory (projects with auth)

- `docs/constitution/STAKEHOLDER-MODEL.md` — Auth plane and role architecture (if stakeholders exist)
- `docs/adr/001-auth-architecture.md` — Auth architecture decision record (if multi-user/multi-role)

### Mandatory (projects with code)

- `tests/` — Test directory
- Test framework config file (vitest.config.ts, jest.config.ts, etc.)
- At least one `.test.` or `.spec.` file with passing test
- CI workflow with Sacred Four (`.github/workflows/` or equivalent)
- `docs/ops/test-infrastructure.md` — Test framework and coverage documentation

### Enforcement

**When:** @G verifies structure after @C completion (before routing to @F)

**On failure:** @G produces `docs/ops/preflight-failure-report.md` with missing items, STOPS. Human MUST address failures.

**On success:** @G auto-generates `docs/ops/preflight-checklist.md` with verification results, proceeds to route to @F (per autonomy tier).

**Grandfathering:** Projects created before 2026-02-10 are exempt from structural verification.
```

---

## 7. Agent Operating Guide Changes (EXACT TEXT)

### 7.1 @E Pre-Flight Verification

**File:** `/Users/leonardknight/kv-projects/FORGE/method/agents/forge-e-operating-guide.md`

**Action:** MODIFY

**Location:** Insert new section before Section 6 (Handoff → Completion Protocol), after Section 5 (Escalation Triggers)

**Insert exactly:**

```markdown
## 5.5 Pre-Flight Verification (NEW)

Before accepting any handoff, @E MUST run pre-flight checks IN ORDER. These checks are HARD STOPS — if any check fails, @E produces a failure report and STOPS.

### Check 1: Structure

- [ ] Project root has CLAUDE.md
- [ ] Project root has FORGE-AUTONOMY.yml
- [ ] abc/FORGE-ENTRY.md exists
- [ ] docs/ structure matches template scaffold
- [ ] inbox/30_ops/handoffs/ exists

**IF ANY FAIL → HARD STOP.** Report: "Structure gate failed: [missing items]"

### Check 2: Test Infrastructure

- [ ] Test framework is installed (check package.json or equivalent)
- [ ] Test config file exists (vitest.config.ts, jest.config.ts, etc.)
- [ ] `pnpm test` (or equivalent) executes and produces output (NOT "no tests found")
- [ ] At least one test file exists (*.test.*, *.spec.*)

**IF ANY FAIL → HARD STOP.** Report: "Test infrastructure gate failed: [missing items]"

**EXCEPTION:** If handoff packet contains `is_test_setup: true` flag (PR-000 test infrastructure setup), skip test checks and proceed.

### Check 3: Auth Readiness (conditional)

**IF handoff involves auth, roles, permissions, or user management:**

- [ ] AUTH-ARCHITECTURE ADR exists in docs/adr/
- [ ] Stakeholder model defined in docs/constitution/ (if stakeholders in scope)
- [ ] Role scoping mechanism documented (profile vs membership)

**IF ANY FAIL → HARD STOP.** Report: "Auth architecture gate failed: [missing items]"

**IF handoff does NOT involve auth:** Skip this check.

### Check 4: Sacred Four Dry Run

- [ ] `pnpm typecheck` succeeds (or reports expected pre-existing errors only)
- [ ] `pnpm lint` succeeds
- [ ] `pnpm test` succeeds (with actual test execution, not "no tests found")
- [ ] `pnpm build` succeeds

**IF ANY FAIL → WARN.** Report: "Sacred Four pre-flight warning: [details]"

(Not a hard stop because the handoff may fix these issues, but @E must be aware.)

### Failure Reporting

On any HARD STOP, @E:
1. Produces pre-flight failure report: `docs/ops/preflight-failure-[handoff-id].md`
2. Logs failure to completion packet (status: `blocked`)
3. Returns to @G with failure details
4. STOPS (does not proceed with implementation)

### Success Path

If all checks pass (or are skipped with valid exceptions):
1. @E logs pre-flight success to completion packet
2. @E proceeds with implementation per handoff packet
```

**Also update:** `.claude/skills/forge-e/SKILL.md` (agent skill definition)

**Location:** Within startup sequence or constraints section

**Insert exactly:**

```markdown
## Pre-Flight Verification (MANDATORY)

Before accepting any handoff, run pre-flight checks:

1. **Structure gate** — Verify CLAUDE.md, FORGE-AUTONOMY.yml, abc/FORGE-ENTRY.md, docs/, inbox/ exist
2. **Test infrastructure gate** — Verify test framework installed, config exists, tests execute (EXCEPTION: `is_test_setup: true` flag)
3. **Auth readiness gate** — Verify AUTH-ARCHITECTURE ADR exists (if handoff involves auth)
4. **Sacred Four dry run** — Run typecheck, lint, test, build (WARN on failure, not HARD STOP)

**HARD STOP conditions:** Missing structure, missing test infrastructure (unless PR-000), missing auth architecture (if auth work).

**Failure action:** Produce `docs/ops/preflight-failure-[handoff-id].md`, log to completion packet (status: `blocked`), return to @G, STOP.
```

---

### 7.2 @G Verification Step and Structural Audit

**File:** `/Users/leonardknight/kv-projects/FORGE/method/agents/forge-g-operating-guide.md`

**Action:** MODIFY

**Location:** Insert new section after Section 7.1 (Handling a Transition Request), before Section 7.2 (Handling a "Catch Me Up" Request)

**Insert exactly:**

```markdown
### 7.1a Structural Verification After @C (NEW)

When @C completes and produces `abc/FORGE-ENTRY.md`, @G MUST perform structural verification BEFORE routing to @F. This is an automatic @G action, not a new phase.

**Trigger:** `abc/FORGE-ENTRY.md` creation detected

**Action sequence:**

```
1. READ POLICY
   - Check FORGE-AUTONOMY.yml for `external_project` waiver
   - Check project creation date for grandfathering (before 2026-02-10)

2. IF GRANDFATHERED
   - Log: "Project grandfathered — structural verification skipped"
   - Proceed to route to @F (per autonomy tier)

3. IF NOT GRANDFATHERED
   - Run structural verification checklist:
     [ ] Project under FORGE/projects/<slug>/ OR `external_project: true`
     [ ] abc/FORGE-ENTRY.md exists
     [ ] docs/constitution/ exists
     [ ] docs/adr/ exists
     [ ] docs/ops/state.md exists
     [ ] docs/router-events/ exists
     [ ] inbox/00_drop/ exists
     [ ] inbox/10_product-intent/ exists
     [ ] inbox/20_architecture-plan/ exists
     [ ] inbox/30_ops/handoffs/ exists
     [ ] tests/ exists (for code projects)
     [ ] CLAUDE.md exists
     [ ] FORGE-AUTONOMY.yml exists and is valid

4. EVALUATE RESULT
   - IF ALL PASS:
     - Auto-generate `docs/ops/preflight-checklist.md` with PASS status
     - Log structural verification success to router events
     - Proceed to route to @F (per autonomy tier)

   - IF ANY FAIL:
     - Auto-generate `docs/ops/preflight-failure-report.md` with failure details
     - Log structural verification failure to router events
     - Instruct human: "Structural verification failed. Address failures before FORGE execution."
     - STOP (do not route to @F)
```

**Output artifacts:**
- `docs/ops/preflight-checklist.md` (on success)
- `docs/ops/preflight-failure-report.md` (on failure)
- Router event log entry (all cases)

**Human recovery path (on failure):**
1. Read `docs/ops/preflight-failure-report.md`
2. Address missing directories/files
3. Re-invoke @G to re-run structural verification
4. On success, @G proceeds to route to @F
```

**Also insert:** New section after Section 7.3 (Handling Completion Packet Validation)

**Insert exactly:**

```markdown
### 7.4 Transition-Specific Validation (NEW)

Before approving ANY transition, @G MUST validate transition-specific preconditions. These checks are in addition to policy evaluation (Tier 0/1/2/3).

#### On transition @C → @F (after structural verification passes)

- [ ] Structural verification completed with PASS status
- [ ] `docs/ops/preflight-checklist.md` exists

**IF FAIL → HARD STOP:** "Cannot begin Frame — structural verification incomplete or failed"

#### On transition @F → @O

- [ ] PRODUCT.md exists
- [ ] All actors in PRODUCT.md have explicit auth plane assignments
- [ ] Auth model decision (single-plane vs multi-plane) is answered

**IF FAIL → HARD STOP:** "Cannot begin Orchestrate — product framing incomplete or auth planes not assigned"

#### On transition @O → @E (first handoff)

- [ ] TECH.md exists
- [ ] AUTH-ARCHITECTURE ADR exists (if auth in scope)
- [ ] Test infrastructure specification exists in TECH.md or `docs/ops/test-infrastructure.md`
- [ ] Handoff packet exists in `inbox/30_ops/handoffs/`

**IF FAIL → HARD STOP:** "Cannot begin Execute — preconditions unmet: [list missing items]"

#### Universal checks (all transitions)

- [ ] Project is under FORGE/projects/ OR has explicit waiver (`external_project: true`)
- [ ] `docs/router-events/` exists and is writable
- [ ] FORGE-AUTONOMY.yml is valid

**IF FAIL → HARD STOP:** "Governance structure invalid"

**Logging:** All transition validation results MUST be logged to router events, regardless of pass/fail.
```

**Also update:** `.claude/skills/forge-g/SKILL.md` (agent skill definition)

**Location:** Within startup sequence or transition handling section

**Insert exactly:**

```markdown
## Structural Verification After @C (MANDATORY)

When @C completes:
1. Check for grandfathering (project created before 2026-02-10)
2. If NOT grandfathered, run structural verification checklist
3. On PASS: auto-generate `docs/ops/preflight-checklist.md`, log success, proceed to @F
4. On FAIL: auto-generate `docs/ops/preflight-failure-report.md`, log failure, STOP

## Transition-Specific Validation (MANDATORY)

Before approving transitions:
- **@C → @F:** Structural verification passed
- **@F → @O:** Actor planes assigned, auth model decided
- **@O → @E:** AUTH-ARCHITECTURE ADR exists (if auth), test infra configured, handoff packet exists
- **Universal:** Project under FORGE/projects/ or waived, router-events/ writable, FORGE-AUTONOMY.yml valid

**HARD STOP on any failure.** Instruct human with specific missing items.
```

---

### 7.3 @F Mandatory Auth Plane Decision

**File:** `/Users/leonardknight/kv-projects/FORGE/method/agents/forge-f-operating-guide.md`

**Action:** MODIFY (if file exists; if not, create with this content as a section)

**Location:** At completion gate section (or create one if missing)

**Insert exactly:**

```markdown
## Completion Gate: Required Decisions (NEW)

PRODUCT.md is NOT complete until the following decisions are explicitly documented:

### Actor Classification (MANDATORY)

For each actor identified:
- [ ] Actor is assigned to an explicit auth plane (Product/Stakeholder/Admin/etc.)
- [ ] Actor's role scoping is defined (profile-level vs membership-level)
- [ ] Actor's data boundaries are defined (what can they see/do?)

### Stakeholder Decision (MANDATORY if stakeholders exist)

- [ ] "Are stakeholders and product users in the same auth plane?" — EXPLICITLY ANSWERED
- [ ] If multi-plane: STAKEHOLDER-MODEL.md started (to be completed by @O)
- [ ] If single-plane: rationale documented in PRODUCT.md

**IF NOT ANSWERED → HARD STOP:** "Cannot complete Frame without auth plane decision"

**Validation:** @F MUST self-validate before declaring PRODUCT.md complete. @G will re-validate during @F → @O transition.

**Output artifacts:**
- Enhanced PRODUCT.md with actor plane assignments table
- STAKEHOLDER-MODEL.md (if stakeholders exist) — draft started, to be completed by @O
```

**Also update:** `.claude/skills/forge-f/SKILL.md` (agent skill definition)

**Location:** Within completion criteria or constraints section

**Insert exactly:**

```markdown
## Completion Gate (MANDATORY)

PRODUCT.md is NOT complete until:
1. All actors have explicit auth plane assignments
2. Auth model decision (single-plane vs multi-plane) is answered
3. If stakeholders exist, STAKEHOLDER-MODEL.md is started

**HARD STOP if incomplete.** @F MUST self-validate before declaring completion.
```

---

### 7.4 @O Auth Architecture ADR Requirement

**File:** `/Users/leonardknight/kv-projects/FORGE/method/agents/forge-o-operating-guide.md`

**Action:** MODIFY (if file exists; if not, create with this content as a section)

**Location:** At completion gate section (or create one if missing)

**Insert exactly:**

```markdown
## Completion Gate: Auth Architecture (NEW)

TECH.md is NOT complete until the following are documented:

### Auth Architecture ADR (MANDATORY for projects with auth)

**Applies to:** Multi-user OR multi-role projects

- [ ] ADR exists in `docs/adr/` with auth architecture decision
- [ ] Number of auth planes documented
- [ ] Role scoping mechanism specified (profile vs membership)
- [ ] RLS policy mapping documented
- [ ] Stakeholder vs product boundary defined (if applicable)

**IF NOT COMPLETE → HARD STOP:** "Cannot complete Orchestration without auth architecture ADR"

**EXCEPTION:** Single-user, single-role projects (e.g., admin-only tools) MAY skip auth ADR. Rationale MUST be documented in TECH.md.

### Test Architecture (MANDATORY for projects with code)

- [ ] Test framework specified
- [ ] Coverage tool specified
- [ ] Sacred Four commands documented
- [ ] CI/CD integration specified
- [ ] Coverage thresholds defined (default + Sacred Four paths)

**IF NOT COMPLETE → HARD STOP:** "Cannot complete Orchestration without test architecture specification"

**Delivery:** @O produces `docs/ops/test-infrastructure.md` OR includes test architecture in TECH.md.

**Validation:** @O MUST self-validate before declaring TECH.md complete. @G will re-validate during @O → @E transition.

**Output artifacts:**
- `docs/adr/001-auth-architecture.md` (if auth in scope)
- `docs/ops/test-infrastructure.md` OR test architecture section in TECH.md
- Enhanced TECH.md with auth and test architecture references
```

**Also update:** `.claude/skills/forge-o/SKILL.md` (agent skill definition)

**Location:** Within completion criteria or constraints section

**Insert exactly:**

```markdown
## Completion Gate (MANDATORY)

TECH.md is NOT complete until:
1. AUTH-ARCHITECTURE ADR exists (for multi-user/multi-role projects)
2. Test architecture is specified (framework, coverage, Sacred Four commands)
3. RLS policy mapping documented (if auth in scope)

**HARD STOP if incomplete.** @O MUST self-validate before declaring completion.

**EXCEPTION:** Single-user, single-role projects MAY skip auth ADR with documented rationale.
```

---

### 7.5 Universal Project Location Check (All Agents)

**Files:**
- `.claude/skills/forge-a/SKILL.md`
- `.claude/skills/forge-b/SKILL.md`
- `.claude/skills/forge-c/SKILL.md`
- `.claude/skills/forge-f/SKILL.md`
- `.claude/skills/forge-g/SKILL.md`
- `.claude/skills/forge-o/SKILL.md`
- `.claude/skills/forge-e/SKILL.md`
- `.claude/skills/forge-r/SKILL.md`

**Action:** MODIFY (each file)

**Location:** Within startup sequence or universal constraints section

**Insert exactly (in EACH file):**

```markdown
## Universal Startup Check (MANDATORY — All Agents)

Before proceeding, verify project governance:

1. **Is this project under FORGE/projects/<slug>/?**
   - YES → Proceed normally
   - NO → Check FORGE-AUTONOMY.yml for `external_project: true` waiver
     - Waiver exists → WARN: "Project is external. Governance discipline is your responsibility."
     - No waiver → HARD STOP: "Project is not under FORGE governance. Cannot proceed."

2. **Does FORGE-AUTONOMY.yml exist?**
   - YES → Read and apply tier configuration
   - NO → HARD STOP: "Missing governance policy. Cannot determine autonomy tier."

**Enforcement:** This check runs BEFORE any agent-specific work begins.

**Exception:** @A (Acquire) runs this check as a planning verification (project will be created at valid location), not a gate.
```

---

## 8. Skill Definition Changes

For each agent's `.claude/skills/forge-X/SKILL.md` file, the changes specified in Section 7.5 (Universal Project Location Check) have already been provided.

Additionally, agent-specific startup checks from Sections 7.1 (@E), 7.2 (@G), 7.3 (@F), and 7.4 (@O) MUST be added to the respective SKILL.md files as shown in those sections.

**No additional skill definition changes beyond those already specified above.**

---

## 9. Project Template Scaffold Changes

### 9.1 New Template Files in template/project/

**Action:** CREATE the following files

1. `template/project/docs/constitution/STAKEHOLDER-MODEL.md.template`
   - Content: See Section 5.1

2. `template/project/docs/adr/001-auth-architecture.md.template`
   - Content: See Section 5.2

3. `template/project/docs/ops/test-infrastructure.md.template`
   - Content: See Section 5.3

4. `template/project/docs/ops/preflight-checklist.md.template`
   - Content: See Section 5.4

**Verification:** After implementation, `template/project/` MUST contain all four new templates in correct locations.

---

## 10. FORGE-AUTONOMY.yml Schema Update

**File:** `/Users/leonardknight/kv-projects/FORGE/method/templates/forge-template-autonomy-policy.md` (or equivalent autonomy schema documentation file)

**Action:** MODIFY

**Location:** Within schema definition, add new field

**Insert exactly:**

```yaml
# NEW FIELD (added 2026-02-10)
external_project: false  # Set to true to waive FORGE/projects/ location check

# Description:
# If true, project may exist outside FORGE/projects/ directory.
# All other FORGE governance rules still apply.
# Use case: External repositories using FORGE methodology but not in canonical FORGE/projects/ structure.
# Default: false (project MUST be under FORGE/projects/)
```

**Also document in prose:**

```markdown
### external_project Field (NEW)

**Type:** Boolean

**Default:** `false`

**Purpose:** Allows projects outside `FORGE/projects/` directory to use FORGE methodology.

**Behavior:**
- When `false` (default): All agents check that project exists under `FORGE/projects/<slug>/`
- When `true` (waiver): Agents skip location check, log warning, proceed normally

**Use case:** External repositories using FORGE methodology but not in canonical FORGE directory structure (e.g., client projects, open-source contributions, research experiments).

**Governance:** Setting `external_project: true` is a governance decision. All other FORGE rules (structural verification, test requirements, Sacred Four, etc.) still apply.

**Added:** 2026-02-10 (FORGE System Hardening)
```

---

## 11. Testing Requirements Update

**File:** `/Users/leonardknight/kv-projects/FORGE/method/templates/forge-template-testing-requirements.md`

**Action:** MODIFY

**Location:** Within Sacred Four definition or zero-test handling section

**Insert exactly:**

```markdown
### Zero-Test Clarification (CRITICAL)

The Sacred Four test step MUST execute at least one test. Zero tests is a Sacred Four FAILURE, not a pass.

**Enforcement:**

1. **File existence check:** At least one `.test.` or `.spec.` file MUST exist before running test command
2. **Test runner output check:** Test runner MUST produce test execution output, NOT "no tests found" message
3. **Both checks required:** File existence alone is insufficient; test runner MUST execute tests

**Examples of FAILURE:**

```
# Example 1: No test files exist
$ pnpm test
No test files found.
→ FAILURE (zero tests)

# Example 2: Test files exist but test runner finds nothing
$ pnpm test
0 tests found
→ FAILURE (zero tests)

# Example 3: Test framework not configured
$ pnpm test
Error: No test configuration found
→ FAILURE (test infrastructure missing)
```

**Examples of PASS:**

```
# Example: At least one test executes
$ pnpm test
✓ auth.test.ts (2 tests) 123ms
  ✓ user can sign up
  ✓ user can log in

Tests: 2 passed (2 total)
→ PASS (tests executed and passed)
```

**Agent enforcement:**
- @E MUST verify test infrastructure exists before first PR (pre-flight check)
- @E MUST verify test runner executes tests (not just exits successfully) before every PR
- @G MUST validate completion packets report `tests_added > 0` and `tests_passed > 0`

**Exception:** See PR-000 Exception below.
```

**Also insert:** New section for PR-000 exception

**Insert exactly:**

```markdown
### PR-000 Exception: Test Infrastructure Setup (NEW)

The first PR in any FORGE project MUST set up test infrastructure. This creates a circular dependency: PR-000 cannot have tests because its purpose is to create the test framework.

**Exception mechanism:**

1. **Handoff packet flag:** The handoff packet for PR-000 MUST contain `is_test_setup: true`
2. **@E behavior:** When `is_test_setup: true` flag is present, @E skips pre-flight test infrastructure checks
3. **Validation:** @E MUST produce test infrastructure as output of PR-000
4. **One-time use:** Only PR-000 may use this exception; all subsequent PRs require tests

**Example handoff packet (YAML frontmatter):**

```yaml
---
handoff_id: HO-2026-001-test-setup
handoff_type: infrastructure
is_test_setup: true  # ← EXCEPTION FLAG
scope: |
  Set up Vitest test framework with coverage reporting.
  Configure Sacred Four commands in package.json.
  Create at least one passing stub test.
acceptance_criteria:
  - Vitest installed and configured
  - At least one .test.ts file with passing test
  - Sacred Four commands documented in package.json
  - CI workflow includes Sacred Four
---
```

**Delivery requirements for PR-000:**
- Test framework installed and configured
- At least one passing test file created
- Sacred Four commands functional
- `docs/ops/test-infrastructure.md` created and complete

**After PR-000:** All subsequent PRs MUST have tests. The exception flag is invalid for any handoff after test infrastructure exists.
```

---

## 12. Implementation Sequence

### Batch 1: Canon Foundation (CRITICAL PATH)

**Prerequisite:** None

**Must complete before:** All other batches

**Files:**

1. `/Users/leonardknight/kv-projects/FORGE/method/core/forge-core.md`
   - Add Law 5a (Section 4.1, Change 1)
   - Add Explicit Architecture Decisions rule (Section 4.1, Change 2)
   - Enhance Required Extensions (Section 4.1, Change 3)

2. `/Users/leonardknight/kv-projects/FORGE/method/core/forge-operations.md`
   - Add Sacred Four zero-test clarification (Section 4.2, Change 1)
   - Add @G Structural Verification Step (Section 4.2, Change 2)
   - Add Enforcement Matrix (Section 4.2, Change 3)
   - Add Grandfathering Policy (Section 4.2, Change 4)

**Verification:** All changes applied, version numbers bumped to 1.3, no syntax errors.

**Rationale:** Canon MUST be updated first because agent changes reference canon rules.

---

### Batch 2: Templates (PARALLEL TO BATCH 3)

**Prerequisite:** Batch 1 complete

**Must complete before:** Batch 4

**Files:**

1. CREATE `/Users/leonardknight/kv-projects/FORGE/template/project/docs/constitution/STAKEHOLDER-MODEL.md.template`
   - Content: Section 5.1

2. CREATE `/Users/leonardknight/kv-projects/FORGE/template/project/docs/adr/001-auth-architecture.md.template`
   - Content: Section 5.2

3. CREATE `/Users/leonardknight/kv-projects/FORGE/template/project/docs/ops/test-infrastructure.md.template`
   - Content: Section 5.3

4. CREATE `/Users/leonardknight/kv-projects/FORGE/template/project/docs/ops/preflight-checklist.md.template`
   - Content: Section 5.4

**Verification:** All four templates exist in correct locations, content matches specification exactly.

**Rationale:** Templates MUST exist before agent behavior references them.

---

### Batch 3: Template Guidance Updates (PARALLEL TO BATCH 2)

**Prerequisite:** Batch 1 complete

**Must complete before:** Batch 4

**Files:**

1. MODIFY OR CREATE `/Users/leonardknight/kv-projects/FORGE/method/templates/forge-template-frame.md`
   - Add Actor Taxonomy with Plane Assignment section (Section 6.1)

2. MODIFY OR CREATE `/Users/leonardknight/kv-projects/FORGE/method/templates/forge-template-orchestrate.md`
   - Add Auth Architecture section (Section 6.2)
   - Add Test Infrastructure section (Section 6.2)

3. MODIFY `/Users/leonardknight/kv-projects/FORGE/method/templates/forge-template-project-identity.md`
   - Add Pre-Flight Gate section (Section 6.3)
   - Add Structural Integrity section (Section 6.3)

4. MODIFY `/Users/leonardknight/kv-projects/FORGE/method/templates/forge-template-repository-scaffold.md`
   - Add Required Structure Verification section (Section 6.4)

5. MODIFY `/Users/leonardknight/kv-projects/FORGE/method/templates/forge-template-autonomy-policy.md` (or equivalent)
   - Add `external_project` field to schema (Section 10)

6. MODIFY `/Users/leonardknight/kv-projects/FORGE/method/templates/forge-template-testing-requirements.md`
   - Add Zero-Test Clarification section (Section 11)
   - Add PR-000 Exception section (Section 11)

**Verification:** All guidance documents updated, content matches specification exactly.

**Rationale:** Template guidance updates can happen in parallel with template creation.

---

### Batch 4: Agent Behavior Changes (CRITICAL PATH)

**Prerequisite:** Batches 2 and 3 complete

**Must complete before:** Batch 5 (but Batch 5 is documentation only, so this is effectively final critical path)

**Files:**

1. **Universal location check (all 8 agents):**
   - `.claude/skills/forge-a/SKILL.md` (Section 7.5)
   - `.claude/skills/forge-b/SKILL.md` (Section 7.5)
   - `.claude/skills/forge-c/SKILL.md` (Section 7.5)
   - `.claude/skills/forge-f/SKILL.md` (Section 7.5)
   - `.claude/skills/forge-g/SKILL.md` (Section 7.5)
   - `.claude/skills/forge-o/SKILL.md` (Section 7.5)
   - `.claude/skills/forge-r/SKILL.md` (Section 7.5)
   - `.claude/skills/forge-e/SKILL.md` (Section 7.5)

2. **@G structural verification and transition gates:**
   - `/Users/leonardknight/kv-projects/FORGE/method/agents/forge-g-operating-guide.md` (Section 7.2)
   - `.claude/skills/forge-g/SKILL.md` (Section 7.2, additional content)

3. **@E pre-flight checks:**
   - `/Users/leonardknight/kv-projects/FORGE/method/agents/forge-e-operating-guide.md` (Section 7.1)
   - `.claude/skills/forge-e/SKILL.md` (Section 7.1, additional content)

4. **@F auth plane decision gate:**
   - `/Users/leonardknight/kv-projects/FORGE/method/agents/forge-f-operating-guide.md` (Section 7.3)
   - `.claude/skills/forge-f/SKILL.md` (Section 7.3, additional content)

5. **@O auth ADR requirement:**
   - `/Users/leonardknight/kv-projects/FORGE/method/agents/forge-o-operating-guide.md` (Section 7.4)
   - `.claude/skills/forge-o/SKILL.md` (Section 7.4, additional content)

**Verification:** All agents updated, startup checks present in SKILL.md files, operating guides complete.

**Rationale:** All agents MUST be updated together to prevent inconsistent enforcement. @G structural verification MUST be implemented before @E pre-flight checks reference it.

---

### Batch 5: Enforcement Documentation (FINAL)

**Prerequisite:** Batches 1-4 complete

**Must complete before:** None (documentation)

**Note:** This batch is documentation-only — enforcement matrix and timeline are already added to forge-operations.md in Batch 1, Change 3. No additional work required beyond verification.

**Verification:** Enforcement matrix exists in `method/core/forge-operations.md`, content matches specification.

**Rationale:** Documentation synthesizes all changes into reference tables. Best done last to reflect actual implementation.

---

## 13. Acceptance Criteria

Each criterion MUST be verifiable with PASS or FAIL.

### AC-001: Law 5a Exists

**Test:** Read `method/core/forge-core.md`, search for "5a. Preconditions Are Hard Stops"

**Pass:** Section exists with language matching Section 4.1, Change 1 exactly

**Fail:** Section missing or content does not match

---

### AC-002: Structural Verification Defined as @G Step

**Test:** Read `method/core/forge-operations.md`, verify structural verification is described as @G automatic step after @C, NOT as a new phase

**Pass:** Text explicitly states "@G performs structural verification after @C completion and before @F begins"

**Fail:** Structural verification described as new phase OR missing

---

### AC-003: Sacred Four Zero-Test Clarified

**Test:** Read `method/core/forge-operations.md`, search for Sacred Four definition

**Pass:** Definition includes "Zero tests = Sacred Four FAILURE" language matching Section 4.2, Change 1

**Fail:** Zero-test handling not mentioned or ambiguous

---

### AC-004: Explicit Architecture Decisions Rule Exists

**Test:** Read `method/core/forge-core.md`, search for "Explicit Architecture Decisions"

**Pass:** Rule exists with auth planes, role scoping, stakeholder separation, test infrastructure as mandatory decisions (Section 4.1, Change 2)

**Fail:** Rule missing or incomplete

---

### AC-005: @E Pre-Flight Checks Implemented

**Test:** Read `.claude/skills/forge-e/SKILL.md`, verify startup sequence includes structure gate, test infrastructure gate, auth readiness gate

**Pass:** All three gates present with HARD STOP failure mode, PR-000 exception documented (Section 7.1)

**Fail:** Any gate missing or failure mode not HARD STOP

---

### AC-006: @G Structural Verification Implemented

**Test:** Read `.claude/skills/forge-g/SKILL.md`, verify structural verification checklist exists and auto-generates preflight report

**Pass:** Checklist matches Section 7.2, report generation documented

**Fail:** Checklist missing, incomplete, or no auto-generation

---

### AC-007: @F Auth Plane Decision Gate Implemented

**Test:** Read `.claude/skills/forge-f/SKILL.md`, verify completion gate requires explicit actor plane assignments

**Pass:** Gate blocks PRODUCT.md completion until all actors have plane assignments (Section 7.3)

**Fail:** Gate missing or optional

---

### AC-008: @O Auth ADR Requirement Implemented

**Test:** Read `.claude/skills/forge-o/SKILL.md`, verify completion gate requires AUTH-ARCHITECTURE ADR for multi-user/multi-role projects

**Pass:** Gate exists with conditional logic (only multi-user/role), HARD STOP on failure (Section 7.4)

**Fail:** Gate missing, not conditional, or not HARD STOP

---

### AC-009: Universal Location Check Implemented

**Test:** Check all 8 agent SKILL.md files for universal startup check (FORGE/projects/ or external_project waiver)

**Pass:** All 8 agents have location check with waiver logic (Section 7.5)

**Fail:** Any agent missing check

---

### AC-010: STAKEHOLDER-MODEL Template Exists

**Test:** Check `template/project/docs/constitution/STAKEHOLDER-MODEL.md.template` file exists

**Pass:** File exists with content matching Section 5.1 exactly

**Fail:** File missing or incomplete

---

### AC-011: AUTH-ARCHITECTURE Template Exists

**Test:** Check `template/project/docs/adr/001-auth-architecture.md.template` file exists

**Pass:** File exists with content matching Section 5.2 exactly

**Fail:** File missing or incomplete

---

### AC-012: TEST-INFRASTRUCTURE Template Exists

**Test:** Check `template/project/docs/ops/test-infrastructure.md.template` file exists

**Pass:** File exists with content matching Section 5.3 exactly

**Fail:** File missing or incomplete

---

### AC-013: PREFLIGHT-CHECKLIST Template Exists

**Test:** Check `template/project/docs/ops/preflight-checklist.md.template` file exists

**Pass:** File exists with content matching Section 5.4 exactly

**Fail:** File missing or incomplete

---

### AC-014: Enhanced PRODUCT.md Guidance

**Test:** Read `method/templates/forge-template-frame.md`, verify actor plane assignment section exists

**Pass:** Template guidance includes actor taxonomy with plane assignment requirements (Section 6.1)

**Fail:** Section missing or incomplete

---

### AC-015: Enhanced TECH.md Guidance

**Test:** Read `method/templates/forge-template-orchestrate.md`, verify auth and test architecture sections exist

**Pass:** Template guidance requires AUTH-ARCHITECTURE and test infrastructure sections (Section 6.2)

**Fail:** Sections missing or optional

---

### AC-016: Enhanced CLAUDE.md Non-Negotiables

**Test:** Read `method/templates/forge-template-project-identity.md`, verify pre-flight gate and structural integrity sections exist

**Pass:** Non-Negotiables section includes content from Section 6.3 exactly

**Fail:** Sections missing or incomplete

---

### AC-017: Enhanced Repository Scaffold Documentation

**Test:** Read `method/templates/forge-template-repository-scaffold.md`, verify required structure verification section exists

**Pass:** Section includes mandatory directories/files with conditional requirements (Section 6.4)

**Fail:** Section missing or incomplete

---

### AC-018: FORGE-AUTONOMY.yml Schema Updated

**Test:** Read `method/templates/forge-template-autonomy-policy.md` (or equivalent), verify external_project field documented

**Pass:** Field exists with type boolean, default false, waiver semantics explained (Section 10)

**Fail:** Field missing or undocumented

---

### AC-019: Testing Requirements Updated

**Test:** Read `method/templates/forge-template-testing-requirements.md`, verify zero-test clarification and PR-000 exception exist

**Pass:** Both sections present with unambiguous language (Section 11)

**Fail:** Either section missing or ambiguous

---

### AC-020: Enforcement Matrix Exists

**Test:** Read `method/core/forge-operations.md`, verify enforcement matrix table exists

**Pass:** Table matches Section 4.2, Change 3 structure exactly

**Fail:** Table missing or incomplete

---

### AC-021: Enforcement Timeline Exists

**Test:** Read `method/core/forge-operations.md`, verify enforcement timeline diagram exists

**Pass:** Diagram shows structural verification as @G step after @C and before @F (Section 4.2, Change 3)

**Fail:** Diagram missing or structural verification incorrectly positioned

---

### AC-022: Grandfathering Policy Documented

**Test:** Read `method/core/forge-operations.md`, verify grandfathering section exists

**Pass:** Section states existing projects exempt, new gates for new projects only (Section 4.2, Change 4)

**Fail:** Section missing or ambiguous

---

### AC-023: @G Transition Gates Enhanced

**Test:** Read `.claude/skills/forge-g/SKILL.md`, verify transition-specific gates exist

**Pass:** Gates for @C→@F, @F→@O, @O→@E match Section 7.2 requirements exactly

**Fail:** Any gate missing or incorrect

---

### AC-024: All Four Templates in Project Scaffold

**Test:** Check `template/project/` directory structure

**Pass:** All four new templates (STAKEHOLDER-MODEL, AUTH-ARCHITECTURE, TEST-INFRASTRUCTURE, PREFLIGHT-CHECKLIST) exist in correct locations

**Fail:** Any template missing or in wrong location

---

### AC-025: Failure Prevention Verification

**Test:** Trace each original failure from Section 2 to enforcement mechanism in Sections 4-7

**Pass:** All four failures (stakeholder drift, tests-first violation, missing structural signals, implicit canon) have documented prevention mechanism

**Fail:** Any failure lacks prevention mechanism

**Prevention mapping:**

| Failure | Prevention Mechanism |
|---------|---------------------|
| Stakeholder drift | @F auth plane decision gate (Section 7.3) + @O auth ADR requirement (Section 7.4) + @G transition validation (Section 7.2) |
| Tests-first violation | @E pre-flight checks (Section 7.1) + Sacred Four zero-test clarification (Section 4.2, Change 1) + @G structural verification (Section 7.2) |
| Missing structural signals | Universal location check (Section 7.5) + @G structural verification (Section 7.2) + @E structure gate (Section 7.1) |
| Implicit canon | Law 5a preconditions (Section 4.1, Change 1) + Explicit Architecture Decisions rule (Section 4.1, Change 2) + all agent pre-flight gates (Sections 7.1-7.4) |

---

## 14. Blast Radius Assessment

### Files Affected

**Total:** 23 files (19 modifications, 4 new templates)

**By category:**

| Category | Count | Files |
|----------|-------|-------|
| **Canon (method/core/)** | 2 modified | forge-core.md, forge-operations.md |
| **Agent operating guides (method/agents/)** | 4 modified | forge-e-operating-guide.md, forge-g-operating-guide.md, forge-f-operating-guide.md, forge-o-operating-guide.md |
| **Agent skill definitions (.claude/skills/)** | 8 modified | forge-a, forge-b, forge-c, forge-f, forge-g, forge-o, forge-r, forge-e (SKILL.md in each) |
| **Template guidance (method/templates/)** | 5 modified | forge-template-frame.md, forge-template-orchestrate.md, forge-template-project-identity.md, forge-template-repository-scaffold.md, forge-template-testing-requirements.md (one file may be created if missing) |
| **Project scaffold templates** | 4 created | STAKEHOLDER-MODEL.md.template, 001-auth-architecture.md.template, test-infrastructure.md.template, preflight-checklist.md.template |

### Cross-Repo Impact

**None.** This proposal affects only the FORGE canonical repository (`/Users/leonardknight/kv-projects/FORGE/`). No changes to external projects unless they voluntarily migrate.

### Backward Compatibility

**Grandfathering:** Projects with `abc/FORGE-ENTRY.md` created before 2026-02-10 are exempt from new enforcement gates. See Section 4.2, Change 4 for full policy.

**Breaking changes:** None for existing projects. New projects created after implementation MUST comply with new gates.

**Migration path:** Existing projects MAY voluntarily adopt new gates. Migration is optional, not required.

---

## 15. Quality Gate Self-Check (Ralph)

**Forbidden terms check:** Searching proposal for `TBD`, `???`, `maybe`, `should` (where MUST/MAY/WILL is appropriate), `consider` (where WILL/WILL NOT is appropriate)...

**Result:** PASS

**Forbidden terms found:** 0

**Completeness check:**
- All sections complete: YES
- All exact text provided for canon changes: YES
- All templates include complete content: YES
- All agent changes include exact text: YES
- All file paths absolute: YES
- All decisions documented: YES
- No placeholders or "to be determined later": YES

**Final verification:** This proposal contains ZERO forbidden terms and is implementation-ready. Every piece of text intended for canon is exact and ready to paste. No placeholders exist.

---

## Appendix A: File Manifest

Complete list of files modified or created by this proposal:

### Modified Files (19)

1. `/Users/leonardknight/kv-projects/FORGE/method/core/forge-core.md`
2. `/Users/leonardknight/kv-projects/FORGE/method/core/forge-operations.md`
3. `/Users/leonardknight/kv-projects/FORGE/method/agents/forge-e-operating-guide.md`
4. `/Users/leonardknight/kv-projects/FORGE/method/agents/forge-g-operating-guide.md`
5. `/Users/leonardknight/kv-projects/FORGE/method/agents/forge-f-operating-guide.md`
6. `/Users/leonardknight/kv-projects/FORGE/method/agents/forge-o-operating-guide.md`
7. `/Users/leonardknight/kv-projects/FORGE/.claude/skills/forge-a/SKILL.md`
8. `/Users/leonardknight/kv-projects/FORGE/.claude/skills/forge-b/SKILL.md`
9. `/Users/leonardknight/kv-projects/FORGE/.claude/skills/forge-c/SKILL.md`
10. `/Users/leonardknight/kv-projects/FORGE/.claude/skills/forge-f/SKILL.md`
11. `/Users/leonardknight/kv-projects/FORGE/.claude/skills/forge-g/SKILL.md`
12. `/Users/leonardknight/kv-projects/FORGE/.claude/skills/forge-o/SKILL.md`
13. `/Users/leonardknight/kv-projects/FORGE/.claude/skills/forge-r/SKILL.md`
14. `/Users/leonardknight/kv-projects/FORGE/.claude/skills/forge-e/SKILL.md`
15. `/Users/leonardknight/kv-projects/FORGE/method/templates/forge-template-frame.md`
16. `/Users/leonardknight/kv-projects/FORGE/method/templates/forge-template-orchestrate.md`
17. `/Users/leonardknight/kv-projects/FORGE/method/templates/forge-template-project-identity.md`
18. `/Users/leonardknight/kv-projects/FORGE/method/templates/forge-template-repository-scaffold.md`
19. `/Users/leonardknight/kv-projects/FORGE/method/templates/forge-template-testing-requirements.md`

### Created Files (4)

20. `/Users/leonardknight/kv-projects/FORGE/template/project/docs/constitution/STAKEHOLDER-MODEL.md.template`
21. `/Users/leonardknight/kv-projects/FORGE/template/project/docs/adr/001-auth-architecture.md.template`
22. `/Users/leonardknight/kv-projects/FORGE/template/project/docs/ops/test-infrastructure.md.template`
23. `/Users/leonardknight/kv-projects/FORGE/template/project/docs/ops/preflight-checklist.md.template`

**Note:** One additional file may be created if it does not exist:
- `/Users/leonardknight/kv-projects/FORGE/method/templates/forge-template-autonomy-policy.md` (for `external_project` field documentation)

---

*End of implementation-ready proposal. All sections complete. All exact text provided. Ready for human review and approval.*
