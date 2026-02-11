<!-- Audience: Public -->

# FORGE Changelog

All notable changes to the FORGE methodology canon.

Format: `[YYYY-MM-DD] Title` with summary, files touched, and impact scope.

---

## [2026-02-10] Enforcement Hardening (v1.3.0)

**Summary:** Transitioned FORGE from declarative canon to enforced governance. Added Law 5a (Preconditions Are Hard Stops), automatic @G structural verification after @C, Sacred Four zero-test enforcement, explicit external project waiver semantics, auth architecture ADR gates, stakeholder model requirements, and a 14-rule enforcement matrix. Backward-compatible via grandfathering policy for existing projects.

**Decision:** forge-system-hardening (via forge-rd pipeline, canon mode)

**Tag:** `v1.3.0`

**Files touched:**
- `core/forge-core.md` (modified v1.2 → v1.3) — Law 5a, Explicit Architecture Decisions rule
- `core/forge-operations.md` (modified v1.1 → v1.3) — @G structural verification, zero-test enforcement, enforcement matrix, grandfathering policy
- `agents/forge-e-operating-guide.md` (modified) — Pre-flight verification, PR packet exemptions
- `agents/forge-g-operating-guide.md` (modified) — Structural verification after @C, transition-specific validation
- `agents/forge-o-operating-guide.md` (modified) — Auth architecture + test architecture completion gates
- `agents/forge-product-strategist-guide.md` (modified) — Actor classification + stakeholder decision gates
- `templates/forge-template-testing-requirements.md` (modified) — Zero-test clarification, PR-000 exception
- `templates/forge-template-repository-scaffold.md` (modified) — Required structure verification
- `.claude/skills/forge-{a,b,c,e,f,g,o,r}/SKILL.md` (8 files modified) — Universal startup check, waiver semantics
- `template/project/docs/` (4 new templates) — STAKEHOLDER-MODEL, auth-architecture ADR, test-infrastructure, preflight-checklist

**Impact:** Public canon — enforcement upgrade. All new projects subject to hardened gates. Existing projects grandfathered (except zero-test, which is retroactive).

### Added
- **Law 5a: Preconditions Are Hard Stops** — agents must verify inputs before producing outputs
- **@G Structural Verification** — automatic 13-item scaffold check after @C, before @F
- **Enforcement Matrix** — 14 rules with agent, trigger, failure mode, and bypass documented
- **Grandfathering Policy** — existing projects exempt from new gates (effective 2026-02-10)
- **Universal Startup Check** — all 8 agents verify project location + FORGE-AUTONOMY.yml
- **PR-000 Exception** — `is_test_setup: true` flag for test infrastructure bootstrap
- 4 project scaffold templates (STAKEHOLDER-MODEL, auth ADR, test-infrastructure, preflight-checklist)

### Changed
- Sacred Four zero-test: zero tests is now a FAILURE, not a pass (retroactive, no grace period)
- External project waiver: `external_project: true` waives location only, not governance
- PR packet: exemptions for PR-000 and docs-only PRs
- @F completion gate: requires explicit auth plane assignments
- @O completion gate: requires auth ADR (multi-user/role) + test architecture
- @E pre-flight: 4 sequential checks before accepting any handoff

---

## [2026-02-07] Agent Packaging & Distribution (v1.3.1)

**Summary:** Made FORGE self-contained and distributable by shipping 10 agents and 9 skills inside the repository at `.claude/agents/` and `.claude/skills/`. Cloners now receive all FORGE agents with zero setup (Mode A). Added export pipeline (`bin/forge-export`) for one-way sync with scrubbing, optional install script (`bin/forge-install`) with per-file confirmation, and @O/@R operating guides.

**Decision:** forge-agent-packaging (via forge-rd pipeline)

**Files touched:**
- `.claude/agents/forge-a.md` through `forge-e.md` (created) — 8 canon role-agent definitions
- `.claude/agents/forge-rd.md` (created) — R&D meta-agent definition
- `.claude/agents/decision-logger.md` (created) — Decision recording agent
- `.claude/skills/forge-a/` through `forge-e/` (created) — 8 role skill directories
- `.claude/skills/forge-rd-pipeline/` (created) — R&D pipeline skill with templates and resources
- `.claude/settings.json` (created) — Shared permission defaults
- `bin/forge-export` (created) — One-way sync with automated scrubbing
- `bin/forge-install` (created) — Optional global install with confirmation UX
- `agents/forge-o-operating-guide.md` (created) — @O Orchestrate operating guide
- `agents/forge-r-operating-guide.md` (created) — @R Refine operating guide
- `README.md` (created) — Umbrella README with Mode A/B setup instructions
- `CHANGELOG.md` (updated)

