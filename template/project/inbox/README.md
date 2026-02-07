# Inbox — Frame & Orchestrate Workflow

This directory supports the inbox-driven Frame (F) and Orchestrate (O) phase workflows.

---

## How It Works

### 1. Drop Discovery Materials

Create a folder in `00_drop/` with your feature slug:

```
inbox/00_drop/my-feature/
├── README.md          ← Required: describe what you want
├── threads/           ← Transcripts, notes, brain dumps
├── assets/            ← Sketches, screenshots, photos
└── links.md           ← External references (optional)
```

### 2. Product Strategist Processes

The Product Strategist agent:
1. Reads your discovery materials
2. Asks clarifying questions (up to 3 rounds)
3. Synthesizes into coherent product intent
4. Produces Product Intent Packet

### 3. Output Delivered

Product Intent Packet appears in `10_product-intent/`:

```
inbox/10_product-intent/my-feature/
├── README.md
├── intent.md
├── actors.md
├── use-cases.md
├── non-goals.md
├── assumptions.md
├── open-questions.md
└── source-index.md
```

### 4. Human Routes to Orchestrate

Human Lead reviews packet and routes to Project Architect.

### 5. Project Architect Processes

The Project Architect agent:
1. Reads the Product Intent Packet
2. Asks clarifying questions (up to 2 rounds)
3. Decomposes into architecture components
4. Produces Architecture & Execution Packet

### 6. Architecture Packet Delivered

Architecture Packet appears in `20_architecture-plan/`:

```
inbox/20_architecture-plan/my-feature/
├── README.md                 ← Overview + coherence checklist
├── architecture-overview.md  ← System decomposition
├── execution-plan.md         ← Phases and milestones
├── pr-plan.md                ← PR waypoints
├── risks.md                  ← Known risks
├── assumptions.md            ← Planning assumptions
└── open-questions.md         ← Items for Human Lead
```

### 7. Human Routes to Execute

Human Lead reviews architecture packet and routes to execution agents.

---

## Directory Structure

```
inbox/
├── README.md              ← You are here
├── 00_drop/               ← Discovery input (you write here)
│   └── .template/         ← Example structure
├── 10_product-intent/     ← Product Intent Packets (Frame output)
│   └── .template/         ← Example packet
└── 20_architecture-plan/  ← Architecture Packets (Orchestrate output)
    └── .template/         ← Example packet
```

---

## When to Use This

- **New feature:** Drop discovery for any new capability
- **Bug/refactor:** When clarification needed before fixing
- **Pivot:** When direction is changing significantly
- **Enhancement:** When scope needs definition

---

## Quality Expectations

Product Intent Packets are professional PM-level artifacts:
- Usable by external development teams
- Clear enough for stakeholder review
- Complete enough for technical planning

---

## Relationship to Other Artifacts

| Artifact | Purpose | Location |
|----------|---------|----------|
| Product Intent Packet | Frame-phase discovery output | `inbox/10_product-intent/` |
| Architecture Packet | Orchestrate-phase planning output | `inbox/20_architecture-plan/` |
| PRODUCT.md | Refined constitutional doc | `docs/constitution/` |

**Flow:** Product Intent → Architecture Packet → Constitutional docs → Execute

Both packets are preserved as historical discovery and planning records.
