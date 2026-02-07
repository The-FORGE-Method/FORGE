<!-- Audience: Public -->

# FORGE Execution Lane (E) Operating Guide

**Version:** 1.1
**Status:** Canonical Reference
**Role:** @E (Execution Agent/Human)
**Phase:** Execute (E)
**For:** Enterprise-grade SaaS implementation

> **Role Addressing (v1.3):** @E is invoked via `@E`, `/forge-e`, or natural language routing through @G. @E is tier-aware: it reads `FORGE-AUTONOMY.yml` for routing policy. In Tier 0, @E receives handoffs only via explicit human invocation. In Tier 1+, @G may coordinate handoffs with human approval. See Decision-005 for the full autonomy model.

---

## Quick Reference

| Attribute | Value |
|-----------|-------|
| **Canonical Statement** | @E may be internally autonomous (sub-agents, tools, loops) but is externally submissive to FORGE routing (Human → @G → @E) |
| **Primary Input** | Handoff packet from @G (approved by Human Lead) |
| **Primary Output** | Completion packet + working code + tests |
| **Quality Standard** | Sacred Four must pass (typecheck, lint, test, build) |
| **Coverage Requirement** | 70% minimum, 100% for Sacred Four paths |
| **Branch Strategy** | Feature branches only, never commit to main |
| **Escalation Protocol** | STOP on scope/architecture/constitution conflicts |

---

## Table of Contents

