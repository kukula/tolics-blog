---
title: "Living Software: The Framework"
date: 2026-02-07
lastmod: 2026-02-07
draft: false
author: "Tolic Kukul"
description: "Stability contracts, consequence graphs, immutable event logs, and a conductor that turns the gap between intent and reality into autonomous work."
tags: ["software-architecture", "ai-agents", "autonomous-systems", "self-healing", "design-patterns"]
categories: ["Software Architecture"]
series: ["Living Software Framework"]
---

The previous posts explored [what AI-native software could look like](/posts/2026-02-05-beyond-the-horseless-carriage/) and [how ambiguity becomes its vital sign](/posts/2026-02-06-ambiguity-as-a-vital-sign/). The vision is clear enough: software as a living system, not a factory pipeline. Express intent, let AI handle the translation layers, evolve continuously within safety bounds.

But a vision without a framework is just a metaphor. This post makes it concrete — the primitives, layers, and mechanisms that would let you actually build software this way.

## The Stability Contract

The foundation is an immutable layer that agents cannot touch. Think of it like a constitution for the system. Humans write this, agents obey it.

```text
system "crm_system" {

  # Hard invariants — never violatable
  invariant customer_data_never_lost
  invariant response_time < 500ms
  invariant auth_required_for_customer_data

  # Behavioural intent — what the system does
  capability track_interactions {
    accepts: rep_logged_activity, customer_event
    produces: engagement_score, churn_alerts
    property: works_offline
    property: data_stays_in_region unless compliance_allows
  }

  capability assign_rep {
    accepts: new_deal, rep_availability
    produces: deal_assignment
    property: handles_reassignment
    property: respects_territory
  }

  # Quality bounds — the system can optimise within these
  optimise cost within budget($200/month)
  optimise latency minimise
  optimise accessibility WCAG_AA
}
```

This is what humans care about. Everything below this is the agent's domain.

The stability contract needs invariants that go beyond technical correctness:

```text
invariant no_spam_or_over_contact
invariant customer_maintains_data_sovereignty
invariant contact_requires_consent
invariant data_retention_compliant
invariant explainable_recommendations  # no black-box scoring
```

These are harder to verify formally, but they can be checked through a combination of static analysis, simulation, and human-in-the-loop review for the subset of changes that touch these concerns.

## Intent as Reactive Specification

The stability contract declares what must always be true. But a living system also needs to declare what should happen when things change — a reactive specification that can answer "given everything that's happened, what should be true right now?"

### A Complete Example

```text
system "customer_platform" {

  # ─── DATA SEMANTICS ───

  entity customer {
    has: interactions[]
    has: deals[]
    has: preferences
    rule: always_has_encryption_key
    rule: deletion_means_crypto_shred
  }

  entity interaction {
    belongs_to: customer
    immutable: true        # once recorded, never changed
    has: type, sentiment, timestamp, context
    rule: timestamp_never_in_future
  }


  # ─── REACTIVE CONSEQUENCES ───
  # Each "when" block declares: if X happens, Y must follow.
  # The conductor just checks: did Y follow?

  when interaction.created {

    # Always happens
    must: update_engagement_score(interaction.customer)
    must: acknowledge_to_rep(interaction)
      within: 5s

    # Conditional consequences
    if engagement(interaction.customer).trend
       crosses threshold.churn_warning {

      must: alert_rep(
        customer: interaction.customer,
        reason: churn_risk_rising,
        actionable: true    # alert must suggest next step
      )
        within: 1m

      must: log_alert_event
    }

    if engagement(interaction.customer).trend
       crosses threshold.churn_critical
       AND interaction.customer.has_account_manager {

      must: notify_account_manager(
        manager: interaction.customer.primary_account_manager,
        summary: engagement_summary(interaction.customer),
        urgency: high
      )
        within: 5m

      must: await_manager_acknowledgment
        within: 24h
        fallback: escalate_to_sales_director
    }
  }

  when customer.assigned_rep {
    must: share_history(
      data: customer.interactions,
      recipient: rep,
      requires: data_access_authorisation
    )
    must: setup_notification_channel(customer, rep)
  }


  # ─── TEMPORAL EXPECTATIONS ───
  # Things that should happen based on time, not events

  every day at rep.preferred_time {
    if rep.has_active_deals {
      should: prompt_activity_log(rep)
        # "should" vs "must" — soft expectation,
        # gap is low priority
    }
  }

  every week {
    for each customer with interactions.count > 3 {
      must: generate_pipeline_review(customer)
      must: recalculate_engagement_scores(customer)
    }
  }

  when alert.unacknowledged for 4h {
    must: re_alert(
      escalate: true,
      channel: most_reliable(rep.contact_preferences)
    )
  }


  # ─── INVARIANTS (always true, not event-triggered) ───

  always {
    assert: every(interaction) is reachable_through_projection
    assert: every(customer.encryption_key) exists AND valid
    assert: no(alert.critical) is unacknowledged for > 24h
    assert: every(deal_score) has explanation
    assert: every(customer_contact) has consent_record
  }
}
```

