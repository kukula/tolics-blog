---
title: "Rails in Enterprise: Awesome and Awful in Equal Measure"
date: 2020-06-15
lastmod: 2020-06-15
draft: false
author: "Tolic Kukul"
tags: ["ruby-on-rails", "enterprise", "software-development", "scaling", "team-productivity"]
categories: ["Software Development"]
description: "Ruby on Rails is simultaneously perfect and terrible for enterprise applications, depending on whether you optimise for speed or predictability."
---

Rails is awesome for enterprise. Rails is awful for enterprise.

Both statements are true, and understanding why reveals everything about the nature of enterprise software development.

## Why Rails is Awesome

**Standards That Scale Teams**: The biggest advantage isn't technical — it's social. When you rotate developers (and you will, constantly), ramp-up time is dramatically reduced. Every Rails app follows similar patterns — MVC structure, consistent naming conventions, familiar gem ecosystem. A senior Rails developer can be productive on day one.

**The 95% Rule**: For internal applications serving 5-10K employees, performance differences between Rails and Java are often irrelevant. 95% of enterprise applications are CRUD operations with some business logic. Rails excels at this with rapid feature development, built-in conventions, and excellent testing frameworks.

## Why Rails is Awful

**The Java Hegemony**: Most enterprise environments are Java shops. This creates problems: hiring challenges (most "enterprise developers" have Java backgrounds), infrastructure gaps (monitoring tools built for JVM), and organisational resistance (CTOs who understand Java performance).

**The Enterprise Mindset Mismatch**: Rails philosophy ("convention over configuration," "programmer happiness") conflicts with enterprise culture. Enterprise developers prefer verbose, obvious code. Rails abstractions can feel like black boxes. Enterprise environments often prioritise predictability over speed.

## The Real Question: What Are You Optimising For?

**Optimise for Rails when**: You need rapid feature development, your team can hire Rails developers, performance requirements are reasonable, you value developer productivity over operational familiarity.

**Optimise for Java when**: You have existing Java expertise and infrastructure, performance requirements are extreme, compliance requires explicit code, your organisation values predictability over development speed.

## The Verdict

Rails isn't inherently good or bad for enterprise — it's a tool optimised for different values than traditional enterprise development.

If your enterprise values developer productivity, rapid iteration, and modern development practices — Rails is awesome.

If your enterprise values operational predictability, explicit code, and risk minimisation — Rails might be awful.

The key is honest assessment of what your organisation actually optimises for, not what it claims to value in mission statements.

Most enterprises would benefit from Rails, but few have the organisational culture to use it effectively.
