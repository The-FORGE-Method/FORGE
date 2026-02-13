# Work-Item: Ship FORGE Core Agent Pack with Every Spawned Project (Project-Local .claude/)

## Intent

When FORGE spawns a new project, the **FORGE core agent team** ships with it. Agents, skills, and tool config live inside the project repo so teammates can clone and immediately work the FORGE way — no global install required.

This is a deliberate packaging decision: **project-local by default, version-pinned, upgradable.**

## Decision (Leo + Jordan, 2026-02-12, refined)

**Decision: Core FORGE team in every repo. FORGE-only agents and skills. No personal/global extras.**

The agent roster is intentionally focused:
- 10 agents (A/B/C/F/O/R/G/E + forge-rd + decision-logger)
- 9 skill folders (matching forge-* skills + forge-rd-pipeline)
- Plugins are manifest-only (ralph-wiggum, frontend-design)

Non-FORGE agents (iOS specialists, jordan persona, project-orchestrator, research-agent, spec-writer, mac-tuneup, kv-*) stay in `~/.claude/` as optional global tooling. They don't ship with projects.

The global model (`bin/forge-install` → `~/.claude/`) remains as optional developer convenience, but is NOT the primary distribution mechanism. The project repo IS the source of truth for its agents.

## Problem Statement

1. `template/project/` contains NO `.claude/` directory — no agents, no skills, no tool configs
2. When forge-architect scaffolds a new project, the resulting project has zero FORGE agent awareness
3. The RecallTech BOLO project was spawned and got none of the agents, rules, or skills — this is the direct symptom
4. The existing global model (`bin/forge-install`) works on Leo's machine but:
   - Requires manual execution
   - Not part of the spawn flow
   - Machine-specific — teammates/CI get nothing
   - No project-specific customization path

**Root cause:** FORGE agents were treated as environment tooling (like a CLI) rather than project infrastructure (like a linter config). They need to be vendored.

## Architecture: Vendored Core Pack, Version-Pinned

### Model

```
Every project repo includes:
.claude/
├── VERSION                    # FORGE_AGENT_PACK=2.0.0
├── README.md                  # Usage, roster classification, upgrade path
├── REQUIRED_PLUGINS.md        # Marketplace plugins to install
├── settings.json              # Project-level Claude Code settings
├── agents/                    # Core FORGE agent definitions (10 files)
│   ├── forge-a.md
│   ├── forge-b.md
│   ├── forge-c.md
│   ├── forge-e.md
│   ├── forge-f.md
│   ├── forge-g.md
│   ├── forge-o.md
│   ├── forge-r.md
│   ├── forge-rd.md
│   └── decision-logger.md
└── skills/                    # Core FORGE skill definitions (9 folders)
    ├── forge-a/
    ├── forge-b/
    ├── forge-c/
    ├── forge-e/
    ├── forge-f/
    ├── forge-g/
    ├── forge-o/
    ├── forge-r/
    └── forge-rd-pipeline/
```

### Key Principles

