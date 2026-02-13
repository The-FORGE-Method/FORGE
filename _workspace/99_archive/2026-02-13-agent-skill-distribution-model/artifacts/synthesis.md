---
title: Agent-Skill Distribution Model — Detailed Specification
date: 2026-02-13
version: v1.0
status: Final
author: SpecWriter Agent
tags: [forge, agents, distribution, template, project-spawn]
---

# Agent-Skill Distribution Model — Detailed Specification

## Executive Summary

Ship FORGE core agents and skills with every spawned project by vendoring them into `template/project/.claude/`. This shifts distribution from global-install-only to project-local-by-default, making FORGE agents immediately available to teammates who clone a project without manual setup. Implementation includes adding `.claude/` directory to template, killing `FORGE/projects/` directory entirely (hard separation), creating version tracking, and establishing upgrade workflow.

**Key Decision:** Exclude forge-rd and forge-rd-pipeline from vendored pack due to hard dependencies on FORGE-repo-only infrastructure (_workspace/, method/core/, sub-agents). Final roster: 9 agents, 8 skills.

**Critical Change:** FORGE projects must live OUTSIDE the FORGE repo. Default spawn location: `~/forge-projects/` (configurable). Hard stop if user attempts spawn inside FORGE repo.

---

## 1. Requirements Matrix

### 1.1 Core Requirements

| ID | Requirement | Type | Status |
|----|-------------|------|--------|
| CR-001 | Create `template/project/.claude/` directory structure | CREATE | Required |
| CR-002 | Vendor 9 agents into template | COPY+EDIT | Required |
| CR-003 | Vendor 8 skills into template | COPY+EDIT | Required |
| CR-004 | Add `external_project: true` to template FORGE-AUTONOMY.yml | UPDATE | Required |
| CR-005 | Create VERSION file with version + upgrade docs link | CREATE | Required |
| CR-006 | Create .claude/README.md documenting roster | CREATE | Required |
| CR-007 | Create .claude/REQUIRED_PLUGINS.md documenting plugins | CREATE | Required |
| CR-008 | Create .claude/settings.json with baseline permissions | CREATE | Required |
| CR-009 | Update template .gitignore to exclude settings.local.json | UPDATE | Required |
| CR-010 | Update template CLAUDE.md to reference local .claude/ | UPDATE | Required |
| CR-011 | Delete FORGE/projects/ directory entirely | DELETE | Required |
| CR-012 | Update FORGE CLAUDE.md to remove projects/ references | UPDATE | Required |
| CR-013 | Update forge-architect agent/skill for external spawn | UPDATE | Required |
| CR-014 | Create bin/forge-sync script for project updates | CREATE | Required |
| CR-015 | Preserve bin/forge-install unchanged | VERIFY | Required |

### 1.2 Agent Adaptation Requirements

| ID | Agent | Changes Required | Files Affected |
|----|-------|-----------------|----------------|
| AR-001 | forge-a.md | Remove template/project references (lines 64, 80), Replace operating guide link with GitHub URL (line 117) | 1 file |
| AR-002 | forge-b.md | Replace operating guide link with GitHub URL (line 99) | 1 file |
| AR-003 | forge-c.md | Replace operating guide link with GitHub URL (line 112) | 1 file |
| AR-004 | forge-e.md | Replace operating guide link with GitHub URL (line 96) | 1 file |
| AR-005 | forge-f.md | Replace operating guide link with GitHub URL (line 80) | 1 file |
| AR-006 | forge-g.md | Replace operating guide link with GitHub URL (line 149) | 1 file |
| AR-007 | forge-o.md | Replace operating guide link with GitHub URL (line 82) | 1 file |
| AR-008 | forge-r.md | Replace operating guide link with GitHub URL (line 86) | 1 file |
| AR-009 | decision-logger.md | No changes required (no FORGE-repo-specific dependencies) | 0 files |
| AR-010 | forge-rd.md | EXCLUDED — Hard dependencies on _workspace/, method/core/ make unsuitable for spawned projects | N/A |

### 1.3 Skill Adaptation Requirements

| ID | Skill | Changes Required | Files Affected |
|----|-------|-----------------|----------------|
| SR-001 | forge-a/ | Universal Startup Check preserved (external_project waiver handles it), No build artifacts | SKILL.md |
| SR-002 | forge-b/ | Universal Startup Check preserved, No build artifacts | SKILL.md |
| SR-003 | forge-c/ | Universal Startup Check preserved, No build artifacts | SKILL.md |
| SR-004 | forge-e/ | Universal Startup Check preserved, No build artifacts | SKILL.md |
| SR-005 | forge-f/ | Universal Startup Check preserved, No build artifacts | SKILL.md |
| SR-006 | forge-g/ | Universal Startup Check preserved, No build artifacts | SKILL.md |
| SR-007 | forge-o/ | Universal Startup Check preserved, No build artifacts | SKILL.md |
| SR-008 | forge-r/ | Universal Startup Check preserved, No build artifacts | SKILL.md |
| SR-009 | forge-rd-pipeline/ | EXCLUDED — Hard dependencies on _workspace/, method/core/, FORGE-only sub-agents (forge-recon-runner, spec-writer, forge-maintainer) | N/A |

---

## 2. File-by-File Specifications

### 2.1 New Files to CREATE

#### 2.1.1 template/project/.claude/VERSION

**Path:** `/Users/leonardknight/kv-projects/FORGE/template/project/.claude/VERSION`

**Content:**
```
FORGE_AGENT_PACK_VERSION=1.0.0
UPGRADE_DOCS=https://github.com/[org]/FORGE/blob/main/docs/upgrading-agent-pack.md
```

**Purpose:** Track vendored agent pack version and provide upgrade documentation link.

