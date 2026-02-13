# FORGE Project — v2.0

> **Constitution = truth. Inbox = execution. Done = history.**

---

## How This Project Works

All work flows through `_forge/inbox/`:

1. **Create packet** — Make a folder in `_forge/inbox/active/` with `packet.yml` + `README.md`
2. **@G plans** — @G writes `plan.md` and `handoff.md`
3. **Human approves** — Human Lead sets `approved: true` in `packet.yml`
4. **@E executes** — Tests-first. Sacred Four must pass.
5. **@E completes** — @E writes `acceptance.md` with Sacred Four results
6. **PR merges** — Human Lead merges PR after review
7. **Move to done/** — Folder moves from `active/` to `done/`

**1 PR = 1 packet. One branch. One folder. That's it.**

---

## Rules

- No execution without a packet in `_forge/inbox/active/`
- No execution without `approved: true` in `packet.yml`
- No PR without Sacred Four passing
- No constitution edits during execution (escalate to Human Lead)
- One PR per packet. One packet per PR.

---

## Routing

| You Say | Route To |
|---------|----------|
| "What's the status?" / "Catch me up" | @G |
| "Plan this" / "What's the approach?" | @G |
| "Build it" / "Implement this" | @E (only if approved packet exists) |
| "Review this" | @R |
| "Change the product scope" | Human Lead (constitution change) |
| "I want to build X" | @A (Pre-FORGE intake) |
| "I'm stuck" | Ask clarifying questions, identify phase, suggest action |

**Precision addressing:** `@G catch me up`, `@E build it`, `/forge-g`, `/forge-e`

---

## Key Locations

| What | Where |
|------|-------|
| **Constitution (truth)** | `docs/constitution/` |
| Product intent | `docs/constitution/PRODUCT.md` |
| Technical architecture | `docs/constitution/TECH.md` |
| Governance rules | `docs/constitution/GOVERNANCE.md` |
| Architecture decisions | `docs/adr/` |
| **Active work** | `_forge/inbox/active/` |
| **Completed work (ledger)** | `_forge/inbox/done/` |
| Autonomy policy | `FORGE-AUTONOMY.yml` |
| Source code | `src/` |
| Tests | `tests/` |
| Database | `supabase/` |

---

## Packet Structure

Every packet is a folder in `_forge/inbox/active/`:

```
_forge/inbox/active/2026-02-11-auth-email-password/
├── packet.yml        # Metadata (5 fields)
├── README.md         # Problem + scope + acceptance criteria
├── plan.md           # Written by @G
├── handoff.md        # Written by @G (task brief for @E)
└── acceptance.md     # Written by @E (Sacred Four results)
```

### packet.yml

```yaml
slug: "2026-02-11-auth-email-password"
branch: "feat/auth-email-password"
pr: ""
status: "active"    # active | done
approved: true      # Human Lead has approved execution
```

### Lifecycle

```
Create in active/ → @G plans → Human approves → @E executes → Sacred Four → PR merges → move to done/
```

- If blocked: stays in `active/`, README notes why
- If abandoned: delete folder or move to `done/` with note
- `done/` IS the archive

---

## Sacred Four (Required Before Every PR)

```bash
pnpm typecheck && pnpm lint && pnpm test:run && pnpm build
```

**All four must pass. No exceptions.**

---

## Constitution Check

**Before any work, verify:**

```
docs/constitution/
├── PRODUCT.md        # What we're building and why
├── TECH.md           # How we're building it
└── GOVERNANCE.md     # Rules, permissions, policies
```

**If empty or missing: STOP.** Request inputs from Human Lead.
**Constitutional docs are read-only during execution.** Propose changes via a separate packet.

---

## Agent Lanes

### Pre-FORGE (A.B.C)

| Agent | Role | Boundary |
|-------|------|----------|
| @A | Acquire — scaffold + intake | No product decisions |
| @B | Brief — sensemaking (optional) | No scope finalization |
| @C | Commit — decision gate | No code |

### FORGE Lifecycle (F.O.R.G.E)

| Agent | Role | Boundary |
|-------|------|----------|
| @F | Frame — intent + scope | No architecture or code |
| @O | Orchestrate — architecture + planning | No product decisions or code |
| @R | Refine — review + coherence | No new decisions or code |
| @G | Govern — routing + policy + gating | No domain work |
| @E | Execute — tests + code + PR | No scope/arch changes |

### Lane Rules

- All transitions route through @G
- Human-in-the-loop at all governance checkpoints
- Each agent produces artifacts and STOPs
- No autonomous agent-to-agent continuation

### Progressive Lifecycle Gates

FORGE uses 4 progressive gates to ensure readiness at each phase:

**Gate 1 — PRD Lock (@F)**
- Enforced by: @F
- Requirement: PRODUCT.md contains description, actors, use cases, MVP, success criteria
- Blocks: @O cannot proceed until Gate 1 passes

**Gate 2 — Architecture Lock (@O)**
- Enforced by: @O
- Prerequisite: Gate 1 passed
- Requirement: TECH.md contains stack, data model, build plan
- Blocks: @R cannot proceed until Gate 2 passes

**Gate 3 — Coherence Review (@R)**
- Enforced by: @R
- Prerequisite: Gate 2 passed
- Requirement: @R verifies PRODUCT ↔ TECH alignment
- Blocks: @G/@E cannot proceed until Gate 3 passes

**Gate 4 — Execution Loop (@G + @E)**
- Enforced by: @G and @E
- Prerequisite: Gate 3 passed
- Requirement: Approved packet exists in `_forge/inbox/active/`
- Process: @G creates packet → Human approves → @E executes → repeat per PR

**Human Lead can bypass any gate with explicit instruction** (e.g., "skip Gate 3" or "proceed without Gate 2").

---

## When to Stop

- Constitution missing or incomplete
- Work outside approved packet scope
- Sacred Four fails
- Spec conflict detected
- `approved: false` in packet.yml
- "This feels wrong"

**When in doubt: ask. It's faster than fixing a wrong turn.**

---

## Project Identity

### What This Is
[CUSTOMIZE: 2-3 sentences describing the project]

### Current Phase
[CUSTOMIZE: Frame | Orchestrate | Refine | Govern | Execute]

---

## FORGE Agents (Bundled)

This project includes FORGE agents in `.claude/` directory. All agents are immediately available -- no setup required.

**Invoke agents:**
- Natural language: "Catch me up" → @G
- Explicit role: `@G catch me up` → forces @G
- Skill command: `/forge-g` → direct invocation

**Agent roster:**
- **Pre-FORGE:** @A (Acquire), @B (Brief), @C (Commit)
- **FORGE Lifecycle:** @F (Frame), @O (Orchestrate), @R (Refine), @G (Govern), @E (Execute)
- **Supporting:** decision-logger

**Customization:**
- Local agents: `.claude/agents/` (edit directly or use `.claude/settings.local.json`)
- Local skills: `.claude/skills/`
- Add specialists: Copy agent .md and skill/ folders to `.claude/`, restart Claude Code

See `.claude/README.md` for upgrade workflow and specialist agent installation.

---

## Technical Stack

| Layer | Technology |
|-------|------------|
| Framework | [CUSTOMIZE] |
| Language | [CUSTOMIZE] |
| Database | [CUSTOMIZE] |
| Auth | [CUSTOMIZE] |
| Hosting | [CUSTOMIZE] |
| Styling | [CUSTOMIZE] |

---

## FORGE Canon Reference

This project operates under **The FORGE Method(TM)**.

- FORGE Core: `method/core/forge-core.md`
- Operations: `method/core/forge-operations.md`

> This repo does not redefine FORGE. It consumes FORGE by reference.

---

## Template Version

**v2.0 Lean** — Git-native execution ledger model.

See `FORGE-AUTONOMY.yml` for `template_version: "2.0"`.

---

*This project follows The FORGE Method(TM) — theforgemethod.org*