**Impact:** Public canon — makes FORGE fully distributable. Enables community contribution via forge-rd.

### Added
- 10 agent definitions in `.claude/agents/` (8 role-agents + forge-rd + decision-logger)
- 9 skill directories in `.claude/skills/` (8 role skills + forge-rd-pipeline)
- `bin/forge-export` — automated export with comprehensive private data scrubbing
- `bin/forge-install` — optional install with per-file overwrite confirmation
- `.claude/settings.json` — conservative shared defaults (FORGE skills + git read only)
- @O operating guide (promoted from project-orchestrator agent)
- @R operating guide (promoted from spec-writer + recon-runner agents)
- Umbrella README.md with Mode A/B setup documentation
- forge-rd as shippable meta-agent ("FORGE applied to FORGE itself")

### Changed
- forge-o.md cross-reference updated to new operating guide
- forge-r.md cross-reference updated to new operating guide
- forge-rd-pipeline state reset to IDLE for clean distribution

### Not Shipped (By Design)
- forge-architect (deprecated per Decision-005, clean break)
- jordan (internal strategist, not for public distribution)
- mac-tuneup (personal utility)

---

## [2026-02-06] Role Addressing & Autonomy Tiers (v1.3.0)

**Summary:** Introduced 8 real role-agents (@A/@B/@C pre-FORGE + @F/@O/@R/@G/@E FORGE lifecycle) with explicit @role addressing, @G as canonical router, configurable autonomy tiers (0-1), FORGE-AUTONOMY.yml schema v0.1, and pre-FORGE lifecycle (A.B.C) with FORGE-ENTRY.md gate artifact. This AMENDS Decision-003 to add structured @G routing within Tier 0-1 constraints.

**Decision:** [Decision-005](_workspace/05_decisions/decision-005-role-addressing-tier01-2026-02-06.md)

**Files touched:**
- `agents/forge-a-operating-guide.md` (created) — @A Acquire agent guide
- `agents/forge-b-operating-guide.md` (created) — @B Brief agent guide
- `agents/forge-c-operating-guide.md` (created) — @C Commit agent guide
- `agents/forge-g-operating-guide.md` (created) — @G Govern/Router agent guide
- `templates/forge-template-autonomy-policy.md` (created) — FORGE-AUTONOMY.yml schema doc
- `templates/forge-template-router-events.md` (created) — Router event log format
- `core/forge-core.md` (modified) — Law 3 Tier 0-1 compatibility, Govern section @G update
- `core/forge-governance.md` (modified) — Autonomy model governance section
- `core/forge-operations.md` (modified) — Router operations appendix
- `agents/forge-product-strategist-guide.md` (modified) — Added @F addressing note
- `agents/forge-e-operating-guide.md` (modified) — Added tier-aware behavior note
- `agents/forge-ops-agent-guide.md` (modified) — Deprecated in favor of @G
- `agents/forge-agent-roles-handoffs.md` (modified) — Full A/B/C + F/O/R/G/E table
- `CHANGELOG.md` (updated)

**Impact:** Public canon — adds role addressing system, pre-FORGE lifecycle, and autonomy model foundation.

### Added
- 8 real role-agents: @A/@B/@C (pre-FORGE) + @F/@O/@R/@G/@E (FORGE lifecycle)
- Explicit @role addressing syntax for precision invocation
- @G as canonical router for all cross-lane transitions
- FORGE-AUTONOMY.yml schema v0.1 (default tier 0, autonomy engine stubbed)
- Router event logging to `docs/router-events/` (append-only audit trail)
- `abc/` directory structure for pre-FORGE lifecycle (A.B.C)
- `abc/FORGE-ENTRY.md` as gate artifact unlocking F/O/R/G/E agents
- CLAUDE.md concierge startup UX (progressive disclosure, no jargon)
- Operating guides for @A/@B/@C/@G agents
- Skills-based implementation (`/forge-a` through `/forge-e`)
- Tier 0 routing: roles request @G, @G refuses, instructs human
- Tier 1 schema (human approval before dispatch, Phase 2 activation)

### Changed
- Decision-003 AMENDED to add structured @G routing within Tier 0-1 constraints
- Law 3 clarified: Tier 0-1 compatible with "human greenlight required"
- Product Strategist guide updated (now also addressed as @F)
- @E guide updated with tier-aware behavior
- Agent Roles & Handoffs updated with full 8-agent model

### Deprecated
- forge-architect agent (absorbed into @A, sunset planned for v1.4, removal in v2.0)
- forge-ops-agent-guide.md (superseded by forge-g-operating-guide.md)