**Acceptance Criteria:**
- [ ] File exists at specified path
- [ ] Version format is semver (X.Y.Z)
- [ ] UPGRADE_DOCS URL is valid GitHub link

---

#### 2.1.2 template/project/.claude/README.md

**Path:** `/Users/leonardknight/kv-projects/FORGE/template/project/.claude/README.md`

**Content:**
```markdown
# FORGE Agent Pack — Project Distribution

**Version:** 1.0.0
**Distribution Model:** Project-local by default

This directory contains FORGE core agents and skills bundled with your project. All agents are immediately available to anyone who clones this repository — no manual setup required.

---

## Agent Roster

### Pre-FORGE Agents (A.B.C)

For feature intake within this project:

| Agent | Invoke | Role |
|-------|--------|------|
| **@A** | `/forge-a` | Acquire — Intake + Organize |
| **@B** | `/forge-b` | Brief — Sensemaking (optional) |
| **@C** | `/forge-c` | Commit — Decision Gate |

### FORGE Lifecycle Agents (F.O.R.G.E)

For building:

| Agent | Invoke | Role |
|-------|--------|------|
| **@F** | `/forge-f` | Frame — Product Intent |
| **@O** | `/forge-o` | Orchestrate — Architecture |
| **@R** | `/forge-r` | Refine — Review + Coherence |
| **@G** | `/forge-g` | Govern — Routing + Policy |
| **@E** | `/forge-e` | Execute — Code + Tests |

### Supporting Agents

| Agent | Invoke | Role |
|-------|--------|------|
| **decision-logger** | Direct invocation | Structured decision capture |

---

## What's NOT Included

These agents live only in the canonical FORGE repo (not bundled with projects):

- **forge-rd** — FORGE meta-evolution agent (requires `_workspace/`, `method/core/`)
- **forge-architect** — FORGE project spawning (FORGE-repo-only)
- **forge-maintainer** — FORGE repo maintenance (FORGE-repo-only)
- **forge-recon-runner** — FORGE R&D pipeline sub-agent (FORGE-repo-only)
- **spec-writer** — FORGE R&D pipeline sub-agent (FORGE-repo-only)

---

## Agent Resolution Order

Claude Code loads agents in this order (highest priority first):

1. **Project-local** — `.claude/` in this directory (YOU ARE HERE)
2. **Global** — `~/.claude/` in your home directory (fallback)

If you've installed FORGE agents globally via `bin/forge-install`, project-local agents take precedence.

---

## Customization

### Local Overrides

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

### Adding Specialist Agents

To add domain-specific agents (iOS, analytics, etc.):

1. Copy agent .md file to `.claude/agents/`
2. Copy skill folder to `.claude/skills/` (if skill exists)
3. Add skill permission to `.claude/settings.local.json` if needed
4. Restart Claude Code

**Example:** Adding iOS agents from FORGE repo:
```bash
cp ~/kv-projects/FORGE/.claude/agents/swift-architect.md .claude/agents/
cp -r ~/kv-projects/FORGE/.claude/skills/swift-architect/ .claude/skills/
```

Then add to `.claude/settings.local.json`:
```json
{
  "permissions": {
    "allow": ["Skill(swift-architect)"]
  }
}
```

---

## Upgrading Agent Pack

When FORGE releases new agent pack versions:

1. Check current version: `cat .claude/VERSION`
2. Run from FORGE repo: `./bin/forge-sync /path/to/your/project`
3. Review changes and merge conflicts
4. Commit updated agents

See: https://github.com/[org]/FORGE/blob/main/docs/upgrading-agent-pack.md

---

## Documentation

- **FORGE Method:** https://github.com/[org]/FORGE/blob/main/method/core/forge-core.md
- **Agent Operating Guides:** https://github.com/[org]/FORGE/tree/main/method/agents/
- **Template Source:** https://github.com/[org]/FORGE/tree/main/template/project/

---

*Bundled with The FORGE Method™ — theforgemethod.org*
```

**Acceptance Criteria:**
- [ ] File exists at specified path
- [ ] Agent roster matches vendored agents (9 agents, 8 skills)
- [ ] Excluded agents documented with rationale
- [ ] Upgrade workflow documented
- [ ] Specialist agent addition workflow documented

---

#### 2.1.3 template/project/.claude/REQUIRED_PLUGINS.md

**Path:** `/Users/leonardknight/kv-projects/FORGE/template/project/.claude/REQUIRED_PLUGINS.md`

**Content:**
```markdown
# Required Claude Code Marketplace Plugins

FORGE agents rely on these marketplace plugins for full functionality. Install via Claude Code marketplace or CLI.

---

## Core Plugins

### ralph-wiggum
**Purpose:** Enhanced code understanding and architectural analysis
**Install:** `claude plugins install ralph-wiggum` (or via marketplace)
**Used by:** @O (Orchestrate), @R (Refine)

### frontend-design
**Purpose:** UI/UX design analysis and component generation
**Install:** `claude plugins install frontend-design` (or via marketplace)
**Used by:** @E (Execute) for frontend work

---

## Installation

### Via Marketplace (Recommended)
1. Open Claude Code
2. Navigate to Marketplace
3. Search for plugin name
4. Click Install

### Via CLI
```bash
claude plugins install ralph-wiggum
claude plugins install frontend-design
```

### Verification
```bash
claude plugins list
```

You should see both plugins marked as `[installed]`.

---

## Optional Plugins

These enhance specific workflows but are not required:

- **stripe** — Payments integration (if project uses Stripe)
- **supabase** — Database operations (if project uses Supabase)
- **perplexity** — AI web search (for research tasks)

Install as needed based on your project's tech stack.

---

*FORGE Agent Pack v1.0.0*
```

**Acceptance Criteria:**
- [ ] File exists at specified path
- [ ] Installation instructions include both marketplace and CLI methods
- [ ] Verification method documented
- [ ] Optional plugins listed with conditional logic

