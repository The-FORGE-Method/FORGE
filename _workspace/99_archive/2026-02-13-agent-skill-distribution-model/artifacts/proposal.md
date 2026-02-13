---
title: Agent-Skill Distribution Model — Approval Proposal
date: 2026-02-13
version: v1.0
status: Ready for Approval
author: SpecWriter Agent
tags: [forge, agents, distribution, proposal]
---

# Agent-Skill Distribution Model — Approval Proposal

## Summary

Vendor FORGE core agents and skills into every spawned project by adding `.claude/` to `template/project/`. Kill `FORGE/projects/` directory entirely — projects must live outside FORGE repo (default: `~/forge-projects/`). This makes FORGE agents immediately available to teammates who clone a project, eliminates manual setup friction, and enforces hard separation between methodology (FORGE repo) and work (spawned projects).

**Final roster:** 9 agents (forge-a through forge-r, decision-logger), 8 skills (forge-a through forge-r). Excludes forge-rd/forge-rd-pipeline (FORGE-repo-only).

---

## What Changes

| File/Directory | Action | Summary |
|----------------|--------|---------|
| `template/project/.claude/` | CREATE | Entire directory with agents/, skills/, VERSION, README.md, REQUIRED_PLUGINS.md, settings.json |
| `template/project/.claude/agents/` | CREATE | 9 agent .md files (forge-a through forge-r, decision-logger) with GitHub URL footers |
| `template/project/.claude/skills/` | CREATE | 8 skill directories (forge-a through forge-r) copied from FORGE repo |
| `template/project/.claude/VERSION` | CREATE | Version tracking file (1.0.0) with upgrade docs link |
| `template/project/.claude/README.md` | CREATE | Roster documentation, upgrade workflow, specialist agent installation guide |
| `template/project/.claude/REQUIRED_PLUGINS.md` | CREATE | Marketplace plugin documentation (ralph-wiggum, frontend-design) |
| `template/project/.claude/settings.json` | CREATE | Baseline permissions (8 skills, read-only git) |
| `template/project/FORGE-AUTONOMY.yml` | UPDATE | Add `external_project: true` waiver (line 9) |
| `template/project/.gitignore` | UPDATE | Add `.claude/settings.local.json` to exclusions |
| `template/project/CLAUDE.md` | UPDATE | Add "FORGE Agents (Bundled)" section after "Project Identity" |
| `FORGE/projects/` | DELETE | Entire directory removed (hard separation: FORGE = method, projects = external) |
| `FORGE/CLAUDE.md` | UPDATE | Remove projects/ from structure, document external spawn, mark global install optional |
| `FORGE/.claude/agents/forge-architect.md` | UPDATE | Add spawn location validation (default ~/forge-projects/, HARD STOP if inside FORGE repo) |
| `FORGE/.claude/skills/forge-architect/SKILL.md` | UPDATE | Sync with agent .md spawn location logic |
| `bin/forge-sync` | CREATE | Script for project-level agent pack updates (rsync-based, version-aware) |
| `bin/forge-install` | PRESERVE | No changes (global install remains optional fallback) |

**Total new files:** 13 (VERSION, README.md, REQUIRED_PLUGINS.md, settings.json, 9 agent .md files)
**Total new directories:** 9 (.claude/, agents/, skills/, 8 skill folders)
**Total deleted:** 1 directory (projects/)

---

## Implementation Order

### Phase 1: Create Structure
1. Create `template/project/.claude/` with subdirectories (agents/, skills/)
2. Create VERSION, README.md, REQUIRED_PLUGINS.md, settings.json

### Phase 2: Vendor Agents
3. Copy 9 agents from FORGE/.claude/agents/ with modifications:
   - forge-a: Remove template/project references (lines 64, 80), replace footer URL
   - forge-b through forge-r: Replace footer URLs with GitHub links
   - decision-logger: Copy unchanged
4. Exclude forge-rd.md (FORGE-repo-only)

### Phase 3: Vendor Skills
5. Copy 8 skill directories from FORGE/.claude/skills/ unchanged
6. Verify no __pycache__ or build artifacts
7. Exclude forge-rd-pipeline/ (FORGE-repo-only)

### Phase 4: Update Template
8. Add `external_project: true` to FORGE-AUTONOMY.yml
9. Add `.claude/settings.local.json` to .gitignore
10. Add "FORGE Agents (Bundled)" section to CLAUDE.md

### Phase 5: Kill projects/ + Update FORGE Docs
11. Delete FORGE/projects/ directory entirely
12. Update FORGE/CLAUDE.md (remove projects/, document external spawn)
13. Update forge-architect agent/skill (spawn location validation)

### Phase 6: Tooling + Verification
14. Create bin/forge-sync script with execute permissions
15. Run verification checklist (9 agents, 8 skills, no projects/, spawn test)
16. Update CHANGELOG.md

---

## Acceptance Criteria (Binary)

### Structure
- [ ] `template/project/.claude/agents/` contains exactly 9 .md files
- [ ] `template/project/.claude/skills/` contains exactly 8 directories
- [ ] `FORGE/projects/` does NOT exist

### Configuration
- [ ] VERSION file exists with semver format and upgrade URL
- [ ] settings.json grants 8 skill permissions (excludes forge-rd-pipeline)
- [ ] FORGE-AUTONOMY.yml contains `external_project: true`
- [ ] .gitignore excludes `.claude/settings.local.json`

### Agents
- [ ] forge-a.md has template/project references removed
- [ ] All 9 agents have GitHub URLs in footer (not method/agents/ paths)
- [ ] forge-rd.md NOT vendored (excluded)

