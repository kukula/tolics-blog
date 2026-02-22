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
- Short-form: 150-400 words
- Long-form (technical deep-dives): no hard cap, but earn every paragraph

**Structure for posts**:
1. Clear, engaging opening (challenge an assumption or reveal overlooked truth)
2. Explain in short paragraphs (2-4 sentences, one idea per paragraph)
3. One small example (moment, experience, or metaphor)
4. Cohesive closing — one section, not fragmented endings. Let data speak without editorialising. Close with a confident assertion or reflective line.

**Formatting**:
- Active voice
- Simple sentences, sophisticated vocabulary (deliberate, inevitable, clarity, substance)
- Bold key concepts sparingly
- Use spaces around em dashes: "idea — the next" not "idea—the next"
- Australian English: organise, realise, colour, favour, centre

**Avoid**: "I think", "maybe", "in some cases", "you must", "that's wrong", jargon without explanation, markdown tables (convert to prose or bullet lists — tables render poorly on mobile and in RSS), vendor-specific tool comparisons (they age fast — fold into a single sentence if essential)

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

**Diagrams**:
- Use Mermaid (` ```mermaid `) instead of ASCII art — renders as SVG, responsive, and adapts to dark/light theme
- Linear pipelines: use `flowchart TD` — keeps nodes full-width and readable on mobile
- Branching graphs: use `flowchart LR` — branches stack vertically and stay narrow on mobile
- Supported via Hugo code block render hook + Mermaid JS (loaded only on pages that use it)
- If needed use CSS variables for accent-style highlighted nodes: `classDef accent fill:var(--accent-primary),stroke:var(--accent-secondary),color:white;`

**Links**:
- Limit inline links to 3–7 per post
- Prefer primary sources (research papers, official engineering blogs) over vendor listicles or aggregator sites
- Every inline link should directly support the claim it's attached to
- Do not duplicate inline links in a footer section — if a source is linked in the text, it doesn't need a second entry
- A **Further Reading** section at the end is for additional sources not already linked inline
- Internal links use the full path with date prefix: `/posts/YYYY-MM-DD-slug/` (not just `/posts/slug/`)
- **Verify every link before publishing** — both internal and external. Broken links erode trust.
  - Internal: `./scripts/check_links.sh`
  - External: `./scripts/check_external_links.sh`

**SEO**:
- Title: <60 characters, include primary keyword
- Description: 150-160 characters, complete sentence
- Internal links to related posts

---

## Tags

**Rules**:
- Lowercase only: `ai` not `AI`
- Hyphens for multi-word: `software-architecture`
- 3-6 tags per post
- Use standardised tags (see full list in appendix)

**Common tags**: `ai`, `software-development`, `software-architecture`, `design-patterns`, `code-quality`, `career`, `productivity`, `rust`, `ruby-on-rails`

---

## Pre-Publish Checklist

- [ ] All required front matter fields present
- [ ] Description is 150-160 characters
- [ ] 3-6 tags from standardised list
- [ ] Heading hierarchy correct (no skipped levels)
- [ ] Code examples tested and commented
- [ ] Australian English spelling
- [ ] Spaces around em dashes
- [ ] Clear value proposition in first paragraph
- [ ] Strong closing — reflective, assertive, or both
- [ ] Internal links verified (`./scripts/check_links.sh`)
- [ ] External links verified (`./scripts/check_external_links.sh`)

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

### Business & Organisation
`enterprise`, `scaling`, `product-management`, `requirements`, `team-ownership`, `organizational-design`, `management`, `leadership`, `team-productivity`

### People & Skills
`career`, `learning`, `interviews`, `hiring`, `talent-management`, `neurodivergent`, `adhd`, `productivity`

### Other
`philosophy`, `psychology`, `personal`, `reflection`, `future-of-work`

---

Last updated: 2026-02-22