---

#### 2.1.4 template/project/.claude/settings.json

**Path:** `/Users/leonardknight/kv-projects/FORGE/template/project/.claude/settings.json`

**Content:**
```json
{
  "permissions": {
    "allow": [
      "Skill(forge-a)",
      "Skill(forge-b)",
      "Skill(forge-c)",
      "Skill(forge-f)",
      "Skill(forge-o)",
      "Skill(forge-r)",
      "Skill(forge-g)",
      "Skill(forge-e)",
      "Bash(git status*)",
      "Bash(git diff*)",
      "Bash(git log*)"
    ]
  },
  "enableAllProjectMcpServers": false
}
```

**Purpose:** Baseline project permissions (read-only git, vendored skills enabled)

**Acceptance Criteria:**
- [ ] File exists at specified path
- [ ] All 8 vendored skills granted permission
- [ ] forge-rd-pipeline NOT included (not vendored)
- [ ] Git permissions read-only (status, diff, log)
- [ ] MCP servers disabled by default

---

#### 2.1.5 bin/forge-sync

**Path:** `/Users/leonardknight/kv-projects/FORGE/bin/forge-sync`

**Content:**
```bash
#!/usr/bin/env bash
# bin/forge-sync — Update project-local agent pack to latest FORGE version
# Usage: ./bin/forge-sync /path/to/project
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
FORGE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 /path/to/project" >&2
    exit 1
fi

PROJECT_ROOT="$1"
if [[ ! -d "$PROJECT_ROOT" ]]; then
    echo "ERROR: Project directory not found: $PROJECT_ROOT" >&2
    exit 1
fi

if [[ ! -d "$PROJECT_ROOT/.claude" ]]; then
    echo "ERROR: Project does not have .claude/ directory. Not a FORGE project?" >&2
    exit 1
fi

# Read current version
CURRENT_VERSION="unknown"
if [[ -f "$PROJECT_ROOT/.claude/VERSION" ]]; then
    CURRENT_VERSION=$(grep "^FORGE_AGENT_PACK_VERSION=" "$PROJECT_ROOT/.claude/VERSION" | cut -d= -f2)
fi

# Read FORGE template version
FORGE_VERSION="unknown"
if [[ -f "$FORGE_ROOT/template/project/.claude/VERSION" ]]; then
    FORGE_VERSION=$(grep "^FORGE_AGENT_PACK_VERSION=" "$FORGE_ROOT/template/project/.claude/VERSION" | cut -d= -f2)
fi

echo "=== FORGE Agent Pack Sync ==="
echo "Project: $PROJECT_ROOT"
echo "Current version: $CURRENT_VERSION"
echo "FORGE version: $FORGE_VERSION"
echo ""

if [[ "$CURRENT_VERSION" == "$FORGE_VERSION" ]]; then
    echo "Project is already up-to-date."
    read -rp "Force sync anyway? [y/N] " confirm
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        echo "Aborted."
        exit 0
    fi
fi

echo "WARNING: This will overwrite project agents/skills with FORGE template versions."
echo "If you've customized agents, this may create merge conflicts."
echo ""
read -rp "Continue? [y/N] " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "Aborted."
    exit 0
fi

# Sync agents
echo ""
echo "Syncing agents..."
rsync -av --delete \
    "$FORGE_ROOT/template/project/.claude/agents/" \
    "$PROJECT_ROOT/.claude/agents/"

# Sync skills
echo ""
echo "Syncing skills..."
rsync -av --delete \
    "$FORGE_ROOT/template/project/.claude/skills/" \
    "$PROJECT_ROOT/.claude/skills/"

# Sync VERSION
echo ""
echo "Updating VERSION..."
cp "$FORGE_ROOT/template/project/.claude/VERSION" "$PROJECT_ROOT/.claude/VERSION"

# Sync README (with prompt)
if [[ -f "$PROJECT_ROOT/.claude/README.md" ]]; then
    read -rp "Overwrite .claude/README.md? [y/N] " ans
    if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
        cp "$FORGE_ROOT/template/project/.claude/README.md" "$PROJECT_ROOT/.claude/README.md"
        echo "  ✓ README.md updated"
    else
        echo "  - Skipped README.md"
    fi
else
    cp "$FORGE_ROOT/template/project/.claude/README.md" "$PROJECT_ROOT/.claude/README.md"
    echo "  ✓ README.md created"
fi

# Sync settings.json (merge, don't overwrite)
echo ""
echo "NOTE: settings.json NOT synced (project-specific)."
echo "If FORGE template added new skills, manually add to .claude/settings.json:"
echo "  grep 'Skill(' $FORGE_ROOT/template/project/.claude/settings.json"

echo ""
echo "=== Sync Complete ==="
echo "Updated to version: $FORGE_VERSION"
echo ""
echo "Next steps:"
echo "1. Review changes: git status"
echo "2. Test agents: restart Claude Code, invoke /forge-g"
echo "3. Commit if satisfied: git add .claude/ && git commit -m 'Sync FORGE agent pack to $FORGE_VERSION'"
```

**Purpose:** Automate project-level agent pack updates with version tracking

**Acceptance Criteria:**
- [ ] Script exists at specified path with execute permissions
- [ ] Script accepts one argument (project path)
- [ ] Script validates project has .claude/ directory
- [ ] Script shows version diff before sync
- [ ] Script prompts for confirmation
- [ ] Script uses rsync --delete for agents and skills
- [ ] Script does NOT overwrite settings.json (project-specific)
- [ ] Script provides post-sync instructions

---

### 2.2 Files to UPDATE

#### 2.2.1 template/project/FORGE-AUTONOMY.yml

**Path:** `/Users/leonardknight/kv-projects/FORGE/template/project/FORGE-AUTONOMY.yml`

