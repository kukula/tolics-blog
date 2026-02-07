---
title: "Building a Graph-Based Intent Modelling Tool"
date: 2026-01-28
lastmod: 2026-01-28
draft: false
author: "Tolic Kukul"
description: "A proof-of-concept tool for graph-based system modelling — defining system behaviour, validating it structurally, and generating tests from the intent."
tags: ["software-architecture", "declarative-programming", "llms"]
categories: ["Software Architecture"]
series: ["Declarative Systems"]
---

We've established that [code is a lossy format](/posts/2026-01-19-code-is-a-lossy-format/), proposed [the self-validating graph](/posts/2026-01-20-the-self-validating-graph/) as a solution, and outlined [an incremental adoption path](/posts/2026-01-21-adopting-system-models-incrementally/). To explore these ideas further, this series includes a small proof-of-concept called Lattice. Here's what modelling, validating, and generating tests might look like in practice.

**Repository:** [github.com/kukula/lattice](https://github.com/kukula/lattice) *(experimental, not production-ready)*

## The Core Idea

Lattice represents system behaviour as a graph. Entities, their states, relationships, and transitions form nodes and edges that can be traversed, queried, and validated. The format is flexible — these demos use YAML, but any structured format works:

```yaml
entities:
  User:
    attributes:
      - name: email
        type: string
        unique: true
    relationships:
      - has_many: Post

  Post:
    belongs_to: User
    attributes:
      - name: title
        type: string

    states:
      - name: draft
        initial: true
      - name: published
        terminal: true

    transitions:
      - from: draft
        to: published
        trigger: user.publish
```

This graph-based approach makes intent machine-readable without sacrificing human authorship. The structure is rigid enough for automated analysis yet expressive enough to capture real-world complexity.

## Validation

The tool performs two types of validation. **Structural validation** runs fast and locally — detecting orphaned entities, unreachable states, broken references, and cycles. Consider a model with issues:

```yaml
entities:
  Task:
    states:
      - name: pending
        initial: true
      - name: in_progress
      - name: completed
        terminal: true
      - name: secret  # No incoming transitions!

    transitions:
      - from: pending
        to: in_progress
        trigger: user.start
      - from: in_progress
        to: completed
        trigger: user.complete
      - from: secret  # Can never reach this state
        to: completed
        trigger: admin.resolve
```

The tool catches this immediately:

```
$ intent validate task_model.yaml
ERRORS:
  ✘ UNREACHABLE_STATE: [Task.secret] State 'secret' cannot be reached from initial state 'pending'

WARNINGS:
  (none)

Validation failed: 1 error(s), 0 warning(s)
```

**Semantic validation** leverages LLM analysis to find contradictions that structural rules miss. Given an authorisation model with these rules:

```yaml
authorization_rules:
  - name: owner_access
    rule: "user == resource.owner => allow(*)"

  - name: suspended_block
    rule: "user.status == suspended => deny(*)"
    priority: high
```

The LLM surfaces the conflict:

```
$ intent analyze auth_model.yaml
ERRORS:
  (none)

WARNINGS:
  ⚠ SEMANTIC_CONTRADICTION: [Resource] Rule 'owner_access' grants owner full access,
    but 'suspended_block' denies all actions for suspended users. If owner is
    suspended, which rule wins? Consider adding explicit priority or a
    'suspended_owner' rule.

Validation passed with 1 warning(s)
```

## Test Generation

From validated models, Lattice generates test stubs. State transitions become test scenarios:

```python
class TestPositiveTransitions:
    """Tests for valid state transitions."""

    def test_post_draft_to_published(self, post_in_draft_state):
        """
        Post transitions from draft to published on user.publish
        """
        # Trigger: user.publish
        # TODO: Assert state == 'published'
        pass
```

```
$ intent generate-tests examples/minimal_valid.yaml
Generated 5 tests in 1 files
```

## Why This Matters

Documentation drifts. Code decays. But a model that validates itself against both stays honest. When intent becomes structure, assumptions have nowhere to hide.
