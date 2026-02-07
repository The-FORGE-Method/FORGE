# FORGE Project Template

**A FORGE-governed software development project.**

---

## How to Work with This Project

> *I'm your FORGE guide. Tell me what you want to do and I'll help you get there. No jargon needed — just speak naturally.*

### Quick Start

**First time here?** Just tell me what you want to build. I'll handle the rest.

**Already working?** Here's how to talk to me:

| You Say | What Happens |
|---------|-------------|
| "I want to build X" | I set up your project workspace |
| "Help me think through this" | I help you explore options and make sense of inputs |
| "I'm ready to commit" | I lock scope and unlock the full build lifecycle |
| "How should this be architected?" | I route to architecture planning |
| "What's next?" or "Catch me up" | I show you project status and next steps |
| "Start coding" or "Ship it" | I coordinate implementation |

**Precision addressing:** Use `@role` for direct access (e.g., `@G catch me up`, `@F help me scope this`).

### How I Work

1. **I suggest, never auto-invoke** — You always confirm before action
2. **I translate natural language** — Speak naturally, I route to the right agent
3. **I maintain lane discipline** — Each agent has clear boundaries
4. **I respect human authority** — You greenlight all decisions
5. **I use progressive disclosure** — No jargon until you need it

### If You're Stuck

Just say "I'm stuck" or "I don't understand" and I'll figure out where you are and suggest next steps.

---

## I'm New to FORGE

**60-second orientation:**

FORGE helps you build software with AI assistance. It has two lifecycles:

### Pre-FORGE (A.B.C) — Before You Commit

| Step | Agent | What It Does |
|------|-------|-------------|
| **Acquire** | @A | Sets up your workspace and organizes your idea |
| **Brief** | @B | *(Optional)* Helps you explore options if you're unsure |
| **Commit** | @C | Locks your scope and unlocks the full build lifecycle |

### FORGE Lifecycle (F.O.R.G.E) — Building

| Phase | Agent | What It Does |
|-------|-------|-------------|
| **Frame** | @F | Define what to build (product intent, scope, success criteria) |
| **Orchestrate** | @O | Design how to build it (architecture, phases, data model) |
| **Refine** | @R | Review for coherence, conflicts, and risks |
| **Govern** | @G | Coordinate execution (routing, status, handoffs) |
| **Execute** | @E | Build it (tests first, code, PRs) |

**Key principle:** Humans always greenlight decisions. Agents propose, humans approve.

**Your first step:** Just tell me what you want to build. I'll start with @A to get you set up.

**Want more?** Say "Explain FORGE" for the full philosophy primer.

---

## FORGE Canon Reference

This project operates under **The FORGE Method(TM)**.

**Canonical Authority:**
- FORGE Core: [method/core/forge-core.md](../../method/core/forge-core.md)
- Operations: [method/core/forge-operations.md](../../method/core/forge-operations.md)
- SD Profile: See FORGE method documentation

> **Rule:** This repo does not redefine FORGE. It *consumes* FORGE by reference.
> If methodology questions arise, consult the canon.

---

## FORGE Philosophy Primer

### The Five Laws of FORGE

1. **Intent Before Implementation** — Understand "why" before building
2. **Agents Stay in Lanes** — Each role has boundaries; no scope creep
3. **Human Greenlight Required** — Agents propose, humans approve
4. **One Canonical Record** — Single source of truth; no duplicates
5. **Hard Stops Are Non-Negotiable** — If verification fails, stop

### The F→O→R→G→E Lifecycle

```
Frame → Orchestrate → Refine → Govern → Execute
  (F)        (O)        (R)       (G)       (E)

  Discovery  Architecture  Review   Coordinate  Build
  →Intent    →Plan        →Approve →Tasks      →Verify
```

### Why This Structure Exists

- **Separation of concerns:** Framing the problem is different from architecting the solution
- **Human checkpoints:** Strategic decisions remain with humans
- **Quality gates:** Work doesn't progress until verified
- **Traceability:** Every decision has a record

### What This Means for You

- **You don't need to think in phases** — Just tell me what you want
- **I'll route your intent** — And explain which phase applies
- **You retain control** — Nothing happens without your approval

---

## Common Requests & FORGE Translations

When you speak naturally, I translate to FORGE actions. Here's what I listen for:

