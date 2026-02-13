# Clarifying Questions: 2026-02-13-agent-skill-distribution-model

## Answered

| ID | Question | Answer |
|----|----------|--------|
| Q1 | Universal Startup Check handling? | C — Keep check + add `external_project: true` to template FORGE-AUTONOMY.yml |
| Q2 | Ship forge-rd + forge-rd-pipeline? | B — Don't ship (FORGE-repo-only). Hard deps on _workspace/, method/core/, sub-agents. Consider portable project-rd agent later (don't block this packet). |
| Q3 | Operating guide footer links? | B — Replace with GitHub URLs |
| Q4 | Add external_project: true to template? | A — Yes |
| Q5 | New bin/forge-sync or extend forge-install? | A — New script bin/forge-sync |
| Q6 | Document adding specialist agents? | A — Yes |
| Q7 | Git permissions in settings.json? | A — Read-only safe default |
| Q8 | Remove forge-a template/project references? | A — Remove |
| Q9 | VERSION file content? | B — Version + upgrade docs link |
| Q10 | Ship @A/@B/@C pre-FORGE agents? | B — Include all (feature-level intake) |

## Additional Directives (from Human Lead + Jordan)

**D1: Kill FORGE/projects/ entirely**
- Projects must NEVER be created inside the FORGE repository
- Hard separation: FORGE = method, Projects = external
- Default spawn root: `~/forge-projects/` (configurable)
- Hard stop in forge-architect if user tries to spawn inside FORGE
- Remove `FORGE/projects/` directory and all references
- Prevents accidental IP exposure via git push to public FORGE repo

**D2: Portable project-rd (future)**
- If excluding forge-rd reduces "team completeness" feeling, create lightweight `project-rd.md` that only operates on project-local surfaces (`docs/constitution/` + `_forge/inbox/`)
- Zero dependencies on FORGE repo infra
- Do NOT block this packet on project-rd — it's a follow-up item
