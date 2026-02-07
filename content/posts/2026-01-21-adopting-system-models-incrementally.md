---
title: "Adopting System Models Incrementally"
date: 2026-01-21
lastmod: 2026-01-21
draft: false
author: "Tolic Kukul"
description: "Practical guide to adopting graph-based system models incrementally. Covers escape hatches, LLM workflows, and week-by-week adoption strategy."
tags: ["software-architecture", "declarative-programming", "ai", "llms"]
categories: ["Software Architecture"]
series: ["Declarative Systems"]
---

LLMs operate downstream of the model. Their role is to propose code that conforms to the graph and satisfies generated tests. They are not trusted to preserve invariants — the model enforces them.

The workflow reverses the usual dynamic:

1. Human or LLM modifies the graph
2. Structural validation runs immediately
3. Semantic validation surfaces warnings
4. Test suite regenerates
5. LLM proposes implementation
6. Tests verify conformance
7. Human reviews the graph diff, not the code diff

Instead of encoding intent into prompts and hoping it survives, intent is encoded structurally and verified mechanically. The LLM is a worker, not an oracle.

**Escape hatches** keep the system practical. Explicit breakouts define a "here be dragons" node — custom code with a defined contract:

```yaml
PaymentProcessing:
  type: external
  inputs: [order_id, amount, payment_method]
  outputs: [success, failure, pending]
  maintains: ["order.total = sum(line_items.price)"]
```

The system cannot validate inside the box, but it validates at the boundaries. Override with justification allows a rule violation if a human explicitly approves with a reason — logged as technical debt. Gradual formalisation starts with `unclear` markers and replaces them with formal constraints as understanding solidifies.

**Adoption does not require a full rewrite.** Start with a single bounded context — authorisation, workflows, billing rules.

**Week 1:** Pick one invariant that keeps breaking. "Users can only see their own data." Model it as a graph constraint. Generate tests from it.

**Week 2:** Add related entities and relationships. Surface structural gaps. Fix the obvious ones.

**Month 1:** One bounded context is fully modelled. New features start from the graph. Code generation becomes viable.

**Over time:** The graph grows as a system of record for intent. The codebase gradually becomes a derived artifact.

Once the model exists: onboarding means reading the graph, not the code. Impact analysis is a graph traversal. Auditing is a query, not a code review.

The goal is not to eliminate code. It is to make code the output of a process that preserves intent, rather than the input to a process that tries to recover it.