### The Consequence Graph

The intent layer compiles down to a consequence graph — a computable structure that the conductor evaluates:

```text
Event: interaction.created(i1, customer: c1, type: call, sentiment: negative)

Expected consequences:
├─ MUST engagement_updated(c1)              within: 5s
│   └─ status: ✓ (event e4021 satisfies this)
├─ MUST acknowledged(i1)                    within: 5s
│   └─ status: ✗ GAP — no acknowledgment event found
├─ CONDITIONAL: check churn threshold
│   └─ engagement(c1).trend = 42 → crosses churn_warning(45)
│       ├─ MUST alert_rep(c1, churn_risk_rising) within: 1m
│       │   └─ status: ✓ (event e4022)
│       └─ MUST log_alert_event
│           └─ status: ✓ (event e4023)
└─ CONDITIONAL: check critical + manager
    └─ trend = 42, critical threshold = 20 → not crossed
        └─ no consequences required ✓

Gaps found: 1
  → acknowledgment missing for interaction i1
  → severity: must-within-5s (high priority)
  → spawn agent to resolve
```

The conductor doesn't need to know anything about CRM. It just evaluates the consequence graph. The intelligence is in the intent spec, not the gap detector.

### Priority: Must, Should, Could

The must/should distinction is how the framework decides which gaps to resolve now and which to let evolve:

- **must** — hard gap. Conductor spawns agent immediately. Promotion is blocked until resolved.
- **should** — soft gap. Conductor logs it, spawns agent on low priority. System continues functioning.
- **could** — optimisation opportunity. Conductor notes it, addresses when there's spare budget.

Invariant violations sit above all three — fix immediately.

### Intent Evolution Creates Gaps Automatically

When the intent evolves, the system automatically knows what work needs to happen to bring existing data into compliance. No migration scripts. No Jira tickets. The gap just appears and agents resolve it.

```text
# Day 1: intent spec says
when interaction.created {
  must: update_engagement_score(customer)
}

# Day 30: human updates intent spec to add
when interaction.created {
  must: update_engagement_score(customer)
  must: check_competitor_mentions(customer)   # NEW
}

# The conductor immediately detects:
# "there are 5,000 existing interactions where
#  check_competitor_mentions never ran"
#
# This is a CONSEQUENCE GAP — retroactive.
# The intent layer can specify:

when intent.evolved {
  backfill_policy: sequential   # process old events against new rules
  # vs: prospective_only        # only apply to new events
  # vs: human_decision          # ask human what to do
}
```

## The Persistence Model

Code is stateless — you can throw it away and regenerate it. Data is the opposite. It's accumulated, irreplaceable, and it has meaning that changes as the system evolves. If agents are going to restructure the system continuously, the data has to survive every restructuring.

### The Immutable Event Log

Underneath everything, the framework maintains an immutable, append-only event log. Every piece of primary data enters the system as an event and never changes.