---

## [2026-02-06] E Lane Formalization (v1.2.0)

**Summary:** Formalized the E (Execution) lane as an enterprise-grade capability for building production SaaS applications. @E is now an addressable role-agent with comprehensive operating guide, SaaS development standards, testing infrastructure, CI/CD workflows, and human handoff protocols.

**Files touched:**
- `agents/forge-e-operating-guide.md` (created) — Complete @E behavioral model (~5000 lines)
- `templates/forge-template-saas-standards.md` (created) — SaaS tech stack defaults (~3000 lines)
- `templates/forge-template-testing-requirements.md` (created) — Testing infrastructure spec (~3500 lines)
- `templates/forge-template-cicd-workflows.md` (created) — CI/CD pipeline templates (~2500 lines)
- `templates/forge-template-handoff-protocols.md` (created) — Human handoff protocols (~2000 lines)
- `agents/forge-agent-roles-handoffs.md` (modified) — Added @E addressability section
- `CHANGELOG.md` (updated)

**Impact:** Public canon — defines canonical Execute (E) phase implementation. Elevates @E from under-specified "implementation agents/humans" to enterprise-grade execution role.

**Details:**

### Added
- @E operating guide with behavioral model, authority matrix, sub-agent roster
- SaaS development standards (Next.js 15+, Supabase, TypeScript strict)
- Testing requirements (70% default, 100% Sacred Four paths)
- CI/CD pipeline templates (GitHub Actions + Vercel + Supabase)
- Human team handoff protocols (README, ARCHITECTURE, ONBOARDING, ADRs)
- Handoff → completion protocol with YAML frontmatter validation
- Capability detection protocol
- Escalation triggers and decision tree

### Key Concepts
- **@E Canonical Statement:** "May be internally autonomous but externally submissive to FORGE routing"
- **Sacred Four:** typecheck, lint, test, build (enforced on all PRs)
- **Coverage thresholds:** 70% default, 100% for auth/billing/data integrity/security
- **Handoff packets:** YAML frontmatter with scope, constraints, acceptance criteria
- **Completion packets:** JSON frontmatter + markdown narrative for @G validation
- **Sub-agent roster:** E-test-writer, E-ui-builder, E-api-builder, E-migrations, E-ci-cd, E-docs
- **Stack defaults:** Next.js + Supabase + TypeScript strict + Vitest + Playwright
- **TDD workflow:** Tests-first preferred, tests-alongside minimum, tests-later forbidden

### Changed
- **@E clarification:** E is addressable role-agent (not just "Cursor" or generic implementation)
- Updated `forge-agent-roles-handoffs.md` with @E as addressable role
- Updated roles table to show @E (E agents/humans) consistently

---

## [2026-02-03] Ops Agent — Govern Phase Owner (v1.2.0)

**Summary:** Introduced the Ops Agent as the canonical owner of the Govern (G) phase. Established role-based (F/O/R/G/E) model as canon. Clarified that CC is infrastructure, not a FORGE role.

**Files touched:**
- `agents/forge-ops-agent-guide.md` (created) — Complete operating guide for Ops Agent
- `docs/evolution/cc-to-roles-evolution.md` (created) — Role vs tool clarification
- `core/forge-core.md` (modified) — Added Ops Agent as G-phase owner
- `agents/forge-agent-roles-handoffs.md` (modified) — Updated roles table and topology
- `CHANGELOG.md` (updated)

**Impact:** Public canon — defines canonical Govern (G) phase implementation. Establishes role-based model.

**Details:**

### Added
- Ops Agent operating guide (`agents/forge-ops-agent-guide.md`)
- Role evolution document (`docs/evolution/cc-to-roles-evolution.md`)
- `inbox/30_ops/` directory structure for G-phase artifacts
- Build Plan as canonical execution state artifact
- Human-in-the-loop checkpoint model (4 required gates)
- MAY DO / MAY NOT DO permission matrix
- STOP conditions for mandatory agent halts
- G → E coordination patterns

### Changed
- **G-phase owner:** Ops Agent (explicit role, not implicit coordination)
- **Role hierarchy:** F/O/R/G/E established as canonical (role-based, not tool-based)
- **CC clarification:** CC is infrastructure/runtime, not a FORGE role
- **E clarification:** E represents execution agents/humans (what Cursor historically represented)
- Updated `forge-agent-roles-handoffs.md` with Ops Agent in roles table
- Updated `forge-core.md` with Ops Agent as G-phase owner
- Updated communication topology diagram

