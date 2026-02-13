# FORGE

> **Frame. Orchestrate. Refine. Govern. Execute.**
> A methodology for building production-grade systems using orchestrated AI agents.

---

## Quick Start

You are inside the canonical FORGE repository. Everything is pre-configured.

**To start a new project:** Say "I want to build X" or run `/forge-a`
**To check status:** Say "catch me up" or run `/forge-g`
**To evolve FORGE itself:** Run `/forge-rd start <slug>`

---

## Agent Roster

FORGE uses 8 role-agents across two lifecycles, plus 2 supporting agents.

### Pre-FORGE Agents (A.B.C)

Before committing to build, projects go through intake, optional sensemaking, and commitment:

| Agent | Invoke | Role | Output |
|-------|--------|------|--------|
| **@A** | `/forge-a` | Acquire — Scaffold + Intake | `INTAKE.md` |
| **@B** | `/forge-b` | Brief — Sensemaking + Options (CONDITIONAL) | `BRIEF.md` |
| **@C** | `/forge-c` | Commit — Decision Gate + FORGE Unlock | `FORGE-ENTRY.md` |

**Flow:** @A -> [@B optional] -> @C -> `abc/FORGE-ENTRY.md` -> FORGE UNLOCKED

### FORGE Lifecycle Agents (F.O.R.G.E)

After commitment, the full build lifecycle:

| Agent | Invoke | Role | Output |
|-------|--------|------|--------|
| **@F** | `/forge-f` | Frame — Intent + Scope | `PRODUCT.md` |
| **@O** | `/forge-o` | Orchestrate — Architecture + Planning | `TECH.md`, Architecture Packets |
| **@R** | `/forge-r` | Refine — Review + Coherence | Review Reports, Conflict Logs |
| **@G** | `/forge-g` | Govern — Router + Policy + Gating | Routing, Event Logs |
| **@E** | `/forge-e` | Execute — Tests + Code + PR | Working Software |

### Supporting Agents

| Agent | Purpose |
|-------|---------|
| **forge-rd** | R&D meta-agent for evolving FORGE itself |
| **decision-logger** | Structured decision capture and tracking |

---

## Routing

Three ways to invoke agents:

1. **Natural language** — "I want to build X" routes to @A. "Catch me up" routes to @G.
2. **Explicit @role** — `@G catch me up` forces @G dispatch.
3. **Skill command** — `/forge-g` invokes directly.

### Intent Detection

| User Says | Routes To |
|-----------|-----------|
| "I want to build..." / "New project..." | @A (Acquire) |
| "Help me think through..." / "What are the options..." | @B (Brief) |
| "Lock this down" / "Ready to commit" | @C (Commit) |
| "Define the product..." / "What are we building?" | @F (Frame) |
| "Design the architecture..." / "How should we build?" | @O (Orchestrate) |
| "Review this..." / "Check for conflicts..." | @R (Refine) |
| "Catch me up" / "What's the status?" / "Route this..." | @G (Govern) |
| "Build it" / "Implement..." / "Write the code" | @E (Execute) |

---

## Governance

### Core Principles

| Principle | Meaning |
|-----------|---------|
| **Intent before implementation** | Understand the "why" before coding |
| **Agents stay in lanes** | Each agent has defined scope |
| **Human greenlight required** | Non-trivial changes need explicit approval |
| **One canonical record** | Single source of truth; no duplicates |
| **Hard stops are non-negotiable** | If verification fails, stop |

### A.B.C -> F.O.R.G.E Gate

`abc/FORGE-ENTRY.md` is the gate artifact:
- **Before it exists:** Only @A, @B, @C are available. @F/@O/@R/@G/@E are blocked.
- **After it exists:** @F, @O, @R, @G, @E unlock. @A/@B/@C warn but don't block.

### Lane Rules

- **All transitions route through @G** — No direct role-to-role handoff
- **@B is conditional** — Human decides whether to invoke
- **Each agent produces artifacts and STOPS** — No autonomous continuation
- **Human-in-the-loop at all tiers**

### Sacred Four (Code Verification)

For any executable project, all four must pass before merging:

```bash
npm run typecheck && npm run lint && npm run test && npm run build
```

### Requires Human Approval

- Edits to `method/core/` files (canon)
- Version bumps and releases
- New agent definitions or role changes
- Deletion of any file
- Changes to this CLAUDE.md

### Does NOT Require Approval

