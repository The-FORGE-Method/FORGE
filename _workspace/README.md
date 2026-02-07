# FORGE R&D Workspace

**Active development workspace for evolving FORGE itself.**

**Status:** Non-Canon

---

## Quick Start

### Submitting a Feature Request

1. Create a folder in `00_inbox/` with your feature slug
2. Add `README.md`, `threads/`, and `assets/` subdirectories
3. Place all source material (transcripts, sketches, notes) inside
4. Notify Human Lead or run `/forge-rd start <your-slug>`

See `00_inbox/README.md` for detailed submission instructions.

### Processing a Feature Request

```bash
/forge-rd start <slug>        # Start pipeline for inbox folder
/forge-rd status              # Check current state
/forge-rd approve             # Approve at governance checkpoint
/forge-rd approve --canon     # Approve canon changes (requires confirm)
```

---

## What This Is

`_workspace/` is the **active R&D environment** where FORGE itself is researched, designed, and evolved.

This is where:
- Feature requests enter via `00_inbox/`
- The R&D pipeline transforms ideas into implementations
- Humans and agents collaborate on FORGE evolution
- Cross-repo changes are coordinated

**Think of it as:** The workshop where FORGE is built.

---

## The R&D Pipeline

### Pipeline Flow

```
00_inbox/<feature-slug>/
         |
         v
    /forge-rd start <slug>
         |
         v
+----------------------------------------------------------+
|  INTAKE -> RECON -> [QUESTIONS] -> SYNTHESIS -> PROPOSAL  |
|                                       |                   |
|                                       v                   |
|                            Governance Checkpoint          |
|                           "Human authority required"      |
|                                       |                   |
|                                       v                   |
|                    /forge-rd approve [--canon]            |
|                                       |                   |
|                                       v                   |
|               IMPLEMENT -> VERIFY -> ARCHIVE              |
+----------------------------------------------------------+
         |
         v
    Feature delivered
    Work-item archived to 99_archive/
```

### Pipeline Commands

| Command | Purpose |
|---------|---------|
| `/forge-rd start <slug>` | Start processing an inbox folder |
| `/forge-rd status` | Show current pipeline state |
| `/forge-rd approve` | Approve proposal at governance checkpoint |
| `/forge-rd approve --canon` | Approve changes to `method/core/` |
| `/forge-rd confirm` | Second confirmation (canon or blast radius) |
| `/forge-rd reject "<feedback>"` | Reject with feedback, return to synthesis |
| `/forge-rd answer Q1 "answer"` | Answer a clarifying question |
| `/forge-rd hold` | Pause pipeline |
| `/forge-rd resume` | Resume pipeline |
| `/forge-rd cancel` | Cancel and archive partial work |

---

## Folder Structure

```
_workspace/
├── README.md              <- You are here
├── 00_inbox/              <- Feature request queue (folders only!)
│   └── <feature-slug>/    <- Each submission is a folder
│       ├── README.md
│       ├── threads/
│       └── assets/
├── 01_recon/              <- Standalone recon reports (legacy)
├── 02_research/           <- External references, research
├── 03_synthesis/          <- Standalone synthesis (legacy)
├── 04_proposals/          <- Draft proposals
│   └── work-items/        <- Active pipeline work-items
│       └── YYYY-MM-DD-<slug>/
│           ├── state.json
│           ├── audit-log.md
│           ├── threads/
│           ├── assets/
│           └── artifacts/
├── 05_decisions/          <- Approved decisions (Human Lead only)
└── 99_archive/            <- Completed and retired work
```

### Key Directories

| Directory | Purpose | Who Writes |
|-----------|---------|------------|
| `00_inbox/` | Feature submissions | Anyone |
| `04_proposals/work-items/` | Active pipeline processing | Pipeline only |
| `05_decisions/` | Decision records | Human Lead only |
| `99_archive/` | Completed work | Pipeline only |

---

## Governance Rules

### Who Can Do What

| Action | Who |
|--------|-----|
| Submit to `00_inbox/` | Anyone (follow folder structure) |
| Run `/forge-rd start` | Human Lead or authorized agent |
| Approve proposals | Human Lead only |
| Create decision records | Human Lead only |
| Promote to method/ | Human Lead approval required |

### Governance Checkpoints

The pipeline pauses at these points requiring human authority:

1. **Proposal Approval** — After quality gate passes
2. **Canon Confirmation** — Changes to `method/core/` require two-step approval
3. **Blast Radius Confirmation** — Cross-repo or >10 file changes require confirmation

### Canon Changes

Changes to `method/core/**` are **canon changes** and require:

```bash
/forge-rd start my-feature --canon   # Start with canon flag
# ... pipeline runs ...
/forge-rd approve --canon            # First approval
/forge-rd confirm                    # Second confirmation
```

---

*This workspace exists to make FORGE evolution explicit, traceable, and collaborative.*