### Key Concepts
- **Ops Agent (G):** State ownership, coordination, validation, gating
- **Build Plan:** Canonical execution strategy derived from Architecture Packet
- **Execution State:** Living status narrative (done/blocked/next)
- **Human-in-the-loop:** 4 checkpoints (Build Plan, Phase Completion, PR Merge, Deployment)
- **G → E coordination:** G defines what, E implements how

### Mental Model Correction
- **FORGE is role-based** (F/O/R/G/E), not tool-based
- **CC (Claude Code)** is infrastructure used BY agents, not a FORGE role
- **Cursor** was the historical E analog; E now represents any execution capability
- **G coordinates E**, not "CC coordinates Cursor"

### Quality Standard
Ops Agent enforces:
- Sacred Four verification (typecheck, lint, test, build)
- Architecture Packet compliance
- Human approval at all checkpoints
- No silent continuation past STOP conditions

---

## [2026-02-03] Product Strategist Agent Role (v1.2.0)

**Summary:** Introduced the Product Strategist as the canonical agent role for the Frame (F) phase. This role formalizes inbox-driven product framing with professional PM-level Product Intent Packets.

**Files touched:**
- `agents/forge-product-strategist-guide.md` (created) — Complete operating guide for Product Strategist role
- `agents/forge-agent-roles-handoffs.md` (modified) — Updated Frame phase owner to Product Strategist
- `CHANGELOG.md` (updated)

**Impact:** Public canon — defines canonical Frame (F) phase implementation for all FORGE projects.

**Details:**

### Added
- Product Strategist operating guide (`agents/forge-product-strategist-guide.md`)
- Inbox-driven workflow documentation
- Product Intent Packet specification (8 required + 3 optional artifacts)
- Active Interviewing Protocol (max 3 Q&A rounds)
- Coherence Checklist for stop condition validation
- Domain extension patterns (software, books, real estate, coaching)

### Changed
- Frame phase owner: Product Strategist (role-based, lane-pure)
- Frame deliverable: Product Intent Packet (replaces Frame Artifact)
- Handoff protocol: Human Lead always routes (no agent-to-agent)

### Key Concepts
- **Product Intent Packet:** Structured Frame-phase output with 8 required artifacts
- **Inbox-driven workflow:** Input at `inbox/00_drop/`, output at `inbox/10_product-intent/`
- **Active Interviewing:** Bounded iteration (max 3 rounds) for discovery
- **Coherence Checklist:** Binary stop condition for packet completeness
- **Lane discipline:** Frame only — no architecture, no implementation

### Quality Standard
Product Intent Packets must meet professional PM-level quality:
- Usable by external development teams
- Clear enough for stakeholder review
- Complete enough for technical planning

---

## [2026-01-24] Platform-Level Stakeholder Model (v1.1.0)

**Summary:** Clarified the platform vs tenant plane distinction for stakeholders in the FORGE identity model. Stakeholder is now explicitly defined as a platform-level actor, not a tenant role.

**Files touched:**
- `docs/extensions/auth-rbac.md` (modified) — Added platform vs tenant planes; moved stakeholder to platform level
- `docs/extensions/stakeholder-interface.md` (modified) — Added supra-tenant context; clarified platform plane operation
- `CHANGELOG.md` (updated)

**Impact:** Public canon — clarifies identity model for all FORGE software projects.

**Details:**

### Added
- Platform vs tenant plane distinction in auth-rbac.md
- Platform memberships concept (separate from tenant memberships)
- Dual-Plane Human Identity Pattern documentation
- Supra-tenant context clarification in stakeholder-interface.md
- Session invariant: one plane per session, no cross-visibility

### Changed
- Stakeholder clarified as platform-level actor, not tenant role
- Four tenant roles reduced to three (Owner, Admin, Member)
- Stakeholder Interface scoping clarified as platform-level
- Shared Visibility section updated for platform-wide scope

### Key Concepts
- **Platform Plane:** System-wide context for stakeholders (Stakeholder Portal, AI)
- **Tenant Plane:** Per-organization context for business operations
- **Session Invariant:** Switching planes requires logout/login
- **Dual-Plane Human Identity Pattern:** Separate emails for platform vs tenant identities

---

## [2026-01-23] Add Core Extensions: Auth/RBAC, Stakeholder Interface, Discovery Pack

**Summary:** Introduced three foundational FORGE extensions that establish identity, stakeholder visibility, and structured discovery as standard capabilities. These extensions transform FORGE from a development methodology into a complete project operating system.

