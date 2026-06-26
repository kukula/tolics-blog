# Tolic's Engineering Mind - Blog Style Guide

**Golden example**: `content/posts/2026-06-25-the-future-vi-editor-with-own-ui.md` — the reference for voice, rhythm, and structure described below.

## Front Matter

Every post requires:

```yaml
---
title: "Your Post Title: Add Subtitle for Clarity"
date: 2026-08-04
lastmod: 2026-08-04
draft: false
author: "Tolic Kukul"
description: "SEO-friendly description (150-160 chars with main keywords)"
tags: ["primary-tag", "secondary-tag", "tertiary-tag"]
categories: ["Primary Category"]
series: ["Series Name"]   # optional — omit for standalone posts
---
```

**File naming**: `YYYY-MM-DD-post-title-slug.md`
- The date prefix sets `date` (publication date) in front matter
- Run `./sync_dates.sh` after renaming files
- `date` is set once and left alone. `lastmod` is updated by hand whenever a published post changes materially — a correction, an added section, a reworked argument. Trivial typo fixes don't earn a `lastmod` bump.

**Series**: Use `series` only when a post is one instalment of a deliberate run that readers benefit from navigating as a set — "AI Tech in One Sentence", a multi-part deep-dive. A post that merely shares a theme with others is not a series; tags already carry that. Name the series exactly as it should display, in title case, and keep it identical across every instalment — Hugo groups on the literal string. One series per post.

---

## Writing Style

**Voice**: Calm authority with simple grammar and rhythmic flow
- "Good ideas rarely need permission."
- "We've learned that momentum is fragile."
- Confident, not forceful — replace "you must" with "you can"
- First-person and personal is welcome — own the opinion: "I keep wanting an editor that doesn't exist. Here's the dream, out loud." The ban is on *hedging* ("I think", "maybe"), not on "I".

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
- Sentence fragments are encouraged for rhythm and emphasis: "Something tiny. Fast. Bare bones. Like vi." and "Glue, not invention." Use them deliberately to land a beat, not as a crutch.
- Bold key concepts sparingly; italics for a single word of emphasis ("read and write your *entire* editor")
- Use spaces around em dashes: "idea — the next" not "idea—the next"
- Australian English: organise, realise, colour, favour, centre

**Avoid**: "I think", "maybe", "in some cases", "you must", "that's wrong", jargon without explanation, markdown tables (convert to prose or bullet lists — tables render poorly on mobile and in RSS), vendor-specific *feature, version, or pricing* comparisons (they age fast — fold into a single sentence if essential). Comparing tools' *architecture or design philosophy* to frame a point is fine and often illuminating — e.g. contrasting Neovim, Helix, and Zed to locate the gap a new idea fills.

---

## Content Rules

**Headers** (critical for accessibility):
- H1: Post title (automatic)
- H2: Main sections
- H3: Subsections within H2
- Never skip levels (H1→H3 is wrong)
- Prefer short, evocative section titles over generic ones: "The itch", "The vision", "Why now", "The pitch in one line" — not "Introduction", "Background", "Conclusion". Keep them concrete.

**Images**:
- Every image requires alt text that describes its content or function, not its filename: `![A vi buffer splitting into two panes](…)` not `![screenshot](…)`
- If an image is purely decorative, give it empty alt (`![]()`) so screen readers skip it — don't describe ornament
- Alt text is a complete phrase, not keyword soup; it reads as a sentence to someone who can't see the image
- Diagrams count: a Mermaid diagram solving a hard concept should be introduced in prose that conveys the same point, since the SVG isn't reliably read aloud

**Code blocks**:
- Always specify language: ` ```python `
- Add comments for clarity
- Test all examples
- Keep under 80 characters per line

**Diagrams**:
- Only use a diagram when it visualises a genuinely hard concept — a non-trivial system, data flow, state machine, or relationship that prose cannot carry cleanly. Simple lineages, lists, sequences of three or four items, and anything a sentence already explains do not earn a diagram. Default to prose; reach for Mermaid only when the picture does work words can't.
- Use Mermaid (` ```mermaid `) instead of ASCII art — renders as SVG, responsive, and adapts to dark/light theme
- Linear pipelines: use `flowchart TD` — keeps nodes full-width and readable on mobile
- Branching graphs: use `flowchart LR` — branches stack vertically and stay narrow on mobile
- Supported via Hugo code block render hook + Mermaid JS (loaded only on pages that use it)
- If needed use CSS variables for accent-style highlighted nodes: `classDef accent fill:var(--accent-primary),stroke:var(--accent-secondary),color:white;`

**Links**:
- Limit inline links to max 7 per post
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
- Tag slugs are canonical identifiers; once published, prefer keeping a slug stable over correcting its spelling, to avoid breaking URLs.

**Common tags**: `ai`, `software-development`, `software-architecture`, `design-patterns`, `code-quality`, `career`, `productivity`, `rust`, `ruby-on-rails`

---

## Categories

Exactly one category per post — the primary lens a reader would file it under. Categories are broad and few; tags are specific and many. Use only these:

- **AI** — models, agents, the field and its philosophy
- **Software** — engineering, architecture, code quality, tooling
- **Philosophy** — ideas, ethics, epistemology, meaning
- **Fiction** — speculative and short fiction
- **Personal** — reflection, spirituality, life

Don't invent new categories per post. If something genuinely doesn't fit, that's a signal to reconsider the list deliberately — not to add a one-off.

---

## Pre-Publish Checklist

- [ ] All required front matter fields present
- [ ] Description is 150-160 characters
- [ ] 3-6 tags from standardised list
- [ ] Exactly one category from the closed list
- [ ] `series` set if part of a run, omitted otherwise
- [ ] Heading hierarchy correct (no skipped levels)
- [ ] Every image has meaningful alt text (or empty alt if decorative)
- [ ] Code examples tested and commented
- [ ] Australian English spelling
- [ ] Spaces around em dashes
- [ ] Clear value proposition in first paragraph
- [ ] Strong closing — reflective, assertive, or both
- [ ] `lastmod` bumped if this is a material edit to a published post
- [ ] Internal links verified (`./scripts/check_links.sh`)
- [ ] External links verified (`./scripts/check_external_links.sh`)

---

## Appendix: Full Tag List

### Technology & Development
`ai`, `ai-agents`, `machine-learning`, `llms`, `chatgpt`, `claude-code`, `software-development`, `declarative-programming`, `proof-systems`, `hybrid-systems`, `ruby-on-rails`, `rust`, `vim`

### Architecture & Design
`software-architecture`, `design-patterns`, `best-practices`, `modularity`, `abstractions`, `composition`, `microservices`, `distributed-systems`, `event-driven`, `real-time-systems`

### System Operations
`autonomous-systems`, `self-healing`, `adaptive-systems`, `resilience`, `circuit-breaker`, `consensus`, `ai-operations`, `event-streaming`, `batch-processing`, `data-processing`

### Code Quality
`code-quality`, `technical-debt`, `legacy-code`, `maintenance`, `refactoring`, `strangler-fig`

### Business & Organisation
`enterprise`, `scaling`, `product-management`, `requirements`, `team-ownership`, `organisational-design`, `management`, `leadership`, `team-productivity`

### People & Skills
`career`, `learning`, `interviews`, `hiring`, `talent-management`, `neurodivergent`, `adhd`, `productivity`

### Other
`philosophy`, `psychology`, `personal`, `reflection`, `future-of-work`

---

Last updated: 2026-06-26