**Change:**
```yaml
# Add after line 8 (after template_version)
template_version: "2.0"
external_project: true  # NEW LINE

# Autonomy tier determines routing behavior
```

**Rationale:** Vendored agents' Universal Startup Check requires this waiver to pass when project is outside FORGE/projects/ directory.

**Acceptance Criteria:**
- [ ] `external_project: true` field added after template_version
- [ ] No other changes to FORGE-AUTONOMY.yml
- [ ] YAML syntax valid

---

#### 2.2.2 template/project/.gitignore

**Path:** `/Users/leonardknight/kv-projects/FORGE/template/project/.gitignore`

**Change:**
```gitignore
# Add to "Misc" section (after line 72)
.vercel
.netlify
.metrics/
.claude/settings.local.json  # NEW LINE
```

**Rationale:** Exclude user-specific permission overrides from version control.

**Acceptance Criteria:**
- [ ] `.claude/settings.local.json` added to .gitignore
- [ ] Entry added to "Misc" section
- [ ] No other changes to .gitignore

---

#### 2.2.3 template/project/CLAUDE.md

**Path:** `/Users/leonardknight/kv-projects/FORGE/template/project/CLAUDE.md`

**Change:**
Add new section after "Project Identity" (after line 206) and before "Technical Stack":

```markdown
---

## FORGE Agents (Bundled)

This project includes FORGE agents in `.claude/` directory. All agents are immediately available — no setup required.

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
```

**Rationale:** Document that agents are project-local and version-pinned.

**Acceptance Criteria:**
- [ ] Section added after "Project Identity"
- [ ] Agent roster matches vendored agents
- [ ] Invocation methods documented
- [ ] Reference to .claude/README.md for details
- [ ] No other changes to CLAUDE.md

---

#### 2.2.4 FORGE/CLAUDE.md (FORGE repo root)

**Path:** `/Users/leonardknight/kv-projects/FORGE/CLAUDE.md`

**Changes:**

**Change 1:** Remove projects/ from "Quick Start" (line 12):
```markdown
**To start a new project:** Say "I want to build X" or run `/forge-a`
```
(No change needed — already generic)

**Change 2:** Update "Project Structure" section (lines 127-147):
```markdown
## Project Structure

FORGE projects live OUTSIDE the FORGE repo to maintain hard separation between methodology and work. When you spawn a project via @A (forge-architect), it creates a new directory with this layout:

```
~/forge-projects/<slug>/          ← Default spawn location (configurable)
├── abc/                           Pre-FORGE: Acquire, Brief, Commit
│   ├── INTAKE.md                  @A output
│   ├── BRIEF.md                   @B output (optional)
│   └── FORGE-ENTRY.md             @C output (gate artifact)
├── .claude/                       Vendored FORGE agent pack
│   ├── agents/                    9 agents (forge-a through forge-r, decision-logger)
│   ├── skills/                    8 skills (forge-a through forge-r)
│   ├── VERSION                    Agent pack version tracking
│   ├── README.md                  Roster + upgrade docs
│   └── settings.json              Baseline permissions
├── docs/
│   └── constitution/
│       ├── PRODUCT.md             Product intent
│       ├── TECH.md                Technical architecture
│       └── GOVERNANCE.md          Project governance
├── _forge/inbox/active/           Active work packets
├── _forge/inbox/done/             Completed work packets (ledger)
├── src/                           Source code
└── tests/                         Tests
```

**FORGE repo structure (`kv-projects/FORGE/`):**
```
FORGE/                             ← You are here
├── .claude/                       Agent + Skill definitions (FORGE-repo-only + vendored)
├── method/core/                   Canonical FORGE methodology (canon)
├── method/agents/                 Agent operating guides (canon)
├── method/templates/              Reusable templates (operational)
├── template/project/              Scaffold for new projects (operational)
├── _workspace/                    R&D workspace for evolving FORGE (non-canon)
├── bin/                           forge-install, forge-export, forge-sync
└── docs/                          Documentation
```

**Default spawn location:** `~/forge-projects/<slug>/` (configurable via FORGE config)

**Important:** FORGE repo does NOT contain user projects. Projects live externally. This hard separation ensures:
- FORGE repo remains clean (method + tooling only)
- Projects have independent git history
- Teams can clone projects without FORGE repo

Use `template/project/` as the scaffold for new projects. `@A` (forge-architect) handles spawn + instantiation.
```

**Change 3:** Update "Repo Map" section (lines 151-163):
```markdown
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
| `docs/` | Documentation, ADRs, guides | Documentation |

**Removed directories:**
- `projects/` — Deleted. Projects live outside FORGE repo (e.g., `~/forge-projects/`)
```

**Change 4:** Update "Customization → Global Install" section (lines 217-223):
```markdown
### Global Install (Optional)

For FORGE agents available globally (fallback when no project .claude/):

```bash
./bin/forge-install
```

**Note:** Spawned projects bundle agents in `.claude/`, so global install is optional. Useful for:
- Working outside FORGE projects
- Fallback when project lacks vendored agents
- Personal preference for global availability

**Agent resolution order:** Project `.claude/` > Global `~/.claude/`
```

**Acceptance Criteria:**
- [ ] projects/ directory removed from all documentation
- [ ] Default spawn location documented as ~/forge-projects/
- [ ] Project structure shows .claude/ vendored agents
- [ ] Repo map updated with "Removed directories" note
- [ ] Global install marked as optional with rationale
- [ ] Agent resolution order documented

---

### 2.3 Files to DELETE

#### 2.3.1 FORGE/projects/ (entire directory)

**Path:** `/Users/leonardknight/kv-projects/FORGE/projects/`

**Action:** Delete directory and all contents (if any exist)

**Rationale:** Hard separation between FORGE methodology and user projects. Projects must live outside FORGE repo.

