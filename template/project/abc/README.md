# Pre-FORGE Lifecycle (A.B.C)

This directory contains artifacts from the pre-FORGE lifecycle — the intake, sensemaking, and commitment phases that occur **before** the FORGE lifecycle (F.O.R.G.E) begins.

## Agents

| Agent | Role | When |
|-------|------|------|
| **@A** (Acquire) | Scaffold workspace, organize inputs, produce INTAKE.md | Always first |
| **@B** (Brief) | Sensemaking, options, assumptions | Optional — human decides |
| **@C** (Commit) | Decision gate, scope lock, produce FORGE-ENTRY.md | Required to unlock FORGE |

## Flow

```
@A (Acquire) → [@B (Brief)] → @C (Commit) → FORGE UNLOCKED
                 optional
```

1. **@A** creates this directory and organizes your idea into `INTAKE.md`
2. **@B** (optional) helps you make sense of messy inputs and explore options
3. **@C** forces a commitment decision and produces `FORGE-ENTRY.md`

Once `FORGE-ENTRY.md` exists, the FORGE lifecycle agents (@F/@O/@R/@G/@E) become available.

## Directory Structure

```
abc/
├── README.md              ← You are here
├── INTAKE.md              ← @A output: organized idea intake
├── BRIEF.md               ← @B output: sensemaking brief (if invoked)
├── IDEA_OPTIONS.md         ← @B output: candidate directions (if invoked)
├── ASSUMPTIONS.md          ← @B output: surfaced assumptions (if invoked)
├── FORGE-ENTRY.md          ← @C output: commitment artifact (GATE)
├── inbox/                  ← Raw inputs organized by @A
│   └── ...
└── context/                ← Supporting context gathered by @A
    └── ...
```

## Gate Artifact

**`FORGE-ENTRY.md`** is the gate artifact. Its existence determines which agents are available:

| State | Available Agents | Meaning |
|-------|-----------------|---------|
| `FORGE-ENTRY.md` does not exist | @A, @B, @C only | Pre-FORGE: still deciding |
| `FORGE-ENTRY.md` exists | @F, @O, @R, @G, @E | FORGE unlocked: committed to build |

## Autonomy

Pre-FORGE agents (A/B/C) are always capped at **Tier 0** — human approval is required for all actions, regardless of the project's `FORGE-AUTONOMY.yml` tier setting.

---

*Part of The FORGE Method™ — theforgemethod.org*
