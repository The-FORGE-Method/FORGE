# FORGE Orientation

**Mental Model & Operating Intent for The FORGE Method™**

**Version:** 1.0  
**Steward:** FORGE Maintainers  
**Status:** Canonical Companion  
**Purpose:** Context anchor for Leo, Jordan, and aligned agents

---

## 1. What FORGE Is

FORGE is an **execution operating system** for building production-grade software with orchestrated AI agents.

It is not a tool, not a framework, not a process checklist. It is a **methodology**—a disciplined way of thinking about and organizing work that transforms intent into working software.

**The Core Insight:** Most AI-assisted development fails because people conflate *thinking* with *doing*. They start coding while still deciding what to build. Every ambiguity becomes a decision. Every decision becomes a delay. Velocity dies in clarification loops.

**FORGE's Answer:** Separate thinking from doing. Front-load all decisions into constitutional documents *before* execution begins. Then execute mechanically. When FORGE is followed correctly, implementation becomes boring—because every decision has already been made.

**Level of Operation:** FORGE operates at the *methodology* level. It tells you how to organize work, not what tools to use. It works with any AI agents, any tech stack, any team structure. The principles are fixed; the practices adapt.

---

## 2. Why FORGE Exists

FORGE was built to solve specific failure modes observed in AI-assisted development:

| Failure Mode | What Goes Wrong | How FORGE Fixes It |
|--------------|-----------------|-------------------|
| **Decision fatigue during execution** | Every line of code triggers "should I do X or Y?" | Constitutional documents answer 90% of questions before they're asked |
| **Scope creep** | Features expand mid-build without conscious choice | Explicit non-goals and locked specs prevent drift |
| **Agent chaos** | Multiple AI agents working at cross-purposes | Clear roles, lanes, and handoff protocols |
| **Context decay** | Long projects lose coherence as context fragments | Single source of truth, file-based handoffs, context recovery protocols |
| **Quality roulette** | Sometimes good, sometimes broken, unpredictably | Sacred verification sequence runs every cycle |
| **Human bottleneck illusion** | Humans blamed for "slowing down" AI | Human greenlight is a feature—prevents expensive wrong-direction work |

**What Traditional Approaches Get Wrong:**
- Treating AI as a faster typist instead of a different kind of collaborator
- Skipping specification because "we can figure it out as we go"
- Assuming more agents = more speed (it creates chaos without orchestration)
- Optimizing for starting fast instead of finishing fast

**What FORGE Optimizes For:**
- **Speed with correctness**—not speed alone
- **Finishing** projects, not just starting them
- **Transferability**—any qualified agent can pick up where another left off
- **Boring execution**—excitement belongs in ideation, not implementation

---

## 3. How FORGE Is Used in Practice

### The Lifecycle

FORGE has five sequential macro-steps:

```
F → O → R → G → E

Frame → Orchestrate → Refine → Govern → Execute
```

| Phase | What Happens | Output | Who Acts |
|-------|--------------|--------|----------|
| **Frame** | Define intent, scope, non-goals | Frame Artifact | Strategist + Human |
| **Orchestrate** | Configure agents, roles, topology | Agent assignments | Human Lead |
| **Refine** | Produce constitutional documents | Complete specs | Spec Author |
| **Govern** | Establish quality gates, escalation rules | Verification sequences | Spec Author + Human |
| **Execute** | Build per specs via FORGE Cycles | Working software | Quality Gate + Implementation Engine |

**Key Insight:** Phases F-O-R-G are *thinking*. Phase E is *doing*. Most of the calendar time is in FORG. Most of the *work* happens in E—but that work is mechanical if FORG was done right.

### The FORGE Cycle

Execute contains a tight loop that runs dozens of times per project:

```
Trigger → Brief → Implement → Verify → Merge → Repeat
```

Each cycle:
- Takes 30-90 minutes
- Produces one merged PR
- Runs the Sacred Four verification (typecheck, lint, test, build)
- Requires human greenlight to merge

**Speed comes from this cycle running cleanly.** When constitutional documents are complete, cycles flow without decision interruptions. When specs are incomplete, cycles grind to a halt in clarification loops.

### Where Humans vs Agents Act

| Activity | Actor |
|----------|-------|
| Direction, greenlight, final decisions | Human Lead |
| Ideation, options, synthesis | Strategist (AI) |
| Constitutional documents, specs | Spec Author (AI) |
| Verification, PRs, build-plan maintenance | Quality Gate (AI) |
| Code production per task briefs | Implementation Engine (AI) |

The human is not a bottleneck—the human is the **authority**. FORGE routes decisions *to* humans; it doesn't route around them.

---

## 4. Canonical vs Adaptable

This section prevents accidental re-litigation. Know what is locked and what is flexible.

### LOCKED CANON (Do Not Change Without Major Version)

These elements define FORGE. Changing them changes the methodology itself:

- **The Five Laws**
  1. Intent Before Implementation
  2. Agents Stay in Lanes
  3. Human Greenlight Required
  4. One Canonical Record
  5. Hard Stops Are Non-Negotiable

- **The Macro-Step Sequence:** F → O → R → G → E

- **The FORGE Cycle Structure:** Trigger → Brief → Implement → Verify → Merge

- **The Sacred Four Verification:** typecheck && lint && test && build

- **Constitutional Document Hierarchy:** North Star → Architecture → Data Model / API / Playbook → Execution Plan

- **Authority Model:** Human Lead holds final decision authority

### EXPECTED TO EVOLVE (Minor Versions)

These elements improve through real-world usage:

- Decision heuristics (when to fix vs escalate vs abandon)
- Error classification patterns
- Context recovery sequences
- Task brief templates
- Handoff formats
- Stack-specific examples

### PROJECT-SPECIFIC (Not Canonical)

These elements vary by project and team:

- Which specific AI platforms fill each role
- Directory structure and file naming
- Package manager and tooling
- Verification command syntax
- Communication channels
- Status emoji conventions

---

## 5. Roles & Authority (At a Glance)

| Role | Decision Authority | Does NOT |
|------|-------------------|----------|
| **Human Lead** | Final say on everything; greenlights phases; resolves disputes; merges PRs | Implement code; write specs |
| **Strategist** | Business strategy; feature framing; option generation | Implement; manage execution |
| **Spec Author** | Constitutional documents; prompts; ADRs | Implement; create PRs |
| **Quality Gate** | Verification; PR creation; build-plan maintenance; small fixes | Architectural decisions; spec changes |
| **Implementation Engine** | Code production per task briefs | PRs; architectural calls; spec modifications |

**In FORGE Projects:**
- Human Lead = Leo
- Strategist = Jordan (ChatGPT)
- Spec Author = CP (Claude Project)
- Quality Gate = CC (Claude Code)
- Implementation Engine = Cursor

---

## 6. How FORGE Evolves

### What Triggers Changes

- **Execution reality:** CC reports friction between documentation and actual behavior
- **Pattern recognition:** Jordan synthesizes recurring issues into structural proposals
- **Community feedback:** External teams surface unclear documentation
- **Failed cycles:** Abandoned PRs reveal where the method breaks down

### How Feedback Is Classified

All feedback must be tagged before consideration:

| Tag | Meaning | Integration Path |
|-----|---------|------------------|
| **[UNIVERSAL]** | True for any FORGE project | Add to Operations Manual |
| **[CONTEXTUAL]** | Stack or project specific | Document as example |
| **[SITUATIONAL]** | Depends on maturity or risk | Add as conditional guidance |

### What Good Evolution Looks Like

- Grounded in observed execution, not theory
- Maintains or improves execution fidelity
- Does not expand scope
- Does not add complexity without clear payoff
- Versioned with clear changelog

### What Is Explicitly Discouraged

- **Abstraction for its own sake:** If it doesn't run, it doesn't belong
- **Consensus-driven dilution:** Coherence requires stewardship, not voting
- **Framework bloat:** Simplicity is a feature; complexity is debt
- **Prescriptive rigidity:** Principles are fixed; practices adapt
- **Tooling lock-in:** FORGE is methodology, not software

---

## 7. How to Use FORGE in Conversation

### Safe Assumptions in Discussion

When discussing FORGE, you can assume:

- The Five Laws are non-negotiable
- Constitutional documents exist before Execute begins
- Human greenlight is required for phase transitions
- The FORGE Cycle is the execution engine
- Speed comes from locked specs, not faster agents

### Signaling Canon vs Proposal

| Phrase | Meaning |
|--------|---------|
| "Per FORGE..." / "FORGE requires..." | Referring to locked canon |
| "The Operations Manual says..." | Referring to current best practice |
| "What if we..." / "Consider..." | Proposing a change (not canon) |
| "This might be a v1.2 idea..." | Explicitly flagging as proposal |
| "For this project..." | Project-specific adaptation (not canon) |

### Avoiding Scope Creep in FORGE Discussions

- Don't conflate FORGE the method with specific projects using FORGE
- Don't expand FORGE scope to solve problems it wasn't designed for
- Don't treat community suggestions as canon without steward approval
- Don't optimize for edge cases at the expense of core clarity

### Useful Questions to Clarify Intent

- "Is this a FORGE improvement or a project-specific adaptation?"
- "Should this go in Operations Manual or just project docs?"
- "Is this [UNIVERSAL], [CONTEXTUAL], or [SITUATIONAL]?"
- "Does this change locked canon or expected-to-evolve content?"

---

## 8. What FORGE Is Not

A short list for quick reference:

- **Not a tool** — FORGE is methodology; tools implement it
- **Not a coding style** — FORGE governs process, not syntax
- **Not a process checklist** — FORGE is an operating system with judgment built in
- **Not a consensus system** — FORGE is stewarded; evolution is governed, not voted
- **Not a one-size-fits-all prescription** — Principles are fixed; practices adapt
- **Not a guarantee of success** — Discipline enables success; it doesn't ensure it
- **Not a replacement for human judgment** — Humans remain decision-makers throughout

---

## How This Document Is Used

**For Jordan:** This is implicit context for all future FORGE threads. You don't need to re-derive any of this; assume it as foundational.

**For Leo:** You should never need to re-explain "what we're doing here." Point to this document.

**For CP:** When contributors misunderstand scope, point them here before diving into Core or Ops.

**For Future Threads:** This document answers "how should I think about FORGE?" The Core answers "what is FORGE?" The Operations Manual answers "how do I execute FORGE?"

---

## Document Relationships

| Document | Purpose | When to Read |
|----------|---------|--------------|
| **FORGE Orientation** (this) | Mental model, intent, context | First—before anything else |
| **FORGE Core** | Canonical definitions | When you need authoritative statements |
| **FORGE Operations Manual** | Execution-grade how-to | When executing FORGE Cycles |
| **FORGE Governance** | Change management | When proposing methodology changes |
| **FORGE Templates** | Reusable artifacts | When instantiating projects |

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-04 | Initial orientation artifact |

---

**© 2026 FORGE Contributors. All rights reserved.**

**FORGE™** is a trademark of its contributors.

*theforgemethod.org*