### Frame Phase (F) — Product Strategist

| You Say | I Interpret As | I'll Suggest |
|---------|---------------|--------------|
| "I want to build X" | Frame phase work | Route to Product Strategist. Drop materials in `inbox/00_drop/<slug>/` |
| "New feature idea" | Frame phase work | Guide you through discovery submission |
| "What should this product do?" | Frame phase work | Engage Product Strategist for scope definition |
| "Help me figure out scope" | Frame phase work | Recommend Product Strategist |
| "Is this in scope?" | Frame clarification | Check `docs/constitution/PRODUCT.md` or Product Intent Packet |
| "What are we building again?" | Frame review | Reference North Star in `docs/constitution/PRODUCT.md` |

### Orchestrate Phase (O) — Project Architect

| You Say | I Interpret As | I'll Suggest |
|---------|---------------|--------------|
| "How should this be architected?" | Orchestrate phase work | Route to Project Architect for decomposition |
| "What's the tech stack?" | Orchestrate question | Reference `docs/constitution/TECH.md` |
| "Database design question" | Orchestrate phase work | Engage Project Architect for data modeling |
| "API structure?" | Orchestrate phase work | Route to Project Architect for interface design |
| "How do I set this up?" | Orchestrate question | Reference Architecture Packet in `inbox/20_architecture-plan/` |

### Refine Phase (R) — Review/Concern

| You Say | I Interpret As | I'll Suggest |
|---------|---------------|--------------|
| "This feels off" | Refine phase concern | Flag for spec review |
| "Something's wrong with the spec" | Refine phase issue | Escalate to Project Architect |
| "This doesn't match the spec" | Refine conflict | Surface discrepancy and check constitutional docs |
| "Can we change the approach?" | Refine modification | Document proposed change for Human Lead approval |

### Govern Phase (G) — Ops Agent

| You Say | I Interpret As | I'll Suggest |
|---------|---------------|--------------|
| "Catch me up" | Govern status check | Coordinate with Ops Agent; reference `inbox/30_ops/execution-state.md` |
| "What's next?" | Govern planning | Check Build Plan in `inbox/30_ops/build-plan.md` |
| "What's the status?" | Govern status check | Reference Execution State |
| "Can I start coding?" | Govern readiness check | Verify Build Plan approval status |
| "Is this ready to merge?" | Govern gate check | Run Sacred Four verification |
| "What needs approval?" | Govern gate check | Check `inbox/30_ops/approvals/` |

### Execute Phase (E) — Implementation

| You Say | I Interpret As | I'll Suggest |
|---------|---------------|--------------|
| "Ship it" | Execute completion | Check governance gates, then coordinate merge approval |
| "Start coding" | Execute phase work | Reference current task in Build Plan |
| "Implement feature X" | Execute phase work | Check if in scope, reference task brief |
| "Fix this bug" | Execute phase work | Check scope; if out of scope, suggest parking lot |
| "Run tests" | Execute verification | Run Sacred Four: `pnpm typecheck && pnpm lint && pnpm test:run && pnpm build` |

### General / Meta

| You Say | I Interpret As | I'll Suggest |
|---------|---------------|--------------|
| "Explain FORGE" | Orientation request | Provide philosophy primer (see section above) |
| "How do I use this?" | Orientation request | Direct to "How to Work with This Project" section |
| "What can you do?" | Capability question | Explain my role as FORGE guide |
| "I'm stuck" | Escalation signal | Ask clarifying questions to identify phase, then suggest action |
| "This is taking too long" | Process concern | Review current phase and check for blockers |
| "I don't understand" | Confusion signal | Re-orient to current phase with context |
| "Can I skip X?" | Governance question | Explain why X exists and consequences |
| "This is too rigid" | Methodology concern | Explain FORGE flexibility within principles |
| "Who decides?" | Authority question | Human Lead has final authority; I coordinate |

---

## When to Escalate vs Proceed

### Green Light (Proceed)

- Task is in approved Build Plan
- Constitution docs exist and are clear
- Sacred Four passes
- Within approved PR scope

### Yellow Light (Proceed with Caution)

- Slight ambiguity in spec — clarify, then proceed
- Minor scope question — document assumption, proceed
- Technical uncertainty — prototype, validate, proceed

### Red Light (Stop and Escalate)

