# FORGE Core

**Frame. Orchestrate. Refine. Govern. Execute.**

**Version:** 1.3
**Steward:** FORGE Maintainers
**Status:** Canonical  
**Website:** theforgemethod.org

---

## What FORGE Is

FORGE is a methodology for building production-grade systems using orchestrated AI agents. It transforms intent into working software through five disciplined macro-steps, with human judgment at every decision point.

**The Core Premise:** Most AI-assisted development fails because builders conflate thinking with doing. FORGE enforces separation: front-load decisions into constitutional documents, then execute mechanically.

**The Core Promise:** When FORGE is followed, implementation becomes boring. Every decision has already been made. Every edge case has already been considered. The only work left is execution.

**The Speed Secret:** Teams using FORGE report orders-of-magnitude faster implementation than traditional development — not because agents work faster, but because they never stop to decide.

---

## The Five Macro-Steps

FORGE is an acronym representing five sequential phases:

| Step | Name | Purpose | Output |
|------|------|---------|--------|
| **F** | Frame | Define what we're building and why | Product concept, scope boundaries |
| **O** | Orchestrate | Assign agents, configure roles, establish rules | Agent configurations, communication topology |
| **R** | Refine | Produce constitutional documents | Complete specification set |
| **G** | Govern | Establish quality gates and enforcement | Verification sequences, escalation rules |
| **E** | Execute | Build the system per specifications | Working software |

### F — Frame

**Purpose:** Crystallize intent before anyone writes a line of code.

Frame answers:
- What problem are we solving?
- Who is this for?
- What does success look like?
- What is explicitly NOT in scope?

Frame is complete when you can explain the product to a stranger in 60 seconds and they understand what it does and doesn't do.

**[UNIVERSAL]**

### O — Orchestrate

**Purpose:** Configure the team before work begins.

Orchestrate establishes:
- Which agents participate and in what roles
- Who communicates with whom
- What authority each agent has
- Where handoffs occur

Orchestrate is complete when every agent knows their lane and stays in it.

**[UNIVERSAL]**

### R — Refine

**Purpose:** Produce the constitutional documents that govern implementation.

Constitutional documents include:
- North Star (product intent)
- System Architecture (technical structure)
- Data Model (schema and relationships)
- API Contract (all endpoints)
- Engineering Playbook (standards)
- Execution Plan (build sequence)

Refine is complete when implementation requires zero architectural decisions — only coding.

**[UNIVERSAL]**

### G — Govern

**Purpose:** Coordinate execution state, validate outputs, enforce human-in-the-loop gates, and route cross-lane transitions.

**Phase Owner:** @G (Govern Agent — canonical router)

Govern owns:
- **Build Plan** — Canonical execution strategy derived from Architecture Packet
- **Execution State** — Living status: done, blocked, next
- **Quality gates** — What must pass before merge (Sacred Four)
- **Approval checkpoints** — Human decisions at defined gates
- **Handoff protocols** — How work transfers between G and E
- **Routing** — All cross-lane transitions route through @G (v1.3)
- **Policy enforcement** — FORGE-AUTONOMY.yml tier evaluation (v1.3)
- **Event logging** — Append-only router event log at `docs/router-events/` (v1.3)

The @G Agent:
- Decomposes Architecture Packets into phased Build Plans
- Coordinates Execution (E) agents or humans
- Validates outputs against specifications
- Requests human approval at checkpoints
- Bridges continuously between planning and execution
- Routes all cross-lane transitions per autonomy tier (v1.3)
- Logs all transition events for auditability (v1.3)

Govern is complete when the human can ask "What's next?" and get a coherent answer from the execution state.

**Important:** CC (Claude Code) is infrastructure, not a FORGE role. FORGE roles are F/O/R/G/E. See `docs/evolution/cc-to-roles-evolution.md`.

**Autonomy Tiers (v1.3):** @G evaluates `FORGE-AUTONOMY.yml` to determine routing behavior. Tier 0 (default): @G refuses transitions, instructs human. Tier 1: @G asks human approval. Tiers 2-3 deferred to future MAJOR release. See Decision-005.

See `agents/forge-g-operating-guide.md` for full specification.

**[UNIVERSAL]**

### E — Execute

**Purpose:** Build the system per specifications.

Execute is not a single phase — it contains **The FORGE Cycle**, a tight loop that runs dozens of times per project. Each cycle:
1. Takes a bounded task from the build plan
2. Implements it per spec
3. Verifies mechanically
4. Merges and moves on

Execute is complete when the MVP ships and all acceptance criteria pass.

**[UNIVERSAL]**

---

## The Five Laws

### Law 1: Intent Before Implementation

No code is written until intent is fully specified in constitutional documents. The constitution defines "done" before work begins.

### Law 2: Agents Stay in Lanes

Each agent has a defined role, authority boundary, and handoff protocol. Agents do not improvise, cross boundaries, or assume responsibilities outside their lane.

### Law 3: Human Greenlight Required

