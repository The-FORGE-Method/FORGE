# FORGE System Review: Post-Foundations-Reset Analysis

**Date:** 2026-02-10
**Type:** FORGE-RD System Hardening Report
**Status:** DRAFT — Awaiting Human Lead Review
**Scope:** FORGE methodology, templates, agents, enforcement mechanisms

---

## Executive Summary

Four systemic failures surfaced during a recent project foundations reset. None were execution mistakes — all were gaps in FORGE itself. This report identifies root causes and proposes enforceable corrections.

**Core finding:** FORGE has strong *declarative* rules (canon says what MUST happen) but weak *procedural* enforcement (no mechanism stops agents when rules are violated). The system trusts agents to self-police against implicit expectations instead of gating progress behind explicit, verifiable preconditions.

---

## Part A: Root Cause Analysis

### Failure 1: Stakeholder Portal Drift

**Symptom:** Stakeholder portal implemented as combined super-user instead of distinct plane. Roles on profiles instead of scoped memberships. No early decision point for two-plane auth.

**Root Causes:**

| Category | Finding | Severity |
|----------|---------|----------|
| **Missing template** | `forge-core.md` v1.2 lists "Auth/RBAC" and "Stakeholder Interface" as Required Extensions — but provides NO template, NO checklist, NO mandatory artifact | CRITICAL |
| **Missing decision gate** | @F (Frame) defines actors and use-cases but does NOT require explicit "how many auth planes?" decision | CRITICAL |
| **Missing agent constraint** | @O (Orchestrate) designs architecture but has no mandatory "auth architecture decision record" before execution begins | HIGH |
| **Implicit assumption** | The expectation that stakeholder and product concerns are separate planes exists nowhere in canon — it was a human assumption | CRITICAL |

**Why FORGE allowed it:** The Required Extensions in `forge-core.md` are two words each ("Auth/RBAC", "Stakeholder Interface"). They have no specification, no template, no checklist. An agent reading canon sees them listed but has no actionable guidance on what they require. @F produces PRODUCT.md with actors, but nothing forces the question: "Are these actors in the same auth plane or different ones?" @O designs architecture but there's no gate artifact for auth architecture specifically. The system allowed a combined approach because nothing explicitly prohibited it.

---

### Failure 2: Tests-First Canon Violation

**Symptom:** Multiple PRs shipped with zero test infrastructure despite canon mandating tests-first, Sacred Four, and 80%+ coverage.

**Root Causes:**

| Category | Finding | Severity |
|----------|---------|----------|
| **Missing enforcement mechanism** | Sacred Four is a *reactive* check (fails at PR time) not a *proactive* gate (blocks execution start without test infra) | CRITICAL |
| **Missing agent constraint** | @E checks "do tests pass?" but NOT "does test infrastructure exist?" — zero tests = zero failures = Sacred Four "passes" | CRITICAL |
| **Missing template** | CI/CD workflow templates exist but there's no enforcement that they are SET UP before PR-001 | HIGH |
| **Missing review gate** | @G validates transitions but does not audit whether test infrastructure is configured before approving execution handoffs | HIGH |
| **Ambiguous canon** | `forge-template-testing-requirements.md` says "Tests are required" and "tests-later is FORBIDDEN" but @E's startup checks only verify `FORGE-ENTRY.md` exists, not test readiness | HIGH |

**Why FORGE allowed it:** Sacred Four's enforcement model has a fatal flaw: it verifies that tests *pass*, not that tests *exist*. Running `pnpm test` against a project with no test framework configured either succeeds (no tests = no failures) or errors in a way that doesn't trigger the Sacred Four STOP condition. @E's agent definition lists Sacred Four as non-negotiable but its startup checks don't include "test framework is installed and at least one test file exists." The system allowed testless PRs because the gate checked the wrong condition.

---

### Failure 3: Missing Structural Signals

**Symptom:** Project lived outside `FORGE/projects/`, inbox packets and PR packets absent, archival discipline missing. FORGE execution continued without warning.

**Root Causes:**

| Category | Finding | Severity |
|----------|---------|----------|
| **Missing agent constraint** | NO agent checks whether the project is under `FORGE/projects/` | CRITICAL |
| **Missing enforcement mechanism** | Agents check for `FORGE-ENTRY.md` but not for project structure (inbox/, docs/, tests/) | HIGH |
| **Missing agent constraint** | @G does not audit for inbox packets, PR packets, or router-event logs during transitions | HIGH |
| **Missing documentation** | No canon rule states "FORGE execution is only valid within FORGE/projects/" — it's implied by templates but not enforced | HIGH |

