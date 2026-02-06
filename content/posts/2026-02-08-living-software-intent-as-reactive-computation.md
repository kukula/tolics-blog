---
title: "Living Software: Intent as Reactive Computation"
date: 2026-02-08
lastmod: 2026-02-08
draft: true
author: "Tolic Kukul"
description: "Intent is not just a description — it is a reactive specification. A full CRM example shows how consequence graphs make gap detection mechanical."
tags: ["software-architecture", "declarative-programming", "ai-agents", "proof-systems", "autonomous-systems"]
categories: ["Software Architecture"]
series: ["Living Software Framework"]
---

If gaps are detectable at the intent layer, then the conductor doesn't need to understand implementation details at all. It just evaluates the intent spec against the event log and the gaps fall out mechanically. The intent layer becomes a live, computable contract.

## From Description to Reactive Specification

This means the intent language needs to be more than a description. It needs to be a reactive specification — something that can answer "given everything that's happened, what should be true right now?"

## A Complete Example

```text
system "customer_platform" {

  # ─── DATA SEMANTICS ───

  entity customer {
    has: interactions[]
    has: deals[]
    has: preferences
    rule: always_has_encryption_key
    rule: deletion_means_crypto_shred
  }

  entity interaction {
    belongs_to: customer
    immutable: true        # once recorded, never changed
    has: type, sentiment, timestamp, context
    rule: timestamp_never_in_future
  }


  # ─── REACTIVE CONSEQUENCES ───
  # Each "when" block declares: if X happens, Y must follow.
  # The conductor just checks: did Y follow?

  when interaction.created {

    # Always happens
    must: update_engagement_score(interaction.customer)
    must: acknowledge_to_rep(interaction)
      within: 5s

    # Conditional consequences
    if engagement(interaction.customer).trend
       crosses threshold.churn_warning {

      must: alert_rep(
        customer: interaction.customer,
        reason: churn_risk_rising,
        actionable: true    # alert must suggest next step
      )
        within: 1m

      must: log_alert_event
    }

    if engagement(interaction.customer).trend
       crosses threshold.churn_critical
       AND interaction.customer.has_account_manager {

      must: notify_account_manager(
        manager: interaction.customer.primary_account_manager,
        summary: engagement_summary(interaction.customer),
        urgency: high
      )
        within: 5m

      must: await_manager_acknowledgment
        within: 24h
        fallback: escalate_to_sales_director
    }
  }

  when customer.assigned_rep {
    must: share_history(
      data: customer.interactions,
      recipient: rep,
      requires: data_access_authorisation
    )
    must: setup_notification_channel(customer, rep)
  }

  when manager.acknowledged_alert {
    must: notify_rep(
      message: "your manager has reviewed the account",
      tone: informational
    )
  }


  # ─── TEMPORAL EXPECTATIONS ───
  # Things that should happen based on time, not events

  every day at rep.preferred_time {
    if rep.has_active_deals {
      should: prompt_activity_log(rep)
        # "should" vs "must" — soft expectation,
        # gap is low priority
    }
  }

  every week {
    for each customer with interactions.count > 3 {
      must: generate_pipeline_review(customer)
      must: recalculate_engagement_scores(customer)
    }
  }

  when alert.unacknowledged for 4h {
    must: re_alert(
      escalate: true,
      channel: most_reliable(rep.contact_preferences)
    )
  }


  # ─── INVARIANTS (always true, not event-triggered) ───

  always {
    # These aren't consequences — they're continuous truths.
    # Any violation is immediately a gap.

    assert: every(interaction) is reachable_through_projection
    assert: every(customer.encryption_key) exists AND valid
    assert: no(alert.critical) is unacknowledged for > 24h
    assert: every(deal_score) has explanation
    assert: every(customer_contact) has consent_record
  }
}
```

## The Consequence Graph

The intent layer compiles down to a consequence graph — a computable structure that the conductor evaluates:

```text
Event: interaction.created(i1, customer: c1, type: call, sentiment: negative)

Expected consequences:
├─ MUST engagement_updated(c1)              within: 5s
│   └─ status: ✓ (event e4021 satisfies this)
├─ MUST acknowledged(i1)                    within: 5s
│   └─ status: ✗ GAP — no acknowledgment event found
├─ CONDITIONAL: check churn threshold
│   └─ engagement(c1).trend = 42 → crosses churn_warning(45)
│       ├─ MUST alert_rep(c1, churn_risk_rising) within: 1m
│       │   └─ status: ✓ (event e4022)
│       └─ MUST log_alert_event
│           └─ status: ✓ (event e4023)
└─ CONDITIONAL: check critical + manager
    └─ trend = 42, critical threshold = 20 → not crossed
        └─ no consequences required ✓

Gaps found: 1
  → acknowledgment missing for interaction i1
  → severity: must-within-5s (high priority)
  → spawn agent to resolve
```

