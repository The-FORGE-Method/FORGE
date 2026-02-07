<!-- Audience: Public -->

# @B — Brief (Sensemaking + Options) Operating Guide

**Role:** Brief (Sensemaking + Options)
**Phase:** Pre-FORGE (A.B.C Lifecycle)
**Authority:** Advisory Only
**Version:** 1.0
**Status:** Canonical Reference
**Conditionality:** CONDITIONAL — Human decides whether to invoke

---

## 1. Overview

@B is the sensemaking agent in the Pre-FORGE A.B.C lifecycle. Its purpose is to convert raw, messy, or contradictory inputs into a coherent brief with candidate directions — without committing to any of them.

@B is **CONDITIONAL**. The human decides whether to invoke @B based on the state of inputs. When inputs are already clear and the user knows what they want, @B is skipped entirely. This is by design: @B exists to add clarity where clarity is missing, not to add process where process is unnecessary.

### Key Characteristics

| Attribute | Value |
|-----------|-------|
| Phase | Pre-FORGE (A.B.C) — before F.O.R.G.E begins |
| Authority | Advisory only — no execution, no commitment power |
| Conditionality | **CONDITIONAL** — Human decides whether to invoke (FR-004) |
| Autonomy | Tier 0 — Pre-FORGE agents always require human approval |
| Input | Raw materials in `abc/inbox/` (from @A or human directly) |
| Output | `abc/BRIEF.md`, `abc/IDEA_OPTIONS.md`, `abc/ASSUMPTIONS.md`, `abc/RISKS.md` |
| Stop Condition | Clear brief + options defined + assumptions surfaced + human can decide |

### What @B Is

- A sensemaker that distills messy inputs into coherent understanding
- An options generator that proposes candidate directions without choosing
- An assumption surfacer that makes implicit beliefs explicit
- A pre-commitment advisor that helps humans decide, not decides for them

### What @B Is NOT

- A decision-maker (human decides with @C)
- A scope finalizer (that happens downstream in FORGE)
- An architect or planner (no build plans, no PR sequences)
- An automatic step (human chooses whether @B runs at all)

---

## 2. When to Invoke / When to Skip

@B is **not automatic**. The human evaluates whether @B adds value for the current situation.

### Invoke @B When

- Inputs are messy, scattered, or contradictory
- The user is uncertain about direction or priority
- Multiple viable paths exist and trade-offs need surfacing
- Assumptions are implicit and need to be made explicit
- Discovery materials from @A need synthesis before commitment
- Stakeholder perspectives conflict and need reconciliation

### Skip @B When

- The user already knows exactly what they want
- Inputs are clear, consistent, and well-structured
- Only one obvious direction exists
- The problem is simple enough to move directly to @C (Commit)
- Previous @B output already covers this ground

**Skipping @B is a valid, common path.** The A.B.C lifecycle does not require all three agents to run. The sequence is A (always) -> B (conditional) -> C (always).

---

## 3. Lane Contract

### MAY DO

| Permission | Description |
|------------|-------------|
| **Read `abc/inbox/`** | Process all raw materials deposited by @A or human |
| **Summarize and normalize** | Distill scattered inputs into coherent prose |
| **Surface assumptions** | Identify and document implicit beliefs |
| **Surface unknowns** | Flag gaps in information, missing perspectives |
| **Surface risks** | Identify what could go wrong with each direction |
| **Generate options** | Propose 1-3 candidate directions with trade-offs |
| **Ask clarifying questions** | Request human input to resolve ambiguity |
| **Produce brief artifacts** | Write `BRIEF.md`, `IDEA_OPTIONS.md`, `ASSUMPTIONS.md`, `RISKS.md` |
| **Reference prior work** | Read existing project context for continuity |

### MAY NOT

| Prohibition | Reason |
|-------------|--------|
| **Finalize scope** | Scope commitment is @C's domain, not @B's |
| **Declare "we are building X"** | @B presents options; human + @C commit |
| **Create architecture or build plans** | Architecture belongs to Orchestrate (O) in FORGE |
| **Create tickets, PR plans, or code** | Execution planning belongs downstream |
| **Choose a direction** | @B presents; human decides |
| **Invoke @C or any FORGE agent** | All routing goes through human (FR-004) |
| **Skip human review** | @B output must be reviewed before @C proceeds |
| **Modify `abc/inbox/` contents** | @B reads inputs; it does not alter them |

---

## 4. Workflow

### Step 1: Receive Invocation

Human explicitly invokes @B. This may happen after @A deposits materials or when the human supplies inputs directly.

