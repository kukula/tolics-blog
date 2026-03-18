---
title: "Vibes-Driven Development: When AI Tooling Runs on Feeling"
date: 2026-03-17
lastmod: 2026-03-17
draft: false
author: "Tolic Kukul"
description: "Most teams have no idea if their AI workflow investments are paying off. Here's what to actually measure instead of relying on vibes and excitement."
tags: ["ai", "team-productivity", "management", "software-development", "best-practices"]
categories: ["AI and Development"]
---

Every second dev manager I talk to these days tells me the same thing.

*"We've been levelling up our AI workflows. Added some MCPs, built out a few custom skills, the team's really cooking now."*

So I ask: how do you know?

Silence. Then: *"You can just feel it. The team's shipping faster."*

Can they? Or does it just feel that way because the tools are new and people are excited?

This is vibes-driven development. That feeling is real. It just isn't a metric.

Nobody's measuring baseline cycle time, rework rates, or defect escape rates. They're just adding tools, feeling good, and calling it improvement.

Without measurement, you can't tell the difference between *actually faster* and *differently slow*. Most teams have adoption confused with value.

## What to actually track

**Cycle time** — PR open to merge, before and after. This is your headline number. If it's not moving, nothing else matters.

**Code churn** — how much AI-generated code gets deleted or substantially rewritten within a week of merging. High churn means you're shipping fast and undoing it quietly.

**PR revision count** — are reviewers asking for fewer rounds of changes, or more? AI-assisted code that looks complete often has subtler problems that take longer to surface.

**Bug introduction rate** — bugs filed per unit of code shipped. Tells you whether AI-assisted code is actually higher or lower quality at the source.

**Defect escape rate** — bugs caught in production vs pre-merge. Teams often find escape rate flat but introduction rate creeping up — meaning review is working harder to compensate, not that the code got better.

**AI acceptance rate** — of everything the model suggests, how much do developers actually keep? If it's low, your tooling investment isn't landing where you think.

**Time-to-first-meaningful-commit** — useful for catching whether AI is actually helping engineers get unstuck faster, or just generating noise they then have to wade through.

None of these are exotic. Most teams already have the data sitting in their git history, their issue tracker, their CI pipeline.

If you're unsure where your team sits, an [AI maturity framework](/posts/2026-02-26-ai-maturity-framework/) can help you assess readiness before layering on more tools.

Before you add the next MCP or prompt library or skill pack, pick two of these metrics and build a dashboard — excitement fades, but numbers hold.