**Acceptance Criteria:**
- [ ] Directory does not exist at /Users/leonardknight/kv-projects/FORGE/projects/
- [ ] Git status shows deletion (if directory was tracked)
- [ ] No references to projects/ in FORGE repo files (verified via grep)

---

### 2.4 Agents to COPY + ADAPT

For each agent, copy from `/Users/leonardknight/kv-projects/FORGE/.claude/agents/` to `/Users/leonardknight/kv-projects/FORGE/template/project/.claude/agents/` with modifications:

#### 2.4.1 forge-a.md

**Source:** `/Users/leonardknight/kv-projects/FORGE/.claude/agents/forge-a.md`
**Destination:** `/Users/leonardknight/kv-projects/FORGE/template/project/.claude/agents/forge-a.md`

**Modifications:**
1. Remove lines 64, 80 (references to "template/project")
2. Replace line 117 footer with GitHub URL:
   ```markdown
   *Operating guide: https://github.com/[org]/FORGE/blob/main/method/agents/forge-a-operating-guide.md*
   ```

**Acceptance Criteria:**
- [ ] File copied to destination
- [ ] template/project references removed
- [ ] Operating guide link replaced with GitHub URL
- [ ] No other changes

---

#### 2.4.2 forge-b.md

**Source:** `/Users/leonardknight/kv-projects/FORGE/.claude/agents/forge-b.md`
**Destination:** `/Users/leonardknight/kv-projects/FORGE/template/project/.claude/agents/forge-b.md`

**Modifications:**
1. Replace line 99 footer with GitHub URL:
   ```markdown
   *Operating guide: https://github.com/[org]/FORGE/blob/main/method/agents/forge-b-operating-guide.md*
   ```

**Acceptance Criteria:**
- [ ] File copied to destination
- [ ] Operating guide link replaced with GitHub URL
- [ ] No other changes

---

#### 2.4.3 forge-c.md

**Source:** `/Users/leonardknight/kv-projects/FORGE/.claude/agents/forge-c.md`
**Destination:** `/Users/leonardknight/kv-projects/FORGE/template/project/.claude/agents/forge-c.md`

**Modifications:**
1. Replace line 112 footer with GitHub URL:
   ```markdown
   *Operating guide: https://github.com/[org]/FORGE/blob/main/method/agents/forge-c-operating-guide.md*
   ```

**Acceptance Criteria:**
- [ ] File copied to destination
- [ ] Operating guide link replaced with GitHub URL
- [ ] No other changes

---

#### 2.4.4 forge-e.md

**Source:** `/Users/leonardknight/kv-projects/FORGE/.claude/agents/forge-e.md`
**Destination:** `/Users/leonardknight/kv-projects/FORGE/template/project/.claude/agents/forge-e.md`

**Modifications:**
1. Replace line 96 footer with GitHub URL:
   ```markdown
   *Operating guide: https://github.com/[org]/FORGE/blob/main/method/agents/forge-e-operating-guide.md*
   ```

**Acceptance Criteria:**
- [ ] File copied to destination
- [ ] Operating guide link replaced with GitHub URL
- [ ] No other changes

---

#### 2.4.5 forge-f.md

**Source:** `/Users/leonardknight/kv-projects/FORGE/.claude/agents/forge-f.md`
**Destination:** `/Users/leonardknight/kv-projects/FORGE/template/project/.claude/agents/forge-f.md`

**Modifications:**
1. Replace line 80 footer with GitHub URL:
   ```markdown
   *Operating guide: https://github.com/[org]/FORGE/blob/main/method/agents/forge-product-strategist-guide.md*
   ```

**Acceptance Criteria:**
- [ ] File copied to destination
- [ ] Operating guide link replaced with GitHub URL
- [ ] No other changes

---

#### 2.4.6 forge-g.md

**Source:** `/Users/leonardknight/kv-projects/FORGE/.claude/agents/forge-g.md`
**Destination:** `/Users/leonardknight/kv-projects/FORGE/template/project/.claude/agents/forge-g.md`

**Modifications:**
1. Replace line 149 footer with GitHub URL:
   ```markdown
   *Operating guide: https://github.com/[org]/FORGE/blob/main/method/agents/forge-g-operating-guide.md*
   ```

**Acceptance Criteria:**
- [ ] File copied to destination
- [ ] Operating guide link replaced with GitHub URL
- [ ] No other changes

---

#### 2.4.7 forge-o.md

**Source:** `/Users/leonardknight/kv-projects/FORGE/.claude/agents/forge-o.md`
**Destination:** `/Users/leonardknight/kv-projects/FORGE/template/project/.claude/agents/forge-o.md`

**Modifications:**
1. Replace line 82 footer with GitHub URL:
   ```markdown
   *Operating guide: https://github.com/[org]/FORGE/blob/main/method/agents/forge-o-operating-guide.md*
   ```

**Acceptance Criteria:**
- [ ] File copied to destination
- [ ] Operating guide link replaced with GitHub URL
- [ ] No other changes

---

#### 2.4.8 forge-r.md

**Source:** `/Users/leonardknight/kv-projects/FORGE/.claude/agents/forge-r.md`
**Destination:** `/Users/leonardknight/kv-projects/FORGE/template/project/.claude/agents/forge-r.md`

**Modifications:**
1. Replace line 86 footer with GitHub URL:
   ```markdown
   *Operating guide: https://github.com/[org]/FORGE/blob/main/method/agents/forge-r-operating-guide.md*
   ```

**Acceptance Criteria:**
- [ ] File copied to destination
- [ ] Operating guide link replaced with GitHub URL
- [ ] No other changes

---

#### 2.4.9 decision-logger.md

**Source:** `/Users/leonardknight/kv-projects/FORGE/.claude/agents/decision-logger.md`
**Destination:** `/Users/leonardknight/kv-projects/FORGE/template/project/.claude/agents/decision-logger.md`

