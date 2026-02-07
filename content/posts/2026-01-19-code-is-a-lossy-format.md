---
title: "Code Is a Lossy Format"
date: 2026-01-19
lastmod: 2026-01-19
draft: false
author: "Tolic Kukul"
description: "Source code is a lossy format that discards intent. LLMs expose this weakness. Graph-based models preserve meaning as first-class structure."
tags: ["software-architecture", "declarative-programming", "ai", "llms"]
categories: ["Software Architecture"]
series: ["Declarative Systems"]
---

For decades, we have conflated programming with typing code. In reality, typing was never the hard part. The real work lies in understanding domains, modelling systems, and making tradeoffs under constraints. Source code is simply how these decisions get serialised into something a machine can execute — and it is a lossy format.

When we read code, we are not reading intent. We are reverse-engineering it. Much of modern software engineering — code review, testing, refactoring — exists to compensate for this information loss.

With Large Language Models, this weakness becomes visible. LLMs do not fail because they cannot generate code. They fail because we force them to operate at a level where meaning is implicit and correctness must be inferred.

Graph-based system models offer a different approach. Nodes represent domain entities, states, or invariants. Edges encode relationships: dependency, authorisation, causality. Constraints are first-class objects, not comments or naming conventions.

A simple example illustrates the shift. Instead of scattering authorisation logic across code, we define an invariant: an action is executable only if a path exists from User → Permission → Action. If a human or an LLM introduces a change that violates this invariant, the model rejects it structurally. No prompt reminders, code review heuristics, or tribal knowledge required.

Once intent is explicit, test generation follows naturally. Each invariant implies positive, negative, and boundary cases that can be derived mechanically. Tests verify conformance to intent rather than restating it in a different language.

This is not a new idea. Model-Based Systems Engineering has existed since the 1990s. Aerospace and defence have used these techniques for decades. But the tooling was heavyweight, the notation required specialists, and the models sat in separate systems from the code they described. They became documentation that drifted.

What has changed is the translation layer. LLMs can bridge natural language and formal structure without requiring humans to learn a specification language. They can surface ambiguity as a feature rather than a failure mode — marking what is unclear rather than guessing.

The vision is a system where the graph is the artifact. Not a diagram that describes the system, but the source of truth from which code and tests are derived.
