# Recon Report: Remove abc/ from Template + Replace Gate with Lifecycle Gates

**Date:** 2026-02-13
**Recon Agent:** forge-recon-runner
**Work-Item:** _workspace/00_inbox/remove-abc-from-template/

---

## 1. Summary

This work-item removes the `abc/` folder from `template/project/` (4 files), replaces the single binary `forge_entry` gate with a progressive 4-gate lifecycle chain, updates all references across 8 agent files (operating guides + skills), and adds a `projects/.gitignore` to prevent project data from syncing back to the FORGE repo.

**Initial assessment:** Feasible and well-scoped. The abc/ folder exists and contains exactly 4 files as expected. All affected files are identified. No canon changes required (all updates are operational). The gate replacement is a significant behavioral change but architecturally sound — it shifts from a single file-existence check to progressive readiness gates at each FORGE phase.

**Critical finding:** The work-item correctly identifies that A.B.C agents remain available for feature-level intake within spawned projects. This is agent availability, not folder structure. Removing the folder does NOT remove the agents.

---

## 2. Source Material Inventory

| File | Type | Size | Description |
|------|------|------|-------------|
| README.md | Specification | 10KB | Work-item intent, problem statement, gate replacement design |

**Total:** 1 file, 10KB

**Additional discovery (not listed in work-item but critical):**

| File | Type | Status | Notes |
|------|------|--------|-------|
| template/project/abc/README.md | Template | EXISTS | 2,223 bytes — Pre-FORGE lifecycle description |
| template/project/abc/INTAKE.md.template | Template | EXISTS | 651 bytes — @A output template |
| template/project/abc/BRIEF.md.template | Template | EXISTS | 955 bytes — @B output template |
| template/project/abc/FORGE-ENTRY.md.template | Template | EXISTS | 780 bytes — Gate artifact template |
| projects/.gitignore | Config | MISSING | Does not exist — must be created |
| FORGE/.gitignore | Config | EXISTS | 27 lines — no projects/ exclusion currently |

---

## 3. Key Requirements Extracted

### Explicit Requirements
- [x] Delete `template/project/abc/` directory (4 files)
- [x] Remove `forge_entry` section from `template/project/FORGE-AUTONOMY.yml` (lines 17-20)
- [x] Add `lifecycle_gates` section to `FORGE-AUTONOMY.yml` with Gates 1-4 definitions
- [x] Update `template/project/CLAUDE.md` (remove abc/ refs, add gate chain description)
- [x] Update `method/agents/forge-g-operating-guide.md` (remove abc gate checks, add Gate 4)
- [x] Update `method/agents/forge-e-operating-guide.md` (remove abc pre-flight, add Gate 4)
- [x] Update `.claude/skills/forge-g/SKILL.md` (remove abc gating, add lifecycle gate logic)
- [x] Update `.claude/skills/forge-e/SKILL.md` (remove abc pre-flight, add Gate 4 checks)
- [x] Update `.claude/skills/forge-f/SKILL.md` (add Gate 1 enforcement — PRODUCT.md checklist)
- [x] Update `.claude/skills/forge-o/SKILL.md` (add Gate 2 enforcement — requires Gate 1, TECH.md checklist)
- [x] Update `.claude/skills/forge-r/SKILL.md` (add Gate 3 enforcement — requires Gate 2, coherence check)
- [x] Create `projects/.gitignore` with wildcard exclusion except `_registry.json`