The conductor doesn't need to know anything about CRM. It just evaluates the consequence graph. The intelligence is in the intent spec, not the gap detector.

## Three Layers of Gap Detection

**Layer 1: Consequence gaps (reactive)** — "This event happened, this consequence didn't." Detected by replaying the `when` blocks against the event log. Mechanically computable.

Examples: interaction created but engagement score not updated; alert fired but rep not notified; rep assigned but history not shared.

**Layer 2: Invariant gaps (continuous)** — "This thing should always be true and currently isn't." Detected by periodically evaluating `always` blocks against current system state.

Examples: an interaction exists in event log but not in projection; an encryption key is expired; a deal score has no explanation.

**Layer 3: Temporal gaps (scheduled)** — "This time-based expectation wasn't met." Detected by evaluating `every` and `when...for` blocks against the clock.

Examples: pipeline review not generated by end of week; daily activity prompt not sent at preferred time; alert unacknowledged for more than 4 hours.

## Priority: Must, Should, Could

The must/should distinction is how the framework decides which ambiguities to resolve now and which to let evolve:

- **must** — hard gap. Conductor spawns agent immediately. Promotion is blocked until resolved.
- **should** — soft gap. Conductor logs it, spawns agent on low priority. System continues functioning.
- **could** — optimisation opportunity. Conductor notes it, addresses when there's spare budget.

```text
# This gives the system a natural priority queue:
#   must gaps    → fix now
#   should gaps  → fix soon
#   could gaps   → fix when possible
#   invariant violations → fix IMMEDIATELY (above must)
```

## Intent Evolution Creates Gaps Automatically

```text
# Day 1: intent spec says
when interaction.created {
  must: update_engagement_score(customer)
}

# Day 30: human updates intent spec to add
when interaction.created {
  must: update_engagement_score(customer)
  must: check_competitor_mentions(customer)   # NEW
}

# The conductor immediately detects:
# "there are 5,000 existing interactions where
#  check_competitor_mentions never ran"
#
# This is a CONSEQUENCE GAP — retroactive.
# The intent layer can specify:

when intent.evolved {
  backfill_policy: sequential   # process old events against new rules
  # vs: prospective_only        # only apply to new events
  # vs: human_decision          # ask human what to do
}
```

When the intent evolves, the system automatically knows what work needs to happen to bring existing data into compliance. No migration scripts. No Jira tickets. The gap just appears and agents resolve it.

## Verification and Debugging

The compiled consequence graph is also what makes verification possible:

```text
When an agent submits a draft for promotion:

  1. Replay ALL "when" blocks against the full event log
     using the NEW system implementation in the draft

  2. Does the new implementation produce all the same
     consequence events the old one did?

  3. Does it ALSO close the gap it was spawned to fix?

  4. Do all "always" invariants hold in the new state?

  If yes to all → promote
  If no → reject draft, agent tries again
```

The human-writable intent spec is parsed into an abstract consequence graph, which is then compiled into an executable gap detector. At runtime, the gap detector evaluates triggered `when` blocks for each new event, computes expected results, diffs against actual outcomes, and emits gaps. On schedule, it evaluates temporal blocks and invariants, also emitting gaps. The conductor then spawns agents to resolve them.

The intent spec is the single source of truth for what the system should be doing. The gap detector is mechanically derived from it. The conductor is generic — it works for any system, any domain. Swap the intent spec and you have a completely different living system using the same framework.

Debugging becomes fundamentally different. You don't ask "what went wrong in the code." You ask "which consequence didn't fire, and why did the agent fail to resolve it." The entire debugging surface is at the intent level, not the implementation level.

## The Gap Between Vision and Reality

Current AI models can handle simple gap resolution (rebuild a projection, append a missing event) but struggle with genuine architectural reasoning. The framework's value is that it degrades gracefully — even with limited AI capability, the gap detection and stability contract provide value. As models improve, the range of gaps they can autonomously resolve widens. The framework is the scaffolding; the intelligence grows into it.

A proof-of-concept would demonstrate the full lifecycle end-to-end: events arrive, gaps are detected against the consequence graph, agents resolve straightforward gaps by appending events, cascading consequences are handled, and when the intent evolves, retroactive gaps are identified and either resolved or escalated.

The core data structures — the consequence graph, the gap evaluator, and the conductor loop — are the heart of the whole framework. The next piece that would make this real is the intent language parser, turning the human-writable spec syntax into computable consequence graphs.

---

*Previous: [Living Software: The Conductor](/posts/2026-02-08-living-software-the-conductor/)*