**Files touched:**
- `docs/extensions/auth-rbac.md` (created) — Identity and permission foundation
- `docs/extensions/stakeholder-interface.md` (created) — First-party visibility and AI assistance
- `docs/extensions/discovery-pack.md` (created) — Structured discovery-to-spec methodology
- `docs/extensions/README.md` (modified) — Added extension index with categories
- `core/forge-core.md` (modified) — Added Extensions section (v1.1 → v1.2)
- `CHANGELOG.md` (updated)

**Impact:** Public canon — new required extensions for software projects; Discovery Pack required for ALL projects.

**Details:**

### Auth/RBAC
- Org-centric identity model (users belong to orgs via memberships)
- Four standard roles: Owner, Admin, Member, Stakeholder
- Stakeholder is first-class role, not a flag
- Multi-role users supported (roles are additive)
- Two-phase auth: identity then context
- Required for all software projects

### Stakeholder Interface
- First-party visibility and feedback system
- Stakeholder Interface AI (Foundational) ships Day One
- AI explains, answers, captures feedback — does NOT execute
- Upvote-only voting; humans triage and prioritize
- All stakeholders see all submissions (within org)
- Required for all software projects

### Discovery Pack
- Structured discovery-to-spec methodology
- Applies to ALL project types (software, book, coaching, research)
- "Every project has discovery; not every project has software"
- Four stages: Intake → Structure → Iterate → Handoff
- Agent-assisted, human-gated
- Explicit handoff moment with spec pack

### Key Distinctions
- Stakeholder Interface AI (Foundational) = Day One, required, explanatory + intake
- FAI-for-execution = Optional, maturity-gated, deferred
- Same AI identity, different capability surfaces

---

## [2026-01-16] Add FORGE AI Interface (FAI) extension

**Summary:** Introduced FAI as the first optional FORGE extension, providing a first-class AI interface layer for projects that need user-facing Q&A, action execution, feedback capture, and multimodal intake.

**Files touched:**
- `docs/extensions/README.md` (created) — Extensions index
- `docs/extensions/fai-overview.md` (created) — FAI capability definition
- `core/forge-governance.md` (modified) — Added Extensions section
- `docs/agents/README.md` (modified) — Added FAI reference
- `CHANGELOG.md` (updated)

**Impact:** Public canon — new optional extension capability.

**Details:**
- FAI is explicitly OPTIONAL — no project requires it for FORGE compliance
- FAI is an interface layer, not an autonomous agent
- Four capability tiers: Read-Only Q&A, Action Execution, Feedback Capture, Multimodal Intake
- Hard boundaries: no code modification, no PR creation, no auto-merge
- GitHub Apps required (no PATs); RBAC mirroring with confirm-before-act
- Integration points: docs/constitution/FAI.md, parking-lot, task briefs
- Research basis: method/docs/research/ai-interface/

---

## [2026-01-15] Standardize project-architect template with retrofit support

**Summary:** Created canonical project-architect template with standardized output contracts, lane separation rules, and retrofit capability for existing repos.

**Files touched:**
- `templates/agents/project-architect.template.md` (created) — New canonical template location
- `templates/forge-template-project-architect.md` (modified) — Marked DEPRECATED, points to new location
- `~/.claude/agents/forge-architect.md` (modified) — Added RETROFIT MODE section
- `~/.claude/agents/forge-maintainer.md` (modified) — Added scoped agent installation capability
- `CHANGELOG.md` (updated)

**Impact:** Public canon — standardized per-project governance agent across all FORGE projects.

**Details:**
- New template at `templates/agents/` establishes single source of truth
- Output contract: plans/FEATURE-*.md, PR breakdowns, recon reports, decision records
- Lane separation: project-architect writes plans/docs only, never code
- Operating sequence: Recon → Clarify → Build Plan → PR Breakdown → Stop
- forge-architect gains RETROFIT MODE for installing into existing repos
- forge-maintainer scoped to `.claude/agents/*` and `docs/parking-lot/*` only during installs

---

## [2026-01-15] Add forge-maintainer global agent

**Summary:** Introduced forge-maintainer agent for maintaining/upgrading existing FORGE repos with controlled cross-repo rollouts.

**Files touched:**
- `~/.claude/agents/forge-maintainer.md` (created)
- `~/.claude/agents/forge-architect.md` (updated — added scope clarification)
- `docs/agents/README.md` (created)
- `docs/forge-architect-explainer.md` (created earlier)
- `CHANGELOG.md` (created)

**Impact:** Public canon — new agent architecture for FORGE operations.

**Details:**
- forge-maintainer handles maintenance/upgrades with mandatory PROCEED gate
- forge-architect remains focused on spawning new projects only
- Added docs/agents/README.md as quickstart reference for all global agents
- Established changelog protocol for future FORGE method updates

---