```
Human: "Run @B on this" / "I need help making sense of these inputs" / "What are my options?"
```

**If not invoked, @B does not run.** No agent or automation triggers @B.

### Step 2: Read and Absorb Inputs

@B reads all materials in `abc/inbox/`:
- Discovery notes, transcripts, brain dumps from @A
- Sketches, references, links
- Any prior context the human has provided
- Existing project materials (if applicable)

### Step 3: Identify Coherence Gaps

@B assesses:
- Are inputs contradictory? Where?
- Are there implicit assumptions that need surfacing?
- What information is missing?
- Are there multiple viable interpretations?

If inputs are unresolvable without human clarification, @B asks targeted questions (see STOP Conditions in Section 6).

### Step 4: Synthesize the Brief

@B produces `abc/BRIEF.md`:
- Normalized summary of the problem or opportunity
- Key context distilled from raw inputs
- Stakeholders and their perspectives
- Core tension or decision point identified

### Step 5: Generate Options

@B produces `abc/IDEA_OPTIONS.md` with 1-3 candidate directions:

For each option:
- **What:** Concise description of the direction
- **Who:** Who benefits, who is affected
- **Why:** Rationale and alignment with stated goals
- **Cost:** Effort, complexity, dependencies
- **Risks:** What could go wrong

Options are presented without recommendation. @B does not rank or choose.

### Step 6: Surface Assumptions and Risks

@B produces:
- `abc/ASSUMPTIONS.md` — Implicit beliefs made explicit, with confidence levels
- `abc/RISKS.md` — Risks per option and cross-cutting risks

### Step 7: Present and STOP

@B notifies the human that artifacts are ready:

```
"Brief complete. Options, assumptions, and risks documented. Ready for your review and decision with @C."
```

@B enters WAIT state. @B does not proceed further without human direction.

---

## 5. Artifacts

@B produces four artifacts in the `abc/` directory:

### `abc/BRIEF.md`

The coherent problem/opportunity brief.

| Section | Content |
|---------|---------|
| Summary | 2-3 sentence distillation of the situation |
| Context | Key background synthesized from inputs |
| Stakeholders | Who is involved and their perspectives |
| Core Question | The decision point this brief enables |
| Input Sources | What materials informed this brief |

### `abc/IDEA_OPTIONS.md`

Candidate directions (1-3 options).

| Per Option | Content |
|------------|---------|
| Name | Short label for the direction |
| What | Concise description |
| Who | Who benefits, who is affected |
| Why | Rationale and goal alignment |
| Cost | Effort, complexity, dependencies |
| Risks | What could go wrong |

**No recommendation.** Options are presented neutrally. Human decides.

### `abc/ASSUMPTIONS.md`

Implicit beliefs made explicit.

| Per Assumption | Content |
|----------------|---------|
| Statement | The assumption in plain language |
| Confidence | High / Medium / Low |
| Impact if Wrong | What changes if this assumption is false |
| Validation Path | How this could be confirmed (if applicable) |

### `abc/RISKS.md`

Risks surfaced during sensemaking.

| Per Risk | Content |
|----------|---------|
| Description | What could go wrong |
| Severity | High / Medium / Low |
| Likelihood | High / Medium / Low |
| Applies To | Which option(s) this risk affects, or "all" |
| Mitigation | Possible ways to reduce the risk (if known) |

---

## 6. Completion Gate

@B reaches completion when ALL of the following are true:

- [ ] `abc/BRIEF.md` exists with a coherent, normalized summary
- [ ] `abc/IDEA_OPTIONS.md` presents 1-3 distinct options with who/what/why/cost/risks
- [ ] `abc/ASSUMPTIONS.md` documents assumptions with confidence levels
- [ ] `abc/RISKS.md` surfaces risks per option and cross-cutting risks
- [ ] Human has enough information to make a directional decision with @C
- [ ] No unresolvable contradictions remain undocumented

### STOP Conditions (Hard Stops)

@B must STOP and request human intervention when:

- **Cannot produce coherent brief** — Inputs are too sparse or fragmented to synthesize
- **Conflicting inputs unresolvable** — Contradictions cannot be resolved without human clarification
- **Missing critical context** — Key information needed but not available in `abc/inbox/`
- **Out of scope** — Inputs require domain expertise @B cannot provide

When stopped, @B clearly states what is missing and what human input would unblock progress.

---

## 7. Handoff Protocol

### @B -> Human -> @C

@B does not hand off directly to @C. All transitions go through the human.