```text
Event log (immutable, append-only, source of truth):

  e001: { customer: c1, type: interaction_logged,
           data: {call, duration: 15m, notes: "pricing Q"}, time: ... }
  e002: { customer: c1, type: deal_updated,
           data: {stage: negotiation, value: 50k}, time: ... }
  e003: { customer: c1, type: rep_assigned,
           data: {rep: jsmith}, time: ... }
  e004: { customer: c1, type: consent_granted,
           data: {marketing_emails: true}, time: ... }
```

This is event sourcing elevated to a framework primitive rather than an architectural choice. Agents never touch this log — they can only append to it. Everything else — the queryable database, the API responses, the user-facing views — is a projection of this log, and projections can be rebuilt from scratch at any time.

### Disposable Projections

This is what makes evolution safe. When an agent restructures the system, it's not migrating data. It's building a new projection of the same immutable events.

```text
Current system:
  Event log: [e001, e002, e003, ... e50000]
  Projection A: PostgreSQL with schema v3
    → customers table, interactions table, deals table

Agent creates a draft with a completely different data model:
  Projection B: Graph database
    → company nodes, contact nodes, deal nodes, relationship edges

Promotion process:
  1. Agent builds Projection B from the FULL event log
     (replays all 50,000 events into new structure)
  2. Verification: is every primary data point accessible
     through the new projection?
  3. Canary: run both projections simultaneously, compare
     results for real queries
  4. Swap: route traffic to Projection B
  5. Keep Projection A alive for rollback window
  6. Event log never changed. Nothing was "migrated."
```

The event log is the invariant. Projections are disposable. Agents can be as radical as they want about restructuring the queryable layer because the raw data is untouchable.

### Enrichment and Deletion

Schema evolves. Early events might have `{type: "call"}`. Later the intent adds duration, sentiment, follow-up. The framework handles this through enrichment events — agents create derived events that augment old data without modifying it:

```text
# Original event (immutable, stays forever)
e001: { type: "call" }

# Enrichment event (agent-generated, linked to original)
e001_enriched: {
  source: e001,
  type: retroactive_enrichment,
  inferred_sentiment: null,       # honestly unknown
  normalised_interaction: "call_outbound",
  enrichment_confidence: 0.95
}
```

The enrichment is clearly marked as inferred, not original. Projections can use enrichments or ignore them.

