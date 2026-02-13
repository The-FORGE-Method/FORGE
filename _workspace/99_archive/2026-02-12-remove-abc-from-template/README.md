# Work-Item: Remove abc/ from Project Template + Replace Gate with Lifecycle Gates + Add projects/.gitignore

## Intent

`abc/` is pre-project / pre-commitment. It should not ship inside `template/project/`. Every spawned project currently gets an `abc/` folder that implies A.B.C is part of the project's ongoing lifecycle — it is not. A.B.C happens before a project exists, inside the FORGE repo or a conversation. Once you spawn, you've committed.

Remove `abc/` from the template. Replace the old `forge_entry` gate with a proper 4-gate lifecycle structure. Add a `.gitignore` for `projects/` so contributors don't sync their projects back to FORGE.

**Important:** A.B.C agents remain available inside spawned projects for feature-level intake — you remove the folder, not the agents. New features within a running project still benefit from @A (intake), @B (sensemaking), @C (commitment).

## Problem Statement

1. `template/project/abc/` ships with every spawned project, including:
   - `README.md` (describes A.B.C as pre-FORGE lifecycle)
   - `INTAKE.md.template`, `BRIEF.md.template`, `FORGE-ENTRY.md.template`
2. `FORGE-AUTONOMY.yml` references `abc/FORGE-ENTRY.md` as a gating artifact:
   ```yaml
   forge_entry:
     required_file: "abc/FORGE-ENTRY.md"
     unlock_on_approval: true
   ```
3. Template `CLAUDE.md` references `abc/` in Key Locations table and has a full "Gating: A.B.C -> F.O.R.G.E" section
4. Multiple agent operating guides and skills reference `abc/FORGE-ENTRY.md` as a gate check
5. **No `projects/.gitignore` exists** — contributors who fork FORGE could accidentally push their project data back upstream
6. **No formal lifecycle gates exist** — The old gate was a single file-existence check. It should be replaced with a proper gate chain that enforces readiness at each phase.

**Root cause:** A.B.C was designed as a pre-project intake process, but was physically co-located in the project template, creating confusion about when it runs and what it means. The gate was too coarse (one binary check) instead of progressive.

## The Gate Problem (Critical) + Replacement

### Old gate (remove)

- Agents check `abc/FORGE-ENTRY.md` exists → if yes, F.O.R.G.E agents unlock
- If no → agents refuse to run ("FORGE not unlocked. Complete @C first.")

**Decision: Remove `forge_entry` from FORGE-AUTONOMY.yml entirely.**

Spawning from the template IS the commitment. Constitution emptiness already triggers a STOP in agent behavior ("If empty or missing: STOP. Request inputs from Human Lead."), which is a better gate — it checks for actual readiness, not a ceremonial file.

### New gate structure (encode)

Replace the single abc gate with a 4-gate lifecycle chain. These encode the natural rhythm Jordan + Leo defined:

```
Gate 1: PRD Lock        — @F stops until PRODUCT.md meets checklist
Gate 2: Architecture    — @O only proceeds after Gate 1; produces TECH.md + PR plan
Gate 3: Coherence       — @R verifies PRD ↔ plan alignment before execution
Gate 4: Execution Loop  — @G creates PR packets, @E executes, Human approves each
```

#### Gate 1 — PRD Lock (inside repo)
- **Owner:** @F
- **Trigger:** User invokes @F or says "define the product"
- **Enforces:** @F STOPs until PRODUCT.md contains:
  - Product description (what + why)
  - Actors / user types
  - Use cases (minimum 1)
  - MVP definition
  - Success criteria
- **Gate artifact:** `docs/constitution/PRODUCT.md` is non-empty and has all required sections
- **If not met:** @F refuses to pass. Instructs human to complete PRODUCT.md.

#### Gate 2 — Architecture + PR Plan Lock
- **Owner:** @O
- **Trigger:** User invokes @O after Gate 1 passes
- **Prerequisite:** Gate 1 passed (PRODUCT.md meets checklist)
- **Enforces:** @O STOPs until TECH.md contains:
  - Stack / architecture decisions
  - Data model outline
  - API contracts (if applicable)
  - Build plan → PR0..PRn series
- **Gate artifact:** `docs/constitution/TECH.md` is non-empty and has all required sections
- **If not met:** @O refuses to pass. If Gate 1 not met, redirects to @F first.

