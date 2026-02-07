# Ops Agent Directory (G-phase)

This directory contains execution coordination artifacts produced by the **Ops Agent (G)**.

---

## FORGE Role Context

| Letter | Role | Agent |
|--------|------|-------|
| F | Frame | Product Strategist |
| O | Orchestrate | Project Architect |
| R | Refine | Human review |
| **G** | **Govern** | **Ops Agent** |
| E | Execute | Execution agents/humans |

The Ops Agent owns the **Govern (G)** phase — coordinating execution without designing products or writing code.

---

## Artifacts

| File | Purpose |
|------|---------|
| `build-plan.md` | Canonical execution strategy derived from Architecture Packet |
| `execution-state.md` | Living status: done, blocked, next |
| `approvals/` | Explicit human checkpoint gates |
| `handoffs/` | Task briefs for Execution (E) agents/humans |
| `run-logs/` | Summaries of Ops Agent actions (not raw logs) |

---

## Human Interaction

The Ops Agent operates **human-in-the-loop**. At checkpoints, you will be asked to:

- **Proceed** — Continue with current plan
- **Pause** — Stop and wait
- **Revise plan** — Update Build Plan
- **Take over** — Handle this step yourself
- **Skip** — Remove step from plan

**You are never forced into tools or code.** All interactions are natural language.

---

## Required Checkpoints

| Checkpoint | When |
|------------|------|
| Build Plan Approval | After Architecture Packet decomposition |
| Phase Completion | Each PR merged or phase completed |
| PR Merge Approval | PR verified and ready |
| Migration/Deployment | Before infrastructure changes |

---

## G-phase Flow

```
1. Architecture Packet approved (from inbox/20_architecture-plan/)
       ↓
2. Ops Agent decomposes into Build Plan
       ↓
3. Human approves Build Plan
       ↓
4. Ops Agent coordinates Execution (E)
       ↓
5. Per-phase approval gates
       ↓
6. PR merge approvals
       ↓
7. Migration/deployment approvals (if applicable)
```

---

## What's Next?

Check `execution-state.md` for current status.

If no execution state exists yet, the Ops Agent will create one after the Architecture Packet is approved.

---

## Related

- `inbox/20_architecture-plan/` — Input from Project Architect
- `CLAUDE.md` — Project identity and G-phase onboarding
- `method/agents/forge-ops-agent-guide.md` — Full Ops Agent specification

---

*Ops Agent (G) — State ownership, coordination, validation, gating.*
