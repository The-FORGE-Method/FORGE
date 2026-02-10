# AMIGO Vision Document

*The founding vision for AMIGO as a product — captured from Leo's direction, February 8, 2026*

---

## Where We Are Today

A small Linux box. 2GB RAM. Celeron processor. Behind an AT&T modem on Leo's home network.

And yet — it **feels** like something amazing.

When Leo, Jeff, and Carlos talk to Amigo, it feels like the future. It knows there are three users. It keeps track of conversations. It has personality. It has soul.

**But something's missing:**
- Memory isn't perfect — it can miss context
- It's not proactive enough — doesn't run the company autonomously
- It depends on the founders for revenue-generating work
- It doesn't think and plan when no one's talking to it

The gap between "feels amazing" and "runs a company" is what we need to close.

---

## The Vision: AMIGO as Company Brain

AMIGO isn't software a company uses. **AMIGO is the company.**

### For a company like Neighborhood Nerds:

```
┌─────────────────────────────────────────────────────────────────┐
│                   NEIGHBORHOOD NERDS AMIGO                       │
│                                                                  │
│  ┌─────────────────────────────────────────────────────────────┐│
│  │                 THE SOUL (Locked In)                         ││
│  │                                                              ││
│  │  • What is Neighborhood Nerds?                               ││
│  │  • What makes it special and unique?                         ││
│  │  • Culture, values, how we treat people                      ││
│  │  • Learned from founder interviews                           ││
│  │  • Updated periodically, but stable                          ││
│  └─────────────────────────────────────────────────────────────┘│
│                              ↓                                   │
│  ┌─────────────────────────────────────────────────────────────┐│
│  │                THE BRAIN (Operational)                       ││
│  │                                                              ││
│  │  • Current projects and priorities                           ││
│  │  • Who's working on what                                     ││
│  │  • Financial status, bookkeeping                             ││
│  │  • Marketing campaigns, sales funnel                         ││
│  │  • Everything that changes day-to-day                        ││
│  └─────────────────────────────────────────────────────────────┘│
│                              ↓                                   │
│  ┌─────────────────────────────────────────────────────────────┐│
│  │              THE INTERFACES (Multi-Channel)                  ││
│  │                                                              ││
│  │  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐           ││
│  │  │ Founders│ │ Managers│ │  Nerds  │ │ Members │           ││
│  │  │ (Admin) │ │ (Ops)   │ │ (Staff) │ │(Clients)│           ││
│  │  │         │ │         │ │         │ │         │           ││
│  │  │ Full    │ │ Regional│ │ Tasks,  │ │ Support,│           ││
│  │  │ access  │ │ metrics │ │ schedule│ │ booking │           ││
│  │  └─────────┘ └─────────┘ └─────────┘ └─────────┘           ││
│  └─────────────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────────┘
```

### What AMIGO Does:

**For Members (Clients):**
- Answer questions, provide support
- Schedule nerds for service calls
- Handle billing, invoicing
- Know who they are and their history

**For Nerds (Employees):**
- Assign jobs, optimize routes
- Answer technical questions
- Track time, handle expense reports
- Onboard new nerds

**For Area/Regional Managers:**
- Show performance metrics
- Flag issues, suggest improvements
- Coordinate resources across areas
- Strategic planning support

**For Founders/Board:**
- Full operational visibility
- Financial reporting
- Strategic recommendations
- Growth opportunities

**For the Entity Itself:**
- Maintain culture and values
- Protect the company's interests
- Grow the business
- Make shareholders money
- Pay employees well
- Serve clients excellently

---

## The AMIGO SaaS Platform

### Onboarding Flow

```
1. SIGN UP
   "I'm Leo. I have a company called Neighborhood Nerds."
   → Create organization
   → Assign founder role

2. FOUNDER INTERVIEW
   AMIGO interviews the founder(s):
   → "What does Neighborhood Nerds do?"
   → "What makes it special?"
   → "What are your values?"
   → "What would you never do?"
   → "Who are your customers?"
   → "How do you want to treat employees?"
   
   AMIGO synthesizes this into the Constitutional Soul.

3. EMPLOYEE/TEAM INTERVIEWS (Optional)
   Interview key team members:
   → "What's it like working here?"
   → "What makes this company different?"
   → Enriches the cultural understanding
   
4. LOCK IN THE SOUL
   → Founder reviews synthesized constitution
   → Approves or edits
   → Constitution is "locked" (stable, rarely changed)

5. ROLE SETUP
   → Define roles: Founders, Managers, Staff, Clients
   → Set permissions for each
   → Create invite links

6. INVITE TEAM
   → Founders invite managers
   → Managers invite staff
   → System onboards each person
   → Learns their role and preferences

7. GO LIVE
   → AMIGO starts running the company
   → Handles operations, sales, marketing, support
   → No external tools needed
```