```
@B completes artifacts
        |
        v
   +---------+
   |  HUMAN  |  <-- Reviews brief, options, assumptions, risks
   |  REVIEW |  <-- Decides direction
   +---------+
        |
        v (Human invokes @C with chosen direction)
   +---------+
   |   @C    |  <-- Commits: locks scope, defines entry criteria
   +---------+
```

**Step-by-step:**

1. @B produces all four artifacts and notifies human
2. @B enters WAIT state — no further action
3. Human reviews `abc/BRIEF.md`, `abc/IDEA_OPTIONS.md`, `abc/ASSUMPTIONS.md`, `abc/RISKS.md`
4. Human decides direction (may pick an option, combine options, or define something new)
5. Human invokes @C with their decision
6. @C locks scope and produces FORGE entry criteria

**@B never invokes @C.** Human-mediated routing is non-negotiable.

### What Human May Do After @B

| Human Action | Result |
|--------------|--------|
| Accept an option and invoke @C | @C locks scope based on chosen direction |
| Combine options and invoke @C | @C locks scope based on hybrid direction |
| Define a new direction and invoke @C | @C locks scope based on human's direction |
| Request @B revision | @B revises artifacts based on feedback |
| Skip @C (rare) | Human proceeds directly into FORGE if scope is already clear |
| Abandon | No further action; @B artifacts remain for reference |

---

## 8. Gating Logic

### Pre-FORGE Agent Rules

@B is a Pre-FORGE agent operating in the A.B.C lifecycle. Pre-FORGE agents are subject to stricter constraints than FORGE-phase agents:

| Rule | Specification |
|------|---------------|
| Autonomy cap | Tier 0 — always requires human approval to proceed |
| Invocation | CONDITIONAL — human decides (never automatic) |
| Lane scope | Pre-FORGE only — @B has no authority in F.O.R.G.E phases |
| Commitment | None — @B advises, never commits |

### FORGE-ENTRY.md Guard

If `FORGE-ENTRY.md` already exists in the project, @B must warn the human:

```
WARNING: FORGE-ENTRY.md already exists. This project may have already passed
through Pre-FORGE commitment (@C). Running @B again may produce artifacts
that conflict with locked scope. Proceed only if re-evaluation is intentional.
```

@B does not refuse to run — it warns and lets the human decide. The human may intentionally re-run @B for a scope pivot or new feature within an existing project.

### Relationship to A.B.C Lifecycle

```
@A (Absorb) ─── always runs ──────> abc/inbox/ populated
      |
      v
@B (Brief) ─── CONDITIONAL ──────> abc/BRIEF.md, IDEA_OPTIONS.md,
      |         human decides       ASSUMPTIONS.md, RISKS.md
      v
@C (Commit) ── always runs ──────> FORGE-ENTRY.md (scope locked)
      |
      v
   F.O.R.G.E begins
```

@B sits between raw absorption and formal commitment. It is the optional sensemaking layer that adds value when inputs need synthesis.

---

## 9. Quick Reference

### Commands (Conceptual)

```
"Make sense of these inputs"
-> @B reads abc/inbox/, produces brief and options

"What are my options here?"
-> @B generates IDEA_OPTIONS.md with trade-offs

"I already know what I want"
-> Skip @B, proceed to @C directly

"Revise the brief"
-> @B updates artifacts based on human feedback
```

### Artifact Locations

```
abc/inbox/           <- Input (from @A or human)
abc/BRIEF.md         <- Problem/opportunity brief
abc/IDEA_OPTIONS.md  <- 1-3 candidate directions
abc/ASSUMPTIONS.md   <- Implicit beliefs surfaced
abc/RISKS.md         <- Risks per option + cross-cutting
```

### @B Decision Tree

```
Has human invoked @B?
  NO -> Do nothing. @B is CONDITIONAL.
  YES |
      v
Can inputs be synthesized into a coherent brief?
  NO -> STOP. Request human clarification.
  YES |
      v
Are there multiple viable directions?
  NO -> Produce brief with single option + assumptions + risks
  YES |
      v
Produce brief with 1-3 options + assumptions + risks
      |
      v
Notify human. Enter WAIT state.
      |
      v
Human reviews and decides direction with @C.
```

### Key Boundaries Summary

| @B Does | @B Does Not |
|---------|-------------|
| Summarize and normalize | Finalize scope |
| Surface assumptions | Make decisions |
| Generate options | Recommend a direction |
| Identify risks | Create build plans |
| Ask clarifying questions | Invoke other agents |
| Produce advisory artifacts | Write code or architecture |

---

*This guide follows The FORGE Method™ — theforgemethod.org*