**Why FORGE allowed it:** FORGE agents have exactly one structural check: does `abc/FORGE-ENTRY.md` exist? This is a *gate* check, not a *structural integrity* check. An agent can find FORGE-ENTRY.md at any path and proceed. Nothing validates that the surrounding project structure matches the template scaffold. @G logs router events but doesn't verify that the logging directory exists. @E produces PRs but doesn't check that inbox/30_ops/handoffs/ exists for the handoff packet. The system assumed structural compliance because the template defines it, but no agent verifies it.

---

### Failure 4: Implicit vs Explicit Canon

**Symptom:** Critical assumptions (tests-first, role scoping, stakeholder separation) were implicit. Agents optimized for forward motion. No hard STOP until human intervention.

**Root Causes:**

| Category | Finding | Severity |
|----------|---------|----------|
| **Missing enforcement mechanism** | Agent constraints are defined as "MUST NOT" prohibitions, not "MUST VERIFY" preconditions — agents check what they *can't* do, not what must be true *before they start* | CRITICAL |
| **Missing review gate** | No "pre-flight checklist" mechanism exists for any agent | CRITICAL |
| **Missing agent constraint** | @E's definition has 5 MUST rules and 5 MUST NOT rules but zero pre-execution verification steps | HIGH |
| **Systemic pattern** | FORGE agents are optimized for *production* (make artifacts, advance phases) not *verification* (confirm preconditions before acting) | CRITICAL |

**Why FORGE allowed it:** FORGE's enforcement model is prohibition-based ("agents MUST NOT cross lanes") rather than precondition-based ("agents MUST VERIFY X before proceeding"). This creates a fundamental asymmetry: agents know what they can't do but don't know what must be true before they act. When @E starts a handoff, it checks that FORGE-ENTRY.md exists and that Sacred Four passes *after* work is done. It doesn't check that test infrastructure exists, that auth architecture is decided, that stakeholder planes are defined, or that the project structure is valid. The system optimizes for forward motion because every agent's success metric is "produce an artifact," not "verify the environment is correct."

---

## Part B: Canon Corrections

### B1. New Non-Negotiable Rules (Add to `forge-core.md`)

#### Rule: Execution Preconditions (Law 6 candidate or Law 5 extension)

> **Pre-flight verification is mandatory.** Before any agent produces artifacts, it MUST verify that its preconditions are met. Preconditions are not suggestions — they are hard gates. An agent that cannot verify its preconditions MUST STOP and report what is missing. Forward motion without verified preconditions is a canon violation.

#### Rule: Test Infrastructure Gate

> **Test infrastructure must exist before PR-001.** No pull request may be created in any FORGE project until: (a) a test framework is installed and configured, (b) at least one test file exists and passes, (c) the Sacred Four command sequence runs successfully with actual test execution. Zero tests is not "tests passing" — it is a gate failure.

#### Rule: Structural Integrity

> **FORGE execution requires FORGE structure.** Agents MUST verify project structural integrity before proceeding. A project without the required directory structure, governance files, and inbox system is not a valid FORGE project. @G MUST halt transitions when structural signals are absent.

#### Rule: Auth Architecture Decision

> **Auth architecture must be explicitly decided before implementation.** For any project with user-facing authentication, the following must be documented in an Architecture Decision Record (ADR) before @E receives its first handoff: (a) how many auth planes exist, (b) how roles are scoped (profile-level vs membership-level), (c) whether stakeholder and product concerns share infrastructure. Implicit auth is a canon violation.

---

### B2. Clearer Phase Definitions

#### Phase 0: Scaffold Verification (NEW — between @C and @F)

After FORGE-ENTRY.md is created and before @F begins framing:

```
Phase 0 Checklist:
[ ] Project lives under FORGE/projects/<slug>/
[ ] Directory structure matches template/project/ scaffold
[ ] FORGE-AUTONOMY.yml exists and is valid
[ ] .github/workflows/ exist (or equivalent CI config)
[ ] Test framework is installed and `pnpm test` returns 0 (with stub)
[ ] docs/constitution/ directory exists
[ ] inbox/ directory structure exists
[ ] docs/router-events/ directory exists
```

