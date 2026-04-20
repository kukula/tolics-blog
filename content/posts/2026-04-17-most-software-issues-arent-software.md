---
title: "Most Software Issues Aren't Software"
date: 2026-04-17
lastmod: 2026-04-17
draft: false
author: "Tolic Kukul"
description: "The real bottleneck in software development is not knowledge — it is processing. Ambiguity, cognitive load, and feedback latency are the upstream causes."
tags: ["software-development", "team-productivity", "organizational-design", "productivity", "philosophy"]
categories: ["Software Development"]
---

Knowledge isn't the bottleneck anymore. How to build a distributed cache, how to set up CI/CD, how to structure a microservice — the answers are a search away. Or a prompt away. Twenty years ago, finding the answer was the hard part. Now it's everywhere.

So why is software development still so hard?

Because the real bottleneck isn't knowledge. It's processing. Knowing how to build a distributed cache doesn't tell you whether you *should*, given your team size, your timeline, your actual traffic patterns, and the three other priorities competing for attention. The difficulty isn't accessing information — it's making sense of it in context.

And once you see it that way, the usual suspects start to look different. They're not random, unrelated problems. They're all processing failures.

## The Usual Suspects

**Ambiguity.** Requirements are unclear, incomplete, or contradictory. Stakeholders don't know what they want until they see what they don't want. This isn't a failure of documentation — it's a fundamental property of complex problem spaces. You can't fully specify what you don't yet understand.

**Cognitive load.** Humans can only hold so much in working memory. When a system exceeds that threshold, mistakes become inevitable regardless of how skilled the team is. This is a biological constraint, not a tooling problem. It also explains why adding more documentation, more frameworks, more tools doesn't help proportionally — you're adding inputs to a system already bottlenecked on processing capacity.

**Communication.** Information degrades every time it crosses a boundary — between teams, disciplines, or even conversations a week apart. Conway's Law isn't just an observation, it's a warning: your architecture will mirror your org chart whether you design it that way or not.

**Change.** The thing you're building for is a moving target. Markets shift, users surprise you, dependencies update. Even if you perfectly understood the problem today, it'll be a different problem tomorrow.

**Coordination cost.** Getting multiple people to work on the same thing without stepping on each other scales nonlinearly. Adding people to a late project makes it later — Brooks told us this in 1975 and we keep re-learning it.

**Feedback latency.** How long until you discover you were wrong? Long feedback loops let bad assumptions compound silently. Short ones make uncertainty survivable.

## What Actually Helps

If the core problem is processing, not knowledge, then the remedy is surprisingly simple in principle. Two rules of thumb cover most of it.

**Make the invisible visible.** Mind maps, architecture diagrams, kanban boards, observability dashboards, written ADRs — these are all external processing tools. You're offloading what's trapped in someone's head onto a surface where others can see it, challenge it, and build on it. A mind map isn't just an organisational trick. It's moving cognitive work out of biological memory and into shared space.

**Shorten the distance between action and feedback.** TDD, CI/CD, shipping small increments, talking to users early, pair programming — every effective practice is really about reducing the time between "we think this is right" and "here's evidence it's not."

The two reinforce each other. Visibility is useless if you don't act on it fast enough. Feedback is useless if you can't see what it's telling you.

And if you want a third: **reduce what anyone needs to hold in their head at once.** Small PRs, clear service boundaries, well-named abstractions, consistent conventions. This is cognitive load management — making the processing problem smaller rather than expecting people to process harder.

## The Upstream Problem

Technical debt, bugs, missed deadlines — these are symptoms. The root causes are upstream, in how humans process information, communicate under uncertainty, and organise around problems they don't fully understand yet.

The hard part was never knowing what to do — it's thinking clearly enough to do the right thing, in this context, right now. And [ambiguity is not a bug to fix](/posts/2026-02-06-ambiguity-as-a-vital-sign/) — it's a signal that the processing work hasn't been done yet.
