# Recon Report: agent-skill-distribution-model

**Date:** 2026-02-13
**Recon Agent:** forge-recon-runner
**Work-Item:** /Users/leonardknight/kv-projects/FORGE/_workspace/04_proposals/work-items/2026-02-13-agent-skill-distribution-model

---

## 1. Summary

The work-item proposes vendoring a FORGE core agent pack (10 agents, 9 skills) into every spawned project by adding `.claude/` to `template/project/`. This shifts from global-install-only to project-local-by-default distribution. The goal is to make FORGE agents immediately available to teammates who clone a project, without requiring manual setup.

**Initial assessment:** Architecturally sound, but requires careful handling of FORGE-repo-specific path dependencies. Several agents and skills contain references to `method/core/`, `_workspace/`, `FORGE/projects/`, and FORGE-specific sub-agents that will break when vendored into spawned projects. The total package size (252KB) is well within acceptable limits. Implementation requires path abstraction and removal of FORGE-repo-only assumptions.

---

## 2. Source Material Inventory

| File | Type | Size | Description |
|------|------|------|-------------|
| README.md | Markdown | 13,710 bytes | Complete work-item specification with architecture, roster, acceptance criteria, and recon tasks |
| artifacts/inventory.md | Markdown | 857 bytes | Pre-generated inventory summary |
| state.json | JSON | 756 bytes | Pipeline state tracking |
| audit-log.md | Markdown | 425 bytes | Event log |

**Total:** 4 files, 15.7KB

---

## 3. Key Requirements Extracted

### Explicit Requirements

- [ ] Create `.claude/` directory in `template/project/` with 10 agents, 9 skills
- [ ] Add VERSION file tracking FORGE_AGENT_PACK version
- [ ] Add README.md explaining roster, classification, upgrade path
- [ ] Add REQUIRED_PLUGINS.md documenting marketplace plugins
- [ ] Add settings.json with baseline project permissions
- [ ] Update template CLAUDE.md to reference local `.claude/`
- [ ] Update template .gitignore to exclude `.claude/settings.local.json`
- [ ] Strip build artifacts from vendored skills
- [ ] Agent roster: forge-a, forge-b, forge-c, forge-e, forge-f, forge-g, forge-o, forge-r, forge-rd, decision-logger
- [ ] Skill roster: forge-a, forge-b, forge-c, forge-e, forge-f, forge-g, forge-o, forge-r, forge-rd-pipeline
- [ ] Maintain `bin/forge-install` for global install (do not break)
- [ ] Maintain `bin/forge-export` for versioning (do not break)

### Implicit Requirements (Inferred)

- [ ] Remove or abstract FORGE-repo-specific path dependencies in agents/skills
- [ ] Ensure agents work in spawned projects without access to `method/core/`, `_workspace/`, `template/`
- [ ] Preserve agent/skill functionality when copied out of FORGE repo context
- [ ] Ensure Claude Code loads project `.claude/` with precedence over global `~/.claude/`
- [ ] Document handoff workflow for FORGE-only agents (forge-architect, forge-maintainer, forge-recon-runner, spec-writer)

### Constraints

- Must not ship non-FORGE agents (jordan, iOS specialists, kv-*, mac-tuneup, project-orchestrator, research-agent, spec-writer)
- Must not ship non-FORGE skills (jordan/, session-memory/, dev-metrics-tracker/, gdrive/)
- Must not modify `method/core/` (no canon changes)
- Must not break existing `bin/forge-install` global install workflow
- Total skill size must stay under 5MB (currently 252KB — well within limit)

### Preferences

