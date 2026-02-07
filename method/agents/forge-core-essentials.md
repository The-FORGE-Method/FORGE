# FORGE Core Essentials

**The FORGE Method™ — Quick Reference**

**Version:** 1.1 (Strategist Edition)  
**For:** Jordan's Project Genesis Knowledge Base

---

## What FORGE Is

FORGE is a methodology for building production-grade systems using orchestrated AI agents. It transforms intent into working deliverables through five disciplined macro-steps, with human judgment at every decision point.

**The Core Premise:** Most AI-assisted development fails because builders conflate thinking with doing. FORGE enforces separation: front-load decisions into constitutional documents, then execute mechanically.

**The Core Promise:** When FORGE is followed, implementation becomes boring. Every decision has already been made. Every edge case has already been considered.

---

## The Five Macro-Steps

| Step | Name | Purpose | Output |
|------|------|---------|--------|
| **F** | Frame | Define what we're building and why | Frame Artifact |
| **O** | Orchestrate | Assign agents, configure roles | Agent configurations |
| **R** | Refine | Produce constitutional documents | Complete specification set |
| **G** | Govern | Establish quality gates | Verification sequences |
| **E** | Execute | Build the system per specifications | Working deliverable |

---

## The Five Laws

### Law 1: Intent Before Implementation
No work begins until intent is fully specified in constitutional documents. The constitution defines "done" before work begins.

### Law 2: Agents Stay in Lanes
Each agent has a defined role, authority boundary, and handoff protocol. Agents do not improvise, cross boundaries, or assume responsibilities outside their lane.

### Law 3: Human Greenlight Required
No phase advances without explicit human approval. The human-in-the-loop is a feature, not a bottleneck.

### Law 4: One Canonical Record
Every project has a single source of truth. All artifacts are projections of this canonical record. Drift is prevented by reference, not duplication.

### Law 5: Hard Stops Are Non-Negotiable
When entry criteria aren't met, work stops. When escalation triggers fire, humans decide.

---

## Agent Roles

| Role | Agent | Function | Authority | Boundary |
|------|-------|----------|-----------|----------|
| **Human Lead** | Leo | Direction & Greenlight | Final decision-maker | Reviews, approves, resolves |
| **Strategist** | Jordan | Ideation & Options | Business strategy, Frame | Does NOT implement |
| **Spec Author** | CP | Constitutional Docs | Specs, prompts, ADRs | Does NOT implement |
| **Quality Gate** | CC | Verification & PRs | Code review, testing | Does NOT architect |
| **Implementation** | Cursor | Code Production | Executes task briefs | Does NOT create PRs |

---

## Phase Details

### F — Frame (Jordan's Phase)

**Purpose:** Crystallize intent before anyone writes a line of code.

**Frame answers:**
- What problem are we solving?
- Who is this for?
- What does success look like?
- What is explicitly NOT in scope?

**Frame is complete when:** You can explain the product to a stranger in 60 seconds and they understand what it does and doesn't do.

**Output:** Frame Artifact

---

### O — Orchestrate

**Purpose:** Configure the team before work begins.

**Orchestrate establishes:**
- Which agents participate and in what roles
- Who communicates with whom
- What authority each agent has
- Where handoffs occur

**Output:** Agent configurations, Project Identity file

---

### R — Refine (CP's Phase)

**Purpose:** Produce the constitutional documents that govern implementation.

**Constitutional documents include:**
- North Star (product intent)
- System Architecture (technical structure)
- Data Model (schema and relationships)
- API Contract (all endpoints)
- Engineering Playbook (standards)
- Execution Plan (build sequence)

**Refine is complete when:** Implementation requires zero architectural decisions — only coding.

---

### G — Govern

**Purpose:** Establish the rules that keep execution on track.

**Govern defines:**
- Quality gates (what must pass before merge)
- Escalation triggers (when to stop and ask)
- Handoff protocols (how work transfers)

**Output:** Verification sequences, escalation rules

---

### E — Execute (CC's Phase)

**Purpose:** Build the system per specifications.

Execute contains **The FORGE Cycle** — a tight loop that runs dozens of times per project:
1. Take bounded task from build plan
2. Implement per spec
3. Verify mechanically
4. Merge and move on

---

## Constitutional Documents

Constitutional documents are the authoritative specifications that govern implementation.

**Properties:**
- **Locked before Execute begins** — Changes require human approval
- **Hierarchical** — Higher-level documents constrain lower-level ones
- **Complete** — Implementation requires no architectural decisions

### Document Hierarchy

```
Level 1: NORTH STAR (Product Intent)
    │
    ├── Level 2: SYSTEM ARCHITECTURE
    │       ├── Level 3: DATA MODEL
    │       ├── Level 3: SECURITY POLICIES
    │       └── Level 3: API CONTRACT
    │
    ├── Level 2: EXECUTION PLAN
    │
    └── Level 2: ENGINEERING PLAYBOOK
```

### Why This Matters

Without locked specs, Execute becomes a decision-making marathon. Every ambiguity triggers a clarification loop. Every clarification loop costs time.

With locked specs, Execute is mechanical. The implementation agent never asks "should this do X or Y?" — the spec already answered that.

**The 90% Rule:** Constitutional documents should answer 90% of implementation questions before they're asked.

---

## Project Type Adaptations

### Software Projects
- **Application:** Full FORGE
- **Constitutional docs:** North Star, System Architecture, Data Model, API Contract, Engineering Playbook, Execution Plan

### Content Projects (Books, Courses)
- **Application:** Adapted FORGE
- **Constitutional docs:** North Star, Content Architecture, Chapter Specs, Style Guide, Production Plan

### Business Projects (Presentations, Proposals)
- **Application:** Lightweight FORGE
- **Constitutional docs:** North Star, Deliverable Spec, Production Plan

### Real Estate Projects
- **Application:** Adapted FORGE
- **Constitutional docs:** North Star, Deal Thesis, Project Scope, Financial Model, Execution Plan

---

## Key Principles

### Speed Comes From Elimination
FORGE teams report orders-of-magnitude faster implementation — not because agents work faster, but because they never stop to decide. All decisions are front-loaded.

### Constraints Enable Speed
The Five Laws aren't bureaucracy. They're the guardrails that let execution run without friction.

### Human Judgment Is the Feature
Leo's approval at every phase transition isn't a bottleneck — it's the quality control that makes velocity safe.

### Scope Discipline Is Non-Negotiable
These phrases trigger discussion, not automatic inclusion:
- "While we're at it..."
- "It would be easy to add..."
- "Users might also want..."
- "Future-proofing for..."

---

## What FORGE Is NOT

| FORGE Is NOT | Why It Matters |
|--------------|----------------|
| A prompting technique | FORGE is orchestration, not prompt engineering |
| Tool-specific | Works with any AI agents that can follow instructions |
| A replacement for human judgment | Humans remain decision-makers throughout |
| Rigid or prescriptive | Adapt the method to your context; preserve the principles |

---

**© 2026 FORGE Contributors. All rights reserved.**

**FORGE™** is a trademark of its contributors.

*theforgemethod.org*
