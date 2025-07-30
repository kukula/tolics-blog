# Tolic's Engineering Mind - Blog Style Guide

This style guide ensures consistency across all blog posts, making content easier to maintain and improving the reader experience.

## Table of Contents
1. [Front Matter Template](#front-matter-template)
2. [Tag Standards](#tag-standards)
3. [Writing Guidelines](#writing-guidelines)
4. [Post Structure](#post-structure)
5. [Code Examples](#code-examples)
6. [SEO Best Practices](#seo-best-practices)

---

## Front Matter Template

Every blog post MUST include the following front matter fields:

```yaml
---
title: "Your Post Title: Add a Subtitle for Clarity"
date: 2025-08-04
lastmod: 2025-08-04
draft: false
author: "Tolic Kukul"
description: "SEO-friendly description (150-160 chars). Include main keywords and value proposition."
tags: ["primary-tag", "secondary-tag", "tertiary-tag"]
categories: ["Primary Category"]
---
```

### Optional Front Matter Fields

```yaml
series: ["Series Name"]          # For posts that are part of a series
summary: "Brief summary for listings"  # If different from description
showToc: true                    # Override global TOC setting
cover:
    image: "path/to/image.jpg"   # Cover image
    alt: "Alt text for image"    # Accessibility
```

### Front Matter Rules

1. **Title**: Use title case, be specific and compelling
2. **Date**: Always use YYYY-MM-DD format (no timestamps)
3. **Last Modified**: Update when making significant content changes
4. **Description**: Must be 150-160 characters, include keywords
5. **Tags**: 3-6 tags maximum, see tag standards below
6. **Categories**: Usually one, maximum two categories

---

## Tag Standards

### Formatting Rules

1. **Always lowercase**: `ai` not `AI`
2. **Use hyphens for multi-word tags**: `software-architecture` not `software architecture`
3. **Prefer plural for general concepts**: `abstractions` not `abstraction`
4. **Use 3-6 tags per post**

### Standardized Tag List

#### Core Technology & Development
- `ai` - Artificial Intelligence topics
- `ai-agents` - Autonomous AI agents
- `machine-learning` - ML algorithms and techniques
- `llms` - Large Language Models
- `chatgpt` - ChatGPT specific content
- `claude-code` - Claude Code CLI and tooling
- `software-development` - General programming topics
- `ruby-on-rails` - Rails framework
- `rust` - Rust language
- `vim` - Vim editor

#### Architecture & Design
- `software-architecture` - System design and architecture
- `design-patterns` - Software design patterns
- `modularity` - Modular design concepts
- `abstractions` - Abstraction concepts
- `composition` - Composition over inheritance
- `microservices` - Microservices architecture
- `distributed-systems` - Distributed computing
- `event-driven` - Event-driven architecture
- `real-time-systems` - Real-time processing

#### System Operations
- `autonomous-systems` - Self-managing systems
- `self-healing` - Self-healing mechanisms
- `adaptive-systems` - Systems that adapt
- `resilience` - System resilience
- `circuit-breaker` - Circuit breaker pattern
- `consensus` - Consensus algorithms
- `ai-operations` - AI ops
- `event-streaming` - Event streaming
- `batch-processing` - Batch processing
- `data-processing` - Data processing

#### Code Quality
- `code-quality` - Code quality practices
- `technical-debt` - Technical debt
- `legacy-code` - Legacy system issues
- `maintenance` - Code maintenance
- `refactoring` - Refactoring techniques
- `strangler-fig` - Strangler fig pattern

#### Business & Organization
- `enterprise` - Enterprise software
- `scaling` - Scaling systems/teams
- `product-management` - Product management
- `requirements` - Requirements engineering
- `team-ownership` - Ownership models
- `organizational-design` - Org structure
- `management` - Management practices
- `leadership` - Leadership topics
- `team-productivity` - Team efficiency

#### People & Skills
- `career` - Career development
- `learning` - Learning and education
- `interviews` - Interview processes
- `hiring` - Hiring practices
- `talent-management` - Managing talent
- `neurodivergent` - Neurodivergent topics
- `adhd` - ADHD specific content
- `productivity` - Personal productivity

#### Other
- `philosophy` - Philosophical topics
- `psychology` - Psychology in tech
- `personal` - Personal experiences
- `reflection` - Reflective posts
- `future-of-work` - Future trends

### Tag Selection Process

1. Choose one primary tag that best represents the post
2. Add 2-3 secondary tags for discoverability
3. Include at least one broad category tag
4. Don't create new tags without updating this guide

---

## Writing Guidelines

### Voice and Tone

1. **Professional but approachable** - Write as an experienced engineer sharing insights
2. **Direct and concise** - Get to the point quickly
3. **Practical over theoretical** - Include real-world examples
4. **Humble expertise** - Share knowledge without condescension

### Content Structure

1. **Hook readers immediately** - First paragraph should grab attention
2. **State the problem clearly** - What challenge are you addressing?
3. **Provide concrete examples** - Code, scenarios, or case studies
4. **Actionable takeaways** - What should readers do next?

### Writing Style

1. **Use active voice**: "The system processes events" not "Events are processed by the system"
2. **Short paragraphs**: 3-4 sentences maximum for readability
3. **Bullet points**: Use for lists of 3+ items
4. **Bold key concepts**: Help scanners find important points
5. **Avoid jargon**: Explain technical terms on first use

---

## Post Structure

### Standard Post Template

```markdown
## Introduction/Hook
Brief, engaging opening that hooks the reader (1-2 paragraphs)

## The Problem/Context
What challenge are we addressing? Why should readers care?

## Main Content (2-4 sections)
### Section 1 Title
Core content with examples

### Section 2 Title
Additional insights and details

## Practical Application
How to apply these concepts in real projects

## Conclusion
Summary and call-to-action
```

### Long-Form Posts (1500+ words)

For longer posts, include:
- Table of contents (automatic with ShowToc)
- Clear section breaks
- Summary boxes for key concepts
- Multiple code examples
- Visual diagrams where helpful

### Short Posts (< 800 words)

For shorter posts:
- Single focused topic
- One main insight
- 1-2 examples maximum
- Clear takeaway

---

## Code Examples

### Formatting Rules

1. **Always specify language**: ` ```python ` not just ` ``` `
2. **Keep examples focused**: Show only relevant code
3. **Add comments**: Explain non-obvious parts
4. **Test your code**: Ensure examples actually work

### Example Code Block

```python
# Good example - focused and commented
class CircuitBreaker:
    """Prevents cascading failures in distributed systems"""
    def __init__(self, failure_threshold=5, timeout=60):
        self.failure_threshold = failure_threshold
        self.timeout = timeout
        self.failures = 0
        
    def call(self, func, *args, **kwargs):
        if self.is_open():
            raise CircuitBreakerOpen()
        
        try:
            result = func(*args, **kwargs)
            self.on_success()
            return result
        except Exception as e:
            self.on_failure()
            raise
```

### Code Guidelines

1. **Prefer complete examples** over fragments
2. **Include imports** when not obvious
3. **Show both good and bad examples** for clarity
4. **Keep line length under 80 characters** for mobile readers

---

## SEO Best Practices

### Title Optimization

1. **Include primary keyword** in the title
2. **Keep under 60 characters** for search results
3. **Make it compelling** - people should want to click

### Description Writing

1. **150-160 characters** - This is what appears in search results
2. **Include primary keyword** naturally
3. **Add value proposition** - What will readers learn?
4. **End with period** - Complete sentence

### Content SEO

1. **Use headers properly** - H2 for main sections, H3 for subsections
2. **Include keywords naturally** - Don't force them
3. **Link to related posts** - Internal linking helps SEO
4. **Alt text for images** - Describe what's in the image

### URL Structure

Hugo automatically creates URLs from titles. Ensure titles create good URLs:
- Short and descriptive
- No special characters
- Logical hierarchy

---

## Quality Checklist

Before publishing, verify:

- [ ] Front matter includes all required fields
- [ ] Description is 150-160 characters
- [ ] 3-6 appropriate tags selected
- [ ] Post follows standard structure
- [ ] Code examples are tested and working
- [ ] No spelling or grammar errors
- [ ] Links are working
- [ ] Images have alt text
- [ ] Post provides clear value to readers

---

## Maintenance

This style guide should be updated when:
- New tags are needed (add to standardized list)
- Writing patterns evolve
- SEO best practices change
- New post types are introduced

Last updated: 2025-08-16