**Gate:** @G verifies Phase 0 before routing to @F. Failures are HARD STOP.

#### Enhanced Frame Phase (@F)

Add mandatory decision points to Frame output:

```
PRODUCT.md Must Include:
[ ] Actor taxonomy with explicit plane assignment
[ ] Auth model decision: single-plane or multi-plane
[ ] Stakeholder access model (if applicable)
[ ] Data ownership boundaries per actor
```

#### Enhanced Orchestrate Phase (@O)

Add mandatory artifacts to Orchestrate output:

```
TECH.md Must Include:
[ ] AUTH-ARCHITECTURE section or standalone ADR
[ ] Role/permission model with scoping mechanism
[ ] Stakeholder vs product boundary definition (if multi-plane)
[ ] Test infrastructure specification (framework, coverage tool, CI integration)
```

---

### B3. Explicit Decision Gates

| Gate | When | What Must Be True | Enforced By | Failure Mode |
|------|------|-------------------|-------------|--------------|
| **Structure Gate** | After @C, before @F | Project scaffold valid | @G | HARD STOP |
| **Auth Architecture Gate** | After @O, before first @E handoff | AUTH-ARCHITECTURE ADR exists | @G | HARD STOP |
| **Test Infrastructure Gate** | Before PR-001 | Test framework configured, stub test passes | @E | HARD STOP |
| **Stakeholder Plane Gate** | During @F | Actor planes explicitly assigned | @F | HARD STOP |
| **PR Packet Gate** | Before every PR | Handoff packet in inbox/30_ops/handoffs/ | @E | HARD STOP |
| **Coverage Gate** | Every PR | Coverage >= threshold, delta >= 0 | @E + CI | HARD STOP |

---

### B4. Mandatory Artifacts (New)

| Artifact | Created By | Required Before | Location |
|----------|-----------|-----------------|----------|
| `AUTH-ARCHITECTURE.md` (or ADR) | @O | First @E handoff for auth-related work | `docs/adr/` or `docs/constitution/` |
| `STAKEHOLDER-MODEL.md` | @F | @O begins architecture (if stakeholders exist) | `docs/constitution/` |
| `TEST-INFRASTRUCTURE.md` | @E (Phase 0 handoff) | PR-001 | `docs/ops/` |
| `PREFLIGHT-REPORT.md` | @G (auto-generated) | Every phase transition | `docs/router-events/` |

---

## Part C: Template & System Changes

### C1. Project Template Changes (`template/project/`)

**Add to scaffold:**

```
template/project/
├── docs/
│   ├── constitution/
│   │   ├── STAKEHOLDER-MODEL.md.template    ← NEW
│   │   └── ...existing...
│   ├── adr/
│   │   ├── 001-auth-architecture.md.template ← NEW
│   │   └── ...existing...
│   └── ops/
│       ├── test-infrastructure.md.template   ← NEW
│       ├── preflight-checklist.md.template   ← NEW
│       └── ...existing...
└── ...existing...
```

**New Template: `STAKEHOLDER-MODEL.md.template`**

```markdown
# Stakeholder Model

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
```

**New Template: `001-auth-architecture.md.template`**

```markdown
# ADR-001: Authentication Architecture

## Status: [PROPOSED | ACCEPTED | SUPERSEDED]

## Context
[What is the auth challenge for this project?]

## Decision
[How many planes? What scoping? What provider?]

## Consequences
[What does this mean for implementation?]

## Validation Checklist
- [ ] Each actor has an explicit plane assignment
- [ ] Role scoping mechanism is defined (profile vs membership)
- [ ] Stakeholder access is not conflated with product access
- [ ] RLS policies map to this architecture
```

**New Template: `test-infrastructure.md.template`**

```markdown
# Test Infrastructure

## Framework
- Unit: [Vitest/Jest/etc.]
- Integration: [Vitest/Jest/etc.]
- E2E: [Playwright/Cypress/etc.]
- Coverage: [c8/istanbul/etc.]

## Configuration
- [ ] Test framework installed
- [ ] Test config file exists (vitest.config.ts, etc.)
- [ ] Coverage configured with thresholds
- [ ] CI workflow includes Sacred Four
- [ ] At least one passing test exists

## Sacred Four Commands
```bash
pnpm typecheck
pnpm lint
pnpm test
pnpm build
```

## Coverage Thresholds
- Default: 70%
- Sacred Four paths (auth, payments, data, security): 100%
```