**Modifications:** None required (no FORGE-repo-specific dependencies)

**Acceptance Criteria:**
- [ ] File copied to destination unchanged

---

### 2.5 Skills to COPY

For each skill, copy entire directory from `/Users/leonardknight/kv-projects/FORGE/.claude/skills/` to `/Users/leonardknight/kv-projects/FORGE/template/project/.claude/skills/`:

#### 2.5.1 forge-a/

**Source:** `/Users/leonardknight/kv-projects/FORGE/.claude/skills/forge-a/`
**Destination:** `/Users/leonardknight/kv-projects/FORGE/template/project/.claude/skills/forge-a/`

**Modifications:** None (Universal Startup Check preserved, external_project waiver handles location check)

**Acceptance Criteria:**
- [ ] Directory copied to destination
- [ ] SKILL.md exists
- [ ] No __pycache__ or build artifacts
- [ ] Universal Startup Check intact

---

#### 2.5.2 forge-b/

**Source:** `/Users/leonardknight/kv-projects/FORGE/.claude/skills/forge-b/`
**Destination:** `/Users/leonardknight/kv-projects/FORGE/template/project/.claude/skills/forge-b/`

**Modifications:** None

**Acceptance Criteria:**
- [ ] Directory copied to destination
- [ ] SKILL.md exists
- [ ] No build artifacts

---

#### 2.5.3 forge-c/

**Source:** `/Users/leonardknight/kv-projects/FORGE/.claude/skills/forge-c/`
**Destination:** `/Users/leonardknight/kv-projects/FORGE/template/project/.claude/skills/forge-c/`

**Modifications:** None

**Acceptance Criteria:**
- [ ] Directory copied to destination
- [ ] SKILL.md exists
- [ ] No build artifacts

---

#### 2.5.4 forge-e/

**Source:** `/Users/leonardknight/kv-projects/FORGE/.claude/skills/forge-e/`
**Destination:** `/Users/leonardknight/kv-projects/FORGE/template/project/.claude/skills/forge-e/`

**Modifications:** None

**Acceptance Criteria:**
- [ ] Directory copied to destination
- [ ] SKILL.md exists
- [ ] No build artifacts

---

#### 2.5.5 forge-f/

**Source:** `/Users/leonardknight/kv-projects/FORGE/.claude/skills/forge-f/`
**Destination:** `/Users/leonardknight/kv-projects/FORGE/template/project/.claude/skills/forge-f/`

**Modifications:** None

**Acceptance Criteria:**
- [ ] Directory copied to destination
- [ ] SKILL.md exists
- [ ] No build artifacts

---

#### 2.5.6 forge-g/

**Source:** `/Users/leonardknight/kv-projects/FORGE/.claude/skills/forge-g/`
**Destination:** `/Users/leonardknight/kv-projects/FORGE/template/project/.claude/skills/forge-g/`

**Modifications:** None

**Acceptance Criteria:**
- [ ] Directory copied to destination
- [ ] SKILL.md exists
- [ ] No build artifacts

---

#### 2.5.7 forge-o/

**Source:** `/Users/leonardknight/kv-projects/FORGE/.claude/skills/forge-o/`
**Destination:** `/Users/leonardknight/kv-projects/FORGE/template/project/.claude/skills/forge-o/`

**Modifications:** None

**Acceptance Criteria:**
- [ ] Directory copied to destination
- [ ] SKILL.md exists
- [ ] No build artifacts

---

#### 2.5.8 forge-r/

**Source:** `/Users/leonardknight/kv-projects/FORGE/.claude/skills/forge-r/`
**Destination:** `/Users/leonardknight/kv-projects/FORGE/template/project/.claude/skills/forge-r/`

**Modifications:** None

**Acceptance Criteria:**
- [ ] Directory copied to destination
- [ ] SKILL.md exists
- [ ] No build artifacts

---

### 2.6 Additional Agent Updates (forge-architect)

#### 2.6.1 Update forge-architect agent

**Path:** `/Users/leonardknight/kv-projects/FORGE/.claude/agents/forge-architect.md`

**Changes Required:**
1. Update spawn location logic to default to `~/forge-projects/<slug>/`
2. Add configuration for custom spawn root
3. Add HARD STOP if user attempts to spawn inside FORGE repo

**Specification:**
Add to "Workflow" section (after project name collection):

```markdown
### Spawn Location Determination

1. **Default:** `~/forge-projects/<slug>/`
2. **Custom:** If user provides explicit path, validate it
3. **HARD STOP:** If path is inside FORGE repo:
   - Detect: Check if path starts with `$FORGE_ROOT` or contains `kv-projects/FORGE/`
   - Error: "Cannot spawn project inside FORGE repo. FORGE = method, Projects = external. Spawn location must be outside FORGE repo."
   - Suggest: "Use default ~/forge-projects/<slug>/ or specify different path."

**Validation:**
- Path must not be inside FORGE repo
- Path must be writable
- Parent directory must exist

**Config file:** Future enhancement. For now, hardcode `~/forge-projects/` default.
```

Update "MAY DO" section to include external spawn validation.

**Acceptance Criteria:**
- [ ] Default spawn location is ~/forge-projects/<slug>/
- [ ] HARD STOP if spawn path inside FORGE repo
- [ ] Error message explains hard separation requirement
- [ ] No changes to template instantiation logic (still copies from template/project/)

---

#### 2.6.2 Update forge-architect skill

**Path:** `/Users/leonardknight/kv-projects/FORGE/.claude/skills/forge-architect/SKILL.md`

**Changes Required:**
Same as agent (sync SKILL.md with agent .md changes)

**Acceptance Criteria:**
- [ ] SKILL.md workflow matches agent .md
- [ ] spawn location validation logic consistent

---

## 3. Implementation Order

