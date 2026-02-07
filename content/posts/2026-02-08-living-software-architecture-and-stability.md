---
title: "Living Software: Architecture and Stability"
date: 2026-02-08
lastmod: 2026-02-08
draft: true
author: "Tolic Kukul"
description: "A framework for living software: intent layers, synthesis, materialisation, verification membranes, and the stability contract that keeps it safe."
tags: ["software-architecture", "ai-agents", "autonomous-systems", "self-healing", "design-patterns"]
categories: ["Software Architecture"]
series: ["Living Software Framework"]
---

The previous posts in this series explored [what AI-native software could look like](/posts/2026-02-05-beyond-the-horseless-carriage/) and [how ambiguity becomes its vital sign](/posts/2026-02-06-ambiguity-as-a-vital-sign/). The vision is clear enough: software as a living system, not a factory pipeline. Express intent, let AI handle the translation layers, evolve continuously within safety bounds.

But a vision without a framework is just a metaphor. This post makes it concrete — the layers, primitives, and mechanisms that would let you actually build software this way.

## The Intent Layer

The top of the stack isn't code or config — it's a formal-ish representation of what the system should do. Think something between a constraint satisfaction problem and a contract. Not natural language (too ambiguous), not code (too implementation-specific). Something like typed behavioural specifications with property-based invariants: "this endpoint accepts X, returns Y, never takes longer than Z, and maintains invariant W across all states."

This is what humans interact with. Everything below this is the AI's problem.

This intent language is essentially a new programming language. It's arguably the hardest unsolved piece of the whole framework — the "what replaces programming languages" question. The difference is that it operates at the level of outcomes and constraints rather than procedures and data structures.

## The Synthesis Layer

This is where the "generate and evaluate" idea lives. Given intent, this layer produces candidate system topologies — not just code, but architectural decisions. Should this be one process or five? Stateful or stateless? What's the data model?

The key insight is that these aren't decisions made once by a human architect. They're explored combinatorially, evaluated against the intent constraints, and can be re-explored when the intent changes. The representation here might genuinely not be source code. It could be a differentiable program graph, or an intermediate representation closer to LLVM IR than Python — something that captures the semantics without committing to a specific runtime shape.

## The Materialisation Layer

At some point you need actual running processes. This layer compiles the synthesis layer's output into executable artifacts — containers, functions, whatever the target runtime is.

The topology isn't fixed. The system might materialise as 3 nodes today and 12 tomorrow because the intent changed or the optimisation found a better decomposition. The nodes aren't the architecture. They're a snapshot of one instantiation.

## The Verification Membrane

Not a layer exactly — more like a pervasive property. Every materialised state is continuously checked against the intent layer. This isn't "tests that run in CI." It's more like a runtime proof system. The system knows at all times whether it satisfies its constraints, and if it drifts, the synthesis layer re-engages. This dissolves the build/test/deploy distinction entirely.

## Communication and State

Message queues between sandboxed nodes is one option, but the more interesting primitive is something like causal channels — typed, ordered, observable communication paths where the intent layer specifies the behavioural contract of the channel itself, not just the nodes. The channel between A and B isn't just a pipe; it has its own specification ("messages arrive within 50ms, are deduplicated, maintain causal ordering"). The synthesis layer then figures out whether that means a message queue, shared memory, a direct function call, or something else.

The communication model is derived, not chosen. Sometimes it's a queue. Sometimes it's a shared log. Sometimes two "nodes" get fused into one because the solver realised there's no reason they're separate.

State and identity work differently too. In traditional systems, a "service" has persistent identity — it has a name, an address, state. In this framework, the more natural primitive might be something like capability regions: zones of state plus behaviour that can be split, merged, migrated, or replicated by the synthesis layer as needed. They're not "services" with stable identities. They're more like cells in an organism — defined by function, not by name.