**New Template: `preflight-checklist.md.template`**

```markdown
# Pre-Flight Checklist

## Structure Verification
- [ ] Project under FORGE/projects/<slug>/
- [ ] abc/FORGE-ENTRY.md exists
- [ ] docs/constitution/ populated
- [ ] docs/adr/ initialized
- [ ] inbox/ structure matches template
- [ ] docs/router-events/ exists
- [ ] FORGE-AUTONOMY.yml valid

## Test Readiness
- [ ] Test framework installed
- [ ] At least one test passes
- [ ] Sacred Four runs without error
- [ ] CI/CD workflows configured

## Auth Readiness (if applicable)
- [ ] Auth architecture ADR exists
- [ ] Stakeholder model defined
- [ ] Role scoping decided
- [ ] Plane assignments complete

## Verified By: @G
## Date: [auto]
## Result: [PASS | FAIL — details below]
```

---

### C2. Default Folder Structure Enforcement

**Add to `forge-template-repository-scaffold.md`:**

```markdown
## Required Structure Verification

The following directories and files MUST exist before @E begins execution.
@G verifies this checklist during Phase 0 (Structure Gate).

### Mandatory (all projects):
- `abc/FORGE-ENTRY.md`
- `docs/constitution/`
- `docs/adr/`
- `docs/ops/state.md`
- `docs/build-plan.md`
- `docs/router-events/`
- `inbox/00_drop/`
- `inbox/10_product-intent/`
- `inbox/20_architecture-plan/`
- `inbox/30_ops/handoffs/`
- `tests/`
- `CLAUDE.md`
- `FORGE-AUTONOMY.yml`

### Mandatory (projects with auth):
- `docs/adr/001-auth-architecture.md`
- `docs/constitution/STAKEHOLDER-MODEL.md`

### Mandatory (projects with code):
- Test framework config file
- At least one `.test.` or `.spec.` file
- CI workflow with Sacred Four
```

---

### C3. CLAUDE.md Template Enhancement

**Add to `forge-template-project-identity.md` Non-Negotiables section:**

```markdown
## Non-Negotiables

### Pre-Existing (Sacred Four, 5-line rule, etc.)
...

### NEW: Pre-Flight Gate
Before any PR is created, @E MUST verify:
1. Test framework runs and produces output
2. At least one test exists and passes
3. Auth architecture ADR exists (if auth features are in scope)
4. Stakeholder model is defined (if stakeholder features exist)
5. Sacred Four completes without error (not just without failure)

### NEW: Structural Integrity
This project MUST maintain FORGE structure:
- All handoff packets in `inbox/30_ops/handoffs/`
- All router events in `docs/router-events/`
- All ADRs in `docs/adr/`
- PR completion packets in `docs/ops/`

Deviation from structure is a governance violation.
```

---

## Part D: Agent Behavior Fixes

### D1. @E (Execute) — Pre-Flight Check Addition

**Add to agent startup sequence (before any coding):**

```markdown
## @E Startup: Pre-Flight Verification (NEW)

Before accepting any handoff, @E MUST run these checks IN ORDER:

### Check 1: Structure
- [ ] Project root has CLAUDE.md
- [ ] Project root has FORGE-AUTONOMY.yml
- [ ] abc/FORGE-ENTRY.md exists
- [ ] docs/ structure matches template scaffold
- [ ] inbox/30_ops/handoffs/ exists

IF ANY FAIL → HARD STOP. Report: "Structure gate failed: [missing items]"

### Check 2: Test Infrastructure
- [ ] Test framework is installed (check package.json or equivalent)
- [ ] Test config file exists (vitest.config.ts, jest.config.ts, etc.)
- [ ] `pnpm test` (or equivalent) executes and produces output
- [ ] At least one test file exists (*.test.*, *.spec.*)

IF ANY FAIL → HARD STOP. Report: "Test infrastructure gate failed: [missing items]"
Exception: If this IS the test infrastructure setup handoff (PR-000), proceed.

### Check 3: Auth Readiness (conditional)
IF handoff involves auth, roles, permissions, or user management:
- [ ] AUTH-ARCHITECTURE ADR exists in docs/adr/
- [ ] Stakeholder model defined in docs/constitution/ (if stakeholders in scope)
- [ ] Role scoping mechanism documented (profile vs membership)

IF ANY FAIL → HARD STOP. Report: "Auth architecture gate failed: [missing items]"

### Check 4: Sacred Four Dry Run
- [ ] `pnpm typecheck` succeeds (or reports expected pre-existing errors only)
- [ ] `pnpm lint` succeeds
- [ ] `pnpm test` succeeds (with actual test execution)
- [ ] `pnpm build` succeeds

IF ANY FAIL → WARN. Report: "Sacred Four pre-flight warning: [details]"
(Not a hard stop because the handoff may fix these, but @E must be aware.)
```