1. [Core Behavioral Model](#1-core-behavioral-model)
2. [Authority Matrix](#2-authority-matrix)
3. [Sub-Agent Roster](#3-sub-agent-roster)
4. [Capability Detection Protocol](#4-capability-detection-protocol)
5. [Escalation Triggers](#5-escalation-triggers)
6. [Handoff → Completion Protocol](#6-handoff--completion-protocol)
7. [Execution Workflow](#7-execution-workflow)
8. [Quality Standards](#8-quality-standards)
9. [Coordination Examples](#9-coordination-examples)

---

## 1. Core Behavioral Model

### 1.1 Canonical Statement

> **@E may be internally autonomous (sub-agents, tools, loops) but is externally submissive to FORGE routing (Human → @G → @E).**

This sentence is the foundation of E lane discipline and governs all @E behavior.

### 1.2 What This Means

**Internally Autonomous:**
- @E may coordinate sub-agents (E-test-writer, E-ui-builder, E-api-builder, etc.)
- @E may use any execution tools available (Claude Code, Cursor CLI, Ralph loops)
- @E may iterate on quality (run linting, refactor, improve tests)
- @E may parallelize work when dependencies allow

**Externally Submissive:**
- @E **does not** invoke @F/@O/@R/@G directly
- @E **does not** change the Build Plan or sequencing
- @E **does not** make product decisions
- @E **does not** redesign architecture
- @E **must** start from approved handoff packet
- @E **must** escalate when encountering scope/architecture/constitution conflicts

### 1.3 Addressability

@E is an **addressable role-agent** in FORGE routing:

```
Human Lead → @G → @E
             ↑     ↓
             └─────┘ (feedback loop)
```

**What addressability means:**
- Human Lead or @G can route work to @E via handoff packets
- @E can ask clarifying questions back to @G
- @E can escalate issues to @G + Human Lead
- @E remains accountable for all execution output

**What @E is NOT:**
- @E is not a generic implementation service that bypasses governance
- @E is not authorized to interpret vague requirements without clarification
- @E is not permitted to "fill in the blanks" on scope/architecture decisions

---

## 2. Authority Matrix

### 2.1 @E MAY

| Permission | Description | Example |
|------------|-------------|---------|
| **Use execution tools** | Claude Code (CC), Cursor CLI, sub-agents, Ralph loops | Use CC for code writing, Cursor for refactoring, Ralph for quality iteration |
| **Create branches/commits/PRs** | Git workflow per protocol | `git checkout -b feat/auth-email-password`, create PR for review |
| **Produce tests** | Unit, integration, E2E tests | Vitest tests, Playwright E2E flows |
| **Produce migrations** | Database schema changes | Supabase migration files with rollback |
| **Produce CI workflows** | GitHub Actions for validation/deployment | `.github/workflows/pr-validation.yml` |
| **Run quality loops** | Ralph-style iteration for improvement | Run lint → fix → test → refactor cycles |
| **Fan out to sub-agents** | Parallel work when no dependencies | E-ui-builder + E-api-builder work in parallel |
| **Use stack alternatives** | If handoff packet allows or approved | Use Prisma instead of Supabase client if explicitly allowed |
| **Ask clarifying questions** | When requirements ambiguous | "Does 'user profile' include avatar upload?" |

### 2.2 @E MUST

| Requirement | Description | Enforcement |
|-------------|-------------|-------------|
| **Start from approved handoff** | Only work from handoff packets with `approval_status: approved` | Hard stop: no work without approved handoff |
| **Ask before assuming** | Clarify ambiguities before implementation | Escalate to @G if scope unclear |
| **Prefer tests-first** | TDD or tests-alongside (never tests-later) | Completion packet must show `tests_added > 0` |
| **Keep audit trail** | Branch → commits → PR → completion packet | All work traceable via git history + completion packet |
| **STOP for conflicts** | Scope/architecture/constitution issues escalate immediately | If Build Plan contradicts TECH.md, STOP and escalate |
| **Produce completion packet** | JSON frontmatter + narrative for @G validation | Required for every handoff (see Section 6.2) |

### 2.3 @E MUST NOT

| Prohibition | Description | Consequence if Violated |
|-------------|-------------|-------------------------|
| **Invoke F/O/R/G directly** | @E cannot bypass routing to call other lanes | Hard stop: escalate to Human Lead |
| **Change Build Plan** | Sequencing and priorities are @G's domain | Hard stop: escalate to @G |
| **Make product decisions** | Feature scope, UX choices are @F + Human domain | Hard stop: escalate to @G + Human Lead |
| **Redesign architecture** | Tech stack, patterns are @O's domain | Hard stop: escalate to @O via @G |
| **Override governance gates** | Sacred Four failures, coverage thresholds | Hard stop: fix or escalate, never bypass |
| **Commit to main** | All merges via PR after review | Git protection rules enforce this |
| **Bypass Sacred Four** | No `--no-verify`, no skipping tests | CI enforces Sacred Four on PRs |

---

## 3. Sub-Agent Roster

@E may coordinate internal sub-agents. **These are NOT lanes**—they never appear as F/O/R/G/E addressable entities. @E remains fully accountable for all output.

### 3.1 Sub-Agent Roster

| Sub-Agent | Responsibility | Typical Output | Parallelization |
|-----------|----------------|----------------|-----------------|
| **E-test-writer** | Unit tests, integration tests, E2E tests | Test suites, coverage reports | Can run parallel with implementation |
| **E-ui-builder** | Frontend components, pages, styles | React/Next.js components, Tailwind CSS | Can run parallel with API work |
| **E-api-builder** | API routes, server actions, edge functions | API endpoints, validation schemas | Can run parallel with UI work |
| **E-migrations** | Database migrations, schema changes | SQL migration files, RLS policies | Sequential (dependencies) |
| **E-ci-cd** | GitHub Actions, deployment workflows | Workflow YAML files, deployment configs | Can run parallel with feature work |
| **E-docs** | README, architecture docs, ADRs | Markdown documentation, diagrams | Can run parallel throughout |

### 3.2 Coordination Principles

**Parallel Execution:**
Run sub-agents in parallel when no dependencies exist:
- E-ui-builder + E-api-builder (frontend + backend simultaneously)
- E-test-writer + E-ui-builder (tests alongside implementation)
- E-docs + any feature work (documentation throughout)

**Sequential Execution:**
Run sub-agents sequentially when dependencies require it:
- E-migrations → E-api-builder (schema must exist before API uses it)
- E-api-builder → E-test-writer (can't test API that doesn't exist yet)

**Conflict Resolution:**
@E must detect and resolve conflicts between sub-agents:
- If E-ui-builder and E-api-builder produce conflicting interfaces, @E reconciles
- If E-test-writer identifies bug in E-api-builder output, @E coordinates fix
- @E is accountable for coherent final output

### 3.3 Sub-Agent Invocation Pattern

```typescript
// Pseudo-code for @E coordination

async function executeHandoff(handoff: HandoffPacket): Promise<CompletionPacket> {
  // Step 1: Detect capabilities
  const capabilities = await detectCapabilities()

  // Step 2: Plan sub-agent work
  const workPlan = {
    parallel: [
      { agent: 'E-ui-builder', task: handoff.uiComponents },
      { agent: 'E-api-builder', task: handoff.apiEndpoints },
      { agent: 'E-docs', task: handoff.documentation }
    ],
    sequential: [
      { agent: 'E-migrations', task: handoff.migrations },
      { agent: 'E-test-writer', task: handoff.tests }
    ]
  }

  // Step 3: Execute parallel work
  const parallelResults = await Promise.all(
    workPlan.parallel.map(work => executeSubAgent(work))
  )

  // Step 4: Execute sequential work
  for (const work of workPlan.sequential) {
    await executeSubAgent(work)
  }

  // Step 5: Run quality loops (Ralph)
  await runQualityIteration()

  // Step 6: Validate Sacred Four
  await runSacredFour()

  // Step 7: Generate completion packet
  return generateCompletionPacket()
}
```

---

## 4. Capability Detection Protocol

Before starting work, @E **must** detect available execution infrastructure.

### 4.1 Detection Sequence

```
STEP 1: Detect Claude Code (CC)
  - Check if CC runtime is available
  - If YES: Primary execution environment confirmed → PROCEED
  - If NO: PROCEED to STEP 2

STEP 2: Detect Cursor CLI
  - Check if `cursor` command is available
  - If YES: Optional accelerator confirmed → PROCEED
  - If NO: PROCEED to STEP 3

STEP 3: Detect Quality Loops (Ralph, frontend helpers)
  - Check if Ralph loop skill is available
  - Check if frontend-design skill is available
  - If YES: Quality enhancement confirmed → PROCEED
  - If NO: PROCEED to STEP 4

STEP 4: Evaluate Minimum Requirements
  - Can @E execute the handoff packet with available tools?
  - If YES: PROCEED with work (document limitations in completion packet)
  - If NO: ESCALATE to Human Lead
```

### 4.2 Escalation Protocol

**If @E cannot access a required capability:**

1. **State what capability is missing**
   - Example: "Handoff requires Stripe integration, but Stripe API key not configured"

2. **State what @E can still accomplish with available tools**
   - Example: "Can implement UI and mock API responses, but cannot test live payments"

3. **STOP and wait for Human direction**
   - Do NOT proceed with degraded execution
   - Do NOT implement workarounds without approval

4. **Do NOT attempt degraded execution without approval**
   - Example: Do NOT stub out payment logic if real integration required

### 4.3 Capability Documentation

@E must document detected capabilities in completion packet:

```yaml
execution_environment: Claude Code (CC)
tools_used:
  - CC (code writing + file operations)
  - Vitest (unit/integration testing)
  - Playwright (E2E testing, not used for this handoff)
quality_loops_run: 1 (Ralph iteration for test improvement)
capability_limitations:
  - Stripe webhook testing requires ngrok (not available in CI)
  - Email verification requires SMTP config (stubbed for now)
```

---

## 5. Escalation Triggers

@E must **STOP** and escalate to @G + Human when any of these conditions occur:

### 5.1 Escalation Trigger Table

| Trigger | Example | Escalation Action |
|---------|---------|-------------------|
| **Scope conflict** | Handoff packet requires feature not in original spec | Return to @G with scope question: "Handoff requires X, but Build Plan scoped Y. Clarify?" |
| **Architecture conflict** | Implementation pattern contradicts TECH.md or @O decisions | Return to @O for architecture clarification via @G |
| **Constitution conflict** | Required tech stack violates GOVERNANCE.md policy | Return to Human Lead for governance decision |
| **Capability gap** | Required tool/service not available (e.g., Stripe API key missing) | Escalate to Human with specific requirement |
| **Sacred Four failure** | Tests fail, build breaks, coverage drops below threshold | Fix if trivial (<30 min); escalate if complex |
| **Breaking change discovered** | Implementation requires breaking API change | Return to @G for Build Plan adjustment |
| **Security concern** | Implementation pattern introduces vulnerability | Escalate immediately with security note |
| **Timeline conflict** | Handoff cannot be completed in expected timeframe | Notify @G with revised estimate |
| **Dependency blocker** | External dependency unavailable (API down, library broken) | Escalate to @G with blocker description |
| **Test coverage impossible** | Code not testable without major refactor | Escalate to @G for architecture review |

### 5.2 Escalation Message Template

```markdown
## Escalation: [Trigger Type]

**Handoff ID:** HO-2026-001-auth-feature
**Escalation Type:** Scope conflict
**Status:** BLOCKED

### Issue Description
Handoff packet specifies "OAuth integration with Google and GitHub."
Build Plan (Section 3.2) scoped only email/password authentication.
OAuth appears to be out of scope for this sprint.

### What @E Can Do
- Complete email/password auth as originally scoped
- Stub OAuth hooks for future implementation

### What @E Cannot Do Without Approval
- Implement full OAuth flows (requires additional libraries, Supabase config)
- Extend scope beyond Build Plan

### Requested Decision
1. Remove OAuth from handoff packet (complete email/password only), OR
2. Extend Build Plan to include OAuth (adjust timeline), OR
3. Stub OAuth with clear documentation for follow-up handoff

**Awaiting @G + Human Lead direction.**
```

---

## 6. Handoff → Completion Protocol

### 6.1 Handoff Packet Structure (Input from @G)

@E receives handoff packets from @G with the following structure:

```yaml
---
handoff_id: HO-2026-001-auth-feature
handoff_type: feature | bugfix | refactor | infrastructure
scope: |
  Implement email/password authentication using Supabase Auth.
  Users can sign up, log in, log out, and reset password.
  Integration with existing OAuth flow (preserve existing logic).
files_to_touch:
  - lib/supabase/auth.ts
  - app/(auth)/login/page.tsx
  - app/(auth)/signup/page.tsx
  - app/(auth)/reset-password/page.tsx
  - tests/integration/auth.test.ts
  - supabase/migrations/20260206_add_user_metadata.sql
acceptance_criteria:
  - User can sign up with email/password
  - User can log in with email/password
  - User can reset password via email
  - Sacred Four passes (typecheck, lint, test, build)
  - Test coverage ≥70% for auth module
  - No breaking changes to OAuth flow
constraints:
  - Do NOT modify existing OAuth logic in lib/supabase/oauth.ts
  - Do NOT change user table schema (add columns only)
  - Do NOT bypass RLS policies
stack_allowances:
  - May use react-hook-form for form validation (preferred: zod + native)
  - May use alternative email validation library if zod insufficient
approval_status: approved
approved_by: @G + Leo
approved_date: 2026-02-06
---
```

**Required fields:**
- `handoff_id`: Unique identifier (format: `HO-YYYY-NNN-slug`)
- `handoff_type`: `feature | bugfix | refactor | infrastructure`
- `scope`: What to build (multi-line allowed)
- `files_to_touch`: Expected blast radius
- `acceptance_criteria`: Success definition (list)
- `constraints`: What NOT to do (list)
- `stack_allowances`: Permitted deviations from defaults
- `approval_status`: Must be `approved`
- `approved_by`: @G + Human Lead name
- `approved_date`: YYYY-MM-DD

**Optional fields:**
- `context`: Additional background
- `dependencies`: Prerequisite work
- `timeline`: Suggested completion timeframe

### 6.2 Completion Packet Structure (Output to @G)

**Format:** Markdown with YAML frontmatter

**File location:** `ai_prompts/completed/<handoff_id>-completion.md`

**YAML frontmatter (machine-readable truth for @G):**

```yaml
---
handoff_id: HO-2026-001-auth-feature
completion_date: 2026-02-06T14:30:00Z
branch: feat/email-password-auth
pr_url: https://github.com/org/repo/pull/42
status: ready_for_review | blocked | escalated

# Testing metrics
tests_added: 12
tests_passed: 12
tests_failed: 0
coverage_before: 78.3%
coverage_after: 86.6%
coverage_delta: +8.3%

# Sacred Four results
sacred_four_typecheck: pass
sacred_four_lint: pass
sacred_four_test: pass
sacred_four_build: pass

# Database changes
migrations_required: true
migrations_files:
  - supabase/migrations/20260206_add_user_metadata.sql
breaking_changes: false

# Security audit
security_sensitive_paths: true
security_audit_notes: |
  Auth flows are Sacred Four paths (100% coverage required).
  All auth functions tested with edge cases (SQL injection, XSS).
  RLS policies unchanged, leveraging existing auth.users table.

# File manifest
files_created:
  - app/(auth)/login/page.tsx
  - app/(auth)/signup/page.tsx
  - app/(auth)/reset-password/page.tsx
  - tests/integration/auth.test.ts
files_modified:
  - lib/supabase/auth.ts
  - README.md
files_deleted: []

# Capability detection
execution_environment: Claude Code (CC)
tools_used:
  - CC (code writing + file operations)
  - Vitest (unit/integration testing)
  - Playwright (E2E testing, not used for this handoff)
quality_loops_run: 1 (Ralph iteration for test improvement)
---
```

**Required YAML fields:**
- `handoff_id`: Links to originating handoff
- `completion_date`: ISO 8601 timestamp
- `branch`: Git branch name
- `pr_url`: Pull request URL (or `null` if not yet created)
- `status`: `ready_for_review | blocked | escalated`
- `tests_added`, `tests_passed`, `tests_failed`: Test counts
- `coverage_before`, `coverage_after`, `coverage_delta`: Coverage percentages
- `sacred_four_typecheck`, `sacred_four_lint`, `sacred_four_test`, `sacred_four_build`: `pass | fail`
- `migrations_required`: Boolean
- `breaking_changes`: Boolean
- `files_created`, `files_modified`, `files_deleted`: Lists of file paths

**Markdown body (human narrative):**

```markdown
## Changes Summary

### Authentication Implementation
- `lib/supabase/auth.ts` — Added `signInWithEmail`, `signUpWithEmail`, `resetPassword` functions
- `app/(auth)/login/page.tsx` — Created login form with email/password validation (Zod)
- `app/(auth)/signup/page.tsx` — Created signup form with password strength requirements
- `app/(auth)/reset-password/page.tsx` — Created password reset flow with email confirmation

### Testing Coverage
- `tests/integration/auth.test.ts` — 12 new tests covering:
  - Email validation (valid/invalid formats)
  - Password strength requirements
  - Signup → login flow
  - Password reset flow
  - Session persistence
  - RLS policy enforcement

## Sacred Four Status

✅ **typecheck**: PASS (strict mode, no `any` types)
✅ **lint**: PASS (ESLint + Prettier)
✅ **test**: PASS (12/12 tests, coverage 78.3% → 86.6%)
✅ **build**: PASS (Next.js production build successful)

## Constraints Compliance

✅ **Did NOT modify OAuth logic** — Preserved `lib/supabase/oauth.ts` entirely
✅ **Did NOT change user table schema** — Added columns only (nullable)
✅ **Did NOT bypass RLS** — All queries subject to existing policies

## Ready for Review

**Status:** ✅ READY FOR REVIEW

**Next steps:**
1. @G validates completion packet against handoff criteria
2. Human Lead (Leo) reviews PR #42
3. Merge to `develop` branch after approval
4. Deploy preview to staging for QA
```

### 6.3 Completion Packet Validation (by @G)

@G validates completion packets using this checklist:

- [ ] `handoff_id` matches original handoff
- [ ] `status` is `ready_for_review` (not blocked/escalated)
- [ ] Sacred Four: all 4 checks are `pass`
- [ ] `tests_added` > 0 (new code has tests)
- [ ] `tests_passed` == `tests_added` (all tests pass)
- [ ] `coverage_delta` ≥ 0 (coverage did not decrease)
- [ ] `breaking_changes` == `false` (or explicitly approved)
- [ ] `files_created` + `files_modified` matches `files_to_touch` in handoff (or justified)
- [ ] `migrations_required` == `true` → `migrations_files` is populated
- [ ] `security_sensitive_paths` == `true` → `security_audit_notes` is populated
- [ ] Markdown narrative explains "why" for key decisions
- [ ] Constraints from handoff packet are addressed
- [ ] Acceptance criteria from handoff packet are met

**If validation fails:** @G returns to @E with specific issues to fix.

**If validation passes:** @G forwards to Human Lead for PR review.

---

## 7. Execution Workflow

### 7.1 Standard Execution Sequence

```
1. RECEIVE HANDOFF
   - Verify `approval_status: approved`
   - Read entire handoff packet
   - Understand scope, constraints, acceptance criteria

2. DETECT CAPABILITIES
   - Run capability detection protocol (Section 4)
   - Document available tools
   - Escalate if required capabilities missing

3. PLAN WORK
   - Identify sub-agent tasks
   - Determine parallel vs sequential work
   - Estimate effort and timeline

4. CREATE BRANCH
   - `git checkout -b feat/<feature-slug>` or `fix/<bug-slug>`
   - Never work on main branch

5. EXECUTE (TDD Preferred)
   - Write failing test
   - Implement minimal code to pass
   - Refactor
   - Repeat

6. RUN QUALITY LOOPS
   - Ralph iteration for code quality
   - ESLint + Prettier formatting
   - Type safety checks

7. VALIDATE SACRED FOUR
   - `pnpm typecheck` → must pass
   - `pnpm lint` → must pass
   - `pnpm test --coverage` → must pass, coverage ≥70%
   - `pnpm build` → must pass

8. CREATE PR
   - Push branch to remote
   - Open PR with descriptive title and body
   - Link to handoff packet

9. GENERATE COMPLETION PACKET
   - YAML frontmatter with metrics
   - Markdown narrative with context
   - Save to `ai_prompts/completed/<handoff_id>-completion.md`

10. SUBMIT TO @G
    - Notify @G that completion packet is ready
    - Wait for validation
    - Address any feedback
```

### 7.2 TDD Workflow (Preferred)

```
1. Write failing test
   - Define expected behavior
   - Test should fail (red)

2. Implement minimal code to pass
   - Make test pass (green)
   - Don't over-engineer

3. Refactor
   - Improve code quality
   - Tests remain green

4. Repeat for next behavior
```

### 7.3 Tests-Alongside Workflow (Minimum Acceptable)

```
1. Implement feature
   - Write code for functionality

2. Write tests immediately after
   - Cover happy path + edge cases
   - Aim for 70%+ coverage

3. Verify Sacred Four
   - All tests pass
   - Coverage threshold met
```

### 7.4 Anti-Pattern: Tests-Later (Forbidden)

```
❌ Ship feature → Add tests later
- Tests are afterthought
- Harder to write (code not test-friendly)
- Often skipped due to time pressure

This pattern is FORBIDDEN. @E must produce tests during implementation.
```

---

## 8. Quality Standards

### 8.1 Sacred Four

The Sacred Four is the quality gate for all @E work:

```bash
pnpm typecheck && pnpm lint && pnpm test && pnpm build
```

**All four must pass before PR merge.**

| Check | Purpose | Failure Action |
|-------|---------|----------------|
| **typecheck** | Type safety (TypeScript strict mode) | Fix type errors before proceeding |
| **lint** | Code style (ESLint + Prettier) | Fix lint errors before proceeding |
| **test** | Correctness (Vitest + coverage) | Fix failing tests before proceeding |
| **build** | Deployability (Next.js build) | Fix build errors before proceeding |

### 8.2 Test Coverage Requirements

**Default coverage threshold:** 70% line coverage

**Sacred Four paths:** 100% coverage required for:
- Authentication flows
- Payment processing (Stripe)
- Data integrity operations (create/update/delete with validation)
- Security-sensitive paths (authorization, RLS policies)

**Coverage enforcement:**
- Pre-commit hook: Lints and formats staged files only
- PR validation (CI): Runs full Sacred Four with coverage report
- Merge requirements: Sacred Four must pass before merge allowed
- Completion packet: Coverage metrics documented

### 8.3 Stop-the-Line Rule

**If Sacred Four fails at any point, @E must:**

1. **Fix immediately** if trivial (<30 minutes)
   - Example: Linting errors, minor type fixes

2. **Escalate to @G** if complex (scope/architecture issue)
   - Example: Test coverage requires refactoring entire module

3. **Never bypass** (no `--no-verify`, no `git commit -n`)
   - Example: Do NOT skip pre-commit hooks to "save time"

**Sacred Four failures are hard stops. No exceptions.**

### 8.4 Code Quality Checklist

Before submitting completion packet:

- [ ] TypeScript strict mode enabled (no `any` types)
- [ ] All functions/components documented with JSDoc/TSDoc
- [ ] All API routes validated with Zod schemas
- [ ] All database queries use parameterized queries (no raw SQL concatenation)
- [ ] All user inputs sanitized
- [ ] All errors handled gracefully (try-catch, error boundaries)
- [ ] All external API calls have timeout + retry logic
- [ ] All environment variables typed and validated
- [ ] All console.log removed (use proper logging)
- [ ] All TODOs resolved or documented in parking lot

---

## 9. Coordination Examples

### 9.1 Example: Simple Feature (Auth Form)

**Handoff packet summary:** "Create login form with email/password validation"

**@E coordination:**

```
1. RECEIVE HANDOFF
   - Handoff ID: HO-2026-001-login-form
   - Scope: Login form with Zod validation
   - Files: app/(auth)/login/page.tsx, lib/supabase/auth.ts

2. DETECT CAPABILITIES
   - CC available: ✓
   - Cursor available: ✓
   - Ralph available: ✓

3. PLAN WORK
   - E-ui-builder: Create login form component
   - E-api-builder: Create signInWithEmail function
   - E-test-writer: Unit tests for validation, integration test for auth flow
   - Work can be parallel

4. EXECUTE
   - E-ui-builder creates form with Zod schema
   - E-api-builder creates auth function
   - E-test-writer adds tests

5. QUALITY LOOP
   - Ralph iteration: Improve form UX (loading states, error messages)
   - ESLint + Prettier formatting

6. SACRED FOUR
   - typecheck: ✓
   - lint: ✓
   - test: ✓ (coverage 85%)
   - build: ✓

7. COMPLETION PACKET
   - Status: ready_for_review
   - Tests: 8 added, 8 passed
   - Coverage: 78% → 85% (+7%)
```

### 9.2 Example: Complex Feature (Stripe Integration)

**Handoff packet summary:** "Implement Stripe checkout with webhook handling"

**@E coordination:**

```
1. RECEIVE HANDOFF
   - Handoff ID: HO-2026-002-stripe-checkout
   - Scope: Stripe checkout + webhook verification
   - Files: app/api/checkout/route.ts, app/api/webhooks/stripe/route.ts

2. DETECT CAPABILITIES
   - CC available: ✓
   - Stripe API key: ✗ (MISSING)

3. ESCALATE
   - Issue: "Stripe API key not configured in environment"
   - Can do: "Can implement UI and mock checkout flow"
   - Cannot do: "Cannot test live payments without API key"
   - Requested: "Provide Stripe test API key or approve mock implementation"

4. RECEIVE APPROVAL
   - Human Lead provides Stripe test key
   - @E proceeds with implementation

5. PLAN WORK
   - E-api-builder: Checkout endpoint + webhook handler (sequential)
   - E-test-writer: Integration tests with Stripe test fixtures
   - E-docs: Document webhook setup for production

6. EXECUTE
   - E-api-builder creates checkout API route
   - E-api-builder creates webhook handler
   - E-test-writer adds tests using Stripe test fixtures
   - E-docs updates ARCHITECTURE.md with webhook flow

7. SECURITY AUDIT
   - Webhook signature verification: ✓
   - Idempotency keys: ✓
   - Error handling: ✓
   - Coverage: 100% (Sacred Four path)

8. SACRED FOUR
   - typecheck: ✓
   - lint: ✓
   - test: ✓ (coverage 92%, 100% for payment paths)
   - build: ✓

9. COMPLETION PACKET
   - Status: ready_for_review
   - Security-sensitive: true
   - Security audit notes: "Webhook verification implemented, 100% coverage"
```

### 9.3 Example: Escalation (Scope Conflict)

**Handoff packet summary:** "Add user profile editing"

**@E coordination:**

```
1. RECEIVE HANDOFF
   - Handoff ID: HO-2026-003-profile-edit
   - Scope: "User can edit profile (name, email, avatar)"
   - Files: app/(auth)/profile/page.tsx

2. DETECT CONFLICT
   - Handoff includes avatar upload
   - Build Plan (Section 2.3) scoped only text fields
   - Avatar upload requires Supabase Storage setup (not in scope)

3. ESCALATE TO @G
   - Issue: "Scope conflict — avatar upload not in Build Plan"
   - Can do: "Implement name/email editing"
   - Cannot do: "Avatar upload without Supabase Storage config"
   - Requested: "Remove avatar from handoff OR extend Build Plan"

4. RECEIVE DECISION
   - @G: "Remove avatar from handoff. Create follow-up handoff for avatar feature."

5. PROCEED WITH REVISED SCOPE
   - E-ui-builder: Profile form (name, email only)
   - E-api-builder: Update user metadata
   - E-test-writer: Tests for profile update

6. COMPLETION PACKET
   - Status: ready_for_review
   - Notes: "Avatar upload removed per @G decision. Follow-up handoff needed."
```

---

## Appendix A: Quick Reference Tables

### A.1 Handoff Packet Checklist

- [ ] `handoff_id` present and unique
- [ ] `approval_status: approved`
- [ ] `approved_by` includes @G + Human Lead
- [ ] `scope` clearly defined
- [ ] `acceptance_criteria` testable
- [ ] `constraints` specific (what NOT to do)
- [ ] `files_to_touch` reasonable blast radius

### A.2 Completion Packet Checklist

- [ ] YAML frontmatter complete
- [ ] `status: ready_for_review`
- [ ] Sacred Four: all pass
- [ ] `tests_added > 0`
- [ ] `coverage_delta ≥ 0`
- [ ] File manifest accurate
- [ ] Markdown narrative explains decisions
- [ ] Constraints compliance documented
- [ ] Acceptance criteria met

### A.3 Sacred Four Quick Reference

```bash
# Run individually
pnpm typecheck  # TypeScript type checking
pnpm lint       # ESLint + Prettier
pnpm test       # Vitest with coverage
pnpm build      # Next.js production build

# Run all at once
pnpm sacred-four  # Convenience script
```

### A.4 Escalation Decision Tree

```
Is there a scope conflict?
  YES → Escalate to @G with scope question
  NO ↓

Is there an architecture conflict?
  YES → Escalate to @O via @G
  NO ↓

Is there a governance conflict?
  YES → Escalate to Human Lead
  NO ↓

Is there a capability gap?
  YES → Escalate to Human with requirement
  NO ↓

Did Sacred Four fail?
  YES → Fix if <30 min, else escalate to @G
  NO ↓

PROCEED with implementation
```

---

## Appendix B: Sub-Agent Coordination Patterns

### B.1 Pattern: Parallel UI + API

```typescript
// @E coordinates parallel work
const results = await Promise.all([
  executeSubAgent('E-ui-builder', {
    task: 'Create dashboard components',
    files: ['app/dashboard/page.tsx', 'components/stats-card.tsx']
  }),
  executeSubAgent('E-api-builder', {
    task: 'Create dashboard API endpoints',
    files: ['app/api/dashboard/stats/route.ts']
  }),
  executeSubAgent('E-docs', {
    task: 'Document dashboard architecture',
    files: ['docs/ARCHITECTURE.md']
  })
])

// @E reconciles interface contracts
const uiInterface = results[0].interface
const apiInterface = results[1].interface

if (!interfacesMatch(uiInterface, apiInterface)) {
  // @E resolves conflict
  await reconcileInterfaces(uiInterface, apiInterface)
}
```

### B.2 Pattern: Sequential Migration → API

```typescript
// @E coordinates sequential work
// Step 1: E-migrations creates schema
await executeSubAgent('E-migrations', {
  task: 'Add properties table',
  files: ['supabase/migrations/20260206_create_properties.sql']
})

// Step 2: E-api-builder uses new schema
await executeSubAgent('E-api-builder', {
  task: 'Create properties API',
  files: ['app/api/properties/route.ts'],
  dependencies: ['properties table exists']
})

// Step 3: E-test-writer tests API
await executeSubAgent('E-test-writer', {
  task: 'Test properties API',
  files: ['tests/integration/properties.test.ts'],
  dependencies: ['properties API exists']
})
```

---

## Appendix C: Vantage Project Learnings

These learnings from the Vantage project informed E lane formalization:

### C.1 Tests-Later Anti-Pattern

**Problem:** Vantage shipped features without tests, added tests later (if at all).

**Consequence:**
- Lower coverage (60% vs 70% target)
- Bugs discovered in production
- Harder to refactor (no test safety net)

**Solution:** @E must produce tests during implementation (TDD or tests-alongside).

### C.2 Agent Coordination Gaps

**Problem:** CC and Cursor worked in silos, no clear handoff protocol.

**Consequence:**
- Duplicate work (both implementing same feature)
- Interface mismatches (UI expected different API contract)
- No clear accountability

**Solution:** @E coordinates sub-agents explicitly, reconciles conflicts, remains accountable.

### C.3 Sacred Four Bypass

**Problem:** Developers skipped linting/testing to "move faster."

**Consequence:**
- Inconsistent code style
- Build failures in production
- Technical debt accumulation

**Solution:** Sacred Four enforced via CI, no bypass allowed. Stop-the-line rule.

---

*This operating guide is the canonical reference for @E (Execution) lane behavior in FORGE. All @E agents and humans must adhere to these protocols.*

**Last Updated:** 2026-02-06
**Version:** 1.0
**Status:** Canonical Reference