- Typo fixes and formatting corrections
- Adding recon reports to designated folders
- Parking lot additions (known-issues.md, future-work.md)

---

## Project Structure

FORGE projects live OUTSIDE the FORGE repo (hard separation: methodology vs work). When you spawn a project via @A, it creates a new directory:

```
~/forge-projects/<slug>/          Default spawn location (configurable)
├── .claude/                      Vendored FORGE agent pack
│   ├── agents/                   9 agents (forge-a through forge-r, decision-logger)
│   ├── skills/                   8 skills (forge-a through forge-r)
│   ├── VERSION                   Agent pack version tracking
│   ├── README.md                 Roster + upgrade docs
│   └── settings.json             Baseline permissions
├── abc/                          Pre-FORGE: Acquire, Brief, Commit
│   ├── INTAKE.md                 @A output
│   ├── BRIEF.md                  @B output (optional)
│   └── FORGE-ENTRY.md            @C output (gate artifact)
├── docs/
│   └── constitution/
│       ├── PRODUCT.md            Product intent
│       ├── TECH.md               Technical architecture
│       └── GOVERNANCE.md         Project governance
├── _forge/inbox/active/          Active work packets
├── _forge/inbox/done/            Completed work packets (ledger)
├── src/                          Source code
└── tests/                        Tests
```

**Important:** Projects must NOT live inside the FORGE repo. This ensures:
- FORGE repo remains clean (method + tooling only)
- Projects have independent git history
- Teams can clone projects without the FORGE repo

Use `template/project/` as the scaffold. `@A` handles spawn + instantiation.

---

## Repo Map

| Directory | Purpose | Status |
|-----------|---------|--------|
| `.claude/` | Agent + Skill definitions (FORGE-repo + vendored source) | Operational |
| `method/` | Canonical FORGE methodology | Canon |
| `method/core/` | Core docs — highest authority | Canon (protected) |
| `method/agents/` | Agent operating guides | Canon |
| `method/templates/` | Reusable templates | Operational |
| `template/project/` | Scaffold for new projects (includes vendored .claude/) | Operational |
| `_workspace/` | R&D workspace for evolving FORGE | Non-canon |
| `bin/` | forge-export, forge-install, forge-sync | Tooling |

**Note:** `projects/` was removed. Projects live outside FORGE repo (e.g., `~/forge-projects/`).

### Canon Hierarchy

```
1. method/core/          <- Highest authority (canon)
2. method/templates/     <- Authoritative patterns (operational)
3. template/project/     <- Instantiation standard (operational)
```

If sources conflict: **method/core/ beats everything.**

---

## R&D Pipeline (Advanced)

FORGE includes a meta-agent (`forge-rd`) for evolving FORGE itself:

```bash
/forge-rd start <feature-slug>    # Start R&D pipeline
/forge-rd status                  # Check pipeline state
/forge-rd approve                 # Approve at governance checkpoint
```

Submit feature requests as folders in `_workspace/00_inbox/`:

```
_workspace/00_inbox/
└── my-feature/
    ├── README.md        <- Required: Summary + Problem + Materials
    ├── threads/         <- Transcripts, notes, chat exports
    └── assets/          <- Images, sketches, PDFs
```

See `_workspace/README.md` for full pipeline documentation.

---

## Customization

### Local Settings

Create `.claude/settings.local.json` (gitignored) to extend permissions:

```json
{
  "permissions": {
    "allow": [
      "Bash(git commit*)",
      "Bash(git push*)"
    ]
  }
}
```

### Global Install (Optional)

Spawned projects bundle agents in `.claude/`, so global install is optional. Useful for:
- Working outside FORGE projects
- Fallback when a project lacks vendored agents
- Personal preference for global availability

```bash
./bin/forge-install
```

**Agent resolution order:** Project `.claude/` > Global `~/.claude/`

---

## Verification + Quality Gates

### Definition of Done

**Doc changes:** Correct markdown, all links valid, consistent terminology, CHANGELOG updated if significant.

**Code changes:** Sacred Four passes (typecheck, lint, test, build). Template instantiation passes smoke test.

### Stop the Line Rule

**If verification fails, STOP.** Do not push broken code, skip failing tests, or merge without passing Sacred Four.

---

## When in Doubt

1. Read this CLAUDE.md
2. Run recon on affected files
3. Ask: Does this need approval?
4. When uncertain: STOP and ask the Human Lead

---

*This is the canonical FORGE repository. All agents, skills, methodology, and tooling in one place.*
