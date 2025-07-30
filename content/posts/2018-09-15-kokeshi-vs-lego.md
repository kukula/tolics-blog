---
title: "Kokeshi vs Lego: Two Philosophies of Software Architecture"
date: 2018-09-15
lastmod: 2018-09-15
draft: false
author: "Tolic Kukul"
tags: ["software-architecture", "design-patterns", "modularity", "abstractions"]
categories: ["Software Architecture"]
description: "Two fundamental software architecture approaches: nested abstractions like Russian dolls versus composable pieces like Lego blocks. Learn when to use each."
---

There are two fundamental approaches to building software systems: the Kokeshi doll model and the Lego model.

Understanding which you're using — and when to use each — determines whether your system becomes more flexible or more brittle over time.

## The Kokeshi Doll Model

Kokeshi dolls (also known as Russian nesting dolls) stack abstractions on top of each other. Each layer adds features and complexity, with different capabilities at each level.

**In software, this looks like**: Frameworks built on frameworks, each layer adding its own abstractions and conventions, features distributed across multiple levels, deep inheritance hierarchies, middleware stacks with different concerns at each level.

**Example: Web Framework Stacks**
```
Your Application
  ↓ (uses)
Web Framework (Rails, Django)
  ↓ (uses)
HTTP Server (Puma, Gunicorn)
  ↓ (uses)
Language Runtime (Ruby, Python)
  ↓ (uses)
Operating System
```

Each layer has different abstractions: application layer (models, controllers), framework layer (routing, middleware, ORM), server layer (request handling), runtime layer (memory management), OS layer (process management).

## The Lego Model

Lego pieces are composable units that can be combined in countless ways. Each piece has clear interfaces and can be used independently or as part of larger structures.

**In software, this looks like**: Small, focused modules with clear interfaces, composition over inheritance, microservices with well-defined APIs, functional programming with pure functions, plugin architectures.

**Example: Unix Philosophy**
```bash
cat file.txt | grep "error" | sort | uniq -c | head -10
```

Each command does one thing well, has clear input/output interfaces, can be combined arbitrarily, and doesn't depend on what comes before or after.

## Trade-offs: When to Use Each

**Kokeshi Advantages**: Powerful abstractions, incremental learning (use surface-level features without understanding deep internals), integrated experience, rich ecosystems.

**Kokeshi Disadvantages**: Hard to repurpose, difficult to debug (problems can exist at any level), vendor lock-in, complexity accumulation.

**Lego Advantages**: Flexible composition, easy to replace individual components, clear boundaries, testable in isolation.

**Lego Disadvantages**: Integration overhead (wire everything yourself), inconsistent experience, more boilerplate, coordination complexity.

## Choosing Your Architecture

**Choose Kokeshi when**: You need rapid development with consistent patterns, the problem domain is well-understood and stable, integration and convention are more important than flexibility.

**Choose Lego when**: Requirements are likely to change significantly, you need to integrate with many external systems, different parts have different scaling needs, you want to minimise vendor lock-in.

## The Key Insight

Neither approach is inherently better. The question is: **what kind of flexibility do you need?**

- **Kokeshi** gives you flexibility within the framework's assumptions
- **Lego** gives you flexibility to question and change those assumptions

Understanding this difference helps you choose the right tool for the right job, rather than trying to force every problem into the same architectural pattern.

The best architects know when to use each.