The high-level skeleton: intent specs (human-facing) feed into a constraint solver / synthesis engine (AI-native, explores the design space), which produces an abstract system graph (capability regions plus causal channels), which the materialiser compiles to actual runtime (containers, functions, processes). The verification membrane continuously validates materialised state against intent, feeding divergence back to the synthesis engine.

## The Stability Contract

The foundation is an immutable layer that agents cannot touch. Think of it like a constitution for the system. Humans write this, agents obey it.

```text
system "crm_system" {

  # Hard invariants - never violatable
  invariant customer_data_never_lost
  invariant response_time < 500ms
  invariant auth_required_for_customer_data

  # Behavioural intent - what the system does
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

  # Quality bounds - the system can optimise within these
  optimise cost within budget($200/month)
  optimise latency minimise
  optimise accessibility WCAG_AA
}
```

This is what humans care about. Everything below this is the agent's domain.

## The Agent Workspace

Agents don't modify the live system. Ever. They work in sandboxed "drafts" — complete parallel instances of the system that they can restructure however they want. The key primitives:

- **Draft** — a candidate next-state of the whole system
- **Proof** — evidence that a draft satisfies all invariants
- **Promote** — atomic swap from current state to draft (only if proof checks out)
- **Rollback** — instant revert if runtime behaviour diverges from proof

If this sounds like branching and merging with extra steps — it is, conceptually. Draft/promote/rollback echoes branch/merge/revert. The difference is that promotion requires formal proof against the stability contract, not just a code review approval. The concepts carry over; the guarantees are stronger.

An agent's workflow: create draft, restructure freely, generate proof, request promotion. If the proof doesn't verify, the draft never touches production. The agent can try again with a different approach. This is where the "generate hundreds of candidates" idea becomes practical — each candidate is a draft, and only proven ones get promoted.

## The Stability Membrane

This is the enforcer. It sits between agents and the live system and does three things:

- **Pre-promotion verification** — formal checking of invariants against the draft. Does customer data survive the migration? Do all API contracts still hold? Is auth still enforced on every path? This isn't unit tests. It's closer to property-based verification across the entire system state space.
- **Canary materialisation** — even after proof, the draft gets materialised for a fraction of real traffic first. The membrane watches for divergence between predicted and actual behaviour. Agents can be wrong about the real world even when they're logically correct.
- **Continuous runtime monitoring** — the live system is perpetually checked against the intent spec. Not on a schedule. Continuously. If latency creeps past 500ms, the membrane flags it and agents get a synthesis task automatically.

## The Living Loop

The agents aren't waiting for tickets. They're perpetually active — monitoring the gap between current system behaviour and ideal intent satisfaction, exploring drafts that close that gap, competing with each other to find better solutions. The system is always evolving, but the stability contract means it's evolving within bounds.

```text
Loop forever:
  1. Observe: how well does current system satisfy intent?
  2. Identify: where are the gaps? (latency spike, new edge case, cost creep)
  3. Synthesise: generate candidate drafts that address the gap
  4. Verify: prove drafts satisfy all invariants
  5. Promote: atomically swap in the best verified draft
  6. Monitor: watch for unexpected runtime behaviour
  7. Rollback if needed, feed learnings back to step 3
```

The stability contract needs invariants that go beyond technical correctness:

```text
invariant no_spam_or_over_contact
invariant customer_maintains_data_sovereignty
invariant contact_requires_consent
invariant data_retention_compliant
invariant explainable_recommendations  # no black-box scoring
```

These are harder to verify formally, but they can be checked through a combination of static analysis, simulation, and human-in-the-loop review for the subset of changes that touch these concerns.

## Where to Start

Start with three things — the intent language parser (turning specs like the above into a verifiable constraint graph), a sandbox runtime (where agent drafts can be materialised and tested in isolation), and the promotion gate (the verification step between draft and live). Get those three working for a single simple system — say, a deal pipeline tracker — and you have the skeleton of the whole framework.

The agents themselves can initially just be Claude or similar models with tool access to create drafts, run verification, and request promotion. The framework is the guardrails, not the intelligence.

---
