# Inventory: 2026-02-12-remove-abc-from-template

## Source Material

| File | Size | Type | Source |
|------|------|------|--------|
| README.md | ~10KB | Work-item spec | _workspace/00_inbox/remove-abc-from-template/ |

## Supplementary Context (from conversation)

- Leo + Jordan conversation: abc removal rationale, 4-gate lifecycle design
- Previous smoke test results from template-simplification work-item (PASS)
- Agent/skill inventory from exploration (29 global agents, 10 FORGE repo agents)

## Affected Files (from README.md)

### DELETE (4 files)
- `template/project/abc/README.md`
- `template/project/abc/INTAKE.md.template`
- `template/project/abc/BRIEF.md.template`
- `template/project/abc/FORGE-ENTRY.md.template`

### UPDATE (9 files)
- `template/project/FORGE-AUTONOMY.yml` (remove forge_entry, add lifecycle_gates)
- `template/project/CLAUDE.md` (remove abc refs, add gate chain)
- `method/agents/forge-g-operating-guide.md` (remove abc gate, add Gate 4)
- `method/agents/forge-e-operating-guide.md` (remove abc pre-flight, add Gate 4)
- `.claude/skills/forge-f/SKILL.md` (add Gate 1 enforcement)
- `.claude/skills/forge-o/SKILL.md` (add Gate 2 enforcement)
- `.claude/skills/forge-r/SKILL.md` (add Gate 3 enforcement)
- `.claude/skills/forge-g/SKILL.md` (remove abc gating, add Gate 4)
- `.claude/skills/forge-e/SKILL.md` (remove abc pre-flight, add Gate 4)

### CREATE (1 file)
- `projects/.gitignore` (prevent project data syncing to FORGE repo)

## Canon Impact
- **None.** method/core/ explicitly excluded from scope.

## Feature Count
- **Single feature.** Cohesive scope: abc removal + gate replacement + gitignore.
