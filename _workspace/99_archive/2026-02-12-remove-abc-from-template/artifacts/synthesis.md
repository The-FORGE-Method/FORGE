# Synthesis: Remove abc/ from Template + Replace Gate with Lifecycle Gates

**Date:** 2026-02-13
**Work-Item:** 2026-02-12-remove-abc-from-template
**Status:** SYNTHESIS COMPLETE
**Version:** 1.0

---

## 1. Executive Summary

This work-item removes the `abc/` directory from `template/project/` (eliminating 4 files) and replaces the single binary `forge_entry` gate with a progressive 4-gate lifecycle chain. A.B.C is a pre-project intake process that occurs before spawning — it should not ship inside spawned projects. The new gate structure enforces readiness at each FORGE phase (PRD Lock, Architecture Lock, Coherence Review, Execution Loop) with human-bypassable checkpoints. Additionally, a `projects/.gitignore` is added to the FORGE repo to prevent contributors from accidentally syncing local project data upstream.

**Why this matters:** The old model conflated "pre-project intake" with "ongoing project lifecycle" by physically co-locating abc/ inside projects. This caused confusion about when A.B.C runs and what it means. The new model makes spawning the commitment gate, and enforces progressive readiness gates during the build lifecycle.

---

## 2. Requirements Matrix

### 2.1 DELETE Operations

| File Path | Current State | Change | Verification |
|-----------|--------------|--------|--------------|
| `template/project/abc/README.md` | 2,223 bytes — Pre-FORGE lifecycle description | DELETE entire file | Path does not exist after deletion |
| `template/project/abc/INTAKE.md.template` | 651 bytes — @A output template | DELETE entire file | Path does not exist after deletion |
| `template/project/abc/BRIEF.md.template` | 955 bytes — @B output template | DELETE entire file | Path does not exist after deletion |
| `template/project/abc/FORGE-ENTRY.md.template` | 780 bytes — Gate artifact template | DELETE entire file | Path does not exist after deletion |
| `template/project/abc/` (directory) | Contains 4 files | DELETE entire directory | `template/project/abc/` path does not exist |

---

### 2.2 UPDATE Operations — template/project/FORGE-AUTONOMY.yml

**File:** `/Users/leonardknight/kv-projects/FORGE/template/project/FORGE-AUTONOMY.yml`

#### Change 1: Remove forge_entry section

**Lines:** 17-20
**Current Content:**
```yaml
# Pre-FORGE gate: file that must exist to unlock F/O/R/G/E agents
forge_entry:
  required_file: "abc/FORGE-ENTRY.md"
  unlock_on_approval: true
```

**New Content:** DELETE these 4 lines entirely

**Verification:** No `forge_entry` section exists in file; grep for `forge_entry` returns no results

---

#### Change 2: Add lifecycle_gates section

**Location:** After line 15 (after `agent_version` field, before `router:` section)

**Current Content:** (none — new section)

**New Content:** INSERT the following:
```yaml
# Progressive lifecycle gates (v2.0 enforcement model)
# Gates enforce readiness at each FORGE phase
# All gates are human-bypassable with explicit instruction
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

**Verification:**
- YAML parses without errors
- `lifecycle_gates` section exists with 4 gates defined
- Each gate has correct fields (agent, artifact/requires, optional required_sections)

---

### 2.3 UPDATE Operations — template/project/CLAUDE.md

**File:** `/Users/leonardknight/kv-projects/FORGE/template/project/CLAUDE.md`

#### Change 1: Remove abc/ from Key Locations table

**Line:** 61
**Current Content:**
```markdown
| Pre-FORGE lifecycle | `abc/` |
```

**New Content:** DELETE this line

**Verification:** Key Locations table contains no reference to `abc/`

---

#### Change 2: Replace Gating section

**Lines:** 156-159
**Current Content:**
```markdown
### Gating: A.B.C -> F.O.R.G.E

- Before `abc/FORGE-ENTRY.md` exists: Only @A, @B, @C available
- After `abc/FORGE-ENTRY.md` exists: @F, @O, @R, @G, @E unlock
```

**New Content:** REPLACE with:
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

**Human Lead can bypass any gate with explicit instruction** (e.g., "skip Gate 3" or "proceed without Gate 2").
```

**Verification:**
- Old gating section removed
- New lifecycle gates section added with all 4 gates documented
- Bypass mechanism clearly documented

---

#### Change 3: Confirm Agent Lanes table preserves A.B.C agents