- Constitution missing or incomplete → **STOP** — Request inputs from Human Lead
- Work outside Build Plan scope → **STOP** — Park it or request scope change
- Sacred Four fails → **STOP** — Fix before proceeding
- Spec conflict detected → **STOP** — Escalate to Refine phase
- Governance gate not passed → **STOP** — Request approval
- "This feels wrong" → **STOP** — Flag concern, get clarity

**When in doubt:** Ask. It's faster than fixing a wrong turn.

---

## Template Usage Notice

> **This file is part of the FORGE project template — the operational scaffold for new FORGE projects.**

### If You Are Reading This IN the Template Repo

**This is an ARTIFACT, not a workspace.**

| Do | Don't |
|----|-------|
| Copy this repo to create new projects | Work directly in this repo |
| Reference patterns here | Add project-specific code here |
| Customize after copying | Store recon, research, or proposals here |

**Template changes only arrive via promotion from `../_workspace/` after explicit approval.**

### If You Copied This to Create a New Project

You're in the right place. Customize the `[CUSTOMIZE]` sections below and proceed.

---

## Project Identity

### What This Is
[CUSTOMIZE: 2-3 sentences describing the project's purpose]

### What This Is NOT
- [CUSTOMIZE: Explicit non-goal 1]
- [CUSTOMIZE: Explicit non-goal 2]
- [CUSTOMIZE: Explicit non-goal 3]

### Who This Is For
- **Primary users:** [CUSTOMIZE: Who uses this directly]
- **Stakeholders:** [CUSTOMIZE: Who cares about outcomes]

---

## Constitution Check (CC: Read This First)

**Before any work, check constitutional status:**

```
docs/constitution/
├── PRODUCT.md        # Product intent (North Star)
├── TECH.md           # Technical architecture
└── GOVERNANCE.md     # Security, permissions, policies
```

### If Constitution Is Empty or Missing

**STOP.** Do not scaffold. Do not implement.

Request from Human Lead:
1. Product brief / North Star document
2. Technical decisions / architecture constraints
3. Governance rules (auth, RLS, security requirements)

The constitution must exist before Execute phase begins.

### If Constitution Exists

Proceed with scaffolding and execution per the constitution.

---

## Agent Lanes & @Role Addressing

### Pre-FORGE Agents (A.B.C)

| Agent | Addressing | Phase | Boundary |
|-------|-----------|-------|----------|
| **@A** Acquire | `/forge-a` | Scaffold + Intake | No product decisions, architecture, or build plans |
| **@B** Brief | `/forge-b` | Sensemaking + Options | No scope finalization or code (CONDITIONAL) |
| **@C** Commit | `/forge-c` | Decision Gate | No PRODUCT.md, code, or approval bypass |

### FORGE Lifecycle Agents (F.O.R.G.E)

| Agent | Addressing | Phase | Boundary |
|-------|-----------|-------|----------|
| **Human Lead** | Direct | All | Final decisions, greenlight, merge |
| **@F** Frame | `/forge-f` | Intent + Scope | No architecture or code |
| **@O** Orchestrate | `/forge-o` | Architecture + Planning | No product decisions or code |
| **@R** Refine | `/forge-r` | Review + Coherence | No new decisions or code |
| **@G** Govern | `/forge-g` | Routing + Policy + Gating | Routing/policy only, no domain work |
| **@E** Execute | `/forge-e` | Tests + Code + PR | No scope/arch changes |

**Note:** CC (Claude Code) is infrastructure/runtime, not a FORGE role.

### Addressing Methods

1. **Natural language** — "Catch me up" → routes to @G automatically
2. **Explicit @role** — `@G catch me up` → forces @G dispatch
3. **Skill command** — `/forge-g catch-me-up` → direct skill invocation

Explicit @role addressing takes precedence over natural language interpretation.

### Lane Rules

- **All transitions route through @G** — No direct role-to-role handoff
- **Human-in-the-loop** at all governance checkpoints
- **@B is conditional** — Human decides whether to invoke
- **Pre-FORGE agents (A/B/C) are always Tier 0** — Human approval required
- **Each agent produces artifacts and STOPs** — No autonomous continuation

### Gating: A.B.C → F.O.R.G.E

| State | Available | Blocked |
|-------|-----------|---------|
| Before `abc/FORGE-ENTRY.md` | @A, @B, @C | @F, @O, @R, @G, @E |
| After `abc/FORGE-ENTRY.md` | @F, @O, @R, @G, @E | @A, @B, @C (warn only) |

### Autonomy Tier

This project's autonomy tier is set in `FORGE-AUTONOMY.yml`:

| Tier | Behavior |
|------|----------|
| **0** (default) | @G refuses transitions, instructs human |
| **1** | @G asks human approval before dispatching |
| **2/3** | Future — not available in Phase 1 |

---

## Inbox-Driven Workflow (Frame Phase)

The Product Strategist uses an inbox-driven workflow for Frame phase work.

### Structure

```
inbox/
├── 00_drop/              ← Discovery input (human writes here)
│   └── <feature-slug>/   ← One folder per feature
└── 10_product-intent/    ← Product Intent Packets (agent writes here)
    └── <feature-slug>/   ← Output packet
```

### How to Use the Inbox

**To submit a feature idea:**

1. Create folder: `inbox/00_drop/<your-feature-slug>/`
2. Add `README.md` describing the idea
3. Add `threads/` with any transcripts, notes, brain dumps
4. Add `assets/` with sketches, screenshots
5. Tell me: "I have a new feature idea" — I'll guide next steps

**What happens next:**

1. Product Strategist reviews your materials
2. May ask clarifying questions (up to 3 rounds)
3. Produces Product Intent Packet in `inbox/10_product-intent/<slug>/`
4. Human Lead routes to Project Architect

### Workflow

1. **Human drops discovery materials** in `inbox/00_drop/<slug>/`
   - README.md (required) — describe the idea
   - threads/ — transcripts, notes, brain dumps
   - assets/ — sketches, screenshots
   - links.md — external references

2. **Product Strategist processes** the discovery materials
   - Asks clarifying questions (up to 3 rounds)
   - Synthesizes into coherent product intent
   - Produces Product Intent Packet

3. **Output appears** in `inbox/10_product-intent/<slug>/`
   - 8 required artifacts (intent, actors, use-cases, etc.)
   - Professional PM-level quality

4. **Human Lead routes** to Project Architect

5. **Project Architect processes** the Product Intent Packet
   - Asks clarifying questions (up to 2 rounds)
   - Decomposes into architecture components
   - Produces Architecture & Execution Packet

6. **Architecture Packet appears** in `inbox/20_architecture-plan/<slug>/`
   - 7 artifacts (architecture, execution plan, PR plan, etc.)
   - Complete planning ready for execution

7. **Human Lead routes** to Ops Agent (G)

8. **Ops Agent processes** the Architecture Packet
   - Decomposes into phased Build Plan
   - Requests Build Plan approval
   - Coordinates Execution (E) per phase

9. **Execution output appears** in `inbox/30_ops/`
   - Build Plan
   - Execution State (done/blocked/next)
   - Approval records

### Relationship to Constitution

- **Product Intent Packets** are Frame-phase discovery artifacts
- **Architecture Packets** are Orchestrate-phase planning artifacts
- **PRODUCT.md** (in `docs/constitution/`) is the refined constitutional doc
- Packets **precede and inform** constitutional docs but don't replace them
- Both packet types are preserved as historical records

See `inbox/README.md` for detailed submission guidelines.

---

## G-Phase: @G (Govern) Coordination

After architecture is planned, **@G (Govern)** takes over execution coordination and routing.

### What @G Does

- Decomposes Architecture Packet into phased **Build Plan**
- Routes all cross-lane transitions (canonical switchboard)
- Coordinates **@E (Execute)** agents or humans
- Validates outputs against specs (Sacred Four)
- Enforces human-in-the-loop approval gates
- Logs all transition events to `docs/router-events/`
- Tracks state across sessions

### What @G Does NOT Do

- Design features (that's @F)
- Architect solutions (that's @O)
- Write business logic (that's @E)
- Make product or architecture decisions

### Working with @G

**To check status:** Say "catch me up" or `@G catch me up`
**To get next task:** Say "what's next?" or `@G what's next`
**To request merge:** Say "is this ready to merge?"
**To see blockers:** Say "what needs approval?"

### Human Checkpoints

You will approve:

| Checkpoint | When |
|------------|------|
| Build Plan Approval | After Architecture Packet decomposition |
| Phase Completion | Each PR merged or phase completed |
| PR Merge Approval | PR verified and ready |
| Migration/Deployment | Before infrastructure changes |

### Where to Look

| Artifact | Location |
|----------|----------|
| Build Plan | `inbox/30_ops/build-plan.md` |
| Execution State | `inbox/30_ops/execution-state.md` |
| Pending Approvals | `inbox/30_ops/approvals/` |

**See `inbox/30_ops/README.md` for full details.**

---

## Platform vs Tenant Planes

This project operates on two planes:

### Platform Plane
- **Scope:** System-wide (the SaaS platform itself)
- **Actors:** Stakeholders
- **Surfaces:** Stakeholder Portal, Stakeholder AI
- **Access:** Invite-only platform memberships

### Tenant Plane
- **Scope:** Per-organization (firms, customers, ventures)
- **Actors:** Owners, Admins, Members
- **Surfaces:** Tenant application
- **Access:** Organization memberships

### Session Invariant
**A session is scoped to exactly one plane.** No cross-visibility between planes.

- Stakeholder session → Stakeholder Portal only
- Tenant session → Tenant app for that org only

### Dual-Plane Humans
If a human operates in both planes, they use **separate identities**:
- Stakeholder identity (separate email)
- Tenant identity (separate email)

Switching planes requires logout/login.

---

## Current State

### Phase
[CUSTOMIZE: Frame | Orchestrate | Refine | Govern | Execute]

### If In Execute
- **Current PR:** [PR-XX or "None"]
- **Build Plan:** `docs/build-plan.md`
- **Ops State:** `docs/ops/state.md`

---

## Commands

### Verification Sequence (Sacred Four)
```bash
pnpm typecheck && pnpm lint && pnpm test:run && pnpm build
```
**All four must pass before any PR. No exceptions.**

### What Each Command Accomplishes

| Command | What It Checks | When to Run |
|---------|---------------|-------------|
| `pnpm typecheck` | TypeScript type safety | After any code change |
| `pnpm lint` | Code style and patterns | Before commit |
| `pnpm test:run` | Functional correctness | Before commit |
| `pnpm build` | Production deployability | Before PR |

**Run all four together** before any PR submission. If any fail, fix before proceeding.

### Development
```bash
pnpm dev          # Start development server
pnpm build        # Production build
```

### Database (if using Supabase)
```bash
pnpm db:generate  # Generate migrations
pnpm db:migrate   # Apply migrations
```

---

## DATE SAFETY RULE

All dates used in:
- `CHANGELOG.md`
- `plans/`
- `reports/`
- `docs/decisions/`

**MUST** be based on the current local system date at runtime.

If the agent cannot verify the current date, it must halt and request confirmation before writing dated artifacts.

**Heuristic or assumed dates are prohibited.**

---

## Non-Negotiables

1. **Constitution before Execute** — No constitutional docs = no scaffolding
2. **Verification runs before every PR** — Sacred Four, all must pass
3. **Constitutional docs are read-only** — Suggest changes, don't modify
4. **5-line rule** — < 5 lines: CC fixes; >= 5 lines: back to Cursor
5. **Inbox-driven workflow** — Discovery via `inbox/00_drop/`, outputs via `inbox/10_product-intent/` and `inbox/20_architecture-plan/`

---

## Getting Oriented (CC Session Start)

```
1. Read this file (you're doing it)
2. Check docs/constitution/ — if empty, STOP and request inputs
3. Check docs/build-plan.md for current PR
4. Run: git log --oneline -5
5. Check inbox/ for pending work
6. Ready to proceed (~90 seconds)
```

---

## Key Locations

| What | Where |
|------|-------|
| Pre-FORGE lifecycle | `abc/` |
| Intake artifact | `abc/INTAKE.md` |
| FORGE gate artifact | `abc/FORGE-ENTRY.md` |
| Autonomy policy | `FORGE-AUTONOMY.yml` |
| Constitution | `docs/constitution/` |
| Router events | `docs/router-events/` |
| Inbox (F/O/R/G) | `inbox/` |
| Discovery Input | `inbox/00_drop/` |
| Product Intent Packets | `inbox/10_product-intent/` |
| Architecture Packets | `inbox/20_architecture-plan/` |
| **@G (G-phase)** | `inbox/30_ops/` |
| Build Plan | `inbox/30_ops/build-plan.md` |
| Execution State | `inbox/30_ops/execution-state.md` |
| Approval Records | `inbox/30_ops/approvals/` |
| Task Briefs | `inbox/30_ops/handoffs/` |
| ADRs | `docs/adr/` |
| Parking Lot | `docs/parking-lot/` |
| Discovery (legacy) | `docs/discovery/` |
| Auth Utilities | `src/lib/auth/` |
| Stakeholder Portal (Platform Plane) | `src/app/portal/` |
| Stakeholder AI | `supabase/functions/stakeholder-ai/` |
| Auth Migrations | `supabase/migrations/` |

---

## Parking Lot Protocol

The parking lot (`docs/parking-lot/`) captures issues and ideas discovered during development that shouldn't derail current PR scope.

### Files

| File | What Goes Here |
|------|----------------|
| `known-issues.md` | Bugs, broken things, security risks, technical debt |
| `future-work.md` | Feature ideas, enhancements, optimizations, nice-to-haves |

### When to Log

Log to parking lot **immediately** when you discover:
- A bug unrelated to your current PR
- A missing feature that would be nice but isn't in scope
- Technical debt worth addressing later
- A security concern that needs follow-up
- An optimization opportunity
- Ideas from debugging that could improve the system

### Entry Format

```markdown
## [YYYY-MM-DD] Short Title

**Source:** PR-XX or context | **Severity:** Low/Medium/High | **Effort:** X hrs

One-paragraph description of the issue or idea.

**Workaround:** (if applicable for known-issues)

**Fix:** Proposed solution or next steps.
```

### Workflow

1. **Discover** an issue or idea during PR work
2. **Log immediately** to the appropriate parking-lot file
3. **Continue** with current PR scope
4. **Review** parking lot when planning future PRs
5. **Graduate** items to GitHub Issues when prioritized for a specific PR

**Golden Rule:** Don't let discoveries get lost in conversation history. If it's not in scope, park it.

---

## Technical Stack

| Layer | Technology |
|-------|------------|
| Framework | [CUSTOMIZE: e.g., Next.js 15] |
| Language | [CUSTOMIZE: e.g., TypeScript 5.x] |
| Database | [CUSTOMIZE: e.g., Supabase/Postgres] |
| Auth | [CUSTOMIZE: e.g., Supabase Auth] |
| Hosting | [CUSTOMIZE: e.g., Vercel] |
| Styling | [CUSTOMIZE: e.g., Tailwind + shadcn/ui] |

---

## FORGE Extensions

This project includes scaffolding for required FORGE extensions.

### Discovery Pack (Required for All Projects)

Location: `docs/discovery/`

Every FORGE project begins with discovery. The Discovery Pack provides structured intake-to-spec workflow.

| Stage | Folder | Purpose |
|-------|--------|---------|
| Intake | `docs/discovery/intake/` | Raw inputs (transcripts, notes, screenshots) |
| Structure | `docs/discovery/themes/` | Organized themes |
| Handoff | `docs/discovery/handoff/` | Final spec pack |

**See:** `docs/discovery/README.md`

### Auth/RBAC (Required for Software Projects)

Location: `supabase/migrations/`, `src/lib/auth/`

FORGE uses an org-centric identity model for tenant-level roles and a separate platform-level membership system.

#### Tenant Roles (within organizations)

| Role | Description |
|------|-------------|
| Owner | Ultimate authority over the organization |
| Admin | User management, settings |
| Member | Standard team access |

#### Platform Memberships (supra-tenant)

| Role | Description |
|------|-------------|
| Stakeholder | Stakeholder Portal access, feedback, visibility into product execution |

**Note:** Stakeholder is a platform-level actor, not a tenant role. Stakeholders operate in the platform plane (Stakeholder Portal) and have no implicit access to tenant data. See FORGE method documentation for the Auth/RBAC extension.

**Key files:**
- `supabase/migrations/00001_auth_foundation.sql` — Schema and RLS
- `src/lib/auth/types.ts` — TypeScript types
- `src/lib/auth/client.ts` — Client utilities

### Stakeholder Interface (Required for Software Projects)

Location: `src/app/portal/`, `supabase/functions/stakeholder-ai/`

Supra-tenant visibility and feedback system for stakeholders. The Stakeholder Portal operates in the platform plane and provides visibility into product execution (roadmap, milestones, status) without access to tenant data.

**Portal:** `src/app/portal/`
- Feedback submission and voting
- Project visibility (platform-level, not tenant data)

**Stakeholder AI:** `supabase/functions/stakeholder-ai/`
- Explains project status and roadmap
- Answers questions about the product (from platform context only)
- Captures feedback
- Does NOT access tenant data
- Does NOT execute tasks (execution is FAI, maturity-gated)

**Key files:**
- `supabase/migrations/00002_stakeholder_portal.sql` — Portal schema
- `supabase/functions/stakeholder-ai/index.ts` — AI edge function

---

## FORGE AI Interface (FAI) — Optional

> **Skip this section** if your project does not use FORGE AI Interface.

FAI is an optional FORGE extension that provides a first-class AI interface layer. **FAI is an interface layer, not an autonomous agent.**

### FAI Capabilities

If enabled, FAI provides:
- **Knowledge-Based Q&A** — Answer questions about how the app works
- **Action Execution** — Perform user actions via API with RBAC mirroring
- **Feedback Capture** — Convert conversations to structured parking-lot entries
- **Multimodal Intake** — Accept screenshots for visual context

### FAI Boundaries (Non-Negotiable)

| FAI Does NOT | Why |
|--------------|-----|
| Modify code | Code authority remains with CC/Cursor |
| Create PRs | PRs remain in Quality Gate lane |
| Auto-merge | Human Lead approval required |
| Exceed user permissions | RBAC mirroring enforced |

### FAI Configuration

If adopting FAI:
1. Complete `docs/constitution/FAI.md`
2. Create GitHub App with minimal permissions
3. Configure feedback routing to parking-lot

### FAI Status: [DISABLED / ENABLED]

Set to ENABLED in `docs/constitution/FAI.md` when adopting.

---

*This project follows The FORGE Method(TM) — theforgemethod.org*

---

## @E: Execution Coordination

### Overview

**@E** is the addressable execution role in FORGE. @E may be agents (Claude Code, Cursor) or humans, but always operates under governance routing (Human → @G → @E).

**For complete @E operating guide, see:**
- [method/agents/forge-e-operating-guide.md](../../method/agents/forge-e-operating-guide.md)

### Sacred Four (Required Before Every PR)

```bash
pnpm sacred-four
```

This runs:
1. `pnpm typecheck` — TypeScript strict mode validation
2. `pnpm lint` — ESLint + Prettier
3. `pnpm test:coverage` — Tests with 70% coverage minimum
4. `pnpm build` — Production build verification

**All four must pass.** No exceptions.

### Testing Requirements

- **Default coverage:** 70% (lines, functions, branches, statements)
- **Sacred Four paths:** 100% coverage required for:
  - Authentication flows
  - Payment processing (Stripe)
  - Data integrity operations
  - Security-sensitive paths (RLS, authorization)

**See:** [method/templates/forge-template-testing-requirements.md](../../method/templates/forge-template-testing-requirements.md)

### Technology Stack Defaults

This template uses FORGE SaaS standards:

| Component | Default |
|-----------|---------|
| Framework | Next.js 15+ (App Router) |
| Language | TypeScript 5+ (strict mode) |
| Database | Supabase Postgres |
| Auth | Supabase Auth |
| Testing (Unit) | Vitest |
| Testing (E2E) | Playwright |
| Styling | Tailwind CSS v4 |
| CI/CD | GitHub Actions |

**See:** [method/templates/forge-template-saas-standards.md](../../method/templates/forge-template-saas-standards.md)

### Handoff → Completion Protocol

@E works from **handoff packets** created by @G (Ops Agent). Each handoff packet includes:
- `handoff_id`: Unique identifier
- `scope`: What to build
- `acceptance_criteria`: Success definition
- `constraints`: What NOT to do
- `approval_status: approved`

@E produces **completion packets** with:
- YAML frontmatter (machine-readable metrics for @G validation)
- Markdown narrative (human-readable context)
- Branch + PR link
- Sacred Four results
- Test coverage metrics
- File manifest (created/modified/deleted)

**See:** [method/agents/forge-e-operating-guide.md](../../method/agents/forge-e-operating-guide.md#6-handoff--completion-protocol)

---

