---
title: "Context Engineering: The Skill That Actually Matters"
date: 2026-03-16
lastmod: 2026-03-16
draft: false
author: "Tolic Kukul"
description: "Context engineering — not prompt engineering — is where the real leverage lives. The discipline of deciding what goes into the context window, and why."
tags: ["ai", "llms", "ai-agents", "software-development", "best-practices"]
categories: ["AI Engineering"]
series: ["Working With LLMs"]
---

Everyone's been talking about prompt engineering — the right words, the magic incantations. It's not useless, but it's not where the leverage is either. The thing that actually matters is context engineering.


## Prompt Engineering Was Always the Wrong Frame

Prompt engineering treats the model like a search engine — iterate on wording until it works. But model behaviour isn't primarily a function of how you phrase things. It's a function of *what the model knows when it generates a response*. Change the wording and you get marginal differences. Change what's in the context window and you get fundamentally different behaviour.

Andrej Karpathy put a name to this recently: context engineering — deciding what goes into the context window, in what form, and in what order. That's the actual skill.



## The Principle

The principle is simple: **the context should contain everything needed to accomplish the task, but not more.** Simple to say. Genuinely hard to execute.

"Everything needed" requires you to model how the LLM will reason — where it will look for information, what gaps it will fill by inference, what it might hallucinate if you leave something out.

Get it right and the model performs. Under-include and it hallucinates confidently. Over-include and you dilute the signal, waste tokens, and degrade every downstream decision.


## What "Context" Actually Is

It's easy to think of context as the system prompt plus the conversation. That's a fraction of it. Context is everything in the window:

- System prompt and instructions
- Conversation or task history
- Retrieved documents (RAG)
- Tool call results
- Memory outputs
- Current world state
- Few-shot examples
- Structured data payloads

All of it competes for the same finite space. The model doesn't distinguish between what you put there intentionally and what leaked in accidentally — it treats all of it as equally real and relevant.

This is where most implementations go wrong. The context window gets treated like a text field — fill it up and hope for the best. Context engineering treats it like a working memory budget.


## Why Agents Make This Critical

For a single-turn chat, sloppy context is a mild irritant. For an agent operating across multiple steps, it's load-bearing. Errors compound — a bad assumption at step 1 propagates to step 5, and confident wrong agents are the worst kind of production failure.

**Silent under-inclusion.** The agent needs state you left out. It doesn't ask — it infers. The inference is plausible but wrong. You don't catch it until downstream consequences show up.

**Tool result noise.** A tool returns badly formatted output. The agent burns tokens parsing it before it can reason. Format tool outputs for the model, not for humans.

**Context window pressure.** Long-running agents hit limits. Most implementations naively truncate history — evicting context without regard for what it contains. What you evict is as important as what you keep.


## The Practical Discipline

Building context assembly for agentic systems comes down to a few disciplines:

**Know what the model knows.** You don't need to include what it already knows reliably. Fill the gaps in its knowledge, not its entire knowledge graph.

**Format for reasoning, not for reading.** Tool results, retrieved chunks, structured data — format them so the model can reason with them immediately. Implicit schema is noise. Explicit structure is signal.

**Make retrieval deliberate.** In a RAG system, what you retrieve and how you inject it determines whether the model has genuine situational awareness or a bag of loosely related facts.

**Define a context assembly policy, not a static prompt.** In multi-step tasks, what's sufficient changes. You're engineering rules for what gets pulled into context at each decision point.

**Offload to deterministic tools.** Don't burn context tokens describing every code style rule or edge case that a linter, type checker, or test suite already enforces. Let the model generate, let the tool correct. Linters are cheaper than tokens, and they're never wrong about their own rules. Reserve context for the things only the model can reason about.

**Treat the pre-call brief as the deliverable.** What would you put in a one-page brief for a senior engineer before a decision meeting? Exactly what they need to make the right call without coming back to ask questions.


## The Shift

Prompt engineering is about communication precision. Context engineering is about information architecture — ensuring the right knowledge is present at the right moment.

The models will mostly do the right thing if you give them what they need. The bottleneck isn't their reasoning — it's our ability to construct the context that lets them reason correctly.