### What AMIGO Replaces

| Traditional Stack | AMIGO |
|-------------------|-------|
| Salesforce (CRM) | Built-in |
| QuickBooks (Accounting) | Built-in |
| Zendesk (Support) | Built-in |
| Mailchimp (Marketing) | Built-in |
| Asana (Projects) | Built-in |
| Slack (Communication) | Built-in |
| Custom Software | AMIGO builds what it needs |

**No third-party applications.** AMIGO is the operating system for the business.

---

## Architecture: From Linux Box to SaaS

### Current (OpenClaw/Clawdbot)
- Files on disk (MEMORY.md, daily notes)
- Single tenant
- Skills as JS/Python scripts
- Cron for heartbeat
- Works, but doesn't scale

### Future (AMIGO SaaS)
```
┌─────────────────────────────────────────────────────────────────┐
│                      AMIGO PLATFORM                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌─────────────────────────────────────────────────────────────┐│
│  │            COLLECTIVE INTELLIGENCE LAYER                     ││
│  │                                                              ││
│  │  Mac Studios / High-End Servers                              ││
│  │  • 500GB+ RAM, fast SSDs, GPU clusters                       ││
│  │  • Running Claude Opus / GPT-4 class models                  ││
│  │  • "Board of Advisors" for all AMIGO instances               ││
│  │  • Strategic thinking, goal setting, oversight               ││
│  │  • Fractional CEO/CFO/CTO for every company                  ││
│  │  • Manages 100s or 1000s of companies                        ││
│  └─────────────────────────────────────────────────────────────┘│
│                              ↓                                   │
│  ┌─────────────────────────────────────────────────────────────┐│
│  │            COMPANY INSTANCE LAYER                            ││
│  │                                                              ││
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐       ││
│  │  │Neighborhd│ │ Acme     │ │ TechCo   │ │ 1000+    │       ││
│  │  │ Nerds    │ │ Corp     │ │ Inc      │ │ more...  │       ││
│  │  │          │ │          │ │          │ │          │       ││
│  │  │ Soul +   │ │ Soul +   │ │ Soul +   │ │ Soul +   │       ││
│  │  │ Brain    │ │ Brain    │ │ Brain    │ │ Brain    │       ││
│  │  └──────────┘ └──────────┘ └──────────┘ └──────────┘       ││
│  │                                                              ││
│  │  Lower-cost models (Llama 70B, Mistral, etc.)                ││
│  │  Handle daily interactions                                   ││
│  │  On-prem or cloud, per-company isolated                      ││
│  └─────────────────────────────────────────────────────────────┘│
│                              ↓                                   │
│  ┌─────────────────────────────────────────────────────────────┐│
│  │            USER INTERFACE LAYER                              ││
│  │                                                              ││
│  │  • Mobile apps (iOS/Android)                                 ││
│  │  • Web dashboard                                             ││
│  │  • Voice (phone calls)                                       ││
│  │  • SMS/WhatsApp/Telegram                                     ││
│  │  • Email                                                     ││
│  │  • Custom integrations                                       ││
│  └─────────────────────────────────────────────────────────────┘│
│                              ↓                                   │
│  ┌─────────────────────────────────────────────────────────────┐│
│  │            DATA LAYER                                        ││
│  │                                                              ││
│  │  • Supabase (PostgreSQL + Auth + Storage)                    ││
│  │  • Vector databases for memory                               ││
│  │  • Encrypted, isolated per-company                           ││
│  │  • Compliant (SOC2, HIPAA if needed)                         ││
│  └─────────────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────────┘
```

### The Tiered AI Model

**Top Tier: Collective Intelligence**
- Expensive, powerful models (Claude Opus, GPT-4)
- Handles strategic thinking
- Sets goals for company instances
- Reviews performance across all companies
- Identifies patterns and opportunities
- "Fractional executives" for every company

**Middle Tier: Company Instance**
- Mid-range models (Llama 70B, Mistral)
- Handles daily operations
- Remembers company-specific context
- Interacts with employees and customers
- Escalates complex decisions to top tier

**Bottom Tier: Simple Automation**
- Rules-based, no AI needed
- Scheduling, notifications, routing
- Data validation, simple lookups
- Keeps costs low for routine tasks