### Phase 0: Pre-flight
- [ ] Verify FORGE repo clean (no uncommitted changes in method/core/)
- [ ] Verify template/project/ current state matches spec assumptions
- [ ] Create feature branch: `feat/agent-skill-distribution-model`

### Phase 1: Create template/.claude/ structure
- [ ] Create `template/project/.claude/` directory
- [ ] Create `template/project/.claude/agents/` directory
- [ ] Create `template/project/.claude/skills/` directory
- [ ] Create VERSION file
- [ ] Create README.md
- [ ] Create REQUIRED_PLUGINS.md
- [ ] Create settings.json

### Phase 2: Copy and adapt agents
- [ ] Copy forge-a.md with modifications (remove template/project refs, replace URL)
- [ ] Copy forge-b.md with modifications (replace URL)
- [ ] Copy forge-c.md with modifications (replace URL)
- [ ] Copy forge-e.md with modifications (replace URL)
- [ ] Copy forge-f.md with modifications (replace URL)
- [ ] Copy forge-g.md with modifications (replace URL)
- [ ] Copy forge-o.md with modifications (replace URL)
- [ ] Copy forge-r.md with modifications (replace URL)
- [ ] Copy decision-logger.md unchanged

### Phase 3: Copy skills
- [ ] Copy forge-a/ skill
- [ ] Copy forge-b/ skill
- [ ] Copy forge-c/ skill
- [ ] Copy forge-e/ skill
- [ ] Copy forge-f/ skill
- [ ] Copy forge-g/ skill
- [ ] Copy forge-o/ skill
- [ ] Copy forge-r/ skill
- [ ] Verify no __pycache__ or build artifacts

### Phase 4: Update template files
- [ ] Add `external_project: true` to template/project/FORGE-AUTONOMY.yml
- [ ] Add `.claude/settings.local.json` to template/project/.gitignore
- [ ] Add "FORGE Agents (Bundled)" section to template/project/CLAUDE.md

### Phase 5: Kill FORGE/projects/
- [ ] Delete FORGE/projects/ directory entirely
- [ ] Verify deletion via `ls -la /Users/leonardknight/kv-projects/FORGE/` (no projects/)

### Phase 6: Update FORGE repo docs
- [ ] Update FORGE/CLAUDE.md "Project Structure" section
- [ ] Update FORGE/CLAUDE.md "Repo Map" section
- [ ] Update FORGE/CLAUDE.md "Global Install" section
- [ ] Verify no remaining references to projects/ via grep

### Phase 7: Update forge-architect
- [ ] Update .claude/agents/forge-architect.md with spawn location logic
- [ ] Update .claude/skills/forge-architect/SKILL.md with spawn location logic
- [ ] Test validation: attempt spawn inside FORGE repo (should HARD STOP)

### Phase 8: Create bin/forge-sync
- [ ] Create bin/forge-sync script
- [ ] Set executable permissions: `chmod +x bin/forge-sync`
- [ ] Test dry-run on template/project/ itself (should detect as FORGE template)

### Phase 9: Verification
- [ ] Run Sacred Four on FORGE repo (if applicable)
- [ ] Verify all files created
- [ ] Verify all files updated correctly
- [ ] Verify FORGE/projects/ deleted
- [ ] Verify no broken links in documentation
- [ ] Count agents: 9 in template/.claude/agents/
- [ ] Count skills: 8 in template/.claude/skills/
- [ ] Verify settings.json has 8 skill permissions (no forge-rd-pipeline)
- [ ] Verify VERSION file format
- [ ] Test spawn: Create minimal test project via forge-architect (external location)
- [ ] Test agent invocation in spawned project: `/forge-g` should work

### Phase 10: Documentation
- [ ] Update CHANGELOG.md with feature summary
- [ ] Document upgrade path for existing projects (manual .claude/ copy or bin/forge-sync)
- [ ] Commit with message: "Vendor FORGE agent pack into template/project/, kill FORGE/projects/ (hard separation)"

---

## 4. Acceptance Criteria (Binary PASS/FAIL)

### AC-001: Directory Structure
- [ ] PASS: `template/project/.claude/` exists
- [ ] PASS: `template/project/.claude/agents/` contains exactly 9 .md files
- [ ] PASS: `template/project/.claude/skills/` contains exactly 8 directories
- [ ] PASS: FORGE/projects/ does NOT exist

### AC-002: Agent Roster
- [ ] PASS: forge-a.md vendored with template/project references removed
- [ ] PASS: forge-b.md vendored with GitHub URL footer
- [ ] PASS: forge-c.md vendored with GitHub URL footer
- [ ] PASS: forge-e.md vendored with GitHub URL footer
- [ ] PASS: forge-f.md vendored with GitHub URL footer
- [ ] PASS: forge-g.md vendored with GitHub URL footer
- [ ] PASS: forge-o.md vendored with GitHub URL footer
- [ ] PASS: forge-r.md vendored with GitHub URL footer
- [ ] PASS: decision-logger.md vendored unchanged
- [ ] PASS: forge-rd.md NOT vendored (excluded)

### AC-003: Skill Roster
- [ ] PASS: forge-a/, forge-b/, forge-c/, forge-e/, forge-f/, forge-g/, forge-o/, forge-r/ vendored
- [ ] PASS: forge-rd-pipeline/ NOT vendored (excluded)
- [ ] PASS: No __pycache__ or build artifacts in skills/

### AC-004: Configuration Files
- [ ] PASS: VERSION file exists with semver format and upgrade docs URL
- [ ] PASS: README.md documents 9 agents, 8 skills, exclusions, upgrade workflow
- [ ] PASS: REQUIRED_PLUGINS.md documents ralph-wiggum, frontend-design
- [ ] PASS: settings.json grants 8 skill permissions (no forge-rd-pipeline)
- [ ] PASS: settings.json git permissions read-only (status, diff, log)

