# Tolic's Engineering Mind - Blog Style Guide

## Front Matter

Every post requires:

```yaml
---
title: "Your Post Title: Add Subtitle for Clarity"
date: 2025-08-04
lastmod: 2025-08-04
draft: false
author: "Tolic Kukul"
description: "SEO-friendly description (150-160 chars with main keywords)"
tags: ["primary-tag", "secondary-tag", "tertiary-tag"]
categories: ["Primary Category"]
---
```

**File naming**: `YYYY-MM-DD-post-title-slug.md`
- Date prefix syncs automatically to front matter dates
- Run `./sync_dates.sh` after renaming files

---

## Writing Style

**Voice**: Calm authority with simple grammar and rhythmic flow
- "Good ideas rarely need permission."
- "We've learned that momentum is fragile."
- Confident, not forceful — replace "you must" with "you can"

**Purpose**: Illuminate, not argue
- Reflective and thoughtful, not preachy
- "You don't need to win debates — you need to keep building."

**Length**:
- 150-400 words (excluding code samples)

**Structure for posts**:
1. Clear, engaging opening (challenge an assumption or reveal overlooked truth)
2. Explain in short paragraphs (2-4 lines each, one idea per paragraph)
3. One small example (moment, experience, or metaphor)
4. Reflective closing line (slightly poetic but grounded)

**Formatting**:
- Active voice
- Short paragraphs (2-4 sentences)
- Simple sentences, sophisticated vocabulary (deliberate, inevitable, clarity, substance)
- Bold key concepts sparingly
- Use spaces around em dashes: "idea — the next" not "idea—the next"
- Australian English: organise, realise, colour, favour, centre

**Avoid**: "I think", "maybe", "in some cases", "you must", "that's wrong", jargon without explanation

---

## Content Rules

**Headers** (critical for accessibility):
- H1: Post title (automatic)
- H2: Main sections
- H3: Subsections within H2
- Never skip levels (H1→H3 is wrong)

**Code blocks**:
- Always specify language: ` ```python `
- Add comments for clarity
- Test all examples
- Keep under 80 characters per line

**SEO**:
- Title: <60 characters, include primary keyword
- Description: 150-160 characters, complete sentence
- Use 3-6 tags from standardized list
- Internal links to related posts

---

## Tags

**Rules**:
- Lowercase only: `ai` not `AI`
- Hyphens for multi-word: `software-architecture`
- 3-6 tags per post
- Use standardized tags (see full list in appendix)

**Common tags**: `ai`, `software-development`, `software-architecture`, `design-patterns`, `code-quality`, `career`, `productivity`, `rust`, `ruby-on-rails`

---

## Pre-Publish Checklist

- [ ] All required front matter fields present
- [ ] Description is 150-160 characters
- [ ] 3-6 tags from standardized list
- [ ] Heading hierarchy correct (no skipped levels)
- [ ] Code examples tested and commented
- [ ] Australian English spelling
- [ ] Spaces around em dashes
- [ ] Clear value proposition in first paragraph
- [ ] Actionable takeaway at end

---

## Appendix: Full Tag List

### Technology & Development
`ai`, `ai-agents`, `machine-learning`, `llms`, `chatgpt`, `claude-code`, `software-development`, `declarative-programming`, `proof-systems`, `hybrid-systems`, `ruby-on-rails`, `rust`, `vim`

### Architecture & Design
`software-architecture`, `design-patterns`, `modularity`, `abstractions`, `composition`, `microservices`, `distributed-systems`, `event-driven`, `real-time-systems`

### System Operations
`autonomous-systems`, `self-healing`, `adaptive-systems`, `resilience`, `circuit-breaker`, `consensus`, `ai-operations`, `event-streaming`, `batch-processing`, `data-processing`

### Code Quality
`code-quality`, `technical-debt`, `legacy-code`, `maintenance`, `refactoring`, `strangler-fig`

### Business & Organization
`enterprise`, `scaling`, `product-management`, `requirements`, `team-ownership`, `organizational-design`, `management`, `leadership`, `team-productivity`

### People & Skills
`career`, `learning`, `interviews`, `hiring`, `talent-management`, `neurodivergent`, `adhd`, `productivity`

### Other
`philosophy`, `psychology`, `personal`, `reflection`, `future-of-work`

---

Last updated: 2025-10-19
