---
title: "Ambiguity as a Vital Sign"
date: 2026-02-06
lastmod: 2026-02-06
draft: false
author: "Tolic Kukul"
description: "Traditional observability counts individual leaves. In a living system, ambiguity is the vital sign — it reveals where the system is still becoming."
tags: ["ai", "software-architecture", "autonomous-systems", "adaptive-systems", "philosophy"]
categories: ["Software Architecture"]
series: ["Living Software Framework"]
---

If software becomes a living system — always evolving, adapting at multiple timescales, responding to stimulus rather than waiting for tickets — then traditional observability (logs, metrics, dashboards) is like trying to understand a forest by counting individual leaves. You need a different vital sign. Ambiguity is the metric that tells you where the system doesn't know what to grow into.

## Why Ambiguity, Not Progress

In a linear process, you measure progress: how many tasks done, how many bugs fixed. In an organic process, progress isn't the right concept. Ambiguity is the vital sign. It tells you where the system has clarity and where it doesn't. Think of it like a weather map — not "is it raining" but "where are pressure systems forming."

Observability should mean more than control. Instead of harnesses that prevent agents from doing unexpected things, you want visibility into what they're actually doing so you can steer rather than constrain.

## Three Layers of Ambiguity

**Intent ambiguity** — the system doesn't fully understand what it should become. "Make it fast" — fast for whom? Under what conditions? This is like a blurry zone on the mind map where the goals haven't crystallised. You can actually measure this: how many conflicting interpretations does the system hold for a given intent? If the answer is one, it's resolved. If it's fifteen, that's a hot zone.

**Structural ambiguity** — the system hasn't decided how to organise itself yet. Multiple architectural patterns are competing. This is healthy early on, dangerous if it persists. You measure it by looking at how many candidate structures are still alive and how much they diverge from each other.

**Behavioural ambiguity** — given the same input, the system could do several different things and doesn't have a strong reason to prefer one. This is where bugs live in traditional software. In an organic system, it's where evolution is still happening.

## Visualising the Living Topology

Forget dashboards with green/yellow/red. Think of something more like a living topology. A map where:

- **Dense, stable regions** are where the system has high confidence. Intent is clear, implementation has converged, behaviour is consistent. These areas are "solid" — like bone or wood.
- **Fuzzy, active regions** are where ambiguity is high. Multiple possibilities are still competing. These are the growing tips — like the meristem of a plant. They're not problems. They're where evolution is happening.
- **Connections between regions** show dependencies and influence. Not a call graph or service map — more like how changing intent in one area creates pressure in another. If you say "make auth faster," that ripples outward. The mind map shows those ripples.
- **Temperature** — how much change is happening in each region right now. A hot zone with high ambiguity is actively evolving. A hot zone with low ambiguity is something breaking. A cool zone with high ambiguity is stagnation — the system has an unresolved question it's not working on.

## Two Axes

Two axes matter: ambiguity (low vs. high) and activity (low vs. high).

- **Low ambiguity, high activity** — the system is stable and optimising. Fine-tuning what it already understands.
- **High ambiguity, high activity** — healthy chaos. The system is actively evolving through competing possibilities.
- **Low ambiguity, low activity** — simply stable. Nothing to worry about.
- **High ambiguity, low activity** — the dangerous quadrant. An unresolved question no one's asking. In a human org, that's the architectural debt everyone pretends isn't there.

## Measuring Ambiguity

How to actually measure ambiguity quantitatively:

- **Interpretation divergence** — give the same intent to multiple generation paths and measure how different the outputs are.
- **Decision entropy** — how evenly distributed are the options at each choice point.
- **Stability over time** — how much does a region's behaviour change between cycles.
- **Conflict density** — how many constraints in a region are in tension with each other.

These metrics overlap — they're all facets of the same underlying signal.

The human's job in front of this mind map isn't "fix all the red dots." It's more like reading weather patterns — "there's a pressure system building here, let's see what it becomes" or "this region has been foggy too long, let's inject clarity."

## Ambiguity Is Not a Bug

The philosophical shift is that ambiguity isn't a bug to eliminate. It's information about where the system is still becoming. A system with zero ambiguity everywhere is dead — it's stopped evolving. A system with ambiguity everywhere is chaos. The art is reading the map and knowing which ambiguities to resolve and which to let cook.

In practice, this notion of ambiguity maps to a whole surface of concrete signals in a working framework. Gaps are the most obvious: consequence gaps (something should have happened and didn't), invariant gaps (a truth that should hold but doesn't), temporal gaps (a deadline passed without action).

But there's more. The must/should/could priority system is the framework's version of knowing which ambiguities to resolve now and which to let cook. Agent spawn rates, conflict frequency, and circuit breaker activations are the activity axis — how much change is happening, and where. Canary divergence (predicted vs. actual behaviour during rollout) is interpretation divergence made measurable. Budget pressure under constraint is triage: with limited resources, which ambiguities matter most?

Ambiguity in the organic sense is the felt quality of all these signals together. A framework that makes intent computable can turn that felt quality into a mechanical detection loop: declare what should be true, observe what is true, and the distance between them is work.

---
