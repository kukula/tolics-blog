---
title: "Software Dark Factories"
date: 2026-04-16
lastmod: 2026-04-16
draft: false
author: "Tolic Kukul"
description: "Dark factories are coming to software. The shift from artifact-centric correctness to scenario-driven validation changes what you build and maintain."
tags: ["ai", "ai-agents", "software-architecture", "autonomous-systems", "software-development"]
categories: ["AI Engineering"]
illustration: "robots build machines on conveyor belts in a dark factory hall while a lone foreman watches from a walkway above."
---

A dark factory is a manufacturing line that runs without humans in the work itself. Fully automated production, lights off, humans present only for maintenance and diagnostics. The concept is older than most people realise — robots have been building robots on unsupervised lines since 2001.

Software is now growing dark factories of its own, and you can build one.

The attraction is easy to state: a dark factory compounds. Every scenario you encode, every twin you build, every round through the feedback loop makes the next round cheaper and the outputs more trustworthy. A team that commits to the discipline pulls ahead of one that doesn't — the latter is still paying human wages against work the factory is doing in its sleep.

What changes when you cross over is not the agents. It's the re-ontologisation — not a new process for the same things, but a shift in what the important things are.

In Software 1.0, correctness lives in the artifact. A test file sits next to the source, both versioned together, both written by the same team. "Does it pass?" is a boolean property of the repo. The code and its tests are co-evolved by the same hands, and correctness is something you inspect in place.

In the dark factory, this doesn't survive contact with an optimiser. Once humans stop writing and reviewing code, tests are demoted — they're too easy to reward-hack. `return true` passes a narrow test; an agent rewriting both the code and the test passes them in lockstep. Something outside the codebase has to hold the line.

That something is the **scenario**: structurally a BDD-style end-to-end user story, but held with the discipline of an ML holdout — stored outside the repo and kept out of the agent's reach during generation, so the code can't target it directly. BDD has carried this shape for twenty years; the novelty isn't the artifact but the adversarial separation between implementer and spec. Validation flips from boolean to probabilistic: not "green suite" but **satisfaction** — the fraction of observed trajectories through the scenario corpus that likely satisfy the user.

Once you accept that framing, the building blocks arrange themselves.

## What you need to know

The loop is *seed → validation harness → feedback → satisfaction*.

The **seed** is where human intent enters the factory, and the only place it does. A few sentences, a screenshot, a PRD fragment, an existing codebase — any representation the model can read. Seeds don't need to be complete or precise; they need to be honest about what's wanted.

The **validation harness** is whatever can judge, end-to-end, whether a given trajectory satisfies a scenario. It runs against the real environment or a high-fidelity twin of it. If the harness is cheap, slow, or easy to game, nothing downstream compounds correctness — it compounds error.

The **feedback** closes the loop: the harness's judgment, traces, failures, and near-misses all pipe back to the generator. Not just pass/fail. This is what turns one-shot generation into a process that converges.

**Satisfaction** is the aggregate — the factory's only KPI. Measured across the scenario corpus, not a single run. When satisfaction is high and stable, output ships. When it's low or brittle, the loop keeps running.

All of it runs on tokens. Seed interpretation, generation, harness judgment, feedback synthesis — every step burns inference. **Tokens are the fuel.** Under a thousand dollars per engineer per day and you haven't committed to the factory model; starve the loop and nothing compounds.

## What you need to build

Start with twins — behavioural clones of the SaaS your software depends on: Okta, Jira, Slack, your CRM. You need them because production APIs throttle, cost per call, and run at wall-clock time; a factory needs feedback in seconds, not hours. Don't hand-write the twins. The API documentation is the seed; the twin is factory output. The moment humans are hand-building infrastructure that agents should be generating, Software 1.0 has leaked back in through the back door.

Then separate interactive work from fully-specified work: when intent is complete, hand it off and don't hover. Treat every heuristic inherited from Software 1.0 with suspicion — *deliberate naivety* is the stance of someone who knows the economics moved and refuses to let old constraints set new budgets.

## What you can use

You don't have to start from bare code. Non-interactive coding agent specifications exist — [Attractor](https://factory.strongdm.ai/products/attractor) is one, open-source, with over a dozen community implementations across Python, Rust, Go, Ruby, and C. Context stores for agents exist. Identity layers for humans, workloads, and agents exist. The scaffolding is here; what's missing is operators who take it seriously enough to pour a thousand dollars a day of tokens through it.

The uncomfortable part of the theory is that you maintain *less* code, not more — the code is downstream of the harness, a widget the factory ships. What you actually maintain is the scenario corpus, the twins, and the loop. That's your product now. The role shifts from generative to [curatorial](/posts/2026-03-05-hybrid-vs-ai-native/) — closer to a systems engineer tuning a control loop than a programmer writing functions.

Start with one scenario. Build one twin. Run the loop. The theory is free; the compounding is not. Start anyway.
