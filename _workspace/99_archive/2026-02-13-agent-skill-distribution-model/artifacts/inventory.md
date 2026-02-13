# Inventory: 2026-02-13-agent-skill-distribution-model

## Source Material

| File | Size | Type | Description |
|------|------|------|-------------|
| `README.md` | 13,710 bytes | Markdown | Complete work-item spec: agent/skill vendoring model, roster, architecture, acceptance criteria |

**Total:** 1 file, 13.7KB

## Key Content Areas

- Intent: Ship FORGE core agent pack with every spawned project
- Architecture: Vendored .claude/ directory with VERSION pinning
- Agent roster: 10 agents (A/B/C/F/O/R/G/E + forge-rd + decision-logger)
- Skill roster: 9 folders (forge-a through forge-r + forge-rd-pipeline)
- Plugin manifest: ralph-wiggum, frontend-design (not vendored)
- Exclusion list: 19 agents stay global-only
- Acceptance criteria: 14 PASS/FAIL checks
- Recon tasks: 5 pre-implementation investigations
- Stop conditions: 4 hard stops defined