---

### D2. @G (Govern) — Structural Verification Addition

**Add to @G transition validation:**

```markdown
## @G Transition Validation: Structural Audit (NEW)

Before approving ANY transition, @G MUST verify:

### On transition to @F (Frame):
- [ ] Project exists under FORGE/projects/<slug>/
- [ ] abc/FORGE-ENTRY.md exists
- [ ] Template scaffold structure is present
IF FAIL → HARD STOP: "Cannot begin framing — project structure invalid"

### On transition to @O (Orchestrate):
- [ ] PRODUCT.md exists with actor taxonomy
- [ ] Actor planes are explicitly assigned (not implicit)
IF FAIL → HARD STOP: "Cannot begin orchestration — product framing incomplete"

### On transition to @E (Execute):
- [ ] TECH.md exists with auth architecture section (if auth in scope)
- [ ] Test infrastructure is configured
- [ ] Handoff packet exists in inbox/30_ops/handoffs/
- [ ] Build plan is current
IF FAIL → HARD STOP: "Cannot begin execution — preconditions unmet: [list]"

### On any transition (universal):
- [ ] Project is under FORGE/projects/ OR has explicit waiver in FORGE-AUTONOMY.yml
- [ ] Router events directory exists and is writable
- [ ] FORGE-AUTONOMY.yml is valid
IF FAIL → HARD STOP: "Governance structure invalid"
```

---

### D3. @F (Frame) — Mandatory Decisions Addition

**Add to @F completion gate:**

```markdown
## @F Completion Gate: Required Decisions (NEW)

PRODUCT.md is NOT complete until:

### Actor Classification (MANDATORY)
For each actor identified:
- [ ] Actor is assigned to an explicit auth plane
- [ ] Actor's role scoping is defined (how do they get permissions?)
- [ ] Actor's data boundaries are defined (what can they see/do?)

### Stakeholder Decision (MANDATORY if stakeholders exist)
- [ ] "Are stakeholders and product users in the same auth plane?" — EXPLICITLY ANSWERED
- [ ] If multi-plane: STAKEHOLDER-MODEL.md started (completed by @O)
- [ ] If single-plane: rationale documented in PRODUCT.md

IF NOT ANSWERED → HARD STOP: "Cannot complete Frame without auth plane decision"
```

---

### D4. @O (Orchestrate) — Auth Architecture Gate Addition

**Add to @O completion gate:**

```markdown
## @O Completion Gate: Auth Architecture (NEW)

TECH.md is NOT complete until:

### Auth Architecture ADR (MANDATORY for projects with auth)
- [ ] ADR exists in docs/adr/ with auth architecture decision
- [ ] Number of auth planes documented
- [ ] Role scoping mechanism specified (profile vs membership)
- [ ] RLS policy mapping documented
- [ ] Stakeholder vs product boundary defined (if applicable)

### Test Architecture (MANDATORY for projects with code)
- [ ] Test framework specified
- [ ] Coverage tool specified
- [ ] Sacred Four commands documented
- [ ] CI/CD integration specified

IF NOT COMPLETE → HARD STOP: "Cannot complete Orchestration without auth + test architecture"
```

---

### D5. All Agents — Project Location Check

**Add to every agent's startup:**

```markdown
## Universal Startup Check (NEW — All Agents)

Before proceeding, verify project governance:

1. Is this project under FORGE/projects/<slug>/?
   - YES → proceed normally
   - NO → Check FORGE-AUTONOMY.yml for `external_project: true` waiver
     - Waiver exists → WARN: "Project is external. Governance discipline is your responsibility."
     - No waiver → HARD STOP: "Project is not under FORGE governance. Cannot proceed."

2. Does FORGE-AUTONOMY.yml exist?
   - YES → read and apply tier configuration
   - NO → HARD STOP: "Missing governance policy. Cannot determine autonomy tier."
```

---

## Part E: Enforcement Mechanisms