#### Gate 3 — Coherence Review
- **Owner:** @R
- **Trigger:** User invokes @R after Gate 2 passes
- **Prerequisite:** Gates 1 + 2 passed
- **Enforces:** @R checks:
  - Does O's plan build F's product?
  - Missing use cases?
  - Sequencing risks?
  - Constraint conflicts?
- **Gate artifact:** @R produces a review report (can be inline or in packet)
- **If issues found:** Fix loop back to @F or @O as needed. @R does not pass until coherence verified.

#### Gate 4 — Execution Loop (PR Packets)
- **Owner:** @G (prep) + @E (execute)
- **Trigger:** User says "build it" or invokes @G/@E
- **Prerequisite:** Gates 1-3 passed (or explicitly bypassed by Human Lead)
- **Enforces:**
  - @G creates packet in `_forge/inbox/active/<slug>/`
  - @G creates branch + PR shell
  - @G produces handoff.md for @E
  - Human approves (`approved: true` in packet.yml)
  - @E implements tests-first
  - Sacred Four must pass
  - Human merges PR
  - Packet moves to `done/`
- **Repeat:** PR1...PRn per build plan

### Encoding the gates

Gates should be encoded in two places:

1. **`FORGE-AUTONOMY.yml`** — Add a `lifecycle_gates` section replacing `forge_entry`:
   ```yaml
   lifecycle_gates:
     gate_1_prd:
       agent: F
       artifact: "docs/constitution/PRODUCT.md"
       required_sections: ["description", "actors", "use_cases", "mvp", "success_criteria"]
     gate_2_architecture:
       agent: O
       artifact: "docs/constitution/TECH.md"
       requires: gate_1_prd
       required_sections: ["stack", "data_model", "build_plan"]
     gate_3_coherence:
       agent: R
       requires: gate_2_architecture
     gate_4_execution:
       agent: [G, E]
       requires: gate_3_coherence
       packet_path: "_forge/inbox/active/"
   ```

2. **Agent operating guides / skills** — Each agent checks its gate prerequisite:
   - @O checks PRODUCT.md is populated before proceeding
   - @R checks TECH.md is populated before reviewing
   - @G/@E check that a coherence review has been done (or Human Lead explicitly bypasses)

**Note:** These are progressive gates, not hard blocks. Human Lead can always say "skip Gate 3, we're confident" — the system asks, it doesn't prevent.

## Background

Current `abc/README.md` literally says:
> "This directory contains artifacts from the pre-FORGE lifecycle — the intake, sensemaking, and commitment phases that occur **before** the FORGE lifecycle (F.O.R.G.E) begins."

If it happens BEFORE the project, it shouldn't be IN the project.

A.B.C agents (@A, @B, @C) and their skills remain in the FORGE repo and in spawned projects (via the agent pack — see companion packet) for feature-level intake. They just don't need a dedicated `abc/` folder.

## Scope

### Must Do
- Remove `template/project/abc/` entirely (4 files)
- Update `template/project/FORGE-AUTONOMY.yml`:
  - Remove the entire `forge_entry` section (lines 17-20)
  - Add `lifecycle_gates` section with Gates 1-4 definitions
