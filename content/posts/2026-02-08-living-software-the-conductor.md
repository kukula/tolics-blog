---
title: "Living Software: The Conductor"
date: 2026-02-08
lastmod: 2026-02-08
draft: true
author: "Tolic Kukul"
description: "The conductor layer compares what happened against what should have happened. The gap between them is work. Ephemeral agents resolve it or escalate."
tags: ["software-architecture", "ai-agents", "autonomous-systems", "self-healing", "circuit-breaker", "resilience"]
categories: ["Software Architecture"]
series: ["Living Software Framework"]
---

The conductor is continuously comparing two things: what has happened (event log) versus what should have happened (intent layer). The gap between those is work.

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

A rep logs a call with a customer. The intent layer says that should produce an engagement score update, possibly a churn alert, possibly a manager notification if risk thresholds are crossed. The conductor checks: did those things happen? If the score updated but no alert fired and the churn threshold was crossed — that's a gap. Spawn an agent to fix it.

## The Gap Detection Loop

These gaps are the concrete, computable form of the [ambiguity described earlier](/posts/2026-02-06-ambiguity-as-a-vital-sign/) — places where the system's declared intent and its actual behaviour haven't converged. The difference is that instead of reading ambiguity off a mind map, the conductor detects it mechanically.

## Five Types of Gaps

The gap isn't always "something didn't happen." There are different classes of unresolved work:

**1. Reaction gap** — event happened, expected consequence didn't. "Rep logged a high-risk interaction, no churn alert was generated." Spawn a reactive agent to produce the missing consequence.

**2. Consistency gap** — system state doesn't match what the event log implies. "Event log shows 50 interactions, projection only has 49." Spawn a repair agent to rebuild or fix the projection.

**3. Intent gap** — the intent layer changed, existing data or behaviour doesn't match. "New invariant added: all deal scores must be explainable. 300 existing scores lack explanations." Spawn an enrichment agent to backfill.

**4. Quality gap** — everything works, but optimisation targets aren't met. "Latency is 400ms, target is 200ms." Spawn an optimisation agent to explore better architectures.

**5. Temporal gap** — something should have happened by now and hasn't. "Customer hasn't responded to proposal, 48hr follow-up was due." Spawn a temporal agent to handle time-based triggers.

## Agent Lifecycle

The spawned agents are ephemeral and purpose-built. They're not long-running services. They're born with a specific goal, given a sandbox, and they either resolve the gap or fail. If they fail, the conductor knows because the gap persists and it can try a different approach.

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

This is important — agents don't linger. The conductor is the only persistent process. Everything else is short-lived. This prevents the system from accumulating zombie processes, stale agent states, or conflicting long-running agents stepping on each other.

## Handling Conflicts

Two events arrive close together. Both produce gaps. Two agents get spawned. They both try to restructure the same part of the system. What happens?

```text
Option A: Serialisation
  Conductor detects overlapping scope,
  queues agents sequentially.
  Simple, safe, slow.

Option B: Optimistic concurrency
  Both agents work in parallel drafts.
  First to submit a valid proof gets promoted.
  Second agent's draft is now stale —
  conductor detects the gap is already closed,
  agent gets terminated.

Option C: Composition
  If both drafts are valid and non-conflicting,
  the stability membrane can compose them into
  a single promotion.

The conductor picks the strategy based on:
  - urgency of the gaps
  - scope overlap between agents
  - resource budget
```

## Circuit Breakers and Safety

Agent resolution can cascade — resolving one gap by appending new events might itself create gaps. That's fine; the conductor picks them up in the next loop. But you need circuit breakers. These are the system's vital signs for the activity axis, telling you whether evolution is healthy or spiralling:

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

## The Biological Analogy

The analogy that keeps working is biological:

- **Event log** — DNA (immutable record)
- **Intent layer** — gene expression rules
- **Projections** — proteins (functional structures)
- **Conductor** — immune system (gap detection)
- **Spawned agents** — antibodies (targeted, ephemeral)
- **Stability contract** — homeostasis bounds
- **Draft/promote** — cell division with error checking

And just like an immune system, it can sometimes get it wrong. An agent might "fix" something that wasn't actually broken. That's why the promotion gate and rollback mechanism exist — they're the equivalent of apoptosis, killing a response that's doing more harm than good.

## The Minimal Implementation

```text
You need:
  1. Event log         (Kafka, EventStore, even SQLite to start)
  2. Intent registry   (the parsed constraint graph)
  3. Gap detector      (the conductor's core loop)
  4. Agent runtime     (sandbox + tool access + budget)
  5. Promotion gate    (verify draft against invariants)
```

The conductor itself is surprisingly simple. The complexity lives in defining gaps precisely (intent to expected consequences), giving spawned agents enough capability to actually resolve them, and the verification layer that prevents bad promotions.

The conductor makes the system self-healing by default. You don't build recovery mechanisms. You don't write retry logic. You don't handle edge cases manually. If something goes wrong, it shows up as a gap, and the system routes around it.

The question is how smart the spawned agents need to be for various classes of gaps — some are trivial (rebuild a projection), some require genuine reasoning (the data model needs to evolve to handle a new kind of input nobody anticipated).

---

*Previous: [Living Software: The Persistence Layer](/posts/2026-02-08-living-software-persistence-layer/) · Next: [Living Software: Intent as Reactive Computation](/posts/2026-02-08-living-software-intent-as-reactive-computation/)*