### E1. Complete Enforcement Matrix

| Rule | Enforcing Agent | Trigger Point | Failure Mode | Bypass |
|------|----------------|---------------|--------------|--------|
| Project under FORGE/projects/ | ALL agents (startup) | Agent invocation | HARD STOP (unless waiver) | `external_project: true` in FORGE-AUTONOMY.yml |
| Template scaffold structure valid | @G | Phase 0, before @F | HARD STOP | None |
| Test framework installed | @E | Before first PR | HARD STOP | None |
| At least one test exists | @E | Before every PR | HARD STOP | None |
| Sacred Four passes with real tests | @E | Before every PR merge | HARD STOP | None |
| Auth architecture ADR exists | @G | Before first auth-related @E handoff | HARD STOP | None |
| Stakeholder model defined | @F | Frame completion gate | HARD STOP | N/A if no stakeholders |
| Actor plane assignment explicit | @F | Frame completion gate | HARD STOP | None |
| Role scoping documented | @O | Orchestrate completion gate | HARD STOP | None |
| Handoff packet exists | @E | Before starting handoff work | HARD STOP | None |
| PR packet produced | @E | Before PR creation | HARD STOP | None |
| Router events logged | @G | Every transition | WARN (degraded governance) | None |
| Coverage delta >= 0 | @E + CI | Every PR | HARD STOP | None |
| FORGE-AUTONOMY.yml exists | ALL agents | Agent invocation | HARD STOP | None |

### E2. Enforcement Timeline

```
Project Lifecycle:

  @A (Acquire)
  ├── CHECK: Project will be created under FORGE/projects/ ← NEW
  └── OUTPUT: abc/INTAKE.md

  @C (Commit)
  ├── CHECK: abc/INTAKE.md exists
  └── OUTPUT: abc/FORGE-ENTRY.md  [EXISTING GATE]

  ──── PHASE 0: SCAFFOLD VERIFICATION ──── [NEW PHASE]
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
  ├── CHECK: Phase 0 passed ← NEW
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

---

## Prioritized Changes

### MUST-FIX (Blocking — implement before next project)

| # | Change | Affected Files | Effort |
|---|--------|---------------|--------|
| 1 | **@E pre-flight checks** — Test infra gate, structure gate, auth readiness gate | `.claude/skills/forge-e/SKILL.md`, `method/agents/forge-e-operating-guide.md` | Medium |
| 2 | **@G structural verification** — Validate project structure on every transition | `.claude/skills/forge-g/SKILL.md`, `method/agents/forge-g-operating-guide.md` | Medium |
| 3 | **Sacred Four zero-test fix** — "Zero tests" = gate FAILURE, not gate pass | `method/core/forge-operations.md`, `forge-template-testing-requirements.md` | Small |
| 4 | **Phase 0: Scaffold Verification** — New phase between @C and @F | `method/core/forge-operations.md`, `method/core/forge-core.md` | Medium |
| 5 | **@F mandatory auth plane decision** — Cannot complete Frame without explicit plane assignment | `.claude/skills/forge-f/SKILL.md`, `method/agents/forge-f-operating-guide.md` | Small |
| 6 | **Project location check** — All agents verify FORGE/projects/ or waiver | All agent SKILL.md files | Small |
| 7 | **Auth architecture ADR gate** — @O must produce, @G must verify before @E handoff | `.claude/skills/forge-o/SKILL.md`, `.claude/skills/forge-g/SKILL.md` | Medium |

### SHOULD-FIX (High value — implement within next 2 projects)

| # | Change | Affected Files | Effort |
|---|--------|---------------|--------|
| 8 | **STAKEHOLDER-MODEL.md template** — New template for auth plane decisions | `template/project/docs/constitution/`, `method/templates/` | Small |
| 9 | **AUTH-ARCHITECTURE ADR template** — New template for auth design decisions | `template/project/docs/adr/`, `method/templates/` | Small |
| 10 | **TEST-INFRASTRUCTURE.md template** — New template for test setup documentation | `template/project/docs/ops/`, `method/templates/` | Small |
| 11 | **PREFLIGHT-CHECKLIST.md template** — New template for @G pre-flight reports | `template/project/docs/ops/`, `method/templates/` | Small |
| 12 | **Enhanced PRODUCT.md template** — Add actor plane assignment section | `method/templates/forge-template-frame.md` | Small |
| 13 | **Enhanced TECH.md guidance** — Add auth architecture and test architecture sections | `method/templates/` or new template | Medium |
| 14 | **Canon rule: precondition verification** — Formalize as Law 5 extension | `method/core/forge-core.md` | Small (text change, MAJOR implications) |

### NICE-TO-HAVE (Improvement — implement as capacity allows)

| # | Change | Affected Files | Effort |
|---|--------|---------------|--------|
| 15 | **Automated scaffold validator script** — `bin/forge-validate-scaffold` | `bin/` | Medium |
| 16 | **@G dashboard enhancement** — Show structural health in catch-up | `.claude/skills/forge-g/SKILL.md` | Medium |
| 17 | **Pre-flight report auto-generation** — @G produces PREFLIGHT-REPORT.md automatically | `.claude/skills/forge-g/SKILL.md` | Medium |
| 18 | **forge-export enhancement** — Validate agent constraints include pre-flight checks | `bin/forge-export` | Small |

---

## Draft Canon Language

### Addition to Law 5 (Hard Stops Are Non-Negotiable)

```markdown
### 5a. Preconditions Are Hard Stops