### AC-005: Template Updates
- [ ] PASS: FORGE-AUTONOMY.yml contains `external_project: true`
- [ ] PASS: .gitignore excludes `.claude/settings.local.json`
- [ ] PASS: CLAUDE.md documents local .claude/ as agent source

### AC-006: FORGE Repo Updates
- [ ] PASS: FORGE/CLAUDE.md removes projects/ from structure
- [ ] PASS: FORGE/CLAUDE.md documents external spawn location
- [ ] PASS: FORGE/CLAUDE.md marks global install as optional
- [ ] PASS: forge-architect.md includes spawn location validation
- [ ] PASS: forge-architect HARD STOPs on FORGE-repo-internal spawn

### AC-007: Tooling
- [ ] PASS: bin/forge-sync exists with execute permissions
- [ ] PASS: bin/forge-sync validates project has .claude/ directory
- [ ] PASS: bin/forge-sync prompts for confirmation
- [ ] PASS: bin/forge-install unchanged (preserves global install workflow)

### AC-008: Verification
- [ ] PASS: `grep -r "projects/" FORGE/CLAUDE.md` returns ONLY documentation explaining removal
- [ ] PASS: Spawned test project can invoke `/forge-g` successfully
- [ ] PASS: Universal Startup Check passes in spawned project (external_project waiver works)
- [ ] PASS: Operating guide URLs resolve to GitHub (manual click test)

### AC-009: Size Constraints
- [ ] PASS: Total .claude/ directory size < 5MB (expected ~70KB for 9 agents + 8 skills)

### AC-010: No Regressions
- [ ] PASS: bin/forge-install still works (global install unchanged)
- [ ] PASS: bin/forge-export still works (FORGE repo export unchanged)
- [ ] PASS: FORGE repo agents still function (source unchanged)

---

## 5. Risks & Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Operating guide URLs break if FORGE repo moves | LOW | LOW | Use relative GitHub URLs (org placeholder), document in .claude/README.md that URLs may need update if FORGE moves |
| Universal Startup Check fails if external_project waiver not added | HIGH | LOW | Add waiver to template/project/FORGE-AUTONOMY.yml (CR-004) BEFORE copying agents |
| Users customize vendored agents, upgrade overwrites | MEDIUM | MEDIUM | bin/forge-sync uses rsync --delete with warning. Recommend settings.local.json for permissions, not agent edits |
| Claude Code doesn't load project .claude/ reliably | CRITICAL | LOW | Industry-standard behavior, low risk. If fails, rollback + investigate. Document assumption in README.md |
| forge-architect spawn validation breaks existing workflows | MEDIUM | LOW | Only affects new spawns. Existing projects unaffected. Validation only prevents FORGE-repo-internal spawn |
| Existing spawned projects lack vendored agents | LOW | HIGH | Expected. Document manual upgrade via bin/forge-sync or copy. Not a bug — older templates didn't bundle |

---

## 6. Dependencies

### 6.1 Prerequisites
- [ ] FORGE repo clean (no uncommitted method/core/ changes)
- [ ] forge-architect agent/skill exist (for update)
- [ ] bin/forge-install exists (to preserve)
- [ ] GitHub URL placeholder `[org]` replaced with actual org name before finalization

### 6.2 Downstream Impacts
- **Existing spawned projects:** Will NOT auto-receive vendored agents. Require manual upgrade via bin/forge-sync or copy.
- **RecallTech BOLO project:** Should be upgraded via bin/forge-sync after this work-item completes.
- **Global ~/.claude/ install:** Becomes optional fallback. Update onboarding docs to clarify spawned projects bundle agents.
- **FORGE documentation:** Update any references to "install agents globally" to "bundled by default, global optional".

### 6.3 No Cross-Repo Coordination Required
All changes contained within FORGE repo.

---

## 7. Out of Scope

### 7.1 Explicitly Excluded
- **Portable project-rd:** Future work-item. forge-rd-pipeline excluded from vendored pack for now.
- **Automated project upgrade:** bin/forge-sync is manual. No auto-detection/upgrade mechanism.
- **Multi-version agent pack support:** Projects vendor single version. No version negotiation or multi-version coexistence.
- **forge-architect customization of agent pack:** All spawned projects receive identical agent pack. No per-project agent selection.
- **GitHub org name finalization:** Spec uses `[org]` placeholder. Replace before commit.

### 7.2 Future Enhancements
- **Agent pack marketplace:** Publish agent pack as standalone artifact (not just template bundling)
- **Delta upgrades:** bin/forge-sync currently full overwrite. Future: smart merge with conflict detection
- **Project-level forge-rd:** Portable R&D pipeline for spawned projects (requires sub-agent portability)
- **Config-driven spawn location:** Currently hardcoded `~/forge-projects/`. Future: FORGE config file

---

## 8. Definition of Done

**Doc changes:**
- [ ] Correct markdown in all new/updated files
- [ ] All GitHub URLs valid (placeholder `[org]` replaced)
- [ ] No broken links
- [ ] Consistent terminology (agent pack, vendored, spawned project)
- [ ] CHANGELOG.md updated if significant

**Structural changes:**
- [ ] template/project/.claude/ exists with correct structure
- [ ] FORGE/projects/ deleted
- [ ] All file counts match spec (9 agents, 8 skills)

**Functional changes:**
- [ ] Spawned test project agents work (manual test: `/forge-g`)
- [ ] Universal Startup Check passes in spawned project
- [ ] bin/forge-sync executes without errors
- [ ] forge-architect prevents FORGE-repo-internal spawn

**Quality:**
- [ ] No Sacred Four (FORGE repo is doc-focused, no Sacred Four defined)
- [ ] All acceptance criteria PASS
- [ ] No regressions (bin/forge-install, bin/forge-export work)

---

*Specification complete. Ready for proposal synthesis.*
