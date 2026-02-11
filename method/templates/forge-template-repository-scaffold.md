# FORGE Template: Repository Scaffold

**The Canonical Directory Structure for FORGE-Governed Projects**

**Version:** 1.1
**Status:** First-Class Artifact  
**Based On:** Vantage DD project (ground-truth validation by CC)

---

## Purpose

Every FORGE project needs a consistent repository structure that enables fast context recovery and boring execution.

This template defines the **canonical scaffold** — the directory tree, required files, and initialization sequence that Quality Gate (CC) uses to instantiate new projects.

---

## Quick Start: FORGE Starter Kit

For instant FORGE alignment, use the **FORGE Starter Kit** (`starter-kit/`):

```bash
# Copy starter-kit files to your new project
cp method/starter-kit/CLAUDE.md your-project/
cp -r method/starter-kit/.cursor your-project/
```

The starter-kit includes:
- `CLAUDE.md` — Pre-configured project identity template
- `.cursor/rules/` — Role-specific Cursor rules (SD, CP, CC)
- `chatgpt/` — Jordan (Strategist) setup for ChatGPT Projects
- `claude_ai/` — CP and CC setup for Claude.ai Projects

See `starter-kit/README.md` for complete setup instructions.

---

## When to Create

Create this scaffold **after Frame is approved**, during Orchestrate or early Refine. The scaffold establishes the container; constitutional documents fill it.

**Important:** Scaffolding a repository does NOT authorize Execute. See "Project Shell" section below.

---

## What Problem It Prevents

- Agents hunting for files in inconsistent locations
- Context recovery taking minutes instead of seconds
- Duplicate or conflicting state files (multiple handoff docs)
- Reports and prompts mixed together
- Ambiguity about which files are authoritative
- Scaffolding being mistaken for scope commitment

---

## The FORGE Project Shell

A **Project Shell** is a scaffolded repository that contains:
- Directory structure
- Template files
- Placeholder constitutional documents
- Tooling configuration

A Project Shell explicitly does **NOT**:
- Authorize Execute phase
- Commit to scope or features
- Replace the need for constitutional documents

**Required Banner:** Every Project Shell must include this banner in both `README.md` and `docs/build-plan.md`:

```markdown
> ⚠️ **PROJECT SHELL** — Structure only. Awaiting Frame approval and constitutional documents before Execute is authorized.
```

Remove the banner only when:
1. Frame artifact is approved
2. Constitutional documents are in place
3. Human Lead greenlights Execute

**[UNIVERSAL]**

---

## Canonical Directory Tree

```
[project-codename]/
├── .cursor/
│   └── rules/
│       ├── forge-sd.mdc                 # [UNIVERSAL] Implementation Engine rules
│       ├── forge-cp.mdc                 # [UNIVERSAL] Spec Author rules
│       └── forge-cc.mdc                 # [UNIVERSAL] Quality Gate rules
├── .github/
│   ├── PULL_REQUEST_TEMPLATE.md         # [UNIVERSAL] PR format
│   └── workflows/                       # [CONTEXTUAL] CI/CD if needed
│       └── .gitkeep
├── inbox/
│   ├── active/                          # [UNIVERSAL] Current task brief only
│   │   └── .gitkeep
│   ├── completed/                       # [UNIVERSAL] Archived by PR number
│   │   └── .gitkeep
│   └── templates/                       # [UNIVERSAL] Reusable templates
│       ├── task-brief-template.md
│       └── handoff-template.md
├── docs/
│   ├── constitution/                    # [UNIVERSAL] Authoritative specs
│   │   ├── README.md                    # Hierarchy explanation
│   │   ├── north-star.md                # L1: Product intent
│   │   ├── system-architecture.md       # L2: Technical structure
│   │   ├── engineering-playbook.md      # L2: Standards
│   │   ├── data-model.md                # L3: Schema
│   │   ├── api-contract.md              # L3: Endpoints
│   │   └── security-policies.md         # L3: Auth, RLS, permissions
│   ├── parking-lot/                     # [UNIVERSAL] Issues and ideas for later
│   │   ├── README.md                    # Parking lot protocol
│   │   ├── known-issues.md              # Bugs, tech debt, security concerns
│   │   └── future-work.md               # Feature ideas, enhancements
│   ├── adr/                             # [UNIVERSAL] Architecture decisions
│   │   ├── README.md
│   │   ├── adr-template.md
│   │   └── .gitkeep
│   ├── ops/                             # [UNIVERSAL] Operational state
│   │   └── state.md                     # Current phase, PR, blockers
│   └── build-plan.md                    # [UNIVERSAL] Execution state
├── reports/                             # [SITUATIONAL] Status reports, audits
│   └── .gitkeep
├── src/                                 # [CONTEXTUAL] Application source
│   └── .gitkeep
├── tests/                               # [CONTEXTUAL] Test files (if top-level)
│   └── .gitkeep
├── supabase/                            # [CONTEXTUAL] If using Supabase
│   ├── migrations/
│   │   └── .gitkeep
│   └── seed/
│       └── .gitkeep
├── .env.example                         # [UNIVERSAL] Environment template
├── .gitignore                           # [UNIVERSAL] Standard ignores
├── CLAUDE.md                            # [UNIVERSAL] Project identity
├── README.md                            # [UNIVERSAL] Public description
├── package.json                         # [CONTEXTUAL] If JS/TS project
└── tsconfig.json                        # [CONTEXTUAL] If TypeScript
```