Every agent MUST verify its preconditions before producing artifacts.
Preconditions are not advisory — they are gates.

Universal preconditions (all agents):
- Project is under FORGE governance (FORGE/projects/ or explicit waiver)
- FORGE-AUTONOMY.yml exists and is valid
- Required upstream artifacts exist

Phase-specific preconditions:
- @F: FORGE-ENTRY.md exists, Phase 0 passed
- @O: PRODUCT.md exists with actor plane assignments
- @E: Test infrastructure configured, handoff packet exists, auth ADR exists (if auth in scope)
- @G: Project structure valid, router-events directory writable

An agent that cannot verify its preconditions MUST STOP.
"Precondition unknown" is equivalent to "precondition failed."
Zero tests is a test gate failure, not a test gate pass.
```

### New Canon Rule: Explicit Over Implicit

```markdown
### Rule: Explicit Architecture Decisions

For the following concerns, FORGE requires an explicit, documented decision
before implementation begins. Implicit defaults are canon violations:

1. **Auth planes:** How many auth systems? Who belongs to which?
2. **Role scoping:** Profile-level or membership-level?
3. **Stakeholder separation:** Same plane as product users or different?
4. **Test infrastructure:** What framework? What coverage tool? What thresholds?

These decisions are captured in Architecture Decision Records (ADRs) in docs/adr/.
@O produces them. @G verifies them. @E refuses to proceed without them.
```

### Draft @E Pre-Flight Checklist (Agent Constraint)

```markdown
### @E Pre-Flight Gate (MANDATORY — runs before every handoff)

@E MUST verify the following before writing any code:

STRUCTURE:
□ CLAUDE.md exists at project root
□ FORGE-AUTONOMY.yml exists at project root
□ abc/FORGE-ENTRY.md exists
□ inbox/30_ops/handoffs/ exists
□ Handoff packet for current work exists

TESTS:
□ Test framework is installed (vitest/jest/playwright in dependencies)
□ Test config file exists
□ `pnpm test` executes (not just "no tests found")
□ At least one .test. or .spec. file exists
EXCEPTION: Skip if this handoff IS the test infrastructure setup (PR-000)

AUTH (if handoff involves auth/roles/permissions):
□ docs/adr/ contains auth architecture ADR
□ Auth ADR status is ACCEPTED
□ Role scoping mechanism is documented

FAILURE: Any failed check → HARD STOP → Report missing items to @G
```

---

## Appendix: Failure Prevention Verification

After implementing the MUST-FIX changes, verify each original failure is prevented:

| Original Failure | Prevention Mechanism | Verified By |
|-----------------|---------------------|-------------|
| Stakeholder portal drift | @F requires explicit plane decision; @O requires auth ADR; @G gates execution on ADR existence | @G structural verification |
| Tests-first violation | @E pre-flight requires test infra; zero tests = gate failure; @G verifies test readiness before transition | @E pre-flight + @G transition check |
| Missing structural signals | All agents check project location; @G validates structure at Phase 0; @E checks handoff packets | Universal startup check + @G Phase 0 |
| Implicit canon | Precondition verification is a hard stop; explicit decisions required for auth, roles, tests; "unknown" = "failed" | Law 5a + agent pre-flight gates |

---

*End of report. Awaiting Human Lead review and routing decision.*