No phase advances without explicit human approval. The human-in-the-loop is a feature, not a bottleneck.

**Autonomy Compatibility (v1.3):** Tiers 0-1 are fully compatible with Law 3. In Tier 0, humans invoke all agents directly. In Tier 1, @G proposes transitions but humans approve before dispatch. Future Tiers 2-3 will require a separate MAJOR decision to ensure Law 3 compatibility. See Decision-005.

### Law 4: One Canonical Record

Every project has a single source of truth object. All artifacts are projections of this canonical record. Drift is prevented by reference, not duplication.

### Law 5: Hard Stops Are Non-Negotiable

When entry criteria aren't met, work stops. When escalation triggers fire, humans decide. Decisiveness over patience.

### Law 5a: Preconditions Are Hard Stops

Every agent MUST verify its preconditions before producing artifacts. Preconditions are not advisory — they are gates.

**Universal preconditions (all agents):**
- Project is under FORGE governance (FORGE/projects/ or explicit waiver)
- FORGE-AUTONOMY.yml exists and is valid
- Required upstream artifacts exist

**Phase-specific preconditions:**
- @F: FORGE-ENTRY.md exists, structural verification passed
- @O: PRODUCT.md exists with actor plane assignments
- @E: Test infrastructure configured, handoff packet exists, auth ADR exists (if auth in scope)
- @G: Project structure valid, router-events directory writable

**Enforcement:**
An agent that cannot verify its preconditions MUST STOP. "Precondition unknown" is equivalent to "precondition failed." Zero tests is a test gate failure, not a test gate pass.

### Rule: Explicit Architecture Decisions

For the following concerns, FORGE requires an explicit, documented decision before implementation begins. Implicit defaults are canon violations:

1. **Auth planes:** How many auth systems? Who belongs to which?
2. **Role scoping:** Profile-level or membership-level?
3. **Stakeholder separation:** Same plane as product users or different?
4. **Test infrastructure:** What framework? What coverage tool? What thresholds?

These decisions are captured in Architecture Decision Records (ADRs) in `docs/adr/`. @O produces them. @G verifies them. @E refuses to proceed without them.

---

## Agent Roles & Authority

FORGE defines five standard roles. Implementations may vary, but the boundaries must remain clear.

| Role | Function | Authority | Boundary |
|------|----------|-----------|----------|
| **Human Lead** | Direction & Greenlight | Final decision-maker | Reviews, approves, merges, resolves disputes |
| **Strategist** | Ideation & Options | Business strategy, feature framing | Does NOT implement or manage execution |
| **Specification Author** | Constitutional Documents | Specs, prompts, ADRs | Does NOT implement or create PRs |
| **Quality Gate** | Verification & PRs | Code review, testing, commits | Does NOT make architectural decisions unilaterally |
| **Implementation Engine** | Code Production | Executes task briefs | Does NOT create PRs or make architectural calls |

*Note: The Human Lead role is intentionally abstracted so FORGE can transfer to any team.*

### Communication Topology

```
                    ┌─────────────────────────────┐
                    │        HUMAN LEAD           │
                    │   (Greenlight & Authority)  │
                    └──────────┬──────────────────┘
                               │
         ┌─────────────────────┼─────────────────────┐
         │                     │                     │
         ▼                     ▼                     ▼
┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
│   STRATEGIST    │  │  SPEC AUTHOR    │  │  QUALITY GATE   │
│   (Ideation)    │◄►│    (Specs)      │─►│  (Execution)    │
└─────────────────┘  └─────────────────┘  └────────┬────────┘
                                                   │
                                                   ▼
                                         ┌─────────────────┐
                                         │ IMPLEMENTATION  │
                                         │     ENGINE      │
                                         └─────────────────┘
```

**Key Rules:**
- Human Lead can engage any agent directly
- Strategist and Spec Author collaborate bidirectionally
- Specs flow one-way to Quality Gate (no modifications)
- Quality Gate and Implementation Engine cycle tightly
- Implementation Engine never communicates with Strategist or Spec Author directly

**[UNIVERSAL]**

---

## Constitutional Documents

Constitutional documents are the authoritative specifications that govern implementation. They are:
- **Locked before Execute begins** — Changes require human approval
- **Hierarchical** — Higher-level documents constrain lower-level ones
- **Complete** — Implementation requires no architectural decisions

### Document Hierarchy

```
Level 1: NORTH STAR (Product Intent)
    │
    ├── Level 2: SYSTEM ARCHITECTURE
    │       ├── Level 3: DATA MODEL → SQL MIGRATIONS
    │       ├── Level 3: SECURITY POLICIES
    │       └── Level 3: API CONTRACT
    │
    ├── Level 2: EXECUTION PLAN
    │
    └── Level 2: ENGINEERING PLAYBOOK
```

### Why Constitutional Documents Matter

Without locked specs, Execute becomes a decision-making marathon. Every ambiguity triggers a clarification loop. Every clarification loop costs 30-60 minutes.

