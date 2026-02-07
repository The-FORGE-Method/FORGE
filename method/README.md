# The FORGE™ Method

**Frame. Orchestrate. Refine. Govern. Execute.**

> A methodology for building production-grade systems using orchestrated AI agents.

---

## Quick Navigation

| You want to... | Go to... |
|----------------|----------|
| **Understand the FORGE methodology** | You're in the right place (this repo) |
| **Start a new FORGE project** | Use [template/project/](../template/project/) |

**This repo is the canon.** To actually *use* FORGE on a project, copy the [project template](../template/project/) — it's pre-wired with all the files and structure you need.

---

## What FORGE™ Is

FORGE™ is an execution discipline — not a framework, not a library, not a product. It's a methodology for transforming intent into working software through five disciplined macro-steps, with human judgment at every decision point.

**The Core Premise:** Most AI-assisted development fails because builders conflate thinking with doing. FORGE enforces separation: front-load decisions into constitutional documents, then execute mechanically.

**The Core Promise:** When FORGE is followed, implementation becomes boring. Every decision has already been made. Every edge case has already been considered. The only work left is execution.

**The Speed Secret:** Teams using FORGE report orders-of-magnitude faster implementation than traditional development — not because agents work faster, but because they never stop to decide.

---

## The Five Macro-Steps

| Step | Name | Purpose | Output |
|------|------|---------|--------|
| **F** | Frame | Define what we're building and why | Product concept, scope boundaries |
| **O** | Orchestrate | Assign agents, configure roles, establish rules | Agent configurations, communication topology |
| **R** | Refine | Produce constitutional documents | Complete specification set |
| **G** | Govern | Establish quality gates and enforcement | Verification sequences, escalation rules |
| **E** | Execute | Build the system per specifications | Working software |

### Frame

Crystallize intent before anyone writes a line of code.

Frame answers:
- What problem are we solving?
- Who is this for?
- What does success look like?
- What is explicitly NOT in scope?

Frame is complete when you can explain the product to a stranger in 60 seconds and they understand what it does and doesn't do.

### Orchestrate

Configure the team before work begins.

Orchestrate establishes:
- Which agents participate and in what roles
- Who communicates with whom
- What authority each agent has
- Where handoffs occur

Orchestrate is complete when every agent knows their lane and stays in it.

### Refine

Produce the constitutional documents that govern implementation.

Constitutional documents include:
- **PRODUCT.md** — Product intent (the North Star)
- **TECH.md** — System architecture and technical structure
- **GOVERNANCE.md** — Security, policies, and operational rules

Refine is complete when implementation requires zero architectural decisions — only coding.

### Govern

Establish the rules that keep execution on track.

Govern defines:
- Quality gates (what must pass before merge)
- Escalation triggers (when to stop and ask)
- Timeout policies (when to force decisions)
- Handoff protocols (how work transfers between agents)

Govern is complete when the verification sequence is mechanical and the escalation path is unambiguous.

### Execute

Build the system per specifications.

Execute contains **The FORGE Cycle** — a tight loop that runs dozens of times per project:
1. Take a bounded task from the build plan
2. Implement it per spec
3. Verify against acceptance criteria
4. Commit and move to next task

---

## Core Principles

### 1. Constitution First

No execution without specification. Constitutional documents (PRODUCT.md, TECH.md, GOVERNANCE.md) define truth. Implementation follows.

### 2. Lanes Over Chaos

Every agent has a lane. Strategists strategize. Planners plan. Executors execute. Cross-lane work requires explicit escalation.

### 3. Human-in-the-Loop

AI agents propose. Humans approve. Every significant decision requires steward sign-off.

### 4. Verification Before Progress

Nothing is done until verification passes. Build → Test → Verify → Commit. Skip nothing.

### 5. Scope is Sacred

Scope creep is the enemy. If it's not in the constitutional docs, it doesn't get built without explicit amendment.

---

## Agent Roles

FORGE orchestrates multiple agents with clear separation of concerns:

| Role | Agent | Lane | Authority |
|------|-------|------|-----------|
| **Steward** | Human (Leo) | Approval, adjudication | Final say on everything |
| **Strategist** | Jordan (CP) | Product vision, scope | Defines what to build |
| **Architect** | Project Architect | Planning, governance | Creates task briefs, enforces scope |
| **Executor** | Claude Code (CC) | Implementation | Builds per spec |
| **Editor** | Cursor | File editing | Writes code per brief |

### The Three Non-Negotiable Rules

1. **Cursor NEVER talks to Jordan** — Cursor receives instructions from CC, not strategy from Jordan
2. **CC NEVER commits without verification** — Build, test, verify, then commit
3. **Nobody changes scope without steward approval** — Constitutional amendments require Leo