### Skills
- [ ] All 8 skills copied unchanged (Universal Startup Check preserved)
- [ ] forge-rd-pipeline/ NOT vendored (excluded)
- [ ] No __pycache__ or build artifacts

### FORGE Repo
- [ ] `grep -r "projects/" FORGE/CLAUDE.md` returns ONLY removal explanation
- [ ] forge-architect HARD STOPs on FORGE-repo-internal spawn attempts
- [ ] bin/forge-sync exists with execute permissions
- [ ] bin/forge-install unchanged (preserves global install)

### Functional
- [ ] Spawned test project can invoke `/forge-g` successfully
- [ ] Universal Startup Check passes in spawned project (external_project waiver works)
- [ ] Operating guide GitHub URLs resolve (manual verification)

### Size
- [ ] Total `.claude/` directory < 5MB (expected ~70KB)

---

## Risks & Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Universal Startup Check fails without waiver | HIGH | Add `external_project: true` to template/project/FORGE-AUTONOMY.yml BEFORE copying agents |
| Users customize agents, upgrade overwrites | MEDIUM | bin/forge-sync warns before overwrite. Recommend settings.local.json for permissions |
| Operating guide URLs break if FORGE moves | LOW | Use placeholder `[org]` in spec, replace before commit. Document in README.md |
| Claude Code doesn't load project .claude/ | CRITICAL | Industry-standard behavior, low likelihood. Rollback if fails. Document assumption |
| Existing projects lack vendored agents | LOW | Expected. Document manual upgrade via bin/forge-sync. Not a regression |

**Stop condition:** If spawned test project cannot invoke agents after Phase 6, STOP and investigate Claude Code agent resolution order.

---

## Out of Scope

### Excluded from This Work-Item
- **Portable project-rd:** forge-rd-pipeline excluded. Future work-item addresses project-level R&D.
- **Automated upgrade detection:** bin/forge-sync is manual. No auto-detection of outdated agent packs.
- **Multi-version support:** Projects vendor single version. No version negotiation.
- **Per-project agent selection:** All spawned projects receive identical agent pack.

### Future Enhancements
- Agent pack marketplace distribution (not just template bundling)
- Delta upgrades (smart merge vs full overwrite)
- Config-driven spawn location (currently hardcoded ~/forge-projects/)
- Project-level portable R&D pipeline

---

## Decision Required

### Primary Decision
**Approve vendoring FORGE agent pack into template/project/ with hard separation (projects live outside FORGE repo)?**

Options:
- **APPROVE:** Proceed with implementation per spec
- **REVISE:** Request changes (specify)
- **REJECT:** Maintain global-install-only distribution

### Secondary Decisions (Implicit Approvals via Default Answers)
All questions from recon report answered with defaults:
- Q1: Keep Universal Startup Check + external_project waiver (APPROVED)
- Q2: Exclude forge-rd/forge-rd-pipeline (APPROVED)
- Q3: Replace operating guide links with GitHub URLs (APPROVED)
- Q4: Add external_project: true to template (APPROVED)
- Q5: New bin/forge-sync script (APPROVED)
- Q6: Document adding specialists in README.md (APPROVED)
- Q7: Read-only git permissions in settings.json (APPROVED)
- Q8: Remove forge-a template/project references (APPROVED)
- Q9: VERSION file with version + upgrade link (APPROVED)
- Q10: Include @A/@B/@C (APPROVED)

---

## Implementation Notes

### Critical Path
1. Create .claude/ structure FIRST
2. Add external_project: true to template/FORGE-AUTONOMY.yml BEFORE copying agents
3. Copy agents with URL modifications
4. Copy skills unchanged
5. Delete projects/ and update docs
6. Verify spawn test LAST

### Testing Strategy
**Spawn test (required before approval):**
1. Use forge-architect to spawn minimal project to ~/forge-projects/test-spawn/
2. cd into spawned project
3. Invoke `/forge-g` (should load project-local agent)
4. Verify Universal Startup Check passes (external_project waiver)
5. Verify operating guide URLs resolve to GitHub

**Regression test:**
1. Run bin/forge-install (should still work, install to ~/.claude/)
2. Verify FORGE repo agents still functional

### Rollback Plan
If spawn test fails:
1. Revert template/project/.claude/ changes
2. Revert FORGE/projects/ deletion (restore from git)
3. Investigate Claude Code agent resolution behavior
4. Document findings and propose alternative distribution model

---

## Definition of Done

**Structural:**
- [ ] template/project/.claude/ exists with 9 agents, 8 skills
- [ ] FORGE/projects/ deleted
- [ ] All file counts match spec

**Functional:**
- [ ] Spawned test project agents work (`/forge-g` succeeds)
- [ ] Universal Startup Check passes in spawned project
- [ ] forge-architect prevents FORGE-repo-internal spawn
- [ ] bin/forge-sync executes without errors

**Documentation:**
- [ ] All markdown correct, no broken links
- [ ] GitHub URL placeholder `[org]` replaced
- [ ] CHANGELOG.md updated

**Quality:**
- [ ] All acceptance criteria PASS
- [ ] No regressions (bin/forge-install, bin/forge-export work)
- [ ] Total .claude/ size < 5MB

---

## Approval Requested

**Human Lead:** Review this proposal and provide decision.

**If APPROVED:** Proceed to implementation (est. 2-3 hours for manual file operations + verification).

**If REVISIONS NEEDED:** Specify changes and re-synthesize.

---

*Proposed by SpecWriter Agent — 2026-02-13*
*Detailed specification: `synthesis.md`*
