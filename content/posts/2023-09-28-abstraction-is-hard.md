---
title: "Abstraction Is Hard: Why Wrong Abstractions Are Worse Than No Abstractions"
date: 2023-09-28
lastmod: 2023-09-28
draft: false
author: "Tolic Kukul"
tags: ["abstractions", "software-architecture", "design-patterns", "composition", "code-quality"]
categories: ["Software Architecture"]
description: "Creating good abstractions is one of software development's hardest challenges. Learn when to abstract, when not to, and how to avoid costly mistakes."
---

I learned abstraction through examples of rectangles and lines, like probably many of you did. I spent time thinking abstractly about abstraction based on class names and story titles.

This was a mistake. It's the same kind of mistake we make when we [copy solutions from other companies](/posts/hype-vs-pragmatic-development/) without understanding the problems they were meant to solve.

## The Pedagogy Problem

Computer science education teaches abstraction through geometric shapes and animals:

```java
abstract class Shape {
    abstract double area();
}

class Rectangle extends Shape {
    double width, height;
    double area() { return width * height; }
}
```

Clean. Elegant. Completely misleading about how abstraction works in real systems.

The problem: real-world categories don't map cleanly to code hierarchies. Your axe can implement `Damaging` and `Durable`, while your pickaxe implements `Damaging` and `Upgradeable`, without forcing them into an artificial hierarchy.

## Composition Over Inheritance

This is why "composition over inheritance" is such powerful advice.

**Inheritance says**: "This IS A that"
**Composition says**: "This HAS A that" or "This CAN DO that"

Composition is more flexible because you can combine behaviours independently, change implementations without affecting interfaces, avoid deep inheritance hierarchies, and make dependencies explicit.

## The Abstraction Test

Before creating an abstraction, ask:

**The Behaviour Test**: Do these things actually behave the same way? Will they evolve in the same direction? Do they have the same lifecycle?

**The Change Test**: When requirements change, will these things change together? Or will changes affect them differently?

**The Coupling Test**: Does this abstraction create useful decoupling? Or does it create artificial coupling?

## Red Flags for Bad Abstractions

Method names that don't make sense for all implementations. Lots of empty or default implementations. Frequently checking types at runtime.

```java
class Dog extends Animal {
    void fly() {
        throw new UnsupportedOperationException();
    }
}
```

## When to Create Abstractions

**Good times**: Multiple implementations that truly behave the same way, you need to swap implementations at runtime, you're building a plugin system, the abstraction eliminates meaningful code duplication.

**Bad times**: You have only one implementation (YAGNI), implementations have fundamentally different behaviours, you're just trying to make code "more object-oriented", you're modelling real-world relationships instead of software behaviours.

## The Evolution Strategy

1. Start with concrete implementations
2. Let duplication emerge naturally
3. When you have 3+ similar implementations, consider abstraction
4. Extract based on actual shared behaviour, not theoretical similarity
5. Be willing to break apart abstractions that become unwieldy

The computer doesn't care about your class hierarchy. Abstractions exist to help humans understand and modify code.

Sometimes the best abstraction is no abstraction at all.
