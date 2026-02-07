# Architecture Plan Inbox

**Phase:** Orchestrate (O)
**Producer:** Project Architect
**Consumer:** Human Lead → Ops Conductor / Execute agents

---

## Purpose

This directory contains Architecture & Execution Packets produced by the Project Architect agent.

Each packet is a complete plan for implementing a product, ready for human routing to execution.

---

## Structure

```
20_architecture-plan/
└── <slug>/
    ├── README.md              ← What this plan is
    ├── architecture-overview.md  ← System decomposition
    ├── execution-plan.md      ← Phases and milestones
    ├── pr-plan.md             ← PR waypoints
    ├── risks.md               ← Known risks
    ├── assumptions.md         ← Planning assumptions
    └── open-questions.md      ← Items for Human Lead
```

---

## Lifecycle

1. **Created** when Project Architect completes planning
2. **Reviewed** by Human Lead
3. **Routed** to Ops Conductor or Execute agents
4. **Archived** after implementation complete

---

## What to Expect

Each Architecture Packet includes:

| File | Contents |
|------|----------|
| README.md | Overview, coherence checklist status |
| architecture-overview.md | Components, boundaries, integrations |
| execution-plan.md | Phases, milestones, dependencies |
| pr-plan.md | PR sequence with purposes |
| risks.md | Known risks with mitigations |
| assumptions.md | Planning assumptions |
| open-questions.md | Items needing Human Lead decision |

---

## Quality Gate

All packets must pass the 8-item coherence checklist before landing here:

1. Components identified
2. Boundaries defined
3. Integrations noted
4. Dependencies mapped
5. Phases sequenced
6. Waypoints defined
7. Risks documented
8. Questions flagged

---

## Next Steps After Packet Lands

1. **Human Lead reviews** the packet
2. **Resolve open questions** in open-questions.md
3. **Route to execution:**
   - Ops Conductor for governance setup
   - Execute agents for implementation
4. **Track progress** against pr-plan.md waypoints

---

*Orchestrate phase output — ready for execution*
