---
title: "Optimising Claude Code: The 100-Line CLAUDE.md That Actually Works"
date: 2025-06-15
lastmod: 2025-06-15
draft: false
author: "Tolic Kukul"
description: "Transform your bloated CLAUDE.md into a concise guide that Claude Code actually follows. Learn the secrets from top developers who get 10x better results."
tags: ["claude-code", "ai", "productivity", "software-development"]
categories: ["Software Development"]
---

My CLAUDE.md file was 300+ lines of verbose documentation that Claude Code routinely ignored. Sound familiar?

After researching what actually works in the community, I discovered the brutal truth: **Claude Code doesn't read novels. It needs bullet points and shortcuts.**

## The Problem

My original CLAUDE.md had detailed explanations for error handling, service patterns, and testing rules. Claude Code would consistently miss these rules because they were buried in prose.

## What Actually Works

Expert developers reported that concise, scannable formats work dramatically better. Top developers use shortcuts like `qplan`, `qcode`, `qcheck` with "10x better results." Research shows "1 iteration with structure was of similar accuracy to 8 iterations with unstructured prompts."

### Before: Verbose Explanations
```markdown
### Services
- Follow the Single Responsibility Principle: one service, one task.
- Use class methods for stateless operations.
- Return domain objects, not primitives or temporary files.
```

### After: Scannable Patterns
```ruby
class ExampleService
  def self.call(user:, resource:)  # keyword args only
    # return domain objects, comprehensive error handling
  end
end
```

Instantly scannable. Immediately actionable.

## The Secret Weapon: Shorthand Commands

The biggest game-changer? Adding commands that trigger specific workflows:

```markdown
### Common Commands
- `qplan` = analyse codebase consistency before implementing
- `qcode` = implement with tests and formatting
- `qcheck` = review against CLAUDE.md checklists
- `qcommit` = run quality checks then commit
```

Now instead of hoping Claude remembers rules, I just type `qcheck` and it automatically reviews against my standards.

## Key Principles That Work

1. **Scannable Over Comprehensive** — Bullet points beat paragraphs
2. **Commands Over Explanations** — `qcheck` beats "please review your code"
3. **Examples Over Rules** — Code snippets beat written explanations
4. **Structure Over Length** — Clear sections beat comprehensive coverage
5. **Enforcement Over Hope** — Build verification into workflow

## The Results

**Before:** Claude would skip documentation checks, forget to run quality scripts, create the wrong types of tests, ignore established patterns.

**After:** Claude now always checks specs with `qspec`, automatically runs quality checks with `qcommit`, creates request specs instead of controller specs, follows patterns consistently.

Claude Code is incredibly powerful, but only if you speak its language. That language isn't verbose documentation — it's concise, structured, actionable guidance.

**Stop writing novels. Start writing bullet points.**