1. **Self-contained** — Clone the repo, FORGE agents work. No global setup required.
2. **Version-pinned** — `.claude/VERSION` tracks which FORGE Agent Pack version is vendored.
3. **Upgradable** — Bumping to a new pack version is a deliberate PR, not silent drift.
4. **Customizable** — Projects can modify their local agents without affecting other projects.
5. **Focused** — Only FORGE lifecycle agents ship. Specialist agents (iOS, etc.) are opt-in via global install.
6. **Global is fallback only** — `~/.claude/` still works for dev convenience, but project `.claude/` takes precedence (Claude Code's resolution order: project > global).

### Agent Roster: What Ships vs What Doesn't

#### Ships with every project (`.claude/agents/`)

| Agent | Role | Lane |
|-------|------|------|
| `forge-a.md` | Acquire — intake for new features | Pre-FORGE |
| `forge-b.md` | Brief — sensemaking + discovery | Pre-FORGE |
| `forge-c.md` | Commit — scope lock + commitment gate | Pre-FORGE |
| `forge-f.md` | Frame — PRD / product intent | FORGE Lifecycle |
| `forge-o.md` | Orchestrate — architecture + PR plan | FORGE Lifecycle |
| `forge-r.md` | Refine — coherence review | FORGE Lifecycle |
| `forge-g.md` | Govern — routing + policy + gating | FORGE Lifecycle |
| `forge-e.md` | Execute — tests-first implementation | FORGE Lifecycle |
| `forge-rd.md` | R&D — method evolution within project | Meta |
| `decision-logger.md` | ADR / decision capture | Support |

**Total: 10 agents.**

#### Ships with every project (`.claude/skills/`)

| Skill | Contents |
|-------|----------|
| `forge-a/` | SKILL.md |
| `forge-b/` | SKILL.md |
| `forge-c/` | SKILL.md |
| `forge-e/` | SKILL.md |
| `forge-f/` | SKILL.md |
| `forge-g/` | SKILL.md |
| `forge-o/` | SKILL.md |
| `forge-r/` | SKILL.md |
| `forge-rd-pipeline/` | SKILL.md + resources/, templates/, references/ |

**Total: 9 skill folders.**

#### Does NOT ship (stays global or FORGE-repo-only)

| Item | Reason | Where It Lives |
|------|--------|----------------|
| `jordan.md` | Personal strategic persona | `~/.claude/agents/` |
| `project-orchestrator.md` | General-purpose, not FORGE-specific | `~/.claude/agents/` |
| `research-agent.md` | General-purpose, not FORGE-specific | `~/.claude/agents/` |
| `spec-writer.md` | General-purpose, not FORGE-specific | `~/.claude/agents/` |
| `swift-architect.md` | iOS specialist | `~/.claude/agents/` |
| `swiftui-designer.md` | iOS specialist | `~/.claude/agents/` |
| `ios-*.md` agents | iOS specialists | `~/.claude/agents/` |
| `mac-tuneup.md` | Personal utility | `~/.claude/agents/` |
| `kv-*.md` agents | Legacy KV project management | `~/.claude/agents/` |
| `forge-architect.md` | Spawner — lives in FORGE home base | FORGE repo + `~/.claude/` |
| `forge-maintainer.md` | FORGE repo maintenance | FORGE repo + `~/.claude/` |
| `forge-recon-runner.md` | FORGE R&D pipeline | FORGE repo + `~/.claude/` |
| `jordan/` skill | Personal strategic skill | `~/.claude/skills/` |
| `session-memory/` skill | Cross-project memory | `~/.claude/skills/` |
| `dev-metrics-tracker/` skill | Personal dev metrics | `~/.claude/skills/` |
| `gdrive/` skill | Personal Google Drive mgmt | `~/.claude/skills/` |

### Plugin Distribution (Manifest Only)

Ralph-wiggum, frontend-design, and keybindings-help are **Claude Code marketplace plugins** (`~/.claude/plugins/`). They cannot be vendored into `.claude/`.

**Solution:** `.claude/REQUIRED_PLUGINS.md` documents:

```markdown
# Required Plugins

Install these Claude Code plugins for full FORGE capabilities:

| Plugin | Purpose |
|--------|---------|
| ralph-wiggum | Iterative refinement loops for specs/docs |
| frontend-design | Production-grade UI generation |

These are optional — core FORGE agents work without them.
Install: `claude plugins install ralph-wiggum frontend-design`
```

### Version Pinning

`.claude/VERSION`:
```
FORGE_AGENT_PACK=2.0.0
FORGE_TEMPLATE_VERSION=2.0
PACK_DATE=2026-02-12
SOURCE=https://github.com/<org>/FORGE
```

**Upgrade workflow:**
1. FORGE repo publishes a new agent pack version (tag or changelog)
2. Project maintainer runs `bin/forge-sync` (or manually copies) to update `.claude/`
3. Version file gets bumped
4. Changes committed via PR: "Bump FORGE Agent Pack to X.Y.Z"

### Drift Governance

**Rule:** Projects MAY customize their local `.claude/` agents/skills. Customizations are the project's responsibility. When upgrading the pack, the project team resolves merge conflicts.

**Pattern A (simple, evolve later):**
- Everything lives directly in `.claude/`
- Customizations are edits to the vendored files
- No separate overlay directory (can add later if needed)
- `.claude/README.md` documents the customization policy

## Scope

### Must Do
- Create `.claude/` directory structure in `template/project/`
- Add the 10 core agents to `template/project/.claude/agents/`
- Add the 9 core skill folders to `template/project/.claude/skills/`
- Create `.claude/VERSION` with pack version
- Create `.claude/README.md` with agent roster, classification, and upgrade instructions
- Create `.claude/REQUIRED_PLUGINS.md` with marketplace plugin manifest
- Create `.claude/settings.json` with baseline project permissions
- Update template `CLAUDE.md` to reference local `.claude/` as agent source
- Update template `.gitignore` to exclude `.claude/settings.local.json`
- Strip `__pycache__/` and build artifacts from vendored skills
- Create `bin/forge-sync` script (or add `--project` mode to `bin/forge-install`) for project-level agent pack updates

### Should Do
- Classify agents in `.claude/README.md` (Pre-FORGE / Lifecycle / Meta / Support)
- Add "How to add specialist agents" docs (for teams that want iOS agents, etc.)
- Add a "New Teammate Setup" section to template CLAUDE.md or ONBOARDING.md

### Must Not
- Remove or break `bin/forge-install` (global install remains for dev convenience)
- Remove or break `bin/forge-export` (versioning mechanism still useful)
- Ship non-FORGE agents into project template (jordan, iOS, kv-*, mac-tuneup, etc.)
- Ship non-FORGE skills into project template (jordan/, session-memory/, dev-metrics/, gdrive/)
- Modify method/core/ (no canon changes)

### Open Questions
1. Should forge-architect's scaffold flow automatically copy `.claude/` from the template, or is template copy sufficient? (Leaning: template copy is sufficient — forge-architect reads from template/project/)
2. Should `bin/forge-sync` be a new script, or should `bin/forge-install --project` handle both? (Leaning: new script — cleaner separation)
3. Should forge-rd-pipeline ship with all its resources/templates/references? Or just SKILL.md? (Leaning: ship everything — it's the meta-evolution tool and needs its templates)

## Files Affected

| File | Action |
|------|--------|
| `template/project/.claude/VERSION` | CREATE |
| `template/project/.claude/README.md` | CREATE |
| `template/project/.claude/REQUIRED_PLUGINS.md` | CREATE |
| `template/project/.claude/settings.json` | CREATE |
| `template/project/.claude/agents/*.md` | CREATE (10 agent files) |
| `template/project/.claude/skills/*/` | CREATE (9 skill directories) |
| `template/project/CLAUDE.md` | UPDATE (reference local .claude/) |
| `template/project/.gitignore` | UPDATE (add .claude/settings.local.json) |
| `bin/forge-sync` | CREATE (or update bin/forge-install with --project) |

## Acceptance Criteria (PASS/FAIL)

- [ ] Spawned project contains `.claude/agents/` with exactly 10 core agents
- [ ] Spawned project contains `.claude/skills/` with exactly 9 core skill folders
- [ ] `.claude/VERSION` exists with FORGE_AGENT_PACK version number
- [ ] `.claude/README.md` explains roster, classification, and upgrade path
- [ ] `.claude/REQUIRED_PLUGINS.md` lists marketplace plugins with install commands
- [ ] `.claude/settings.json` exists with baseline project permissions
- [ ] From a fresh clone (no `~/.claude/`), invoking @G works with correct lane behavior
- [ ] From a fresh clone (no `~/.claude/`), invoking @E works and enforces tests-first + Sacred Four
- [ ] Human gating is enforced (no execution without approval)
- [ ] No agent fails due to missing FORGE-repo-only paths (method/core, _workspace)
- [ ] No `__pycache__/` or build artifacts in vendored skills
- [ ] Template CLAUDE.md references local `.claude/` as agent source
- [ ] `.claude/settings.local.json` is in template `.gitignore`
- [ ] No non-FORGE agents (jordan, iOS, kv-*, etc.) are present in spawned project

## Recon Tasks (Before Implementation)

1. **Verify Claude Code agent resolution order**: Confirm project `.claude/` takes precedence over global `~/.claude/`. Document the merge behavior when both exist.
2. **Audit agents for FORGE-repo-only path dependencies**: Search all 10 agent files and 9 skill SKILL.md files for references to `method/core/`, `method/templates/`, `_workspace/`, `template/`, `projects/`, or FORGE-repo absolute paths. These will break in spawned projects.
3. **Reproduce BOLO failure mode**: Spawn a fresh project from template, attempt @G and @E, document exactly what fails and why.
4. **Inventory skill sizes**: Measure disk usage of the 9 skill folders. forge-rd-pipeline has the most resources — confirm total is reasonable.
5. **Plugin install verification**: Confirm marketplace plugin install commands work and document exact syntax.

## Stop Conditions

- If any of the 10 agents hard-depends on FORGE-repo-only paths that can't be resolved at the project level, STOP and design a path abstraction layer.
- If Claude Code doesn't load project `.claude/` agents/skills reliably, STOP and investigate before proceeding.
- If the plugin system doesn't support the documented install commands, STOP and research the correct plugin distribution model.
- If vendoring the 9 skill folders exceeds 5MB, STOP and identify what can be trimmed.

## Materials

- FORGE repo `.claude/agents/`: 10 agents (the exact 10 that ship)
- FORGE repo `.claude/skills/`: 9 skill folders (the exact 9 that ship)
- Global `~/.claude/agents/`: 29 agents (19 stay global-only)
- Global `~/.claude/skills/`: 13 skill folders (4 stay global-only)
- Plugin locations: `~/.claude/plugins/marketplaces/claude-code-plugins/plugins/` (ralph-wiggum, frontend-design)
- `bin/forge-install` — Current global install script (88 lines)
- `bin/forge-export` — Current export/versioning script (171 lines)
- RecallTech BOLO project — Direct symptom of the missing agents problem
- Jordan + Leo conversation (2026-02-12) — Refined roster decision: core FORGE only

---

*Part of the FORGE v2.0 Lean template evolution. Companion packet: remove-abc-from-template.*