### Implicit Requirements (Inferred)
- [x] Preserve A.B.C agent definitions in `.claude/agents/` (they're still needed for feature-level intake)
- [x] Preserve A.B.C skills in `.claude/skills/forge-a/`, `/forge-b/`, `/forge-c/` (same reason)
- [x] Update any documentation that references abc/ as a "required project folder" vs "pre-project phase"
- [x] Ensure gate language is advisory (Human Lead can bypass) not absolute (hard blocks)
- [x] Template CLAUDE.md should still list @A/@B/@C in Agent Lanes (they're valid agents)

### Constraints
- Must NOT remove A.B.C agents/skills from FORGE repo or spawned projects
- Must NOT modify `method/core/` (no canon changes)
- Must NOT make gates absolute hard-blocks (Human Lead can always bypass with explicit instruction)
- Must NOT change src/, tests/, supabase/ in template
- Gates must be progressive (each requires previous), not parallel

### Preferences
- Gate enforcement should be encoded in both FORGE-AUTONOMY.yml (schema) and agent logic (runtime)
- Gate checks should provide clear human instructions when not met
- A.B.C should remain available in FORGE repo for pre-project intake (agents only, no persistent abc/ folder)

---

## 4. Current State Analysis

### FORGE-Method Impact
- **Canon affected:** NO
- **Specific paths:** None — all changes are operational (template/, method/agents/, .claude/skills/)
- **Nature of change:** Operational refinement (template structure + gate mechanism)

### Template Impact
- **Affected:** YES
- **Specific areas:**
  - `template/project/abc/` — 4 files to DELETE
  - `template/project/FORGE-AUTONOMY.yml` — lines 17-20 DELETE, add lifecycle_gates section
  - `template/project/CLAUDE.md` — lines 61 (Key Locations), 156-159 (Gating section)

### Agent Operating Guides Impact
- **Affected:** YES
- **Specific files:**
  - `method/agents/forge-g-operating-guide.md` — Section 7.1a (structural verification after @C, lines 436-493), Section 6.1 (forge_entry field, line 336), Section 7.4 (transition-specific validation, lines 554-591)
  - `method/agents/forge-e-operating-guide.md` — Section 5.5 (pre-flight verification, Check 1 structure gate, line 288)

### Agent Skills Impact
- **Affected:** YES
- **Specific files:**
  - `.claude/skills/forge-g/SKILL.md` — Lines 37-46 (gating logic), lines 56-69 (transition-specific validation)
  - `.claude/skills/forge-e/SKILL.md` — Lines 37-46 (gating logic), lines 54-66 (pre-flight verification)
  - `.claude/skills/forge-f/SKILL.md` — Lines 78-93 (completion gate — needs Gate 1 checklist expansion)
  - `.claude/skills/forge-o/SKILL.md` — Lines 79-95 (completion gate — needs Gate 2 prerequisite + checklist)
  - `.claude/skills/forge-r/SKILL.md` — Lines 83-94 (completion gate — needs Gate 3 prerequisite enforcement)

### Projects Directory Impact
- **Affected:** YES
- **Action:** Create `projects/.gitignore` with wildcard exclusion
- **Current state:** No .gitignore exists in projects/
- **Risk:** Contributors could accidentally push project data to FORGE repo

---

## 5. Gap Analysis

### Undefined Behaviors
1. **Gate bypass syntax:** How does Human Lead explicitly bypass a gate?
   - **Recommendation:** "proceed without Gate N" or "skip Gate N" in natural language should work
   - **Encoding location:** Agent skills should detect this language

2. **Gate state persistence:** How do agents remember which gates have passed across sessions?
   - **Current mechanism:** File existence checks (PRODUCT.md exists → Gate 1 passed)
   - **Gap:** No explicit "gate status" field in FORGE-AUTONOMY.yml or packet.yml
   - **Mitigation:** Work-item design uses file existence + section completeness as implicit state (acceptable)

3. **Gate failure messaging:** What specific language should agents use when a gate is not met?
   - **Recommendation:** "Gate N not met: [missing item]. Complete [missing item] before proceeding, or say 'skip Gate N' to bypass."

### Ambiguous Scope
1. **abc/ folder in FORGE repo root:** The work-item asks whether FORGE itself should keep an `abc/` folder at root for pre-project intake. The answer is in the work-item ("Leaning: A.B.C should remain as agent tooling only"), but it's phrased as an "Open Question."
   - **Clarification needed:** This is actually already answered — A.B.C agents use `_workspace/00_inbox/` for intake, not a persistent abc/ folder. No abc/ folder should exist at FORGE root.

2. **Template CLAUDE.md gating section replacement:** The work-item says "replace" the gating section (lines 156-159) but doesn't specify the exact replacement text.
   - **Gap:** Synthesis/proposal phase will need to draft the new gating language.

### Missing Success Criteria
1. **Smoke test definition:** Work-item lists "smoke test: spawn template → @F → @O → @R → @G → @E" but doesn't define what "passing" looks like for each gate.
   - **Recommendation:** Add explicit smoke test criteria in proposal phase.

---

## 6. Dependencies

### Prerequisites
1. **v2.0 template simplification complete:** DONE (verified in git status — v2.0 template exists)
2. **FORGE-AUTONOMY.yml schema v0.2 stable:** DONE (template version 2.0 uses v0.2)
3. **Agent role addressing (Decision-005) active:** DONE (verified in agent skills — @F/@O/@R/@G/@E addressing is operational)

### Downstream Impacts
1. **All spawned projects get NO abc/ folder after this change:**
   - Impact: A.B.C workflow must happen in conversations or FORGE repo, not inside spawned projects
   - Mitigation: Agent availability is preserved (A/B/C agents still work for feature-level intake)

2. **Existing projects (pre-v2.0) retain abc/ folder:**
   - Impact: No breaking change for existing projects
   - Note: Work-item correctly scopes this to template changes only

3. **Gate failures will be more granular:**
   - Impact: Better failure messages ("PRODUCT.md missing actors" vs "FORGE not unlocked")
   - Benefit: Clearer human instructions

### Cross-Repo Coordination
- **None required:** All changes are within FORGE repo
- **Companion packet:** "agent-skill-distribution-model" is mentioned but independent (not a blocker)

---

## 7. Risks & Concerns

| Risk | Likelihood | Impact | Notes |
|------|------------|--------|-------|
| Gate logic creates agent deadlocks | LOW | HIGH | If Gate 1 requires Gate 0, but Gate 0 doesn't exist, agents could block. MITIGATION: Spawning from template IS Gate 0 (no separate check needed). |
| Human Lead bypass mechanism fails | MEDIUM | MEDIUM | If bypass language isn't detected, Human could be blocked. MITIGATION: Test bypass in smoke test, document exact phrasing. |
| A.B.C agents mistakenly removed | LOW | HIGH | If implementer misinterprets "remove abc/" as "remove A.B.C agents," feature-level intake breaks. MITIGATION: Work-item explicitly states agents remain. Highlight in proposal. |
| projects/.gitignore too broad | LOW | MEDIUM | Wildcard `*` exclusion could prevent valid files (e.g., projects/README.md updates). MITIGATION: Work-item specifies `!_registry.json` exception. Verify README.md is tracked. |
| Existing projects break after update | LOW | LOW | If existing projects rely on abc/ folder structure. MITIGATION: Changes only affect newly spawned projects. Existing projects grandfathered. |
| Gate state becomes inconsistent | MEDIUM | MEDIUM | If @F completes PRODUCT.md but gate isn't "marked passed," @O might re-check incorrectly. MITIGATION: File existence + section completeness is the gate state (no separate flag needed). |
| Structural verification checklist out of sync | MEDIUM | MEDIUM | If @G's structural verification still checks for abc/FORGE-ENTRY.md after deletion. MITIGATION: Update ALL references (recon found 40 files — comprehensive update required). |

---

## 8. Open Questions

**[If empty, write "No clarifying questions needed."]**

| ID | Question | Options | Default |
|----|----------|---------|---------|
| Q1 | Should `projects/README.md` be explicitly allowed in the new `.gitignore`? | A: Add `!README.md` exception, B: Exclude README.md (treat as project-specific), C: Allow manual commits of README.md outside normal workflow | A (allow README.md — it's FORGE-managed documentation) |
| Q2 | Should gates be logged to router-events in v2.0 git-native logging? | A: Yes, log all gate checks, B: No, gates are lightweight checks (no logging), C: Log only gate failures | A (log all — provides audit trail of readiness progression) |
| Q3 | Should the `lifecycle_gates` section in FORGE-AUTONOMY.yml be active (enforced) or schema-only (documented but not runtime-checked) in Phase 1? | A: Active enforcement (agents check YAML), B: Schema-only (agents use hardcoded logic, YAML is documentation), C: Hybrid (YAML schema exists, agents hardcode for now, runtime parsing in Phase 2) | C (schema exists for documentation, agents enforce via hardcoded checks, runtime parsing deferred to Phase 2) |
| Q4 | How should @G detect that PRODUCT.md "meets checklist" for Gate 1? | A: Parse PRODUCT.md sections (actors, use_cases, mvp, success_criteria), B: Rely on @F's self-validation (if @F says complete, it's complete), C: Human confirms "Gate 1 passed" explicitly | B (@F self-validates, @G trusts @F's completion signal — aligns with Tier 0 routing model) |
| Q5 | Should the structural verification checklist in @G's operating guide (lines 456-480) be updated to remove abc/FORGE-ENTRY.md check, or should it be replaced with "lifecycle gates passed" check? | A: Remove abc/FORGE-ENTRY.md, replace with "docs/constitution/PRODUCT.md exists and non-empty", B: Keep abc/FORGE-ENTRY.md check for grandfathered projects, add PRODUCT.md check for new projects, C: Remove structural verification entirely (gates replace it) | A (structural verification checks for PRODUCT.md existence, not abc/FORGE-ENTRY.md — cleaner gate model) |

---

## Recon Assessment

**Readiness:** READY

**Next Phase:** SYNTHESIS

**Rationale:** All source material is clear. The 5 open questions are refinements, not blockers. The work-item is well-scoped with explicit file paths, line numbers, and acceptance criteria. Gate design is architecturally sound (progressive gates, file-existence-based state, human-bypassable). Risk profile is acceptable (no HIGH/HIGH risks, mitigations identified for all MEDIUM risks).

**Recommendation:** Proceed to synthesis. Open questions can be resolved during synthesis or deferred to proposal review.

---

## Detailed Findings by File

### template/project/abc/ (DELETE — 4 files)

**Current structure:**
```
abc/
├── README.md              (2,223 bytes) — Pre-FORGE lifecycle description
├── INTAKE.md.template     (651 bytes) — @A output template
├── BRIEF.md.template      (955 bytes) — @B output template
└── FORGE-ENTRY.md.template (780 bytes) — Gate artifact template
```

**Action:** Delete entire directory

**Impact:** Spawned projects will NOT have abc/ folder. A.B.C workflow happens in FORGE repo or conversation, not inside spawned projects.

**Verification:** After deletion, `template/project/abc/` path should not exist.

---

### template/project/FORGE-AUTONOMY.yml (UPDATE — 2 changes)

**Current state (lines 17-20):**
```yaml
# Pre-FORGE gate: file that must exist to unlock F/O/R/G/E agents
forge_entry:
  required_file: "abc/FORGE-ENTRY.md"
  unlock_on_approval: true
```

**Change 1: DELETE lines 17-20** (remove entire `forge_entry` section)

**Change 2: ADD lifecycle_gates section** (insert after line 15, before `router:` section)

**Proposed addition (from work-item spec):**
```yaml
# Progressive lifecycle gates (v2.0 enforcement model)
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

**Line count impact:** DELETE 4 lines, ADD ~15 lines → net +11 lines

**Verification:**
- [ ] `forge_entry` section no longer exists
- [ ] `lifecycle_gates` section exists with 4 gates defined
- [ ] YAML is valid (no parse errors)

---

### template/project/CLAUDE.md (UPDATE — 3 locations)

**Location 1: Key Locations table (line 61)**

**Current (line 61):**
```markdown
| Pre-FORGE lifecycle | `abc/` |
```

**Change:** DELETE this line

**Verification:** Key Locations table should NOT reference abc/

---

**Location 2: Gating section (lines 156-159)**

**Current (lines 156-159):**
```markdown
### Gating: A.B.C -> F.O.R.G.E

- Before `abc/FORGE-ENTRY.md` exists: Only @A, @B, @C available
- After `abc/FORGE-ENTRY.md` exists: @F, @O, @R, @G, @E unlock
```

**Change:** REPLACE with new lifecycle gates description

**Proposed replacement (to be finalized in synthesis):**
```markdown
### Progressive Lifecycle Gates

FORGE uses 4 progressive gates to ensure readiness at each phase:

**Gate 1 — PRD Lock (@F)**
- Enforced by: @F
- Requirement: PRODUCT.md contains description, actors, use cases, MVP, success criteria
- Blocks: @O cannot proceed until Gate 1 passes

**Gate 2 — Architecture Lock (@O)**
- Enforced by: @O
- Prerequisite: Gate 1 passed
- Requirement: TECH.md contains stack, data model, build plan
- Blocks: @R cannot proceed until Gate 2 passes

**Gate 3 — Coherence Review (@R)**
- Enforced by: @R
- Prerequisite: Gate 2 passed
- Requirement: @R verifies PRODUCT ↔ TECH alignment
- Blocks: @G/@E cannot proceed until Gate 3 passes

**Gate 4 — Execution Loop (@G + @E)**
- Enforced by: @G and @E
- Prerequisite: Gate 3 passed
- Requirement: Approved packet exists in `_forge/inbox/active/`
- Process: @G creates packet → Human approves → @E executes → repeat per PR

**Human Lead can bypass any gate with explicit instruction.**
```

**Verification:**
- [ ] Old gating section removed
- [ ] New lifecycle gates section added
- [ ] All 4 gates documented
- [ ] Bypass mechanism documented

---

**Location 3: Agent Lanes table (lines 131-148)**

**Current state:** A.B.C agents ARE listed in the Agent Lanes table (lines 131-138)

**Change:** KEEP A.B.C agents in the table (they're still valid for feature-level intake)

**No change required** — work-item correctly notes agents remain, only folder is removed

---

### method/agents/forge-g-operating-guide.md (UPDATE — 3 locations)

**Location 1: FORGE-AUTONOMY.yml integration (Section 6.1, line 336)**

**Current (line 336):**
```markdown
forge_entry:
  required_file: "abc/FORGE-ENTRY.md"
  unlock_on_approval: true
```

**Change:** UPDATE schema example to show lifecycle_gates instead of forge_entry

**Proposed replacement:**
```markdown
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

---

**Location 2: What @G Reads table (Section 6.2, line 382)**

**Current (line 382):**
```markdown
| `forge_entry.required_file` | Checks gating for F/O/R/G/E availability |
```

**Change:** REPLACE with lifecycle_gates field references

**Proposed replacement:**
```markdown
| `lifecycle_gates` | Enforces progressive readiness gates at each phase |
```

---

**Location 3: Structural verification checklist (Section 7.1a, lines 456-480)**

**Current (lines 458, v2.0 checklist):**
```markdown
[ ] abc/FORGE-ENTRY.md exists
```

**Change:** REPLACE with Gate 1 check (PRODUCT.md exists and complete)

**Proposed replacement:**
```markdown
[ ] docs/constitution/PRODUCT.md exists and contains required sections
```

**Current (lines 470, v1.x checklist):**
```markdown
[ ] abc/FORGE-ENTRY.md exists
```

**Change:** Same replacement for v1.x checklist

---

**Location 4: Transition-specific validation (Section 7.4, line 558)**

**Current (line 558):**
```markdown
#### On transition @C → @F (after structural verification passes)

- [ ] Structural verification completed with PASS status
- [ ] `docs/ops/preflight-checklist.md` exists
```

**Change:** ADD Gate 1 prerequisite language

**Proposed addition:**
```markdown
#### On transition @C → @F (after structural verification passes)

- [ ] Structural verification completed with PASS status
- [ ] `docs/ops/preflight-checklist.md` exists
- [ ] Gate 0 (spawn) passed — project spawned from template

**IF FAIL → HARD STOP:** "Cannot begin Frame — structural verification incomplete or failed"
```

---

**Location 5: Add new transition validation for F→O, O→R, R→E**

**Current:** Section 7.4 has validation for @C→@F and @F→@O, but not explicit gate checks

**Change:** ADD gate prerequisite checks to existing validations

**Proposed additions:**

```markdown
#### On transition @F → @O

- [ ] Gate 1 passed: PRODUCT.md exists and complete
- [ ] All actors in PRODUCT.md have explicit auth plane assignments
- [ ] Auth model decision (single-plane vs multi-plane) is answered

**IF FAIL → HARD STOP:** "Gate 1 not met. Cannot begin Orchestrate — complete PRODUCT.md first."

#### On transition @O → @R

- [ ] Gate 2 passed: TECH.md exists and complete
- [ ] AUTH-ARCHITECTURE ADR exists (if auth in scope)
- [ ] Test infrastructure specification exists in TECH.md

**IF FAIL → HARD STOP:** "Gate 2 not met. Cannot begin Refine — complete TECH.md first."

#### On transition @R → @E

- [ ] Gate 3 passed: @R coherence review complete
- [ ] No unresolved conflicts between PRODUCT.md and TECH.md

**IF FAIL → HARD STOP:** "Gate 3 not met. Cannot begin Execute — resolve coherence issues first."
```

---

### method/agents/forge-e-operating-guide.md (UPDATE — 1 location)

**Location: Pre-flight verification, Check 1 (line 288)**

**Current (line 288):**
```markdown
### Check 1: Structure

- [ ] Project root has CLAUDE.md
- [ ] Project root has FORGE-AUTONOMY.yml
- [ ] abc/FORGE-ENTRY.md exists
- [ ] docs/constitution/ exists
- [ ] v2.0: `_forge/inbox/active/` exists
- [ ] v1.x: `inbox/30_ops/handoffs/` exists
```

**Change:** REPLACE `abc/FORGE-ENTRY.md exists` with Gate 4 prerequisite check

**Proposed replacement:**
```markdown
### Check 1: Structure

- [ ] Project root has CLAUDE.md
- [ ] Project root has FORGE-AUTONOMY.yml
- [ ] Gate 4 passed: Approved packet exists (v2.0: `_forge/inbox/active/[slug]/packet.yml` with `approved: true`; v1.x: handoff packet with `approval_status: approved`)
- [ ] docs/constitution/ exists
- [ ] v2.0: `_forge/inbox/active/` exists
- [ ] v1.x: `inbox/30_ops/handoffs/` exists
```

---

### .claude/skills/forge-g/SKILL.md (UPDATE — 2 locations)

**Location 1: Gating Logic (lines 37-46)**

**Current (lines 39-46):**
```markdown
## Gating Logic

```
IF abc/FORGE-ENTRY.md DOES NOT EXIST:
  STOP: "FORGE not unlocked. Complete @C (Commit) first.
         abc/FORGE-ENTRY.md is required before FORGE lifecycle agents."

OTHERWISE:
  PROCEED normally
```
```

**Change:** REMOVE abc/FORGE-ENTRY.md check (spawning IS the gate)

**Proposed replacement:**
```markdown
## Gating Logic

FORGE lifecycle agents (@F/@O/@R/@G/@E) are available after project spawn. Progressive gates enforce readiness at each phase:
- Gate 1 (@F): PRODUCT.md complete
- Gate 2 (@O): TECH.md complete
- Gate 3 (@R): Coherence verified
- Gate 4 (@G/@E): Packet approved
```

---

**Location 2: Transition-Specific Validation (lines 63-70)**

**Current (lines 66-68):**
```markdown
- **@C → @F:** Structural verification passed
```

**Change:** ADD Gate 1-4 checks to transition validation

**Proposed replacement:**
```markdown
- **@C → @F:** Structural verification passed (Gate 0)
- **@F → @O:** Gate 1 passed (PRODUCT.md complete)
- **@O → @R:** Gate 2 passed (TECH.md complete)
- **@R → @E:** Gate 3 passed (coherence verified)
- **@G → @E:** Gate 4 passed (packet approved)
```

---

### .claude/skills/forge-e/SKILL.md (UPDATE — 2 locations)

**Location 1: Gating Logic (lines 37-46)**

**Current (lines 39-46):**
```markdown
## Gating Logic

```
IF abc/FORGE-ENTRY.md DOES NOT EXIST:
  STOP: "FORGE not unlocked. Complete @C (Commit) first.
         abc/FORGE-ENTRY.md is required before FORGE lifecycle agents."

OTHERWISE:
  PROCEED normally — check for handoff packet or explicit instructions
```
```

**Change:** REMOVE abc/FORGE-ENTRY.md check, ADD Gate 4 enforcement

**Proposed replacement:**
```markdown
## Gating Logic

Gate 4 (Execution) enforcement:

```
IF packet does NOT exist in _forge/inbox/active/[slug]/:
  STOP: "No packet found. Create packet in _forge/inbox/active/ first."

IF packet.yml approved != true:
  STOP: "Packet not approved. Human Lead must set approved: true before execution."

OTHERWISE:
  PROCEED with pre-flight verification
```
```

---

**Location 2: Pre-Flight Verification (lines 54-66)**

**Current (line 58):**
```markdown
1. **Structure gate** — Verify CLAUDE.md, FORGE-AUTONOMY.yml, abc/FORGE-ENTRY.md, docs/constitution/ exist.
```

**Change:** REMOVE abc/FORGE-ENTRY.md from structure gate

**Proposed replacement:**
```markdown
1. **Structure gate** — Verify CLAUDE.md, FORGE-AUTONOMY.yml, docs/constitution/ exist. Gate 4 passed (packet approved).
```

---

### .claude/skills/forge-f/SKILL.md (UPDATE — 1 location)

**Location: Completion Gate (lines 78-93)**

**Current (lines 78-93):**
```markdown
## Completion Gate (MANDATORY)

PRODUCT.md is NOT complete until:
1. All actors have explicit auth plane assignments
2. Auth model decision (single-plane vs multi-plane) is answered
3. If stakeholders exist, STAKEHOLDER-MODEL.md is started

**HARD STOP if incomplete.** @F MUST self-validate before declaring completion.

- [ ] PRODUCT.md complete with actors, use-cases, success criteria
- [ ] All actors have auth plane assignments
- [ ] Auth model decision answered
- [ ] STAKEHOLDER-MODEL.md started (if stakeholders exist)
- [ ] Human approval of product intent
- [ ] Agent has STOPped and suggested @O as next step
```

**Change:** ADD Gate 1 enforcement language (explicit gate declaration)

**Proposed addition (prepend to existing section):**
```markdown
## Gate 1 Enforcement (PRD Lock)

@F enforces Gate 1. @O cannot proceed until Gate 1 passes.

**Gate 1 requirements:**
- [ ] PRODUCT.md exists
- [ ] Contains: description, actors, use_cases, mvp, success_criteria sections
- [ ] All actors have auth plane assignments
- [ ] Auth model decision answered (single-plane vs multi-plane)
- [ ] If stakeholders exist, STAKEHOLDER-MODEL.md started

**On completion:** @F declares "Gate 1 passed. PRODUCT.md complete. Human: invoke @O for architecture."

**Human Lead bypass:** Human can say "skip Gate 1" or "proceed without Gate 1" to bypass (NOT RECOMMENDED).

## Completion Gate (MANDATORY)

[existing content...]
```

---

### .claude/skills/forge-o/SKILL.md (UPDATE — 1 location)

**Location: Completion Gate (lines 79-95)**

**Current (lines 79-95):**
```markdown
## Completion Gate (MANDATORY)

TECH.md is NOT complete until:
1. AUTH-ARCHITECTURE ADR exists (for multi-user/multi-role projects)
2. Test architecture is specified (framework, coverage, Sacred Four commands)
3. RLS policy mapping documented (if auth in scope)

**HARD STOP if incomplete.** @O MUST self-validate before declaring completion.

**EXCEPTION:** Single-user, single-role projects MAY skip auth ADR with documented rationale.

- [ ] TECH.md complete with architecture, data model, boundaries
- [ ] AUTH-ARCHITECTURE ADR exists (for multi-user/multi-role projects)
- [ ] Test architecture specified
- [ ] Architecture Packets produced with phase plans
- [ ] Human approval of architecture
- [ ] Agent has STOPped and suggested @R or @E
```

**Change:** ADD Gate 2 enforcement language (prerequisite + explicit gate declaration)

**Proposed addition (prepend to existing section):**
```markdown
## Gate 2 Enforcement (Architecture Lock)

@O enforces Gate 2. @R/@E cannot proceed until Gate 2 passes.

**Prerequisite:** Gate 1 must pass first. @O checks that PRODUCT.md exists and is complete before beginning architecture work.

**Gate 2 requirements:**
- [ ] Gate 1 passed (PRODUCT.md complete)
- [ ] TECH.md exists
- [ ] Contains: stack, data_model, build_plan sections
- [ ] AUTH-ARCHITECTURE ADR exists (for multi-user/multi-role projects)
- [ ] Test architecture specified
- [ ] RLS policy mapping documented (if auth in scope)

**On completion:** @O declares "Gate 2 passed. TECH.md complete. Human: invoke @R for coherence review."

**Human Lead bypass:** Human can say "skip Gate 2" or "proceed without Gate 2" to bypass (NOT RECOMMENDED).

## Completion Gate (MANDATORY)

[existing content...]
```

---

### .claude/skills/forge-r/SKILL.md (UPDATE — 1 location)

**Location: Completion Gate (lines 83-94)**

**Current (lines 83-94):**
```markdown
## Completion Gate

- [ ] Review report produced with findings
- [ ] Conflicts surfaced (if any)
- [ ] Recommendations provided
- [ ] Human decides on resolution
- [ ] Agent has STOPped
```

**Change:** ADD Gate 3 enforcement language (prerequisite + explicit gate declaration)

**Proposed addition (prepend to existing section):**
```markdown
## Gate 3 Enforcement (Coherence Review)

@R enforces Gate 3. @E cannot proceed until Gate 3 passes.

**Prerequisite:** Gate 2 must pass first. @R checks that TECH.md exists and is complete before reviewing for coherence.

**Gate 3 requirements:**
- [ ] Gate 2 passed (TECH.md complete)
- [ ] @R reviewed PRODUCT.md ↔ TECH.md alignment
- [ ] No unresolved conflicts
- [ ] All missing use cases identified and resolved
- [ ] All sequencing risks surfaced
- [ ] All constraint conflicts resolved or documented

**On completion:** @R declares "Gate 3 passed. Coherence verified. Human: invoke @G to begin execution planning."

**Human Lead bypass:** Human can say "skip Gate 3" or "proceed without Gate 3" if confident in alignment (NOT RECOMMENDED).

## Completion Gate

[existing content...]
```

---

### projects/.gitignore (CREATE)

**Current state:** File does not exist

**Proposed content (from work-item spec):**
```gitignore
# Project repos are local — never sync back to FORGE
*
!.gitignore
!_registry.json
```

**Verification:**
- [ ] File exists at `/Users/leonardknight/kv-projects/FORGE/projects/.gitignore`
- [ ] Wildcard exclusion prevents accidental project commits
- [ ] `_registry.json` is explicitly allowed (tracked)
- [ ] Test: `git status` in projects/ should show only `.gitignore` and `_registry.json` as trackable

**Potential issue (Q1):** Should `README.md` be allowed? Work-item doesn't specify, but projects/README.md is FORGE-managed documentation (describes the projects/ directory purpose). Recommend adding `!README.md` exception.

---

## Cross-Reference Findings

**Total files referencing abc/FORGE-ENTRY.md:** 40 files
**Total files referencing forge_entry:** 7 files
**Total files referencing abc/:** 49 files

**Breakdown by category:**

| Category | Count | Action Required |
|----------|-------|-----------------|
| Work-item files (recon, proposals) | 6 | No action (self-referential) |
| Template files | 4 | DELETE (abc/ folder itself) |
| Agent operating guides | 5 | UPDATE (remove abc gate, add lifecycle gates) |
| Agent skills | 8 | UPDATE (remove abc gate, add lifecycle gates) |
| Agent definitions (.claude/agents/) | 6 | UPDATE (gating logic) |
| Template scaffold docs | 3 | UPDATE (reference removal) |
| FORGE canon (core/operations) | 2 | ASSESS (may need reference updates) |
| Existing projects (amigo, recalltech) | 2 | No action (grandfathered) |
| Archive/workspace files | 13 | No action (historical) |

**Critical finding:** The work-item lists 13 files to update. Recon found **at least 24 files** with abc/ references that may need updates (excluding archive/workspace files). This is not a gap — many references are in agent definitions (.claude/agents/*.md) which mirror the skills. Recommend synthesis phase produces a comprehensive file manifest.

**No conflicts detected:** No file relies on abc/FORGE-ENTRY.md as a critical runtime dependency beyond the gate check. All references are structural (documentation, gating logic, examples).

---

*Generated by forge-recon-runner on 2026-02-13*