**[UNIVERSAL] structure — specific directories are tagged individually**

---

## Classification Legend

| Tag | Meaning | Rule |
|-----|---------|------|
| **[UNIVERSAL]** | Required for any FORGE project | Always create |
| **[CONTEXTUAL]** | Depends on stack or project type | Create if condition met |
| **[SITUATIONAL]** | Optional, team preference | Create if needed |

---

## Required Files

### Universal Files (Always Create)

| File | Purpose | Created By | When |
|------|---------|------------|------|
| `CLAUDE.md` | Project identity, CC operating context | CC | Instantiation |
| `README.md` | Public project description | CC | Instantiation |
| `.env.example` | Environment variable template | CC | Instantiation |
| `.gitignore` | Git ignores for stack | CC | Instantiation |
| `docs/build-plan.md` | Execution state machine | CC | Instantiation |
| `docs/ops/state.md` | Current phase, PR, blockers | CC | Instantiation |
| `docs/constitution/README.md` | Constitution hierarchy | CC | Instantiation |
| `docs/constitution/*.md` | Authoritative specs | CP (placed by CC) | Refine → Govern |
| `docs/adr/README.md` | ADR index and guidance | CC | Instantiation |
| `docs/adr/adr-template.md` | ADR format | CC | Instantiation |
| `docs/parking-lot/README.md` | Parking lot protocol | CC | Instantiation |
| `docs/parking-lot/known-issues.md` | Bugs, tech debt, security concerns | CC | Instantiation |
| `docs/parking-lot/future-work.md` | Feature ideas, enhancements | CC | Instantiation |
| `.cursor/rules/forge-*.mdc` | Role-specific Cursor rules | CC | Instantiation (from starter-kit) |
| `.github/PULL_REQUEST_TEMPLATE.md` | PR format | CC | Instantiation |
| `inbox/templates/*.md` | Task brief/handoff templates | CC | Instantiation |

### Contextual Files (Create If Condition Met)

| File/Directory | Condition | Notes |
|----------------|-----------|-------|
| `supabase/` | Kickoff Brief specifies Supabase | Include migrations/ and seed/ |
| `tests/` | Stack uses top-level tests convention | Otherwise tests live with source |
| `src/` structure | Depends on framework | Next.js App Router, etc. |
| `package.json` | JS/TS project | Created by framework scaffolder |
| `tsconfig.json` | TypeScript project | Created by framework scaffolder |
| `.github/workflows/` | CI/CD configured | Add workflow files as needed |

### Situational Files (Create If Needed)

| File/Directory | When Useful |
|----------------|-------------|
| `reports/` | Generating periodic reports or audits |
| `scripts/` | Utility scripts needed |
| `sql/` | Standalone SQL files outside migrations |
| `CHANGELOG.md` | Tracking version history |
| `docs/ops/agents.md` | Multi-agent coordination is non-trivial |

---

## Banned Patterns

These patterns caused friction in Vantage and are explicitly disallowed:

| Pattern | Problem | Instead |
|---------|---------|---------|
| `HANDOFF.md` in root | Conflicts with build-plan, causes ambiguity | Use `docs/ops/state.md` |
| `AGENTS.md` in root | Duplicates ops state | Use `docs/ops/agents.md` if needed |
| Reports in `inbox/` | Mixes instructions with outputs | Use `reports/` at root |
| `docs/decisions/` | Non-standard naming | Use `docs/adr/` |
| Multiple handoff files | "Which is current?" confusion | Single `docs/ops/state.md` |

**[UNIVERSAL]**

---

## Cursor Rules Structure

FORGE projects use role-specific Cursor rule files. Copy from `starter-kit/.cursor/rules/`:

```
.cursor/rules/
├── forge-sd.mdc         # [UNIVERSAL] Implementation Engine rules
├── forge-cp.mdc         # [UNIVERSAL] Spec Author rules (if using Cursor for specs)
├── forge-cc.mdc         # [UNIVERSAL] Quality Gate rules
├── 10-project.mdc       # [CONTEXTUAL] Project conventions, stack, code style
├── 20-security.mdc      # [CONTEXTUAL] Auth, RLS, permissions (if applicable)
├── 30-ui.mdc            # [CONTEXTUAL] UI constraints (if applicable)
└── ...                  # Additional numbered rules as needed
```

**Role Files (from starter-kit):**
- `forge-sd.mdc` — Implementation Engine operating rules
- `forge-cp.mdc` — Spec Author operating rules
- `forge-cc.mdc` — Quality Gate operating rules

**Numbered Files (project-specific):**
- `10-` — Project-specific conventions
- `20-` — Security and auth rules
- `30-` — UI and styling rules
- `40+` — Additional domains as needed

**[UNIVERSAL] pattern — specific rule files are [CONTEXTUAL]**

---

## Initialization Sequence

### Phase 1: Framework Scaffold (if applicable)

```bash
# Example for Next.js
pnpm create next-app@latest [codename] --typescript --tailwind --eslint --app --src-dir
cd [codename]
```

Skip if not using a framework scaffolder.

### Phase 2: FORGE Directory Overlay

```bash
# Create FORGE directories
mkdir -p .cursor/rules
mkdir -p .github/workflows
mkdir -p inbox/{active,completed,templates}
mkdir -p docs/{constitution,parking-lot,adr,ops}
mkdir -p reports

# Create .gitkeep files
touch .github/workflows/.gitkeep
touch inbox/active/.gitkeep
touch inbox/completed/.gitkeep
touch docs/adr/.gitkeep
touch reports/.gitkeep

# Conditional: Supabase (only if specified in Kickoff Brief)
# mkdir -p supabase/{migrations,seed}
# touch supabase/migrations/.gitkeep
# touch supabase/seed/.gitkeep

# Conditional: Top-level tests (only if stack convention)
# mkdir -p tests
# touch tests/.gitkeep
```

### Phase 3: Populate Template Files

| File | Source |
|------|--------|
| `CLAUDE.md` | Project Identity template + Kickoff Brief values |
| `README.md` | Standard template + project description |
| `.env.example` | Stack-appropriate template |
| `.gitignore` | Stack-appropriate template |
| `docs/build-plan.md` | Build Plan template (with Project Shell banner) |
| `docs/ops/state.md` | Ops State template |
| `docs/constitution/README.md` | Constitution README template |
| `docs/constitution/*.md` | Placeholder files (replaced during Refine) |
| `docs/adr/README.md` | ADR index template |
| `docs/adr/adr-template.md` | ADR format template |
| `docs/parking-lot/README.md` | Parking lot protocol template |
| `docs/parking-lot/known-issues.md` | Known issues template |
| `docs/parking-lot/future-work.md` | Future work template |
| `.cursor/rules/forge-*.mdc` | Role-specific rules from `starter-kit/.cursor/rules/` |
| `.github/PULL_REQUEST_TEMPLATE.md` | PR template |
| `inbox/templates/task-brief-template.md` | Task Brief template |
| `inbox/templates/handoff-template.md` | Handoff template |

### Phase 4: Place Constitutional Documents

1. Receive constitutional docs from Human Lead (CP-authored)
2. Place in `docs/constitution/`, replacing placeholders
3. Verify internal consistency
4. Remove placeholder files