---

## Repository Structure

```
method/
├── core/                    # Canonical FORGE doctrine
│   ├── forge-core.md        # Core methodology (the five macro-steps)
│   ├── forge-governance.md  # Governance rules and escalation
│   ├── forge-operations.md  # Operational patterns and cycles
│   └── forge-orientation.md # Orientation for new users
│
├── profiles/                # Domain-specific implementations
│   └── forge-sd-profile.md  # FORGE for Software Development
│
├── templates/               # Ready-to-use templates
│   ├── forge-template-frame.md           # Frame phase template
│   ├── forge-template-kickoff-brief.md   # Project kickoff
│   ├── forge-template-project-spec.md    # Specification template
│   ├── forge-template-project-architect.md # Architect agent template
│   ├── forge-template-repository-scaffold.md # Repo structure
│   └── ...
│
├── starter-kit/             # Drop-in project scaffolding
│   ├── CLAUDE.md            # CC identity file template
│   ├── .cursor/             # Cursor rules
│   ├── chatgpt/             # ChatGPT configuration
│   └── claude_ai/           # Claude.ai configuration
│
├── 02_execution/            # Execution evidence
│   ├── recons/              # Validated reconnaissance reports
│   │   └── *.md             # Real-world testing documentation
│   └── experiments/         # In-progress tests
│
├── agents/                  # Agent definitions and configurations
├── meta/                    # Meta-documentation about FORGE itself
└── archive/                 # Historical/deprecated content
```

---

## Getting Started

### For New Projects

1. **Clone the starter-kit** into your new project:
   ```bash
   cp -r starter-kit/* /path/to/your/project/
   ```

2. **Customize CLAUDE.md** with your project identity

3. **Create constitutional docs** in `docs/constitution/`:
   - PRODUCT.md (what you're building)
   - TECH.md (how you're building it)
   - GOVERNANCE.md (rules and policies)

4. **Begin Frame phase** — work with Jordan (or your strategist) to define scope

### For Claude Code Users

The `forge-architect` agent (installed globally at `~/.claude/agents/forge-architect.md`) can scaffold new FORGE projects automatically:

```
Task: forge-architect
Prompt: "Jordan gave me this brief: [YOUR PROJECT BRIEF]"
```

The architect will create:
- Complete folder structure
- Pre-filled CLAUDE.md
- Constitutional doc templates
- Project-specific architect agent
- First task brief

---

## Genesis Vault

Historical spawn system patterns have been archived. Agent specifications now live in `method/agents/`.

---

## Domains

FORGE supports multiple domains with specialized profiles:

### FORGE-SD (Software Development)

Full methodology with code-centric constitutional docs:
- PRODUCT.md, TECH.md, GOVERNANCE.md
- Build plans and verification sequences
- Git workflow and PR templates

### FORGE-BOOK (Publishing)

Adapted methodology for book/content projects:
- CONCEPT.md, STRUCTURE.md, VOICE.md
- Chapter-based build plans
- Revision workflow

---

## Philosophy

### Why Constitutional Documents?

Traditional development asks: "What should we build next?"

FORGE asks: "What did we already decide?" — and finds the answer in the constitution.

This front-loading of decisions means:
- No context loss between sessions
- No decision fatigue during execution
- No scope creep without explicit amendment
- Predictable, repeatable delivery

### Why Strict Lanes?

AI agents are powerful but undisciplined. Without clear boundaries, they:
- Wander into adjacent problems
- Make architectural decisions during implementation
- Optimize for cleverness over specification

FORGE lanes keep agents productive by keeping them constrained.

### Why Human-in-the-Loop?

AI can propose, but AI shouldn't decide. Every significant choice — scope changes, architectural pivots, trade-off resolutions — requires human judgment.

The steward is the adult in the room.

---

## Execution Evidence

FORGE is execution-derived. The `02_execution/recons/` folder contains validated reconnaissance reports documenting:
- What we tested
- What worked
- What failed
- What we learned

These reports prove FORGE claims through real-world testing, not theory.

---

## Contributing

FORGE is maintained by the FORGE community.

- **Canon changes** require steward approval
- **Templates and profiles** welcome community PRs
- **Execution evidence** strengthens the methodology

---

## License

The FORGE Method is maintained by its contributors.

- **Personal use:** Free for individual developers
- **Commercial use:** Contact for licensing
- **Attribution required:** Credit theforgemethod.org

---

## Links

- **Website:** [theforgemethod.org](https://theforgemethod.org)
- **Steward:** FORGE Maintainers

---

*The FORGE Method™ — Frame. Orchestrate. Refine. Govern. Execute.*