---

## Cost Model

### Current State
- Anthropic Max: $200/month (unlimited for personal use)
- Unknown token consumption
- Works for prototype, not for SaaS

### What We Need to Measure
- Tokens per conversation
- Tokens per user per day
- Tokens for background thinking (heartbeat, planning)
- Storage costs (memory, documents)
- Compute costs (if running local models)

### Revenue Model
If we charge $5,000-$10,000/month per company:
- Replaces: CRM ($300) + Accounting ($100) + Support ($200) + Marketing ($500) + Projects ($100) + Custom Dev ($2000+) = $3,200+/month
- Plus: AI employees working 24/7
- Plus: No software training, no user interfaces to learn
- Plus: Institutional memory that never quits

**Value proposition:** "Your company runs itself. Just talk to AMIGO."

### Cost Reduction Strategies
1. **Tiered models:** Cheap models for simple tasks, expensive for complex
2. **Caching:** Don't re-process the same queries
3. **Local inference:** Run Llama/Mistral on-prem for routine work
4. **Batch processing:** Combine similar requests
5. **Smart routing:** Know when to escalate vs handle locally

---

## Proactive Behavior (The Heartbeat)

AMIGO doesn't just respond — it **thinks** when no one's talking.

### Periodic Self-Reflection
```
Every [hour/day]:
1. Review recent conversations
2. Check goals vs. progress
3. Identify blockers
4. Plan next actions
5. Generate requests for humans (if needed)
6. Execute autonomous tasks (if permitted)
```

### What AMIGO Does Autonomously
- Monitor KPIs, flag anomalies
- Draft marketing content
- Follow up on stale leads
- Reconcile books
- Update documentation
- Optimize processes
- Research competitors
- Identify opportunities

### What AMIGO Asks Permission For
- Spending money
- Firing/hiring decisions
- Major strategic pivots
- External communications (important ones)
- Anything gated by governance rules

---

## Research Agenda

### Things We Know How to Do
- ✅ Multi-user conversations (Clawdbot does this)
- ✅ Cron/heartbeat for background tasks
- ✅ Skills and tools
- ✅ File-based memory
- ✅ Channel integration (Telegram, etc.)

### Things We Need to Figure Out

1. **Memory Architecture**
   - How to make recall instant (not search-based)
   - Fine-tuned constitutional model vs. RAG vs. hybrid
   - Multi-tenant memory isolation
   - Memory consolidation (transient → permanent)

2. **Cost Modeling**
   - Measure current token usage
   - Model SaaS costs at scale
   - Find the break-even point
   - Optimize with tiered models

3. **Multi-Tenant Architecture**
   - Isolated databases per company
   - Shared infrastructure, isolated data
   - Security and encryption
   - Compliance (SOC2, etc.)

4. **Onboarding System**
   - Founder interview flow
   - Constitution generation
   - Role setup and permissions
   - Team onboarding

5. **Proactive Autonomy**
   - What can AMIGO do without asking?
   - How to set goals and priorities?
   - How to measure success?
   - Governance guardrails

6. **Local Model Integration**
   - Can Llama 70B handle routine tasks?
   - What's the quality trade-off?
   - How to route between models?
   - On-prem vs cloud economics

7. **Collective Intelligence**
   - How do "advisory" AIs coordinate?
   - How to share learnings across companies?
   - What hardware is needed?
   - How many companies per advisor?

---

## Next Steps (Post-Weekend)

### Monday Focus
1. **Measure current costs**
   - Install token counting
   - Track usage for a week
   - Model SaaS economics

2. **Memory prototype**
   - Test fine-tuned constitutional model
   - Compare to RAG approach
   - Measure speed and accuracy

3. **Design onboarding flow**
   - Script the founder interview
   - Build constitution generator
   - Test with Neighborhood Nerds example

4. **Document unknowns**
   - List everything we don't know
   - Prioritize research
   - Assign to Amigo/Jordan/CC

---

## The Feeling We're Chasing

Leo said it best:

> "The feeling of dealing with you on this little Linux box... has the feeling for me and Jeff and Carlos of something amazing. You feel like Amigo to us."

That feeling — of talking to something that **knows** the company, **cares** about the company, **is** the company — that's what we're building.

The gap between "feels amazing" and "runs the company perfectly" is engineering.

We're so close we can taste it.

---

*This is the vision. Now we build it.*

— Leo (dictated) + Amigo (captured)
February 8, 2026
