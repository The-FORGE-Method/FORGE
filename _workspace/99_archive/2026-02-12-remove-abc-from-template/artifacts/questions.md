# Clarifying Questions: 2026-02-12-remove-abc-from-template

## Answered

| ID | Question | Answer |
|----|----------|--------|
| Q1 | Should projects/README.md be allowed in the new .gitignore? | Yes — add `!README.md` exception |
| Q2 | Should gate checks be logged to git-native event logging? | Yes — log all gate checks (full audit trail) |
| Q3 | Should lifecycle_gates in FORGE-AUTONOMY.yml be active or schema-only? | Hybrid — YAML schema for docs, agents enforce via hardcoded logic, runtime YAML parsing deferred to Phase 2 |
| Q4 | How should @G detect Gate 1 (PRODUCT.md meets checklist)? | @F self-validates. If @F declares complete, @G trusts it. Aligns with Tier 0 routing. |
| Q5 | What replaces abc/FORGE-ENTRY.md in @G's structural verification? | Replace with "docs/constitution/PRODUCT.md exists and non-empty" check |
