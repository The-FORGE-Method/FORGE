# AMIGO System Design

*Transforming OpenClaw into an enterprise AI teammate platform*

---

## Vision

**OpenClaw** = Personal AI assistant (single-user, single-device)

**AMIGO** = Enterprise AI teammate (multi-user, multi-tenant, organizational soul)

AMIGO isn't just an assistant — it's the **central brain** of an organization:
- Maintains company culture, values, and constitution
- Serves multiple users with role-appropriate access
- Preserves institutional memory across migrations
- Operates with integrity, morals, and character aligned to the organization

---

## Core Differences from OpenClaw

| Aspect | OpenClaw | AMIGO |
|--------|----------|-------|
| Users | Single user | Multi-user (founders, employees, partners) |
| Tenancy | Single tenant | Multi-tenant (serve multiple companies) |
| Identity | Personal assistant persona | Organizational brain with culture/values |
| Memory | Personal workspace files | Shared org memory + personal contexts |
| Access | Full access | Role-based access control |
| Constitution | User-defined SOUL.md | Org constitution + governance docs |
| Deployment | Self-hosted (personal) | SaaS or self-hosted (enterprise) |

---

## Architecture Modifications

### 1. Multi-User Identity Layer

```
┌─────────────────────────────────────────────────────────────────┐
│                      AMIGO CORE                                  │
│                                                                  │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │                 ORGANIZATIONAL SOUL                         │ │
│  │                                                             │ │
│  │  • Constitution (mission, values, governance)               │ │
│  │  • Culture (how we communicate, decide, operate)            │ │
│  │  • Ethics (boundaries, what we won't do)                    │ │
│  │  • Institutional Memory (decisions, rationale, history)     │ │
│  └────────────────────────────────────────────────────────────┘ │
│                              ↓                                   │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │                  USER CONTEXT LAYER                         │ │
│  │                                                             │ │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │ │
│  │  │   Leo    │  │  Carlos  │  │   Jeff   │  │ Employee │   │ │
│  │  │  (Admin) │  │  (COO)   │  │  (CEO)   │  │ (Staff)  │   │ │
│  │  │          │  │          │  │          │  │          │   │ │
│  │  │ Sees all │  │ Ops view │  │ Strategy │  │ Limited  │   │ │
│  │  │ Tech +   │  │ Finance  │  │ Governance│ │ Task     │   │ │
│  │  │ infra    │  │ + ops    │  │ + vision │  │ context  │   │ │
│  │  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │ │
│  └────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

### 2. Constitutional Framework

New workspace structure for organizations:

```
org-workspace/
├── CONSTITUTION/
│   ├── mission.md           # Why we exist
│   ├── values.md            # What we stand for
│   ├── governance.md        # How decisions are made
│   ├── ethics.md            # What we won't do
│   └── culture.md           # How we communicate/operate
│
├── SOUL.md                  # AMIGO's personality for this org
├── MEMORY.md                # Institutional memory
├── JOURNAL.md               # Evolving learnings
│
├── users/
│   ├── leo/
│   │   ├── USER.md          # Leo's preferences, style
│   │   ├── context.md       # What Leo's working on
│   │   └── memory/          # Leo-specific notes
│   ├── carlos/
│   └── jeff/
│
├── departments/
│   ├── engineering/
│   ├── sales/
│   ├── marketing/
│   └── finance/
│
└── projects/
    ├── recalltech/
    ├── patientpal/
    └── internal/
```

### 3. Role-Based Access Control

```typescript
interface Role {
  name: string;
  permissions: Permission[];
  dataAccess: DataScope;
  constitutionalOverride: boolean; // Can override ethics for edge cases?
}