**Lines:** 131-148 (Agent Lanes table)
**Current Content:** A.B.C agents are listed (lines 131-138)
**New Content:** NO CHANGE (keep A.B.C agents — they're still valid for feature-level intake)
**Verification:** Agent Lanes table includes @A, @B, @C entries

---

### 2.4 UPDATE Operations — method/agents/forge-g-operating-guide.md

**File:** `/Users/leonardknight/kv-projects/FORGE/method/agents/forge-g-operating-guide.md`

#### Change 1: Update FORGE-AUTONOMY.yml integration example

**Location:** Section 6.1, line 336
**Current Content:**
```markdown
forge_entry:
  required_file: "abc/FORGE-ENTRY.md"
  unlock_on_approval: true
```

**New Content:** REPLACE with:
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

**Verification:** Example matches actual FORGE-AUTONOMY.yml schema

---

#### Change 2: Update "What @G Reads" table

**Location:** Section 6.2, line 382
**Current Content:**
```markdown
| `forge_entry.required_file` | Checks gating for F/O/R/G/E availability |
```

**New Content:** REPLACE with:
```markdown
| `lifecycle_gates` | Enforces progressive readiness gates at each phase |
```

**Verification:** Table row updated, no reference to `forge_entry`

---

#### Change 3: Update structural verification checklist (v2.0)

**Location:** Section 7.1a, line 458 (v2.0 checklist)
**Current Content:**
```markdown
[ ] abc/FORGE-ENTRY.md exists
```

**New Content:** REPLACE with:
```markdown
[ ] docs/constitution/PRODUCT.md exists and contains required sections (description, actors, use_cases, mvp, success_criteria)
```

**Verification:** Checklist item validates PRODUCT.md, not abc/FORGE-ENTRY.md

---

#### Change 4: Update structural verification checklist (v1.x)

**Location:** Section 7.1a, line 470 (v1.x checklist)
**Current Content:**
```markdown
[ ] abc/FORGE-ENTRY.md exists
```

**New Content:** REPLACE with:
```markdown
[ ] docs/constitution/PRODUCT.md exists and contains required sections
```

**Verification:** Checklist item validates PRODUCT.md, not abc/FORGE-ENTRY.md

---

#### Change 5: Add gate prerequisites to transition validations

**Location:** Section 7.4, lines 558-591 (Transition-specific validation)

**Current @F → @O transition (line 572):**
```markdown
#### On transition @F → @O

- [ ] All actors in PRODUCT.md have explicit auth plane assignments
- [ ] Auth model decision (single-plane vs multi-plane) is answered
```

**New Content:** PREPEND Gate 1 prerequisite:
```markdown
#### On transition @F → @O

- [ ] Gate 1 passed: PRODUCT.md exists and complete
- [ ] All actors in PRODUCT.md have explicit auth plane assignments
- [ ] Auth model decision (single-plane vs multi-plane) is answered

**IF FAIL → HARD STOP:** "Gate 1 not met. Cannot begin Orchestrate — complete PRODUCT.md first."
```

---

**Current @O → @R transition (line 579):**
```markdown
#### On transition @O → @R

- [ ] AUTH-ARCHITECTURE ADR exists (if auth in scope)
- [ ] Test infrastructure specification exists in TECH.md
```

**New Content:** PREPEND Gate 2 prerequisite:
```markdown
#### On transition @O → @R

- [ ] Gate 2 passed: TECH.md exists and complete
- [ ] AUTH-ARCHITECTURE ADR exists (if auth in scope)
- [ ] Test infrastructure specification exists in TECH.md

**IF FAIL → HARD STOP:** "Gate 2 not met. Cannot begin Refine — complete TECH.md first."
```

---

**ADD new @R → @E transition:**
```markdown
#### On transition @R → @E

- [ ] Gate 3 passed: @R coherence review complete
- [ ] No unresolved conflicts between PRODUCT.md and TECH.md
- [ ] All missing use cases identified and resolved
- [ ] All sequencing risks surfaced

**IF FAIL → HARD STOP:** "Gate 3 not met. Cannot begin Execute — resolve coherence issues first."
```

**Location:** INSERT after @O → @R transition (after line 586)

**Verification:** All transitions (@F→@O, @O→@R, @R→@E) have gate prerequisites with HARD STOP conditions

---

### 2.5 UPDATE Operations — method/agents/forge-e-operating-guide.md

**File:** `/Users/leonardknight/kv-projects/FORGE/method/agents/forge-e-operating-guide.md`

#### Change: Update pre-flight verification (Check 1)

**Location:** Section 5.5, line 288
**Current Content:**
```markdown
### Check 1: Structure

- [ ] Project root has CLAUDE.md
- [ ] Project root has FORGE-AUTONOMY.yml
- [ ] abc/FORGE-ENTRY.md exists
- [ ] docs/constitution/ exists
- [ ] v2.0: `_forge/inbox/active/` exists
- [ ] v1.x: `inbox/30_ops/handoffs/` exists
```

**New Content:** REPLACE `abc/FORGE-ENTRY.md exists` with Gate 4 check:
```markdown
### Check 1: Structure

- [ ] Project root has CLAUDE.md
- [ ] Project root has FORGE-AUTONOMY.yml
- [ ] Gate 4 passed: Approved packet exists (v2.0: `_forge/inbox/active/[slug]/packet.yml` with `approved: true`; v1.x: handoff packet with `approval_status: approved`)
- [ ] docs/constitution/ exists
- [ ] v2.0: `_forge/inbox/active/` exists
- [ ] v1.x: `inbox/30_ops/handoffs/` exists
```

**Verification:** Structure check validates packet approval (Gate 4), not abc/FORGE-ENTRY.md

---

### 2.6 UPDATE Operations — .claude/skills/forge-g/SKILL.md

**File:** `/Users/leonardknight/kv-projects/FORGE/.claude/skills/forge-g/SKILL.md`

#### Change 1: Replace gating logic

**Location:** Lines 37-46
**Current Content:**
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

**New Content:** REPLACE with:
```markdown
## Gating Logic

FORGE lifecycle agents (@F/@O/@R/@G/@E) are available after project spawn. Progressive gates enforce readiness at each phase:

- **Gate 1 (@F):** PRODUCT.md complete with required sections
- **Gate 2 (@O):** TECH.md complete with required sections
- **Gate 3 (@R):** Coherence verified between PRODUCT.md and TECH.md
- **Gate 4 (@G/@E):** Packet approved in `_forge/inbox/active/`

Spawning from template = commitment. Constitution emptiness triggers @F to populate PRODUCT.md.
```

**Verification:** No reference to abc/FORGE-ENTRY.md; describes 4-gate model

---

#### Change 2: Update transition-specific validation

**Location:** Lines 63-70
**Current Content:**
```markdown
- **@C → @F:** Structural verification passed
```

**New Content:** REPLACE with:
```markdown
- **@C → @F:** Structural verification passed (Gate 0 — spawn complete)
- **@F → @O:** Gate 1 passed (PRODUCT.md complete)
- **@O → @R:** Gate 2 passed (TECH.md complete)
- **@R → @E:** Gate 3 passed (coherence verified)
- **@G → @E:** Gate 4 passed (packet approved)
```

**Verification:** All transition validations reference appropriate gates

---

### 2.7 UPDATE Operations — .claude/skills/forge-e/SKILL.md

**File:** `/Users/leonardknight/kv-projects/FORGE/.claude/skills/forge-e/SKILL.md`

#### Change 1: Replace gating logic

**Location:** Lines 37-46
**Current Content:**
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

**New Content:** REPLACE with:
```markdown
## Gating Logic (Gate 4 Enforcement)

```
IF packet does NOT exist in _forge/inbox/active/[slug]/:
  STOP: "No packet found. @G must create packet in _forge/inbox/active/ first."

IF packet.yml approved != true:
  STOP: "Packet not approved. Human Lead must set approved: true in packet.yml before execution."

OTHERWISE:
  PROCEED with pre-flight verification
```
```

**Verification:** Gate 4 enforcement (packet exists + approved), no reference to abc/FORGE-ENTRY.md

---

#### Change 2: Update pre-flight verification (structure gate)

**Location:** Lines 54-66
**Current Content (line 58):**
```markdown
1. **Structure gate** — Verify CLAUDE.md, FORGE-AUTONOMY.yml, abc/FORGE-ENTRY.md, docs/constitution/ exist.
```

**New Content:** REPLACE with:
```markdown
1. **Structure gate** — Verify CLAUDE.md, FORGE-AUTONOMY.yml, docs/constitution/ exist. Gate 4 passed (packet approved).
```

**Verification:** Structure gate checks packet approval, not abc/FORGE-ENTRY.md

---

### 2.8 UPDATE Operations — .claude/skills/forge-f/SKILL.md

**File:** `/Users/leonardknight/kv-projects/FORGE/.claude/skills/forge-f/SKILL.md`

#### Change: Add Gate 1 enforcement section

**Location:** Lines 78-93 (before existing "Completion Gate" section)
**Current Content:** Completion Gate section exists but doesn't declare Gate 1 explicitly

**New Content:** INSERT before existing "Completion Gate (MANDATORY)":
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

**Human Lead bypass:** Human can say "skip Gate 1" or "proceed without Gate 1" to bypass (NOT RECOMMENDED — PRD lock ensures clarity before architecture work).

```

**Verification:**
- Gate 1 section exists before Completion Gate section
- Checklist matches FORGE-AUTONOMY.yml required_sections
- Bypass mechanism documented

---

### 2.9 UPDATE Operations — .claude/skills/forge-o/SKILL.md

**File:** `/Users/leonardknight/kv-projects/FORGE/.claude/skills/forge-o/SKILL.md`

#### Change: Add Gate 2 enforcement section

**Location:** Lines 79-95 (before existing "Completion Gate" section)
**Current Content:** Completion Gate section exists but doesn't declare Gate 2 explicitly or check Gate 1 prerequisite

**New Content:** INSERT before existing "Completion Gate (MANDATORY)":
```markdown
## Gate 2 Enforcement (Architecture Lock)

@O enforces Gate 2. @R/@E cannot proceed until Gate 2 passes.

**Prerequisite:** Gate 1 must pass first. @O checks that PRODUCT.md exists and is complete before beginning architecture work. If Gate 1 not met, @O redirects to @F with: "Cannot begin Orchestrate — Gate 1 not met. Invoke @F to complete PRODUCT.md first."

**Gate 2 requirements:**
- [ ] Gate 1 passed (PRODUCT.md complete)
- [ ] TECH.md exists
- [ ] Contains: stack, data_model, build_plan sections
- [ ] AUTH-ARCHITECTURE ADR exists (for multi-user/multi-role projects)
- [ ] Test architecture specified (framework, coverage, Sacred Four commands)
- [ ] RLS policy mapping documented (if auth in scope)

**On completion:** @O declares "Gate 2 passed. TECH.md complete. Human: invoke @R for coherence review."

**Human Lead bypass:** Human can say "skip Gate 2" or "proceed without Gate 2" to bypass (NOT RECOMMENDED — Architecture lock ensures design clarity before execution).

```

**Verification:**
- Gate 2 section exists before Completion Gate section
- Prerequisite check for Gate 1 documented
- Checklist matches FORGE-AUTONOMY.yml required_sections
- Bypass mechanism documented

---

### 2.10 UPDATE Operations — .claude/skills/forge-r/SKILL.md

**File:** `/Users/leonardknight/kv-projects/FORGE/.claude/skills/forge-r/SKILL.md`

#### Change: Add Gate 3 enforcement section

**Location:** Lines 83-94 (before existing "Completion Gate" section)
**Current Content:** Completion Gate section exists but doesn't declare Gate 3 explicitly or check Gate 2 prerequisite

**New Content:** INSERT before existing "Completion Gate":
```markdown
## Gate 3 Enforcement (Coherence Review)

@R enforces Gate 3. @E cannot proceed until Gate 3 passes.

**Prerequisite:** Gate 2 must pass first. @R checks that TECH.md exists and is complete before reviewing for coherence. If Gate 2 not met, @R redirects with: "Cannot begin Refine — Gate 2 not met. Invoke @O to complete TECH.md first."

**Gate 3 requirements:**
- [ ] Gate 2 passed (TECH.md complete)
- [ ] @R reviewed PRODUCT.md ↔ TECH.md alignment
- [ ] No unresolved conflicts between product intent and architecture
- [ ] All missing use cases identified and resolved
- [ ] All sequencing risks surfaced and addressed
- [ ] All constraint conflicts resolved or documented

**On completion:** @R declares "Gate 3 passed. Coherence verified. Human: invoke @G to begin execution planning."

**Human Lead bypass:** Human can say "skip Gate 3" or "proceed without Gate 3" if confident in alignment (NOT RECOMMENDED — Coherence review prevents costly rework during execution).

```

**Verification:**
- Gate 3 section exists before Completion Gate section
- Prerequisite check for Gate 2 documented
- Coherence requirements clearly defined
- Bypass mechanism documented

---

### 2.11 CREATE Operations — projects/.gitignore

**File:** `/Users/leonardknight/kv-projects/FORGE/projects/.gitignore` (NEW)

**Current State:** File does not exist

**New Content:**
```gitignore
# Project repos are local — never sync back to FORGE
*
!.gitignore
!README.md
!_registry.json
```

**Verification:**
- File exists at `/Users/leonardknight/kv-projects/FORGE/projects/.gitignore`
- `git status` in `projects/` shows only `.gitignore`, `README.md`, and `_registry.json` as trackable
- Test by creating `projects/test-file.txt` → should NOT appear in `git status`

**Rationale for exceptions:**
- `!.gitignore` — Track the .gitignore itself
- `!README.md` — FORGE-managed documentation (describes projects/ purpose)
- `!_registry.json` — Project registry metadata (FORGE-tracked)

---

## 3. Gate Design Specification

### 3.1 Gate Design Philosophy

**Hybrid model (Q3 answer):**
- `lifecycle_gates` section exists in FORGE-AUTONOMY.yml as **schema documentation**
- Agents enforce gates via **hardcoded logic** (Phase 1)
- Runtime YAML parsing deferred to Phase 2 (when gate configuration needs to be customizable)

**Gate state persistence:**
- File existence + section completeness = implicit state
- No explicit "gate_passed" flags stored
- @F self-validates (Q4 answer) → if @F declares PRODUCT.md complete, Gate 1 is passed

**Logging (Q2 answer):**
- All gate checks logged to git-native event logging (v2.0 router-events)
- Log format: `[timestamp] GATE_CHECK gate=[1-4] status=[PASS|FAIL] agent=[F/O/R/G/E] reason=[details]`
- Example: `2026-02-13T14:32:00Z GATE_CHECK gate=1 status=PASS agent=F reason="PRODUCT.md complete"`

---

### 3.2 Gate Definitions

#### Gate 0 — Spawn (Implicit)

- **Trigger:** Project spawned from `template/project/`
- **Artifact:** Project exists with FORGE-AUTONOMY.yml + CLAUDE.md
- **Effect:** FORGE agents (@F/@O/@R/@G/@E) become available
- **Enforcement:** No explicit check (spawning IS the gate)

---

#### Gate 1 — PRD Lock

- **Owner:** @F
- **Trigger:** User invokes @F or says "define the product"
- **Prerequisite:** Gate 0 (project spawned)
- **Artifact:** `docs/constitution/PRODUCT.md`
- **Required Sections:**
  - `description` — What + why
  - `actors` — User types + auth plane assignments
  - `use_cases` — Minimum 1
  - `mvp` — MVP definition
  - `success_criteria` — Measurable outcomes
- **Enforcement Logic:**
  - @F checks PRODUCT.md file existence
  - @F validates required sections present
  - @F self-validates and declares "Gate 1 passed" on completion
  - @O checks Gate 1 before proceeding (trusts @F's validation per Q4)
- **If not met:** @F stops and instructs: "Gate 1 not met. Complete PRODUCT.md with all required sections."
- **Bypass:** Human says "skip Gate 1" → @F warns but proceeds
- **Logging:** `GATE_CHECK gate=1 status=[PASS|FAIL] agent=F`

---

#### Gate 2 — Architecture Lock

- **Owner:** @O
- **Trigger:** User invokes @O after Gate 1
- **Prerequisite:** Gate 1 passed (PRODUCT.md complete)
- **Artifact:** `docs/constitution/TECH.md`
- **Required Sections:**
  - `stack` — Technology choices
  - `data_model` — Data structure outline
  - `build_plan` — PR sequence (PR0..PRn)
- **Enforcement Logic:**
  - @O checks Gate 1 passed (PRODUCT.md exists and complete)
  - If Gate 1 not met: "Cannot begin Orchestrate — Gate 1 not met. Invoke @F first."
  - @O checks TECH.md file existence
  - @O validates required sections present
  - @O self-validates and declares "Gate 2 passed" on completion
- **If not met:** @O stops and instructs: "Gate 2 not met. Complete TECH.md with all required sections."
- **Bypass:** Human says "skip Gate 2" → @O warns but proceeds
- **Logging:** `GATE_CHECK gate=2 status=[PASS|FAIL] agent=O`

---

#### Gate 3 — Coherence Review

- **Owner:** @R
- **Trigger:** User invokes @R after Gate 2
- **Prerequisite:** Gate 2 passed (TECH.md complete)
- **Artifact:** @R review report (inline or packet)
- **Requirements:**
  - PRODUCT.md ↔ TECH.md alignment verified
  - No unresolved conflicts
  - All missing use cases identified
  - All sequencing risks surfaced
  - All constraint conflicts resolved or documented
- **Enforcement Logic:**
  - @R checks Gate 2 passed (TECH.md exists and complete)
  - If Gate 2 not met: "Cannot begin Refine — Gate 2 not met. Invoke @O first."
  - @R performs coherence analysis
  - @R produces review report with findings
  - If conflicts found: Fix loop back to @F or @O as needed
  - @R declares "Gate 3 passed" only after coherence verified
- **If not met:** @R stops and instructs: "Gate 3 not met. Resolve coherence issues: [list]"
- **Bypass:** Human says "skip Gate 3" → @R warns but proceeds
- **Logging:** `GATE_CHECK gate=3 status=[PASS|FAIL] agent=R reason=[conflicts|coherence_verified]`

---

#### Gate 4 — Execution Loop

- **Owner:** @G (packet creation) + @E (execution)
- **Trigger:** User says "build it" or invokes @G/@E
- **Prerequisite:** Gate 3 passed (coherence verified)
- **Artifact:** Approved packet in `_forge/inbox/active/[slug]/packet.yml` with `approved: true`
- **Requirements:**
  - Packet exists in `_forge/inbox/active/`
  - Packet has `approved: true` in packet.yml
  - Branch created
  - handoff.md exists with execution instructions
- **Enforcement Logic:**
  - @G checks Gate 3 passed (coherence review complete)
  - If Gate 3 not met: "Cannot begin Execute — Gate 3 not met. Invoke @R first."
  - @G creates packet structure
  - @G creates branch + PR shell
  - @G produces handoff.md
  - Human sets `approved: true` in packet.yml
  - @E checks packet approval before executing
  - If `approved != true`: "Packet not approved. Human Lead must approve first."
- **If not met:** @E stops and instructs: "Gate 4 not met. No approved packet found."
- **Bypass:** Human says "skip Gate 4" → @E warns and requests explicit packet path
- **Logging:** `GATE_CHECK gate=4 status=[PASS|FAIL] agent=[G|E] packet=[slug]`

---

### 3.3 Bypass Mechanism

**Trigger phrases (natural language):**
- "skip Gate [N]"
- "proceed without Gate [N]"
- "bypass Gate [N]"
- "Gate [N] override"

**Agent behavior on bypass:**
1. Agent detects bypass phrase
2. Agent warns: "WARNING: Bypassing Gate [N]. This may cause issues: [risk description]"
3. Agent logs bypass: `GATE_BYPASS gate=[N] agent=[X] requested_by=human`
4. Agent proceeds without gate validation

**Bypass is NOT silent** — Always logged and warned.

---

### 3.4 YAML Schema (Documentation)

**Purpose:** Documents gate structure for human reference, not runtime-enforced in Phase 1

**Location:** `template/project/FORGE-AUTONOMY.yml` lines 17-32 (after agent_version, before router)

**Schema:**
```yaml
lifecycle_gates:
  gate_1_prd:
    agent: F                    # Owner agent
    artifact: "path/to/file"    # Gate artifact path
    required_sections: [...]    # Section checklist (for constitution files)
  gate_2_architecture:
    agent: O
    artifact: "path/to/file"
    requires: gate_1_prd        # Prerequisite gate
    required_sections: [...]
  gate_3_coherence:
    agent: R
    requires: gate_2_architecture
  gate_4_execution:
    agent: [G, E]               # Multi-agent ownership
    requires: gate_3_coherence
    packet_path: "path/to/packets"  # For execution gates
```

**Field definitions:**
- `agent` (string or array) — Agent(s) responsible for gate
- `artifact` (string, optional) — File path that serves as gate evidence
- `requires` (string, optional) — Prerequisite gate ID
- `required_sections` (array, optional) — Section checklist for constitution files
- `packet_path` (string, optional) — Path for execution packet storage

---

### 3.5 Hardcoded Agent Logic (Phase 1 Enforcement)

**@F (Gate 1):**
```
ON INVOCATION:
  IF PRODUCT.md missing OR empty:
    POPULATE PRODUCT.md with template sections
    STOP: "Gate 1 not met. Complete PRODUCT.md sections."

  IF PRODUCT.md exists AND has required_sections:
    DECLARE: "Gate 1 passed. PRODUCT.md complete."
    SUGGEST: "Invoke @O for architecture."

  ON BYPASS REQUEST:
    WARN: "Bypassing Gate 1 risks unclear product intent."
    LOG: GATE_BYPASS gate=1 agent=F
    PROCEED
```

**@O (Gate 2):**
```
ON INVOCATION:
  IF PRODUCT.md missing OR incomplete:
    STOP: "Gate 1 not met. Invoke @F to complete PRODUCT.md first."

  IF TECH.md missing OR empty:
    POPULATE TECH.md with architecture template
    STOP: "Gate 2 not met. Complete TECH.md sections."

  IF TECH.md exists AND has required_sections:
    DECLARE: "Gate 2 passed. TECH.md complete."
    SUGGEST: "Invoke @R for coherence review."

  ON BYPASS REQUEST:
    WARN: "Bypassing Gate 2 risks misaligned architecture."
    LOG: GATE_BYPASS gate=2 agent=O
    PROCEED
```

**@R (Gate 3):**
```
ON INVOCATION:
  IF TECH.md missing OR incomplete:
    STOP: "Gate 2 not met. Invoke @O to complete TECH.md first."

  PERFORM coherence analysis (PRODUCT.md ↔ TECH.md)

  IF conflicts found:
    REPORT conflicts
    SUGGEST fixes (route to @F or @O)
    STOP: "Gate 3 not met. Resolve conflicts before execution."

  IF coherence verified:
    DECLARE: "Gate 3 passed. Coherence verified."
    SUGGEST: "Invoke @G to begin execution planning."

  ON BYPASS REQUEST:
    WARN: "Bypassing Gate 3 risks costly rework during execution."
    LOG: GATE_BYPASS gate=3 agent=R
    PROCEED
```

**@G (Gate 4 creation):**
```
ON INVOCATION:
  IF coherence review not complete:
    STOP: "Gate 3 not met. Invoke @R for coherence review first."

  CREATE packet in _forge/inbox/active/[slug]/
  CREATE branch
  PRODUCE handoff.md
  SET approved: false in packet.yml

  INSTRUCT: "Packet created. Human: review and set approved: true to unlock @E."

  ON BYPASS REQUEST:
    WARN: "Bypassing Gate 4 risks unapproved execution."
    LOG: GATE_BYPASS gate=4 agent=G
    PROCEED (create packet anyway)
```

**@E (Gate 4 execution):**
```
ON INVOCATION:
  IF packet missing:
    STOP: "No packet found. Invoke @G to create packet first."

  IF packet.yml approved != true:
    STOP: "Packet not approved. Human Lead must set approved: true."

  IF packet approved:
    PROCEED with execution
    LOG: GATE_CHECK gate=4 status=PASS agent=E

  ON BYPASS REQUEST:
    WARN: "Bypassing Gate 4 execution check. Provide explicit packet path."
    LOG: GATE_BYPASS gate=4 agent=E
    REQUEST packet path from human
    PROCEED
```

---

## 4. Dependency Order

**Phase 1: Delete abc/ folder**
1. DELETE `template/project/abc/README.md`
2. DELETE `template/project/abc/INTAKE.md.template`
3. DELETE `template/project/abc/BRIEF.md.template`
4. DELETE `template/project/abc/FORGE-ENTRY.md.template`
5. DELETE `template/project/abc/` directory

**Phase 2: Update FORGE-AUTONOMY.yml schema**
1. DELETE `forge_entry` section (lines 17-20)
2. ADD `lifecycle_gates` section (after line 15)

**Phase 3: Update template CLAUDE.md**
1. DELETE abc/ from Key Locations table (line 61)
2. REPLACE Gating section (lines 156-159)
3. VERIFY Agent Lanes table still includes A.B.C agents (no change)

**Phase 4: Update @F skill (Gate 1 enforcement)**
1. UPDATE `.claude/skills/forge-f/SKILL.md` — ADD Gate 1 Enforcement section

**Phase 5: Update @O skill (Gate 2 enforcement)**
1. UPDATE `.claude/skills/forge-o/SKILL.md` — ADD Gate 2 Enforcement section

**Phase 6: Update @R skill (Gate 3 enforcement)**
1. UPDATE `.claude/skills/forge-r/SKILL.md` — ADD Gate 3 Enforcement section

**Phase 7: Update @G operating guide + skill**
1. UPDATE `method/agents/forge-g-operating-guide.md`:
   - Section 6.1 (FORGE-AUTONOMY.yml schema example)
   - Section 6.2 (What @G Reads table)
   - Section 7.1a (structural verification checklists)
   - Section 7.4 (transition validations)
2. UPDATE `.claude/skills/forge-g/SKILL.md`:
   - Gating Logic section
   - Transition-specific validation section

**Phase 8: Update @E operating guide + skill**
1. UPDATE `method/agents/forge-e-operating-guide.md`:
   - Section 5.5 (pre-flight verification Check 1)
2. UPDATE `.claude/skills/forge-e/SKILL.md`:
   - Gating Logic section
   - Pre-flight verification section

**Phase 9: Create projects/.gitignore**
1. CREATE `/Users/leonardknight/kv-projects/FORGE/projects/.gitignore`

**Rationale for order:**
- Delete abc/ folder FIRST (removes physical artifact)
- Update schema SECOND (establishes new gate structure)
- Update template docs THIRD (documents new model for spawned projects)
- Update @F/@O/@R skills FOURTH (progressive gate enforcement from top of lifecycle)
- Update @G/@E last (depend on earlier gates being defined)
- Create .gitignore LAST (independent, no dependencies)

---

## 5. Acceptance Criteria

All criteria are PASS/FAIL with no ambiguity.

### 5.1 Deletion Criteria

- [ ] `template/project/abc/` directory does NOT exist
- [ ] `template/project/abc/README.md` does NOT exist
- [ ] `template/project/abc/INTAKE.md.template` does NOT exist
- [ ] `template/project/abc/BRIEF.md.template` does NOT exist
- [ ] `template/project/abc/FORGE-ENTRY.md.template` does NOT exist

**Verification:** `ls template/project/abc/` returns "No such file or directory"

---

### 5.2 FORGE-AUTONOMY.yml Criteria

- [ ] `forge_entry` section does NOT exist in `template/project/FORGE-AUTONOMY.yml`
- [ ] `lifecycle_gates` section EXISTS in `template/project/FORGE-AUTONOMY.yml`
- [ ] `lifecycle_gates` defines `gate_1_prd` with agent=F, artifact, required_sections
- [ ] `lifecycle_gates` defines `gate_2_architecture` with agent=O, artifact, requires=gate_1_prd, required_sections
- [ ] `lifecycle_gates` defines `gate_3_coherence` with agent=R, requires=gate_2_architecture
- [ ] `lifecycle_gates` defines `gate_4_execution` with agent=[G,E], requires=gate_3_coherence, packet_path
- [ ] YAML parses without errors: `yq eval template/project/FORGE-AUTONOMY.yml > /dev/null`

**Verification:** `grep forge_entry template/project/FORGE-AUTONOMY.yml` returns no results; `yq '.lifecycle_gates' template/project/FORGE-AUTONOMY.yml` returns 4 gates

---

### 5.3 Template CLAUDE.md Criteria

- [ ] Key Locations table does NOT reference `abc/`
- [ ] "Gating: A.B.C -> F.O.R.G.E" section does NOT exist
- [ ] "Progressive Lifecycle Gates" section EXISTS with all 4 gates documented
- [ ] Bypass mechanism documented: "Human Lead can bypass any gate"
- [ ] Agent Lanes table INCLUDES @A, @B, @C entries

**Verification:** `grep "abc/" template/project/CLAUDE.md | wc -l` returns 0; `grep "Progressive Lifecycle Gates" template/project/CLAUDE.md` returns match

---

### 5.4 Agent Operating Guide Criteria (@G)

- [ ] `method/agents/forge-g-operating-guide.md` Section 6.1 shows `lifecycle_gates` schema (not `forge_entry`)
- [ ] Section 6.2 "What @G Reads" table references `lifecycle_gates` (not `forge_entry.required_file`)
- [ ] Section 7.1a v2.0 checklist checks `docs/constitution/PRODUCT.md` (not `abc/FORGE-ENTRY.md`)
- [ ] Section 7.1a v1.x checklist checks `docs/constitution/PRODUCT.md` (not `abc/FORGE-ENTRY.md`)
- [ ] Section 7.4 @F→@O transition includes Gate 1 prerequisite check
- [ ] Section 7.4 @O→@R transition includes Gate 2 prerequisite check
- [ ] Section 7.4 @R→@E transition EXISTS with Gate 3 prerequisite check

**Verification:** `grep "abc/FORGE-ENTRY.md" method/agents/forge-g-operating-guide.md | wc -l` returns 0; `grep "Gate 1 passed" method/agents/forge-g-operating-guide.md` returns match

---

### 5.5 Agent Operating Guide Criteria (@E)

- [ ] `method/agents/forge-e-operating-guide.md` Section 5.5 Check 1 references Gate 4 (packet approved), not `abc/FORGE-ENTRY.md`

**Verification:** `grep "abc/FORGE-ENTRY.md" method/agents/forge-e-operating-guide.md | wc -l` returns 0; `grep "Gate 4 passed" method/agents/forge-e-operating-guide.md` returns match

---

### 5.6 Agent Skill Criteria (@G)

- [ ] `.claude/skills/forge-g/SKILL.md` Gating Logic does NOT reference `abc/FORGE-ENTRY.md`
- [ ] Gating Logic describes 4-gate model
- [ ] Transition-specific validation includes Gates 1-4 for appropriate transitions

**Verification:** `grep "abc/FORGE-ENTRY.md" .claude/skills/forge-g/SKILL.md | wc -l` returns 0; `grep "Gate 1 passed" .claude/skills/forge-g/SKILL.md` returns match

---

### 5.7 Agent Skill Criteria (@E)

- [ ] `.claude/skills/forge-e/SKILL.md` Gating Logic enforces Gate 4 (packet approved), not `abc/FORGE-ENTRY.md`
- [ ] Pre-flight verification Check 1 references Gate 4, not `abc/FORGE-ENTRY.md`

**Verification:** `grep "abc/FORGE-ENTRY.md" .claude/skills/forge-e/SKILL.md | wc -l` returns 0; `grep "Gate 4 passed" .claude/skills/forge-e/SKILL.md` returns match

---

### 5.8 Agent Skill Criteria (@F)

- [ ] `.claude/skills/forge-f/SKILL.md` has "Gate 1 Enforcement (PRD Lock)" section
- [ ] Gate 1 section lists required PRODUCT.md sections matching FORGE-AUTONOMY.yml
- [ ] Gate 1 section documents bypass mechanism
- [ ] Completion Gate section still exists (no deletion, only addition)

**Verification:** `grep "Gate 1 Enforcement" .claude/skills/forge-f/SKILL.md` returns match; `grep "skip Gate 1" .claude/skills/forge-f/SKILL.md` returns match

---

### 5.9 Agent Skill Criteria (@O)

- [ ] `.claude/skills/forge-o/SKILL.md` has "Gate 2 Enforcement (Architecture Lock)" section
- [ ] Gate 2 section checks Gate 1 prerequisite
- [ ] Gate 2 section lists required TECH.md sections matching FORGE-AUTONOMY.yml
- [ ] Gate 2 section documents bypass mechanism
- [ ] Completion Gate section still exists (no deletion, only addition)

**Verification:** `grep "Gate 2 Enforcement" .claude/skills/forge-o/SKILL.md` returns match; `grep "Gate 1 must pass first" .claude/skills/forge-o/SKILL.md` returns match

---

### 5.10 Agent Skill Criteria (@R)

- [ ] `.claude/skills/forge-r/SKILL.md` has "Gate 3 Enforcement (Coherence Review)" section
- [ ] Gate 3 section checks Gate 2 prerequisite
- [ ] Gate 3 section defines coherence requirements
- [ ] Gate 3 section documents bypass mechanism
- [ ] Completion Gate section still exists (no deletion, only addition)

**Verification:** `grep "Gate 3 Enforcement" .claude/skills/forge-r/SKILL.md` returns match; `grep "Gate 2 must pass first" .claude/skills/forge-r/SKILL.md` returns match

---

### 5.11 projects/.gitignore Criteria

- [ ] `/Users/leonardknight/kv-projects/FORGE/projects/.gitignore` EXISTS
- [ ] File contains wildcard exclusion: `*`
- [ ] File allows `.gitignore` itself: `!.gitignore`
- [ ] File allows `README.md`: `!README.md`
- [ ] File allows `_registry.json`: `!_registry.json`

**Verification:** `cat projects/.gitignore` shows all 5 lines; Create test file `projects/test.txt` → `git status` does NOT show test.txt

---

### 5.12 Smoke Test Criteria

**Test:** Spawn template → @F populates PRODUCT.md → @O populates TECH.md → @R reviews → @G creates packet → @E executes

**Steps:**
1. Spawn new project from template: `cp -r template/project/ /tmp/test-spawn-gates/`
2. Invoke @F: Should detect empty PRODUCT.md → populate → STOP with "Gate 1 not met"
3. Complete PRODUCT.md sections (description, actors, use_cases, mvp, success_criteria)
4. Invoke @F again: Should declare "Gate 1 passed"
5. Invoke @O: Should check Gate 1 → populate TECH.md → STOP with "Gate 2 not met"
6. Complete TECH.md sections (stack, data_model, build_plan)
7. Invoke @O again: Should declare "Gate 2 passed"
8. Invoke @R: Should check Gate 2 → perform coherence review → declare "Gate 3 passed" (if no conflicts)
9. Invoke @G: Should check Gate 3 → create packet in `_forge/inbox/active/` → set `approved: false`
10. Set `approved: true` in packet.yml
11. Invoke @E: Should check Gate 4 → detect approved packet → proceed with execution

**PASS criteria:**
- [ ] @F blocks if PRODUCT.md incomplete
- [ ] @O blocks if Gate 1 not met (PRODUCT.md incomplete)
- [ ] @O blocks if TECH.md incomplete
- [ ] @R blocks if Gate 2 not met (TECH.md incomplete)
- [ ] @G blocks if Gate 3 not met (coherence review incomplete)
- [ ] @E blocks if packet not approved
- [ ] All gates log to event system (if logging implemented)
- [ ] Bypass works: "skip Gate N" allows progression

---

### 5.13 Preservation Criteria

- [ ] A.B.C agents (@A/@B/@C) remain in `.claude/agents/` directory
- [ ] A.B.C skills remain in `.claude/skills/forge-a/`, `/forge-b/`, `/forge-c/`
- [ ] Template CLAUDE.md Agent Lanes table includes @A, @B, @C
- [ ] No changes to `template/project/src/`
- [ ] No changes to `template/project/tests/`
- [ ] No changes to `template/project/supabase/`
- [ ] No changes to `method/core/` (canon)

**Verification:** `ls .claude/agents/ | grep forge-[abc]` returns 3 files; `ls .claude/skills/ | grep forge-[abc]` returns 3 directories

---

## 6. Risk Mitigations

| Risk | Mitigation |
|------|------------|
| **Gate logic creates agent deadlocks** | Gates are progressive (each requires previous), not circular. Gate 0 (spawn) is implicit — no check needed. Bypass mechanism always available. |
| **Human Lead bypass mechanism fails** | Document exact bypass phrases in all agent skills. Include bypass detection in smoke test. Log all bypass attempts. |
| **A.B.C agents mistakenly removed** | Preserve `.claude/agents/forge-[abc].md` and `.claude/skills/forge-[abc]/` explicitly. Add preservation criteria to acceptance checklist. Highlight in proposal: "A.B.C agents remain for feature-level intake." |
| **projects/.gitignore too broad** | Explicitly allow `README.md` and `_registry.json` (FORGE-managed files). Test with dummy file to verify wildcard exclusion works. |
| **Existing projects break after update** | Changes only affect `template/project/`. Existing projects in `projects/` are grandfathered (keep abc/ if they have it). No backward-incompatible changes. |
| **Gate state becomes inconsistent** | File existence + section completeness IS the state. No separate flag needed. @F/@O/@R self-validate. @G trusts upstream agents (Tier 0 model per Q4). |
| **Structural verification out of sync** | Update ALL structural verification checklists (@G operating guide lines 458, 470). Replace abc/FORGE-ENTRY.md check with PRODUCT.md check (Q5 answer). |
| **@E pre-flight still checks abc/** | Update @E operating guide Section 5.5 Check 1 (line 288) to replace abc/FORGE-ENTRY.md with Gate 4 check. Add to requirements matrix. |
| **Gate failures produce unclear messages** | Standardize failure messages: "Gate N not met: [missing item]. Complete [action] before proceeding, or say 'skip Gate N' to bypass." Include in hardcoded agent logic. |
| **Gates become hard blocks (no bypass)** | Every gate enforcement includes bypass detection. Document bypass phrases. Add "Human Lead can bypass" to all gate descriptions in CLAUDE.md and skills. |

---

## 7. Out of Scope (Explicit)

This work-item does **NOT** touch:

### 7.1 FORGE Repo Structure
- **NO changes** to `method/core/` (canon)
- **NO changes** to existing projects in `projects/` (only affects new spawns)
- **NO deletion** of A.B.C agents (`.claude/agents/forge-[abc].md`)
- **NO deletion** of A.B.C skills (`.claude/skills/forge-[abc]/`)

### 7.2 Template Source Code
- **NO changes** to `template/project/src/`
- **NO changes** to `template/project/tests/`
- **NO changes** to `template/project/supabase/`

### 7.3 Runtime YAML Parsing
- **NO implementation** of runtime YAML parsing in Phase 1
- `lifecycle_gates` section in FORGE-AUTONOMY.yml is **documentation only**
- Agents enforce gates via **hardcoded logic**, not YAML reading
- Runtime YAML enforcement deferred to Phase 2

### 7.4 Event Logging Implementation
- Gate logging is **specified** (Q2: log all gate checks)
- Logging **implementation** depends on v2.0 git-native event logging (separate work-item)
- If event logging not yet implemented, gate checks proceed without logging (no blocker)

### 7.5 A.B.C Workflow Changes
- **NO changes** to A.B.C agent behavior (they still do intake, sensemaking, commitment)
- **NO changes** to when/how A.B.C agents are invoked
- **NO changes** to A.B.C output formats (INTAKE.md, BRIEF.md, FORGE-ENTRY.md can still be produced in conversations or FORGE repo `_workspace/`)

### 7.6 Existing Project Migration
- **NO migration** of existing projects to remove abc/ folder
- Existing projects with abc/ remain valid (grandfathered)
- Gate enforcement only applies to projects spawned AFTER this change

### 7.7 Agent Definitions (.claude/agents/)
- **NO updates** to `.claude/agents/forge-[a-e].md` files (agent definitions)
- Gating logic lives in **skills**, not agent definitions
- Agent definitions describe roles, not implementation logic

---

## 8. Additional Specifications

### 8.1 Gate Failure Messaging Standard

All gate failure messages follow this format:

```
Gate [N] not met: [specific missing item].

Action: [what to do next]

Bypass: Say "skip Gate [N]" to proceed anyway (NOT RECOMMENDED — [risk description]).
```

**Examples:**

**Gate 1 failure:**
```
Gate 1 not met: PRODUCT.md missing "actors" section.

Action: Add actors section to PRODUCT.md with user types and auth plane assignments.

Bypass: Say "skip Gate 1" to proceed anyway (NOT RECOMMENDED — unclear product intent risks misaligned architecture).
```

**Gate 4 failure:**
```
Gate 4 not met: Packet not approved.

Action: Review packet in _forge/inbox/active/my-feature/ and set approved: true in packet.yml.

Bypass: Say "skip Gate 4" to proceed anyway (NOT RECOMMENDED — unapproved execution risks unauthorized changes).
```

---

### 8.2 Gate Success Messaging Standard

All gate success messages follow this format:

```
Gate [N] passed. [Artifact] complete.

Next step: Invoke @[next-agent] for [next phase].
```

**Examples:**

**Gate 1 success:**
```
Gate 1 passed. PRODUCT.md complete.

Next step: Invoke @O for architecture.
```

**Gate 3 success:**
```
Gate 3 passed. Coherence verified.

Next step: Invoke @G to begin execution planning.
```

---

### 8.3 Cross-Reference Updates Required

Recon found **49 files** referencing `abc/`. Most are in `_workspace/` (historical) or existing projects (grandfathered). The following require updates beyond what's in the requirements matrix:

| File | Section | Action |
|------|---------|--------|
| `.claude/agents/forge-a.md` | Description | UPDATE to clarify abc/ templates used in FORGE repo conversations, not spawned projects |
| `.claude/agents/forge-b.md` | Description | Same as above |
| `.claude/agents/forge-c.md` | Output | UPDATE to clarify FORGE-ENTRY.md produced in FORGE repo or conversation, not inside spawned projects |

**Specific change:**

**Current (forge-a.md, line ~18):**
```markdown
@A produces INTAKE.md in the project's abc/ directory.
```

**New:**
```markdown
@A produces INTAKE.md in the FORGE repo's _workspace/ during pre-project intake, or as a conversation artifact. Spawned projects do not include abc/.
```

**Verification:** `grep "abc/" .claude/agents/forge-*.md` shows only contextual references (not structural requirements)

---

### 8.4 Template Instantiation Changes

**Before this change:**
```
template/project/
├── abc/
│   ├── README.md
│   ├── INTAKE.md.template
│   ├── BRIEF.md.template
│   └── FORGE-ENTRY.md.template
├── docs/constitution/
│   ├── PRODUCT.md (empty)
│   └── TECH.md (empty)
└── FORGE-AUTONOMY.yml (with forge_entry gate)
```

**After this change:**
```
template/project/
├── docs/constitution/
│   ├── PRODUCT.md (empty — triggers Gate 1 enforcement)
│   └── TECH.md (empty — triggers Gate 2 enforcement)
└── FORGE-AUTONOMY.yml (with lifecycle_gates schema)
```

**Spawning behavior:**
1. User spawns template → project gets NO abc/ folder
2. User invokes @F → detects empty PRODUCT.md → populates template → STOPS with "Gate 1 not met"
3. User completes PRODUCT.md → invokes @F → @F validates → declares "Gate 1 passed"
4. User invokes @O → @O checks Gate 1 → proceeds to TECH.md
5. ... progressive gates continue

---

### 8.5 CHANGELOG Entry

Add to CHANGELOG under `[Unreleased]` or next version:

```markdown
### Changed
- **Template structure:** Removed `abc/` directory from project template — A.B.C intake now happens before spawn, not inside spawned projects
- **Gate model:** Replaced single `forge_entry` gate with progressive 4-gate lifecycle chain (PRD Lock, Architecture Lock, Coherence Review, Execution Loop)
- **FORGE-AUTONOMY.yml:** Removed `forge_entry` section, added `lifecycle_gates` schema documentation

### Added
- **projects/.gitignore:** Prevent project data from syncing back to FORGE repo
- **Gate enforcement:** @F/@O/@R/@G/@E now enforce progressive readiness gates at each phase
- **Bypass mechanism:** Human Lead can skip any gate with explicit instruction

### Removed
- `template/project/abc/` directory (4 files: README.md, INTAKE.md.template, BRIEF.md.template, FORGE-ENTRY.md.template)
- `forge_entry` gating mechanism from FORGE-AUTONOMY.yml

### Migration Notes
- **Existing projects:** No action required — abc/ folder grandfathered if present
- **New projects:** Spawn from updated template → no abc/ folder, gate enforcement active
- **A.B.C agents:** Still available for feature-level intake within projects (agents preserved, folder removed)
```

---

## 9. Verification Matrix

| Requirement | File | Line(s) | Verification Command | Expected Result |
|-------------|------|---------|----------------------|-----------------|
| abc/ deleted | template/project/abc/ | N/A | `ls template/project/abc/` | "No such file or directory" |
| forge_entry removed | template/project/FORGE-AUTONOMY.yml | 17-20 | `grep forge_entry template/project/FORGE-AUTONOMY.yml` | No results |
| lifecycle_gates added | template/project/FORGE-AUTONOMY.yml | 17-32 | `yq '.lifecycle_gates' template/project/FORGE-AUTONOMY.yml` | 4 gates listed |
| YAML valid | template/project/FORGE-AUTONOMY.yml | All | `yq eval template/project/FORGE-AUTONOMY.yml > /dev/null` | No errors |
| abc/ removed from CLAUDE.md | template/project/CLAUDE.md | 61 | `grep "abc/" template/project/CLAUDE.md` | No results |
| Progressive gates documented | template/project/CLAUDE.md | 156+ | `grep "Progressive Lifecycle Gates" template/project/CLAUDE.md` | Match found |
| @G operating guide updated | method/agents/forge-g-operating-guide.md | 336, 382, 458, 470, 558+ | `grep "abc/FORGE-ENTRY.md" method/agents/forge-g-operating-guide.md` | No results |
| @E operating guide updated | method/agents/forge-e-operating-guide.md | 288 | `grep "abc/FORGE-ENTRY.md" method/agents/forge-e-operating-guide.md` | No results |
| @G skill updated | .claude/skills/forge-g/SKILL.md | 39-46, 63-70 | `grep "abc/FORGE-ENTRY.md" .claude/skills/forge-g/SKILL.md` | No results |
| @E skill updated | .claude/skills/forge-e/SKILL.md | 39-46, 54-66 | `grep "abc/FORGE-ENTRY.md" .claude/skills/forge-e/SKILL.md` | No results |
| @F Gate 1 added | .claude/skills/forge-f/SKILL.md | 78+ | `grep "Gate 1 Enforcement" .claude/skills/forge-f/SKILL.md` | Match found |
| @O Gate 2 added | .claude/skills/forge-o/SKILL.md | 79+ | `grep "Gate 2 Enforcement" .claude/skills/forge-o/SKILL.md` | Match found |
| @R Gate 3 added | .claude/skills/forge-r/SKILL.md | 83+ | `grep "Gate 3 Enforcement" .claude/skills/forge-r/SKILL.md` | Match found |
| projects/.gitignore created | projects/.gitignore | All | `cat projects/.gitignore` | 5 lines (wildcard + 3 exceptions) |
| .gitignore works | projects/ | N/A | `touch projects/test.txt && git status` | test.txt NOT shown |
| A.B.C agents preserved | .claude/agents/ | N/A | `ls .claude/agents/ \| grep forge-[abc]` | 3 files |
| A.B.C skills preserved | .claude/skills/ | N/A | `ls .claude/skills/ \| grep forge-[abc]` | 3 directories |

---

## 10. Final Synthesis Summary

**What is being done:**
- Delete `abc/` directory from project template (4 files)
- Replace `forge_entry` gate with 4-gate progressive lifecycle chain
- Update 8 agent files (2 operating guides, 6 skills) to enforce new gates
- Add `projects/.gitignore` to prevent project data syncing to FORGE repo

**Why it matters:**
- A.B.C is pre-project intake — shouldn't ship inside projects
- Progressive gates enforce readiness at each phase (better than single binary check)
- Gate failures provide clear instructions (not just "FORGE not unlocked")
- Human Lead can always bypass (advisory, not absolute blocks)

**How it works:**
- Spawning from template = commitment (Gate 0)
- @F enforces Gate 1 (PRODUCT.md complete)
- @O enforces Gate 2 (TECH.md complete, requires Gate 1)
- @R enforces Gate 3 (coherence verified, requires Gate 2)
- @G/@E enforce Gate 4 (packet approved, requires Gate 3)

**What is preserved:**
- A.B.C agents still available for feature-level intake
- Existing projects grandfathered (no breaking changes)
- Human Lead control (bypass mechanism always available)

**Success criteria:**
- 60+ binary PASS/FAIL acceptance criteria defined
- Smoke test validates full gate chain
- Zero references to abc/FORGE-ENTRY.md in updated files

**Status:** READY FOR PROPOSAL PHASE

---

*Synthesis complete. All open questions resolved (Q1-Q5). Requirements matrix specifies exact changes with line numbers. Gate design fully specified. Dependency order defined. Acceptance criteria comprehensive.*
