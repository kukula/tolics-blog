---
title: "Abstraction Is Hard: Why Wrong Abstractions Are Worse Than No Abstractions"
date: 2025-03-10
author: "Tolic Kukul"
tags: ["abstractions", "software-architecture", "design-patterns", "composition", "inheritance", "code-quality"]
series: ["Software Architecture"]
summary: "Creating good abstractions is one of the hardest parts of software development. Here's why getting them wrong is so expensive and how to think about them better."
description: "Learn why creating good abstractions is one of software development's hardest challenges. Discover when to abstract, when not to, and how to avoid costly mistakes."
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

class Circle extends Shape {
    double radius;
    double area() { return Math.PI * radius * radius; }
}
```
Now your axe can implement `Damaging` and `Durable`, while your pickaxe implements `Damaging` and `Upgradeable`, without forcing them into an artificial hierarchy.

## Composition Over Inheritance

This is why "composition over inheritance" is such powerful advice.

**Inheritance says:** "This IS A that"
**Composition says:** "This HAS A that" or "This CAN DO that"

Composition is more flexible because:
- You can combine behaviors independently
- You can change implementations without affecting interfaces
- You avoid deep inheritance hierarchies
- You make dependencies explicit

## The Abstraction Test

Before creating an abstraction, ask:

### The Behavior Test
- Do these things actually behave the same way?
- Will they evolve in the same direction?
- Do they have the same lifecycle?

### The Change Test
- When requirements change, will these things change together?
- Or will changes affect them differently?

### The Coupling Test
- Does this abstraction create useful decoupling?
- Or does it create artificial coupling?

## Red Flags for Bad Abstractions

**Method names that don't make sense for all implementations:**
```java
abstract class Animal {
    abstract void fly(); // What about dogs?
}
```

**Lots of empty or default implementations:**
```java
class Dog extends Animal {
    void fly() { 
        throw new UnsupportedOperationException(); 
    }
}
```

**Frequently checking types at runtime:**
```java
if (animal instanceof Bird) {
    ((Bird) animal).fly();
}
```

## When to Create Abstractions

**Good times:**
- Multiple implementations that truly behave the same way
- You need to swap implementations at runtime
- You're building a plugin system or framework
- The abstraction eliminates meaningful code duplication

**Bad times:**
- You have only one implementation (YAGNI)
- Implementations have fundamentally different behaviors
- You're just trying to make the code "more object-oriented"
- You're modeling real-world relationships instead of software behaviors

## The Evolution Strategy

1. **Start with concrete implementations**
2. **Let duplication emerge naturally**
3. **When you have 3+ similar implementations, consider abstraction**
4. **Extract based on actual shared behavior, not theoretical similarity**
5. **Be willing to break apart abstractions that become unwieldy**

## Remember: Abstractions Are for Humans

The computer doesn't care about your class hierarchy. Abstractions exist to help humans understand and modify code.

If your abstraction makes the code harder to understand or change, it's not helping—regardless of how theoretically "correct" it might be.

Sometimes the best abstraction is no abstraction at all.

Focus on making your code clear, flexible, and maintainable. Good abstractions will emerge naturally from these goals.
