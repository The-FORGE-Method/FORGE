# FORGE

**Frame. Orchestrate. Refine. Govern. Execute.**

A methodology for building production-grade systems using orchestrated AI agents.

FORGE gives you a structured lifecycle — from raw idea to working software — with human authority preserved at every step. Clone this repo, start Claude Code, and the full agent system activates with zero setup.

---

## Getting Started

### Clone and Run

```bash
git clone https://github.com/The-FORGE-Method/FORGE.git
cd FORGE
claude
```

That's it. All 10 agents and 9 skills load automatically.

### What Loads

| Agents | Skills |
|--------|--------|
| `@A` Acquire | `/forge-a` |
| `@B` Brief | `/forge-b` |
| `@C` Commit | `/forge-c` |
| `@F` Frame | `/forge-f` |
| `@O` Orchestrate | `/forge-o` |
| `@R` Refine | `/forge-r` |
| `@G` Govern | `/forge-g` |
| `@E` Execute | `/forge-e` |
| `forge-rd` (R&D meta-agent) | `/forge-rd` |
| `decision-logger` | — |

---

## Starting Your First Project

The A.B.C lifecycle takes you from idea to commitment:

```
@A (Acquire)  -->  @B (Brief)  -->  @C (Commit)  -->  FORGE-ENTRY.md
                   [optional]                          |
                                                       v
                                              FORGE lifecycle unlocks:
                                              @F -> @O -> @R -> @G -> @E
```

### Quick Start

1. **Say what you want to build:**
   ```
   I want to build a task management app
   ```
   This routes to `@A`, which scaffolds a project in `projects/`

2. **Optionally run `@B`** for sensemaking if the inputs are unclear

3. **Run `@C`** to lock scope and produce `FORGE-ENTRY.md`

4. **FORGE unlocks:** `@F` (Frame), `@O` (Orchestrate), `@R` (Refine), `@G` (Govern), `@E` (Execute)

---

## Repository Structure

```
FORGE/
├── .claude/                    Agents + Skills (auto-loaded by Claude Code)
│   ├── agents/                 10 agent definitions
│   ├── skills/                 9 skill directories
│   └── settings.json           Shared permission defaults
├── method/                     Canonical FORGE methodology
│   ├── core/                   Core docs (governance, operations, orientation)
│   ├── agents/                 Agent operating guides
│   └── templates/              Reusable templates
├── template/                   Project scaffold
│   └── project/                Copy this to start a new project
├── projects/                   Your FORGE projects live here
├── _workspace/                 R&D workspace (for evolving FORGE itself)
├── bin/                        Tooling
│   ├── forge-export            Sync agents from ~/.claude/ to repo
│   └── forge-install           Install agents globally (optional)
├── CLAUDE.md                   Agent routing and governance
├── README.md                   This file
└── LICENSE                     MIT
```

---

## Global Install (Optional)

Power users can install FORGE agents globally so they're available in any project:

```bash
./bin/forge-install
```

The install script prompts for confirmation before overwriting any existing files in `~/.claude/`.

---

## User Customization

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

Claude Code merges your local settings with the shared defaults.

---

## FORGE R&D Pipeline (Advanced)

FORGE includes a meta-agent for evolving FORGE itself:

```bash
/forge-rd start <feature-slug>    # Start R&D pipeline
/forge-rd status                  # Check pipeline state
/forge-rd approve                 # Approve at governance checkpoint
```

Pipeline: Inbox -> Recon -> Synthesis -> Proposal -> Approval -> Implement -> Verify -> Archive

See `_workspace/README.md` for full documentation.

---

## Documentation

- **Core Methodology:** [`method/core/`](method/core/)
- **Agent Guides:** [`method/agents/`](method/agents/)
- **Templates:** [`method/templates/`](method/templates/)
- **Project Template:** [`template/project/`](template/project/)
- **Governance:** [`CLAUDE.md`](CLAUDE.md)

---

## License

MIT License. See [LICENSE](LICENSE).

---

*This is the only supported public distribution of FORGE.*

*The FORGE Method — Frame. Orchestrate. Refine. Govern. Execute.*
