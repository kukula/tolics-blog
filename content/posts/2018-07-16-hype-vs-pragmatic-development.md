---
title: "The Pragmatic Engineer's Manifesto: Beyond Hype, Toward Solutions"
date: 2018-07-16
lastmod: 2018-07-16
draft: false
author: "Tolic Kukul"
description: "Why asking the right questions and solving your own problems matters more than following trends or memorizing algorithms."
tags: ["software-development", "pragmatism", "software-architecture", "interviews", "problem-solving", "career"]
categories: ["Software Engineering"]
series: ["Software Architecture"]
---

# The Pragmatic Engineer's Manifesto: Beyond Hype, Toward Solutions

Software engineering is drowning in false signals. We optimise for the wrong metrics, test the wrong skills, and chase the wrong goals. The result? Systems that are complex but fragile, teams that are impressive but ineffective, and engineers who can recite algorithms but can't solve real problems.

It's time for a different approach.

## When Answers Are Cheap, Questions Become Expensive

Today, answers are cheaper than they've ever been. ChatGPT, Claude, and Stack Overflow can solve almost any technical problem in seconds. You can find tutorials, code examples, and step-by-step guides for virtually any programming task.

**But we still test answers in interviews, not the ability to ask the right questions.**

This is backwards. In the real world, **knowing what to ask is more valuable than knowing what to answer**. I've written before about [why technical interviews are broken](/posts/interviews/) and how they test everything except what matters for the job.

LLMs have made information retrieval almost free. Yet our interview processes haven't adapted. We still ask candidates to implement binary search on a whiteboard, as if memorizing algorithms is the bottleneck in modern software development.

The hard parts of engineering aren't about having answers memorized. They're about:

- **Problem identification:** What are we actually trying to solve?
- **Context understanding:** What constraints and trade-offs apply here?
- **Question formation:** What don't we know that we need to know?
- **Solution evaluation:** Which approach fits our situation best?

The best engineers aren't human compilers who can recite solutions from memory. They're human debuggers — finding the right questions to ask when systems behave unexpectedly.

## Solve Your Own Problems, Not FAANG Problems

This same question-asking skill is critical when choosing technology. The biggest trap in modern development is **copying FAANG solutions to FAANG problems**.

Google built Kubernetes to manage thousands of services across millions of servers. Netflix created chaos engineering to handle massive distributed systems. Facebook invented React to manage complex UI state at scale.

**But you are not Google. You are not Netflix. You are not Facebook.**

Their problems are not your problems. Their constraints are not your constraints. Their solutions may be overkill, inappropriate, or actively harmful for your context.

Instead of copying their architectural patterns, **solve your actual problems**:
- Start with the simplest thing that could work
- Optimize for maintainability and understanding
- Add complexity only when forced by real constraints
- Choose tools your team can actually master

This applies especially to [software architecture decisions](/posts/abstraction-is-hard/) — wrong abstractions borrowed from other companies can be worse than no abstractions at all.

## The Hype-Driven Development Trap

Too often, we don't ask these questions. Instead, we get caught in hype-driven development, where technology choices are made based on what's trendy rather than what's appropriate.

The motivation is obvious: **hype makes your resume look cool**. It gives you credibility in tech circles. It makes you seem innovative and forward-thinking.

But here's the uncomfortable truth: **hype does nothing good for your project**.

**Hype-driven choices look like this:**
- "Let's use GraphQL because REST is old"
- "We need Kubernetes to scale" (for your 3-user MVP)
- "Microservices will make us more agile" (with a 2-person team)
- "We should switch to Rust for performance" (while serving static HTML)

**Question-driven choices look like this:**
- "What problem are we actually trying to solve?"
- "What are our real constraints and requirements?"
- "What's the simplest solution that works for our context?"
- "Can our team effectively maintain this?"

## Choose Boring Technology

Boring technology is boring for a reason: **it works**. It's been battle-tested. Its rough edges have been smoothed out. Its failure modes are understood.

PostgreSQL is boring. Linux is boring. HTTP is boring. They're also the foundation of nearly every successful system you use daily.

New technology solves new problems, but most of us don't have new problems. We have old, well-understood problems that need reliable, maintainable solutions. This is why [Rails works so well in enterprise](/posts/rails-in-enterprise/) — it's proven, predictable, and gets the job done.

The right questions lead you to boring solutions more often than exciting ones — and that's exactly what most projects need.

## A Better Way Forward

Whether you're choosing a database, hiring a candidate, or [architecting a system](/posts/kokeshi-vs-lego/), the same principles apply:

**Ask these questions:**
- What problem are we actually trying to solve?
- What constraints and context matter here?
- What's the simplest approach that meets our needs?
- Can we learn, maintain, and debug this effectively?

**Not these questions:**
- What would look impressive to others?
- What are the cool companies using?
- What will make us seem innovative?
- What can we memorize and recite?

In a world where answers are commoditized and hype cycles accelerate, the ability to ask the right questions becomes the true differentiator.

Ask better questions. Solve your own problems. Choose boring technology when it works.

That's how you build things that actually work.
