---
title: "Complexity Is a Feature: A Developer's Realisation"
date: 2026-01-29
lastmod: 2026-01-29
draft: false
author: "Tolic Kukul"
description: "Complexity often isn't a bug — it's a feature that benefits interpreters, gatekeepers, and incumbents. A developer's journey from automation idealist to systems realist."
tags: ["software-architecture", "philosophy", "organizational-design", "technical-debt"]
categories: ["Software Architecture"]
---

For over a thousand years, Ptolemy's geocentric model of the universe predicted planetary positions well enough for navigation and agriculture. The price? An ever-growing system of "epicycles" — circles upon circles upon circles, each patch compensating for the fundamental error of placing Earth at the center.

When Copernicus proposed heliocentrism, the resistance wasn't primarily scientific. It was institutional. Generations of astronomers had built careers on epicycle mathematics. Universities taught it. The Church had integrated it into theology. The model's complexity wasn't a bug to be fixed — it was a moat to be defended.

This pattern repeats everywhere. And once you see it, you can't unsee it.

## Why I Became a Developer

I got into software because I wanted to help people escape bureaucracy.

Not a noble calling, exactly — I just hated watching people waste hours on forms, approvals, and processes that existed for their own sake. I thought: if I learn to code, I can automate this stuff away. Save people time. Save them money. Save them the low-grade misery of wrestling with systems designed by nobody and owned by nobody.

For years, I built tools with that belief. Internal dashboards to replace spreadsheet workflows. Scripts to auto-fill repetitive paperwork. Integrations that let data flow instead of being re-keyed by humans. Each project felt like a small victory against entropy.

Then, gradually, something shifted.

The tools worked. They genuinely saved time. But the bureaucracy didn't shrink — it shape-shifted. New requirements appeared. New approvals. New compliance checkboxes. The complexity I'd routed around would regenerate somewhere else, often more elaborate than before.

I started to suspect the problem wasn't a lack of developers, or better software, or smarter automation. The problem was *intent*. The people designing these systems — in business, government, finance — often *benefit* from the complexity. It's not a bug they're trying to fix. It's a feature they're trying to preserve.

That realisation changed how I think about the systems I build.

## Accidental vs. Intentional Complexity

Some complexity is honest. We build systems with incomplete understanding, reality surprises us, we patch. This is accidental complexity — the kind that embarrasses us when we finally see the simpler solution.

But much of the complexity around us isn't accidental at all. It's *load-bearing*. Someone's livelihood depends on it. Someone's power flows through it. Someone's advantage hides inside it.

The tax code isn't complicated because taxes are inherently hard. It's complicated because every loophole is a lobbying victory, every exemption a political favour, every arcane rule a job for specialists who will fight simplification. The complexity is the product.

## The Economics of Confusion

Consider who benefits from complex systems:

**Interpreters** — Every system complex enough to require explanation creates demand for explainers. Lawyers, accountants, consultants, compliance officers. These aren't parasites; they're rational actors responding to incentives. But their existence creates a constituency against simplification.

**Gatekeepers** — Complexity creates chokepoints. If you control the bridge over the moat, you don't drain the moat. Approval processes, certification requirements, licensing boards — each adds friction that someone converts to revenue or authority.

**Incumbents** — A 47-page contract you've already paid lawyers to understand is a barrier to competitors who haven't. Regulatory complexity is cheaper to navigate when you've already built the compliance department. Complexity compounds into advantage.

**Obscurantists** — Some complexity exists purely to hide what's actually happening. Financial instruments so convoluted that risk disappears into the math. Terms of service designed to exhaust rather than inform. The confusion is the point.

## The Ratchet

Here's the brutal game theory: complexity tends to accumulate because adding it is locally rational while removing it requires coordination.

When a bureaucrat adds a new approval step, they gain oversight and reduce their personal risk. The cost is diffused across everyone who must now navigate the extra step. When a lawyer adds protective clauses to a contract template, they reduce liability. The cost is diffused across every future reader.

No individual bears enough cost to fight back. So the ratchet clicks forward.

Worse: attempts to simplify often add complexity instead. A new agency to streamline regulation. A new form to reduce paperwork. A new law to clarify the old ones. Each reform calcifies into another layer.

## Who Simplifies?

Genuine simplification requires one of three things:

**Catastrophe** — Systems sometimes collapse under their own weight. The 2008 financial crisis briefly made "too complex to understand" a liability rather than an asset. Briefly.

**Technology** — New tools can make old complexity irrelevant. You don't need a travel agent when you have Kayak. You don't need a stockbroker when you have index funds. The interpreters of the old system become obsolete faster than they can adapt.

**Power** — Someone with enough authority and enough incentive can force simplification. This is rare because the people with power usually benefit from existing complexity. Occasionally an outsider captures the throne and burns the maze. Usually they just add their own corridors.

## The Software Mirror

Programmers like to think we're different. We worship elegance. We refactor. We have code review.

And yet.

Every mature codebase accumulates its own epicycles. The ORM that required a query cache that required a cache invalidation layer that required a distributed lock manager. The abstraction that made the simple case elegant and the common case impossible. The framework that promised to reduce boilerplate and delivered a different boilerplate plus a learning curve.

We add these things for the same reasons the bureaucrats do. Each decision is locally rational. Each patch reduces immediate pain. The costs are diffused across future developers, future performance, future flexibility.

The difference is that software can be rewritten. In theory. In practice, Chesterton's fence applies — we're afraid to remove what we don't fully understand, and complex systems are definitionally hard to understand. So we patch the patches.

## Designing for Subtraction

Is there a way out?

I don't have a complete answer, but I have a heuristic: *make complexity costly to the people who add it*.

In code, this might mean: the team that adds a service owns its operational burden. The developer who adds a dependency maintains the upgrade path. The architect who designs the abstraction writes the documentation.

In organisations, this might mean: the department that creates a process staffs the help desk. The executive who adds a reporting requirement reads the reports.

The goal isn't to prevent all complexity — some problems are genuinely hard. The goal is to make the cost visible at the point of decision rather than diffused across time and people.

Most systems do the opposite. They socialise the costs of complexity while privatizing its benefits. Until that equation flips, the epicycles will keep accumulating.

But there's a harder question than "how do we make complexity costly?" It's the Copernican question: *What foundational assumption is making this hard in the first place?*

Most of us, most of the time, are adding epicycles. We see a gnarly codebase and ask "how do I work around this?" We see a broken process and ask "how do I automate this?" These are reasonable survival strategies. They're also how complexity metastasises.

The lesson from the opening isn't just that complexity serves someone. It's that **complexity is a symptom of a deeper problem** — and the right response isn't better crutches, it's questioning the model.

It's worth remembering who benefits from the maze: the interpreters, the gatekeepers, the incumbents, the obscurantists. When someone says "that's just how it is," it's worth asking who profits from it staying that way.

## What I Build Now

I still write software to help people escape bureaucracy. But I'm no longer naive about what I'm up against.

The young developer in me thought complexity was a technical problem — something to be solved with cleaner code, better tools, smarter automation. The version of me writing this understands that much complexity is a *political* problem. It exists because someone wants it to exist. Fighting it means understanding incentives, not just algorithms.

This doesn't make the work hopeless. It makes it clearer. When I build something now, I ask different questions: Who benefits from the current complexity? What will they do when I simplify it? How do I design systems where the people adding complexity bear its costs?

I don't have all the answers. But I've stopped expecting technology alone to deliver them.

---

*This is why I'm interested in systems that organise themselves — not because self-organisation is magic, but because it changes who bears the cost of complexity. More on that soon.*