- Update `template/project/CLAUDE.md`:
  - Remove `abc/` from Key Locations table (line 61)
  - Replace "Gating: A.B.C -> F.O.R.G.E" section (lines 156-159) with new lifecycle gates description
  - Keep A.B.C in Agent Lanes table (they're still valid agents for feature-level intake)
  - Update any language that implies abc/ is a local project folder
- Update `method/agents/forge-g-operating-guide.md`:
  - Remove abc/FORGE-ENTRY.md from structural verification
  - Add Gate 4 enforcement (packet exists, approved, branch created)
- Update `method/agents/forge-e-operating-guide.md`:
  - Remove abc/FORGE-ENTRY.md from pre-flight
  - Add Gate 4 prerequisite check (packet approved, handoff exists)
- Update `.claude/skills/forge-g/SKILL.md`: remove abc gating, add lifecycle gate checks
- Update `.claude/skills/forge-e/SKILL.md`: remove abc pre-flight, add Gate 4 checks
- Update `.claude/skills/forge-f/SKILL.md`: add Gate 1 enforcement (PRODUCT.md checklist)
- Update `.claude/skills/forge-o/SKILL.md`: add Gate 2 enforcement (requires Gate 1, TECH.md checklist)
- Update `.claude/skills/forge-r/SKILL.md`: add Gate 3 enforcement (requires Gate 2, coherence check)
- **Add `projects/.gitignore`** to the FORGE repo root with:
  ```
  # Project repos are local — never sync back to FORGE
  *
  !.gitignore
  !_registry.json
  ```

### Must Not
- Remove A.B.C agents/skills from FORGE repo or project pack (they're used for feature-level intake)
- Change src/, tests/, supabase/
- Modify method/core/ (no canon changes)
- Make gates absolute hard-blocks (Human Lead can always bypass with explicit instruction)

### Open Question
- Should the FORGE repo keep an `abc/` folder at its root level for the A.B.C agents to use during pre-project intake? Or does A.B.C purely use FORGE's `_workspace/00_inbox/`?
  - **Leaning:** A.B.C should remain as agent tooling only (`.claude/agents/` + `.claude/skills/`). The abc/ folder structure is only needed temporarily during intake conversations, not permanently in any repo. The agents can create a transient workspace in `_workspace/` if needed.

## Files Affected

| File | Action |
|------|--------|
| `template/project/abc/README.md` | DELETE |
| `template/project/abc/INTAKE.md.template` | DELETE |
| `template/project/abc/BRIEF.md.template` | DELETE |
| `template/project/abc/FORGE-ENTRY.md.template` | DELETE |
| `template/project/FORGE-AUTONOMY.yml` | UPDATE (remove forge_entry, add lifecycle_gates) |
| `template/project/CLAUDE.md` | UPDATE (remove abc refs, add gate chain description) |
| `method/agents/forge-g-operating-guide.md` | UPDATE (remove abc gate, add Gate 4) |
| `method/agents/forge-e-operating-guide.md` | UPDATE (remove abc pre-flight, add Gate 4) |
| `.claude/skills/forge-f/SKILL.md` | UPDATE (add Gate 1 enforcement) |
| `.claude/skills/forge-o/SKILL.md` | UPDATE (add Gate 2 enforcement) |
| `.claude/skills/forge-r/SKILL.md` | UPDATE (add Gate 3 enforcement) |
| `.claude/skills/forge-g/SKILL.md` | UPDATE (remove abc gating, add Gate 4) |
| `.claude/skills/forge-e/SKILL.md` | UPDATE (remove abc pre-flight, add Gate 4) |
| `projects/.gitignore` | CREATE (prevent project data syncing to FORGE repo) |

## Acceptance Criteria (PASS/FAIL)

- [ ] Spawned project contains NO `abc/` folder
- [ ] FORGE-AUTONOMY.yml has no reference to `abc/FORGE-ENTRY.md` and no `forge_entry` section
- [ ] FORGE-AUTONOMY.yml has `lifecycle_gates` section with Gates 1-4 defined
- [ ] Template CLAUDE.md has no `abc/` paths in Key Locations
- [ ] Template CLAUDE.md describes the 4-gate lifecycle chain
- [ ] @F enforces Gate 1: STOPs if PRODUCT.md missing required sections
- [ ] @O enforces Gate 2: checks PRODUCT.md populated before proceeding to TECH.md
- [ ] @R enforces Gate 3: checks TECH.md populated before coherence review
- [ ] @G/@E enforce Gate 4: packet exists, approved, handoff present
- [ ] All gates are advisory (Human Lead can explicitly bypass)
- [ ] A.B.C agents/skills remain available (for feature-level intake within projects)
- [ ] `projects/.gitignore` exists and excludes all project content except `_registry.json`
- [ ] Smoke test: spawn template → @F populates PRODUCT.md → @O populates TECH.md → @R reviews → @G creates packet → @E executes

## Stop Conditions

- If any agent relies on `abc/FORGE-ENTRY.md` as a critical runtime dependency (beyond the gate check), STOP and produce a compatibility plan.
- If gate encoding creates agent deadlocks (e.g., circular dependencies), STOP and simplify.
- If gates become hard blocks that prevent Human Lead from working, STOP and ensure bypass mechanism works.

## Materials

- Current abc/README.md content (pre-FORGE lifecycle description)
- FORGE-AUTONOMY.yml gating config (lines 17-20)
- Template CLAUDE.md (lines 61, 156-159)
- v2.0 template simplification context (just completed, smoke test passed)
- Jordan + Leo conversation re: gate removal + 4-gate lifecycle design
- Jordan's gate chain spec: Gate 0 (spawn) → Gate 1 (PRD) → Gate 2 (Architecture) → Gate 3 (Coherence) → Gate 4 (Execution)

---

*Part of the FORGE v2.0 Lean template evolution. Companion packet: agent-skill-distribution-model.*