### Phase 5: Commit & Report

```bash
git add .
git commit -m "chore: initialize FORGE project structure"
```

Report to Human Lead:
- Scaffold complete
- Constitutional document placeholders ready (or docs placed)
- Project Shell status (awaiting Frame/Constitution or ready for Execute)

**[UNIVERSAL]**

---

## Ops State File

The `docs/ops/state.md` file replaces scattered handoff files with a single source of operational truth:

```markdown
# Operational State

**Last Updated:** [YYYY-MM-DD HH:MM]
**Updated By:** [Agent]

## Current Phase

[Frame | Orchestrate | Refine | Govern | Execute]

## Execution State (if in Execute)

| Field | Value |
|-------|-------|
| Current PR | PR-[XX] |
| Branch | `feat/pr-[xx]-[name]` |
| Active Brief | `inbox/active/[brief].md` |
| Last Verified Commit | `[short-sha]` |

## Blockers

[None | List blockers with owners]

## Session Notes

[Brief notes for next session pickup]
```

**[UNIVERSAL]**

---

## Tests Location Guidance

**Principle [UNIVERSAL]:** Tests must exist and pass before merge.

**Location [CONTEXTUAL]:** Where tests live depends on stack convention:

| Stack | Convention | Location |
|-------|------------|----------|
| Next.js + Vitest | Colocated or top-level | `src/**/*.test.ts` or `tests/` |
| React + Jest | Top-level | `tests/` or `__tests__/` |
| Python + pytest | Top-level | `tests/` |
| Go | Colocated | `*_test.go` alongside source |

If the Kickoff Brief doesn't specify, default to `tests/` at root.

---

## Required Structure Verification

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

---

## Common Failure Modes

| Failure | Symptom | Prevention |
|---------|---------|------------|
| Missing Project Shell banner | Scaffolding mistaken for scope commitment | Always add banner until Execute authorized |
| Multiple state files | "Which handoff doc is current?" | Single `docs/ops/state.md`, ban root HANDOFF.md |
| Reports in inbox | Mixing instructions with outputs | Enforce separation: prompts vs reports |
| Missing .gitkeep files | Empty directories not committed | Add .gitkeep to all empty directories |
| Constitution placeholders not replaced | Execute starts with stub specs | Verify real docs placed before removing Shell banner |
| Wrong tests location | Tests not discovered by runner | Match stack convention, verify in CI |

---

## Scaffold Checklist

Use this checklist when instantiating a new FORGE project:

### Structure
- [ ] All [UNIVERSAL] directories created
- [ ] [CONTEXTUAL] directories created per Kickoff Brief
- [ ] .gitkeep files in empty directories
- [ ] No banned patterns (root HANDOFF.md, etc.)

### Files
- [ ] CLAUDE.md populated from Project Identity template
- [ ] README.md includes Project Shell banner
- [ ] docs/build-plan.md includes Project Shell banner
- [ ] docs/ops/state.md created
- [ ] docs/constitution/README.md created
- [ ] docs/adr/README.md and template created
- [ ] docs/parking-lot/ files created (README.md, known-issues.md, future-work.md)
- [ ] .cursor/rules/forge-*.mdc files copied from starter-kit
- [ ] .github/PULL_REQUEST_TEMPLATE.md created
- [ ] inbox/templates/ populated

### Verification
- [ ] `git status` shows expected files
- [ ] No secrets in committed files
- [ ] .env.example has placeholders, not values
- [ ] Project Shell banner present (if Execute not yet authorized)

---

## What This Template Is NOT

This template defines the scaffold for **FORGE-governed projects** (applications, systems, products).

It does NOT define:
- The FORGE methodology repository structure (`forge/core/`, `forge/operations/`, etc.)
- Documentation-only repositories
- Non-software projects

For the FORGE canon repository structure, see FORGE Governance.

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-06 | Initial template based on Vantage ground-truth (CC) + refinements (Jordan) |
| 1.1 | 2026-01-07 | Added starter-kit reference; updated Cursor rules to role-specific files |

---

**[UNIVERSAL]**

**© 2026 FORGE Contributors. All rights reserved.**

**FORGE™** is a trademark of its contributors.