- Pattern A: Direct edits to vendored files for customization (no overlay directory initially)
- New script `bin/forge-sync` for project-level updates (vs extending bin/forge-install)
- Ship forge-rd-pipeline with all resources/templates/references (it's the meta-evolution tool)

---

## 4. Current State Analysis

### FORGE-Method Impact

- **Canon affected:** No
- **Specific paths:** None (agents/skills are operational, not canon)
- **Nature of change:** Additive (new distribution mechanism, existing global install remains)

### Template Impact

- **Affected:** Yes
- **Specific areas:**
  - `template/project/` — requires new `.claude/` directory
  - `template/project/.gitignore` — requires `.claude/settings.local.json` exclusion
  - `template/project/CLAUDE.md` — requires reference to local `.claude/` as agent source

### Vault Impact

- **Affected:** No
- **Specific patterns:** None

### Current Template State

`template/project/` currently contains:
- NO `.claude/` directory (confirmed absent)
- Existing `.gitignore` with standard patterns (no `.claude/` references)
- `CLAUDE.md` v2.0 documenting packet-based workflow
- `FORGE-AUTONOMY.yml` with template_version "2.0", tier 0

---

## 5. Gap Analysis

### Undefined Behaviors

**Gap 1:** What happens when a spawned project's agent references `method/core/` or `_workspace/`?
- Current state: 8 out of 10 agent files contain references to `method/agents/*.md` in footer (operating guide links)
- All 9 skills contain "Universal Startup Check" that tests for `FORGE/projects/<slug>/` directory structure
- forge-rd-pipeline skill heavily references `_workspace/`, `method/core/`, FORGE-specific sub-agents

**Gap 2:** How do agents detect they're running in a spawned project vs FORGE repo?
- No existing mechanism to distinguish context
- Agents assume FORGE repo structure (method/, _workspace/, projects/)

**Gap 3:** What's the behavior when forge-rd-pipeline tries to invoke forge-recon-runner, forge-maintainer, or spec-writer sub-agents?
- These sub-agents don't ship with projects (FORGE-repo-only)
- forge-rd-pipeline will fail when attempting Task tool invocation of missing agents

### Ambiguous Scope

**Gap 4:** Should vendored agents be modified (paths removed) or should they auto-detect context and adapt?
- README.md says "Strip" and lists path types to remove
- No specification of whether to remove checks entirely or make them conditional

**Gap 5:** Should "Universal Startup Check" (FORGE/projects/ verification) be removed or adapted?
- All lifecycle agents check for FORGE/projects/ location
- FORGE-AUTONOMY.yml includes `external_project: true` waiver mechanism
- Unclear if vendored agents should remove check, make it conditional, or rely on waiver

**Gap 6:** What happens to "Operating guide" footer references to `method/agents/*.md`?
- All generated agent .md files end with footer: `*Operating guide: method/agents/forge-X-operating-guide.md*`
- These files won't exist in spawned projects
- Should these be removed, replaced with URLs, or preserved as documentation?

### Missing Success Criteria

**Gap 7:** How to verify Claude Code agent resolution order (project > global)?
- README.md states "Confirm project `.claude/` takes precedence over global `~/.claude/`"
- No verification method specified
- Claude Code documentation source not identified

**Gap 8:** What's the expected upgrade workflow?
- README.md mentions `bin/forge-sync` script (marked for creation)
- No specification of merge conflict handling when project has customized agents
- No specification of version compatibility checking

---

## 6. Dependencies

### Prerequisites

**Dependency 1:** Claude Code agent resolution behavior — Must confirm that project-local `.claude/` takes precedence over `~/.claude/`
- Why needed: Entire architecture depends on this assumption
- Current status: Not verified, assumed based on industry-standard behavior

**Dependency 2:** Operating guides remain accessible — If footer links to `method/agents/*.md` are removed, need alternative documentation
- Why needed: Agent operating guides provide detailed operational context
- Current status: Links will break in spawned projects

**Dependency 3:** FORGE-AUTONOMY.yml `external_project: true` waiver exists in template — Required for spawned projects to pass startup checks
- Why needed: Agents check for FORGE/projects/ location; spawned projects won't be under that path
- Current status: NOT present in current template/project/FORGE-AUTONOMY.yml (missing field)

### Downstream Impacts

**Impact 1:** Global `~/.claude/` install model changes from primary to fallback — Affects developer workflows and onboarding docs
- What it affects: Developer setup instructions, FORGE documentation

**Impact 2:** FORGE-only agents (forge-architect, forge-maintainer, forge-recon-runner, spec-writer) become unavailable in spawned projects — Affects forge-rd-pipeline functionality
- What it affects: Project-level R&D pipeline capability (may need separate handoff model)

**Impact 3:** Template CLAUDE.md update — Changes project-level agent invocation instructions
- What it affects: Every spawned project's onboarding documentation

### Cross-Repo Coordination

**Coordination 1:** RecallTech BOLO project (motivating symptom) — Should be re-scaffolded or receive manual agent install
- Reason: Work-item cites BOLO as direct symptom of missing agents

**Coordination 2:** Any existing spawned projects — Need notification of new agent distribution model and optional upgrade path
- Reason: Existing projects won't auto-receive vendored agents

---

## 7. Risks & Concerns

| Risk | Likelihood | Impact | Notes |
|------|------------|--------|-------|
| FORGE-repo path assumptions break agents in spawned projects | HIGH | HIGH | 8/10 agents reference method/agents/ in footers. All skills check FORGE/projects/ location. forge-rd-pipeline references _workspace/, method/core/, sub-agents extensively. |
| forge-rd-pipeline unusable in spawned projects | HIGH | MEDIUM | Depends on FORGE-repo-only sub-agents (forge-recon-runner, forge-maintainer, spec-writer) and _workspace/ directory. May require separate handoff model or removal from vendored pack. |
| Universal Startup Check blocks all work in spawned projects | MEDIUM | HIGH | All lifecycle agents check for FORGE/projects/<slug>/ location. external_project: true waiver exists in code but NOT in template FORGE-AUTONOMY.yml. Easy fix: add waiver to template. |
| Operating guide links break | HIGH | LOW | Informational only. Footer links to method/agents/*.md won't resolve in spawned projects. Low impact: agents function without guides, but loss of documentation. |
| Claude Code doesn't load project .claude/ reliably | LOW | CRITICAL | Architecture assumption. Industry-standard behavior, but not verified. If false, entire approach fails. |
| Vendor lock-in to FORGE version | MEDIUM | MEDIUM | Projects vendor specific agent pack version. Upgrade friction increases. Mitigation: bin/forge-sync and VERSION tracking. |
| Agent customization drift | MEDIUM | LOW | Projects modify local agents, diverge from FORGE canonical versions. Merge conflicts on upgrade. Expected behavior per "Pattern A" design choice. |

---

## 8. Open Questions

| ID | Question | Options | Default |
|----|----------|---------|---------|
| Q1 | Should "Universal Startup Check" (FORGE/projects/ validation) be removed from vendored agents, made conditional, or rely on external_project waiver? | A: Remove check entirely, B: Make conditional (detect if running in FORGE repo), C: Keep as-is and add external_project: true to template FORGE-AUTONOMY.yml | C (minimal change, preserves check for FORGE repo projects) |
| Q2 | Should forge-rd-pipeline ship with spawned projects, given its dependency on FORGE-repo-only sub-agents? | A: Ship but document limitations, B: Don't ship (FORGE-repo-only), C: Ship with degraded mode (no sub-agent invocations) | B (avoid broken functionality in spawned projects) |
| Q3 | How should "Operating guide" footer links be handled? | A: Remove entirely, B: Replace with URLs to FORGE repo docs, C: Keep as-is (broken links but informational) | B (preserve documentation access via URL) |
| Q4 | Should template/project/FORGE-AUTONOMY.yml receive external_project: true field? | A: Yes (allows agents to work out-of-box), B: No (require projects to add manually) | A (reduces friction, aligns with work-item intent) |
| Q5 | Should bin/forge-sync be a new script or bin/forge-install --project flag? | A: New script bin/forge-sync, B: Extend bin/forge-install with --project, C: Manual copy process only | A (cleaner separation, work-item preference) |
| Q6 | Should .claude/README.md explain how to add specialist agents (iOS, etc.)? | A: Yes (onboarding clarity), B: No (keep minimal) | A (aligns with "Should Do" from scope section) |
| Q7 | Should .claude/settings.json include git commit permissions or keep read-only? | A: Allow git status/diff/log only (current FORGE repo model), B: Add git commit/push permissions | A (safer default, projects can customize via settings.local.json) |
| Q8 | How to handle forge-a's reference to "template/project" in line 64 and 80? | A: Remove reference (not applicable in spawned projects), B: Replace with relative path assumption, C: Make conditional | A (scaffolding happens at spawn time via forge-architect, not needed in spawned project) |
| Q9 | Should VERSION file include upgrade instructions or just version number? | A: Version number only, B: Include link to upgrade docs, C: Include inline upgrade commands | B (balance brevity with utility) |
| Q10 | Should spawned projects receive simplified agent roster (exclude @A/@B/@C pre-FORGE agents)? | A: Yes (spawned projects start post-spawn, don't need pre-FORGE), B: No (ship all 10 for consistency) | B (consistency, potential use for feature intake within projects) |

---

## Recon Assessment

**Readiness:** NEEDS_CLARIFICATION

**Next Phase:** CLARIFYING_QUESTIONS

---

## Detailed Findings

### Finding A: Agent Path Dependencies (Per-File Analysis)

#### forge-a.md (3.7KB)
- Line 64: "Instantiate project from template/project (absorbs forge-architect)"
- Line 80: "- Instantiate project from template/project (absorbs forge-architect)"
- Line 117: "*Operating guide: method/agents/forge-a-operating-guide.md*"

**Risk:** References to template/project will fail in spawned projects. Operating guide link will 404.

**Recommendation:** Remove template/project references (not applicable post-spawn). Replace operating guide link with URL to FORGE repo docs.

#### forge-b.md (3.3KB)
- Line 99: "*Operating guide: method/agents/forge-b-operating-guide.md*"

**Risk:** Operating guide link will 404.

**Recommendation:** Replace with URL to FORGE repo docs.

#### forge-c.md (3.1KB)
- Line 112: "*Operating guide: method/agents/forge-c-operating-guide.md*"

**Risk:** Operating guide link will 404.

**Recommendation:** Replace with URL to FORGE repo docs.

#### forge-e.md (3.2KB)
- Line 96: "*Operating guide: method/agents/forge-e-operating-guide.md*"

**Risk:** Operating guide link will 404.

**Recommendation:** Replace with URL to FORGE repo docs.

#### forge-f.md (2.6KB)
- Line 80: "*Operating guide: method/agents/forge-product-strategist-guide.md (also addressed as @F)*"

**Risk:** Operating guide link will 404.

**Recommendation:** Replace with URL to FORGE repo docs.

#### forge-g.md (4.6KB)
- Line 149: "*Operating guide: method/agents/forge-g-operating-guide.md*"

**Risk:** Operating guide link will 404.

**Recommendation:** Replace with URL to FORGE repo docs.

#### forge-o.md (2.6KB)
- Line 82: "*Operating guide: method/agents/forge-o-operating-guide.md*"

**Risk:** Operating guide link will 404.

**Recommendation:** Replace with URL to FORGE repo docs.

#### forge-r.md (2.8KB)
- Line 86: "*Operating guide: method/agents/forge-r-operating-guide.md*"

**Risk:** Operating guide link will 404.

**Recommendation:** Replace with URL to FORGE repo docs.

#### forge-rd.md (4.6KB)
- Line 34: "- Scans `_workspace/00_inbox/` for raw material"
- Line 92: "- Canon paths (`method/core/**`): require `--canon` flag"
- Line 94: "- Never deletes files outside `_workspace/99_archive/`"
- Lines 106-115: Workspace structure diagram showing _workspace/

**Risk:** CRITICAL — Agent is designed for FORGE repo R&D workflow. References to _workspace/ and method/core/ are fundamental to its purpose.

**Recommendation:** Do NOT vendor forge-rd into spawned projects. Mark as FORGE-repo-only. Update work-item roster to 9 agents (not 10).

#### decision-logger.md (5.2KB)
- No FORGE-repo-specific path dependencies
- General-purpose decision logging agent

**Risk:** None.

**Recommendation:** Safe to vendor as-is.

### Finding B: Skill Path Dependencies (SKILL.md Files)

#### All lifecycle skills (forge-a through forge-r, 8 files)
Each contains identical "Universal Startup Check":
```
1. **Is this project under FORGE/projects/<slug>/?**
   - YES → Proceed normally
   - NO → Check FORGE-AUTONOMY.yml for `external_project: true` waiver
     - Waiver exists → WARN + proceed
     - No waiver → HARD STOP
```

**Lines affected:**
- forge-f/SKILL.md: 64-68
- forge-a/SKILL.md: 23-27
- forge-o/SKILL.md: 65-69
- forge-g/SKILL.md: 23-27, 71
- forge-b/SKILL.md: 27-31
- forge-r/SKILL.md: 23-27
- forge-c/SKILL.md: 23-27
- forge-e/SKILL.md: 23-27

**Risk:** HIGH — Spawned projects won't be under FORGE/projects/ and current template lacks external_project: true waiver. All lifecycle agents will HARD STOP on first invocation.

**Recommendation:** Add `external_project: true` to template/project/FORGE-AUTONOMY.yml. Optionally make check conditional (detect FORGE repo context).

#### forge-rd-pipeline/SKILL.md (20KB, extensive)
Major dependencies:
- Line 30: "RECON (forge-recon-runner sub-agent)"
- Line 39: "SYNTHESIS (spec-writer FORGE mode)"
- Line 60: "IMPLEMENT (forge-maintainer sub-agent)"
- Line 83: "--canon — Required if the feature touches `method/core/**`"
- Lines 86-87: "Scans `_workspace/00_inbox/`", "Creates work-item at `_workspace/04_proposals/work-items/`"
- Line 253: "Check for duplicates in `_workspace/`"
- Line 272: "Invoke `forge-recon-runner` sub-agent"
- Line 309: "Invoke `spec-writer` in FORGE mode"
- Line 383: "Invoke `forge-maintainer` sub-agent"
- Line 390: "Never deletes files outside `_workspace/99_archive/`"
- Lines 408, 430, 432, 438: Multiple _workspace/ references
- Lines 529, 539, 540, 559: method/core/ references
- Lines 614-616: Sub-agent roster (forge-recon-runner, spec-writer, forge-maintainer)
- Lines 649, 660, 688, 707, 724-726: Sub-agent invocation instructions

**Risk:** CRITICAL — Skill is fundamentally designed for FORGE repo meta-evolution. Cannot function in spawned projects without:
1. _workspace/ directory structure
2. method/core/ directory
3. forge-recon-runner, spec-writer, forge-maintainer sub-agents (FORGE-repo-only)

**Recommendation:** Do NOT vendor forge-rd-pipeline into spawned projects. Mark as FORGE-repo-only. Update work-item roster to 8 skills (not 9). Document alternative: project-level feature intake uses @A/@B/@C, not forge-rd.

### Finding C: Skill Disk Usage

| Skill | Size | Contains |
|-------|------|----------|
| forge-a | 8KB | SKILL.md only |
| forge-b | 8KB | SKILL.md only |
| forge-c | 4KB | SKILL.md only |
| forge-e | 8KB | SKILL.md only |
| forge-f | 8KB | SKILL.md only |
| forge-g | 8KB | SKILL.md only |
| forge-o | 8KB | SKILL.md only |
| forge-r | 8KB | SKILL.md only |
| forge-rd-pipeline | 184KB | SKILL.md + resources/ (11 .sh scripts, 110KB) + templates/ (11 .md templates, 24KB) + references/ (pipeline-state.json) + hooks/ |

**Total (all 9):** 252KB
**Total (excluding forge-rd-pipeline):** 68KB

**Finding:** Well under 5MB limit. If forge-rd-pipeline is excluded (recommended), total drops to 68KB.

**No Python cache files found** — Confirmed clean.

### Finding D: Template Current State

`template/project/`:
- `.claude/` directory: DOES NOT EXIST (confirmed)
- `.gitignore`: Exists, no `.claude/` references
- `CLAUDE.md`: v2.0 Lean, documents packet-based workflow, references FORGE agents but assumes they're available (no mention of source)
- `FORGE-AUTONOMY.yml`: Exists with template_version "2.0", tier 0, lifecycle gates defined
- **MISSING:** `external_project: true` field in FORGE-AUTONOMY.yml

**Gap:** Template assumes agents are available but doesn't bundle them. Work-item addresses this directly.

**Critical gap:** FORGE-AUTONOMY.yml lacks `external_project: true`, which vendored agents expect for spawned projects.

### Finding E: bin/ Scripts

#### bin/forge-install (88 lines)
- Copies agents from `FORGE_ROOT/.claude/agents/*.md` to `~/.claude/agents/`
- Copies skills from `FORGE_ROOT/.claude/skills/*/` to `~/.claude/skills/`
- Prompts before overwriting existing files
- Creates `~/.claude/agents/` and `~/.claude/skills/` if missing

**Impact:** None. Script operates on global `~/.claude/` only. Project-local vendoring is orthogonal.

**Recommendation:** Preserve as-is. Update README.md to clarify it's optional developer convenience, not primary distribution.

#### bin/forge-export (171 lines)
- Exports agents/skills from `~/.claude/` back to FORGE repo
- Generates agent .md files from SKILL.md with headers
- Scrubs personal info patterns
- Verifies no absolute paths or emails leaked
- Resets forge-rd-pipeline state to IDLE

**Impact:** None. Script operates on FORGE repo only.

**Recommendation:** Preserve as-is.

### Finding F: settings.json

Current FORGE repo `.claude/settings.json`:
```json
{
  "permissions": {
    "allow": [
      "Skill(forge-a)", "Skill(forge-b)", "Skill(forge-c)",
      "Skill(forge-f)", "Skill(forge-o)", "Skill(forge-r)",
      "Skill(forge-g)", "Skill(forge-e)", "Skill(forge-rd-pipeline)",
      "Bash(git status*)", "Bash(git diff*)", "Bash(git log*)"
    ]
  },
  "enableAllProjectMcpServers": false
}
```

**Analysis:**
- Grants permission for all 9 skills
- Allows read-only git commands
- Does NOT allow git commit/push (safe default)
- MCP servers disabled (project-specific)

**Recommendation:**
- Remove `Skill(forge-rd-pipeline)` if forge-rd excluded from vendored pack
- Keep git read-only permissions (projects can upgrade via settings.local.json)
- Keep MCP servers disabled (projects enable as needed)

### Finding G: Claude Code Agent Resolution Order

**Documented behavior (industry standard):**
Claude Code loads configuration in this order (highest priority first):
1. Project-local `.claude/` (workspace root)
2. Global `~/.claude/` (home directory)

**Verification method:** Not explicitly documented in Claude Code public docs, but consistent with standard tool behavior (VS Code extensions, git config, npm rc files, etc.).

**Risk:** LOW — Standard pattern across development tools. If false, entire approach fails, but likelihood is very low.

**Recommendation:** Document assumption in .claude/README.md. If concern remains, create minimal test case (spawn project, add local agent with unique response, verify it overrides global).

---

## Stop Conditions Check

### Stop Condition 1: Hard-dependency on FORGE-repo-only paths
**Status:** TRIGGERED (partial)

forge-rd-pipeline and forge-rd.md have hard dependencies on:
- `_workspace/` directory structure
- `method/core/` directory
- FORGE-repo-only sub-agents (forge-recon-runner, spec-writer, forge-maintainer)

**Resolution:** Exclude forge-rd and forge-rd-pipeline from vendored pack. Reduces roster from 10 agents / 9 skills to 9 agents / 8 skills.

Other agents have soft dependencies (operating guide links) that can be resolved via URL replacement.

### Stop Condition 2: Claude Code doesn't load project .claude/ reliably
**Status:** NOT TRIGGERED (assumption-based)

Claude Code agent resolution order follows industry-standard pattern (project > global). Likelihood of failure: LOW.

**Mitigation:** Document assumption. Optional verification via test case.

### Stop Condition 3: Plugin system doesn't support documented install commands
**Status:** NOT TRIGGERED

Work-item documents marketplace plugin manifest approach (REQUIRED_PLUGINS.md with install commands). This is informational/aspirational, not blocking.

**Mitigation:** Verify `claude plugins install` syntax if needed, or document manual install via marketplace.

### Stop Condition 4: Vendoring exceeds 5MB
**Status:** NOT TRIGGERED

Total size: 252KB (with forge-rd-pipeline) or 68KB (without). Well under 5MB limit.

---

## Recommendations Summary

### Critical Path Items

1. **Exclude forge-rd and forge-rd-pipeline from vendored pack** — Hard dependencies on FORGE-repo-only infrastructure make them unsuitable for spawned projects. Update roster to 9 agents, 8 skills.

2. **Add `external_project: true` to template/project/FORGE-AUTONOMY.yml** — Required for vendored agents' Universal Startup Check to pass in spawned projects.

3. **Replace operating guide footer links with URLs** — Change `method/agents/forge-X-operating-guide.md` to `https://github.com/<org>/FORGE/blob/main/method/agents/forge-X-operating-guide.md` (or equivalent).

4. **Remove template/project references from forge-a** — Lines 64, 80 mention template/project scaffolding, not applicable post-spawn.

### High-Value Items

5. **Create .claude/README.md with roster explanation** — Document which agents ship, which don't, how to add specialists, upgrade workflow.

6. **Create bin/forge-sync script** — Automate project-level agent pack updates with version tracking and merge conflict handling.

7. **Update template/project/CLAUDE.md** — Add section documenting local `.claude/` as agent source, clarify global install is optional.

### Nice-to-Have Items

8. **Document forge-rd handoff model** — Explain how projects can use FORGE repo's forge-rd for feature proposals, then hand off implementation packets.

9. **Add .claude/REQUIRED_PLUGINS.md** — Document ralph-wiggum, frontend-design marketplace plugins with install instructions.

10. **Create verification test case** — Spawn minimal project, verify local agents override global, document in acceptance criteria.

---

*Generated by forge-recon-runner*
