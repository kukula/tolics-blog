---
title: "The Self-Validating Graph"
date: 2026-01-20
lastmod: 2026-01-20
draft: false
author: "Tolic Kukul"
description: "Graph-based system models validate themselves through structural checks, semantic analysis, and automatic test generation from invariants."
tags: ["software-architecture", "declarative-programming", "ai", "llms"]
categories: ["Software Architecture"]
series: ["Declarative Systems"]
---

Raising the abstraction only matters if it can be implemented incrementally. A graph-based system model does not replace source code — it sits above it as a coordinating layer.

At the core is a typed graph describing system intent. Nodes represent domain concepts: entities, states, actions, roles. Edges represent relationships. Invariants are expressed as constraints over paths.

```yaml
Order:
  type: entity
  states: [draft, submitted, paid, shipped, cancelled]
  transitions:
    - from: draft
      to: submitted
      requires: [line_items.count > 0]
    - from: submitted
      to: paid
      trigger: payment.success
  invariants:
    - "cannot ship unless paid"
  unclear:
    - "what happens if partial inventory available?"
```

The `unclear` field is not a bug. It is an explicit marker of ambiguity that the system tracks.

**Structural validation** runs first — fast, deterministic, no LLM required. Reachability checks confirm every state can be reached. Reference integrity ensures relationships point to defined entities. Constraint coherence catches contradictory rules. Completeness signals surface orphaned entities and dead-end states.

Many classes of bugs are eliminated here, before anyone writes any code.

**Semantic validation** runs second, often with LLM assistance. "You said orders cannot ship without payment, but there is no transition that sets `paid`. How does that happen?" These appear as warnings, not blockers. The system is curious about itself.

The key UX decision: semantic gaps appear inline, next to the relevant node or edge. The model annotates itself.

**Test generation** follows from invariants. Each constraint defines a test space — positive cases (allowed paths work), negative cases (forbidden paths fail), and boundary conditions (permission revoked mid-session, concurrent transitions to conflicting states).

These tests target the execution surface: APIs, services, domain functions. They regenerate as the model evolves, ensuring tests always reflect current intent.

The graph carries a schema for itself — expectations about what a valid model looks like — and diffs against that schema continuously.