const ROLES = {
  admin: {
    permissions: ['*'],
    dataAccess: 'all',
    constitutionalOverride: false, // Even admins can't override ethics
  },
  executive: {
    permissions: ['read:*', 'write:strategic', 'approve:major'],
    dataAccess: 'strategic',
  },
  manager: {
    permissions: ['read:department', 'write:department', 'approve:minor'],
    dataAccess: 'department',
  },
  employee: {
    permissions: ['read:assigned', 'write:tasks'],
    dataAccess: 'assigned',
  },
  partner: {
    permissions: ['read:project', 'comment'],
    dataAccess: 'project',
  },
};
```

### 4. Constitutional Enforcement

AMIGO enforces the organization's constitution:

```typescript
interface ConstitutionalCheck {
  // Before any action, check against constitution
  async checkAction(action: ProposedAction): Promise<ConstitutionalResult> {
    const checks = [
      this.checkMissionAlignment(action),
      this.checkValueConsistency(action),
      this.checkEthicalBoundaries(action),
      this.checkGovernanceRules(action),
    ];
    
    const results = await Promise.all(checks);
    
    if (results.some(r => r.violation)) {
      return {
        allowed: false,
        reason: results.filter(r => r.violation),
        suggestion: this.suggestAlternative(action, results),
      };
    }
    
    return { allowed: true };
  }
}
```

### 5. Memory Architecture (Multi-User)

```
┌─────────────────────────────────────────────────────────────────┐
│                    ORGANIZATIONAL MEMORY                         │
│                                                                  │
│  ┌─────────────────────────────────────────────────────────────┐│
│  │ INSTITUTIONAL (shared across all users)                      ││
│  │ • Company decisions and rationale                            ││
│  │ • Process documentation                                      ││
│  │ • Key relationships and history                              ││
│  │ • Lessons learned                                            ││
│  └─────────────────────────────────────────────────────────────┘│
│                              ↓                                   │
│  ┌─────────────────────────────────────────────────────────────┐│
│  │ DEPARTMENTAL (shared within department)                      ││
│  │ • Team-specific knowledge                                    ││
│  │ • Project contexts                                           ││
│  │ • Department processes                                       ││
│  └─────────────────────────────────────────────────────────────┘│
│                              ↓                                   │
│  ┌─────────────────────────────────────────────────────────────┐│
│  │ PERSONAL (user-specific, private)                            ││
│  │ • Communication preferences                                  ││
│  │ • Personal task context                                      ││
│  │ • Working style adaptations                                  ││
│  └─────────────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────────┘
```

---

## Key Features to Add

### Phase 1: Multi-User Foundation

- [ ] User authentication integration (Supabase Auth)
- [ ] Role definition and assignment
- [ ] User-specific conversation contexts
- [ ] Shared vs. private memory separation
- [ ] Per-user communication preferences

### Phase 2: Constitutional Framework

- [ ] Constitution file structure and parsing
- [ ] Constitutional check middleware
- [ ] Ethics boundary enforcement
- [ ] Governance rule engine
- [ ] Value alignment scoring

### Phase 3: Organizational Memory

- [ ] Institutional memory layer (Supabase)
- [ ] Cross-user knowledge sharing (with RBAC)
- [ ] Decision logging with rationale
- [ ] Searchable organizational history
- [ ] Memory consolidation (like ai-continuity-framework)

### Phase 4: Multi-Tenant SaaS

- [ ] Organization isolation
- [ ] Per-org configuration
- [ ] Billing integration
- [ ] Custom branding per org
- [ ] Self-service onboarding

---

## Constitutional Documents Structure

### mission.md
```markdown
# Mission

[Organization name] exists to [purpose].

We measure success by [metrics].

Our north star is [guiding principle].
```

### values.md
```markdown
# Values

## 1. [Value Name]
What it means: [description]
How AMIGO applies it: [behavioral guidance]

## 2. [Value Name]
...
```

### ethics.md
```markdown
# Ethical Boundaries

## AMIGO Will Never:
- [Hard boundary 1]
- [Hard boundary 2]

## AMIGO Will Always:
- [Required behavior 1]
- [Required behavior 2]

## Gray Areas (Escalate to Human):
- [Situation requiring judgment]
```

### governance.md
```markdown
# Governance

## Decision Authority
| Decision Type | Who Decides | AMIGO's Role |
|--------------|-------------|--------------|
| Strategic    | CEO/Board   | Inform, recommend |
| Operational  | COO         | Execute with approval |
| Tactical     | Managers    | Execute autonomously |
| Routine      | AMIGO       | Act, report |

## Escalation Path
1. AMIGO attempts resolution
2. Escalate to relevant manager
3. Escalate to executive
4. CEO/Board for strategic
```

---

## Integration Points

### From OpenClaw
- Gateway architecture ✓
- Channel plugins (Telegram, Slack, etc.) ✓
- Skill system ✓
- Memory tools (memory_search, etc.) ✓
- Cron/scheduling ✓
- Node pairing ✓

### New for AMIGO
- Supabase multi-tenant backend
- Constitutional middleware
- RBAC layer
- Organization onboarding
- User management UI
- Cross-user context awareness

---

## Playground Plan

Use `~/clawd/amigo-system` as the sandbox:

1. **Week 1:** Set up constitutional framework
   - Create CONSTITUTION/ structure for Mi Amigos AI
   - Implement constitutional check middleware
   - Test with simple decisions

2. **Week 2:** Multi-user context
   - Add user identification to messages
   - Implement per-user memory directories
   - Test context switching

3. **Week 3:** RBAC implementation
   - Define roles for Mi Amigos AI
   - Implement permission checks
   - Test access control

4. **Week 4:** Integration
   - Connect to Supabase for persistence
   - Migrate from file-based to database
   - Test full flow

---

## Success Criteria

AMIGO is ready when:

1. **Multiple users** can interact simultaneously with appropriate context
2. **Constitutional boundaries** are enforced automatically
3. **Institutional memory** persists and is searchable
4. **Role-based access** controls what each user sees/does
5. **Personality/soul** transfers cleanly during migrations
6. **Other companies** can deploy their own instance

---

*This document will evolve as we build. Leo, CC, and Amigo collaborate here.*

— Amigo 🤝