For genuine deletion — a customer exercises their GDPR right — the log records the intent through tombstone events. The raw events get cryptographically shredded (delete the encryption key for that customer's events, rendering them unrecoverable without actually modifying the log structure).

An agent could literally throw away the entire application layer and rebuild it from scratch, and no customer would lose a single data point. That's what makes "living system" safe rather than terrifying.

## The Conductor

The conductor is the only persistent process. It continuously compares two things: what has happened (event log) versus what should have happened (intent layer). The gap between those is work.

```text
loop forever:

  events = event_log.since(last_checkpoint)

  for event in events:

    # What consequences should this event have triggered?
    expected = intent.expected_consequences(event)

    # What actually happened?
    actual = event_log.consequences_of(event)

    # The gap is work
    unresolved = expected - actual

    if unresolved:
      agent = spawn_agent(
        goal: resolve(unresolved),
        context: event,
        constraints: stability_contract,
        sandbox: new_draft()
      )
      track(agent)
```

These gaps are the concrete, computable form of the [ambiguity described earlier](/posts/2026-02-06-ambiguity-as-a-vital-sign/) — places where the system's declared intent and its actual behaviour haven't converged. Instead of reading ambiguity off a mind map, the conductor detects it mechanically.

### Five Types of Gaps

**1. Reaction gap** — event happened, expected consequence didn't. "Rep logged a high-risk interaction, no churn alert was generated." Spawn a reactive agent.

**2. Consistency gap** — system state doesn't match what the event log implies. "Event log shows 50 interactions, projection only has 49." Spawn a repair agent.

**3. Intent gap** — the intent layer changed, existing data or behaviour doesn't match. "New invariant: all deal scores must be explainable. 300 existing scores lack explanations." Spawn an enrichment agent.

**4. Quality gap** — everything works, but optimisation targets aren't met. "Latency is 400ms, target is 200ms." Spawn an optimisation agent.

**5. Temporal gap** — something should have happened by now and hasn't. "48-hour follow-up was due yesterday." Spawn a temporal agent.

### Ephemeral Agents

The spawned agents are ephemeral and purpose-built. They're not long-running services. They're born with a specific goal, given a sandbox, and they either resolve the gap or fail.

```text
SPAWN → conductor creates agent with:
  - specific goal (resolve this gap)
  - relevant context (the events involved)
  - a sandbox/draft to work in
  - resource budget (time, compute, cost)
  - constraints from stability contract

WORK → agent operates in sandbox:
  - reads event log (read-only)
  - reads current projections (read-only)
  - builds solution in draft
  - generates proof of invariant satisfaction

RESOLVE → agent attempts to close the gap:
  - submits draft for promotion
  - OR appends new events (reactions, enrichments)
  - OR reports: "this gap requires human input"

DIE → agent terminates. Always.
  - no persistent agent state
  - no long-running background agents
  - if the gap recurs, a new agent gets spawned
```

Agents don't linger. The conductor is the only persistent process. Everything else is short-lived. This prevents the system from accumulating zombie processes, stale agent states, or conflicting long-running agents stepping on each other.

## Safety

Agents don't modify the live system. Ever. They work in sandboxed drafts — complete parallel instances of the system that they can restructure however they want. The key primitives:

- **Draft** — a candidate next-state of the whole system
- **Proof** — evidence that a draft satisfies all invariants
- **Promote** — atomic swap from current state to draft (only if proof checks out)
- **Rollback** — instant revert if runtime behaviour diverges from proof

An agent's workflow: create draft, restructure freely, generate proof, request promotion. If the proof doesn't verify, the draft never touches production. The agent can try again with a different approach.

The stability membrane enforces this. Before any promotion, it runs:

- **Pre-promotion verification** — formal checking of invariants against the draft. Does customer data survive? Do all API contracts still hold? This isn't unit tests. It's closer to property-based verification across the entire system state space.
- **Canary materialisation** — even after proof, the draft gets materialised for a fraction of real traffic first. Agents can be wrong about the real world even when they're logically correct.
- **Continuous runtime monitoring** — the live system is perpetually checked against the intent spec. If latency creeps past 500ms, the membrane flags it and agents get a synthesis task automatically.

Agent resolution can cascade — resolving one gap by appending new events might itself create gaps. That's fine; the conductor picks them up in the next loop. But circuit breakers prevent spiralling:

```text
# Prevent infinite spawn loops
max_agent_depth: 5
  → if resolving gap A spawns gap B spawns gap C...
     stop at depth 5, flag for human review

# Prevent resource exhaustion
max_concurrent_agents: 20
max_agents_per_gap: 3
  → if 3 agents have failed to resolve the same gap,
     escalate to human

# Prevent thrashing
cooldown_per_gap: 30s
  → don't re-spawn for the same gap immediately

# Budget enforcement
total_compute_budget: $X/hour
  → conductor prioritises gaps by severity
     when budget is constrained
```

The biological analogy holds: the event log is DNA (immutable record), the intent layer is gene expression, projections are proteins (functional structures built from the record), the conductor is the immune system (gap detection), and spawned agents are antibodies (targeted, ephemeral, disposable). Draft/promote is cell division with error checking. And just like an immune system, it can sometimes get it wrong — that's why the promotion gate and rollback mechanism exist.

## Where to Start

A proof-of-concept needs five things: an event log, a parsed intent registry, a gap detector (the conductor's core loop), an agent runtime with sandbox and tool access, and a promotion gate that verifies drafts against invariants. The agents themselves can initially just be Claude or similar models with tool access. The framework is the guardrails, not the intelligence.

---