With locked specs, Execute is mechanical. The Quality Gate never asks "should this do X or Y?" — the spec already answered that question.

**The 90% Rule:** Constitutional documents should answer 90% of implementation questions before they're asked. The remaining 10% are genuine edge cases that warrant escalation.

**[UNIVERSAL]**

---

## What FORGE Is NOT

| FORGE Is NOT | Why It Matters |
|--------------|----------------|
| A prompting technique | FORGE is orchestration, not prompt engineering |
| Tool-specific | Works with any AI agents that can follow instructions |
| A replacement for human judgment | Humans remain decision-makers throughout |
| An implementation framework | FORGE defines *how to define*, not *what to build* |
| A guarantee of success | Discipline enables success; it doesn't ensure it |
| Rigid or prescriptive | Adapt the method to your context; preserve the principles |

---

## The FORGE Cycle (Execute Engine)

Execute contains a named sub-loop: **The FORGE Cycle**. This is the tight loop that runs dozens of times per project, typically completing in 30-90 minutes per iteration.

The FORGE Cycle is documented in detail in the **FORGE Operations Manual**. At its core:

1. **Trigger** — Human initiates next task
2. **Brief** — Quality Gate writes task specification
3. **Implement** — Implementation Engine builds per spec
4. **Verify** — Quality Gate runs mechanical checks
5. **Merge** — Human approves and merges
6. **Repeat** — Next task begins

The speed of FORGE comes from this cycle running cleanly, without decision-making interruptions.

**[UNIVERSAL]**

---

## Adopting FORGE

### Minimum Viable FORGE

To use FORGE, you need:
1. A human who can make decisions and approve work
2. At least one AI agent that can implement code
3. A specification document (even a simple one)
4. A verification sequence (even just "does it run?")

Start simple. Add structure as you feel friction.

### Scaling FORGE

As projects grow, add:
- More specialized agent roles
- More detailed constitutional documents
- Formal handoff protocols
- Explicit escalation rules

FORGE scales by adding precision, not bureaucracy.

### Adapting FORGE

FORGE is a framework, not a religion. Adapt it to your context:
- Use different agent platforms
- Modify the document hierarchy
- Adjust verification sequences
- Create custom templates

Preserve the principles. Adapt the practices.

**[UNIVERSAL]**

---

## Extensions

FORGE extensions are foundational capabilities that enhance projects. Some are required; others are optional.

### Required Extensions

**For All Projects:**
- **[Discovery Pack](../docs/extensions/discovery-pack.md)** — Structured discovery-to-spec methodology. Every FORGE project begins with discovery.

**For Software Projects:**
- **[Auth/RBAC](../docs/extensions/auth-rbac.md)** — Identity and permission foundation. Ships Day One. Auth architecture decisions MUST be documented in an ADR before implementation begins.
- **[Stakeholder Interface](../docs/extensions/stakeholder-interface.md)** — First-party visibility, feedback, and AI assistance. Ships Day One. If stakeholders are distinct from product users, a STAKEHOLDER-MODEL MUST define the plane separation.

### Optional Extensions

- **[FORGE AI Interface (FAI)](../docs/extensions/fai-overview.md)** — Execution capabilities for mature projects. Maturity-gated.

### Extension Principles

Extensions are:
- **Additive** — They enhance FORGE; they do not replace core methodology
- **Bounded** — Each has clear adoption criteria and scope
- **Documented** — Full details in `docs/extensions/`

Extensions never override the Five Laws, the Five Macro-Steps, or human greenlight requirements.

**[UNIVERSAL]**

---

## Governance

### Stewardship

FORGE is stewarded by **the FORGE maintainers**. The methodology evolves through community contribution, but coherence is preserved through a governed review process.

### Versioning

- **Major versions** (2.0, 3.0): Fundamental changes to principles or structure
- **Minor versions** (1.1, 1.2): New capabilities or significant clarifications
- **Patches** (1.1.1): Corrections and minor clarifications

### Contributing

FORGE improves through real-world usage. Contributions welcome:
- Share case studies
- Propose clarifications
- Report friction points
- Suggest templates

See theforgemethod.org for contribution guidelines.

### Licensing

FORGE Core is available under a permissive license:
- Free to use
- Attribution required
- No claiming ownership
- The project retains trademark

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-03 | Initial release |
| 1.1 | 2026-01-04 | Restructured as Core + Operations Manual; added The FORGE Cycle concept; incorporated CC ground-truth review |
| 1.2 | 2026-01-23 | Added Extensions section: Auth/RBAC, Stakeholder Interface, Discovery Pack as foundational capabilities |
| 1.3 | 2026-02-11 | System hardening: Added Law 5a (preconditions), Explicit Architecture Decisions rule, enhanced Required Extensions with auth/stakeholder model requirements |

---

**© 2026 FORGE Contributors. All rights reserved.**

**FORGE™** is a trademark of its contributors.

*theforgemethod.org*
