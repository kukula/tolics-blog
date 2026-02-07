---
title: "Living Software: The Persistence Layer"
date: 2026-02-08
lastmod: 2026-02-08
draft: true
author: "Tolic Kukul"
description: "Data outlives every restructuring. An immutable event log with disposable projections makes radical architectural evolution safe, not terrifying."
tags: ["software-architecture", "event-driven", "autonomous-systems", "self-healing", "data-processing"]
categories: ["Software Architecture"]
series: ["Living Software Framework"]
---

Code is stateless — you can throw it away and regenerate it. Data is the opposite. It's accumulated, irreplaceable, and it has meaning that changes as the system evolves.

The core problem: an agent restructures the system, and now the data model is different. Old data needs to live in the new world. Every traditional system handles this with migrations — handwritten SQL scripts that transform schema A into schema B. That's exactly the kind of brittle, error-prone, human-era artifact we're trying to eliminate.

## Data as a First-Class Citizen

Data shouldn't be an implementation detail that agents manage. It should be part of the stability contract itself.

```text
data customer_record {
  # Semantic identity - this is what the data IS, not how it's stored
  represents: a customer's interactions and deal history over time

  # Immutability rules
  append_only: interactions     # past entries never modified
  mutable: preferences          # customer can change settings

  # Retention
  lifetime: until_customer_deletes
  backup: continuous

  # Privacy classification
  sensitivity: business_confidential
  encryption: at_rest_and_transit

  # Semantic fields - WHAT not HOW
  fields {
    identity     → company_or_person
    timestamps   → when interactions occurred
    interactions → calls, emails, meetings, deal_updates
    derived      → engagement_scores, churn_risk (can be recomputed)
  }
}
```

Notice there's no SQL, no column types, no table structure. The agent decides how to store this. But the intent layer declares what it is and what guarantees it carries.

The critical distinction is between primary data (interactions the rep entered — sacred, never losable) and derived data (scores, caches, indexes — recomputable from primary data at any time).

## The Append-Only Event Core

Underneath everything, the framework maintains an immutable event log. Every piece of primary data enters the system as an event and never changes.

```text
Event log (immutable, append-only, this is the source of truth):

  e001: { customer: c1, type: interaction_logged,
           data: {call, duration: 15m, notes: "pricing Q"}, time: ... }
  e002: { customer: c1, type: deal_updated,
           data: {stage: negotiation, value: 50k}, time: ... }
  e003: { customer: c1, type: rep_assigned,
           data: {rep: jsmith}, time: ... }
  e004: { customer: c1, type: consent_granted,
           data: {marketing_emails: true}, time: ... }
```

This is event sourcing elevated to a framework primitive rather than an architectural choice. The agents never touch this log. They can only append to it. Everything else — the queryable database, the API responses, the user-facing views — is a projection of this log, and projections can be rebuilt from scratch at any time.

This is what makes evolution safe. When an agent restructures the system, it's not migrating data. It's building a new projection of the same immutable events.

## How Evolution Works with Data

```text
Current system:
  Event log: [e001, e002, e003, ... e50000]
  Projection A: PostgreSQL with schema v3
    → customers table, interactions table, deals table

Agent creates a draft with a completely different data model:
  Projection B: Graph database
    → company nodes, contact nodes, deal nodes, relationship edges

Promotion process:
  1. Agent builds Projection B from the FULL event log
     (replays all 50,000 events into new structure)
  2. Verification: is every primary data point accessible
     through the new projection? Can every intent-layer
     query still be answered?
  3. Canary: run both projections simultaneously, compare
     results for real queries
  4. Swap: route traffic to Projection B
  5. Keep Projection A alive for rollback window
  6. Event log never changed. Nothing was "migrated."
```

The event log is the invariant. Projections are disposable. Agents can be as radical as they want about restructuring the queryable layer because the raw data is untouchable.

## Schema Evolution and Enrichment

Early in the system, an interaction event might look like `{type: "call"}`. Later, the intent evolves to include duration, sentiment, follow-up. New events have richer structure. Old events don't.

The framework needs a concept of event enrichment — agents can create derived events that augment old data without modifying it:

```text
# Original event (immutable, stays forever)
e001: { type: "call" }

# Enrichment event (agent-generated, linked to original)
e001_enriched: {
  source: e001,
  type: retroactive_enrichment,
  inferred_sentiment: null,       # honestly unknown
  normalised_interaction: "call_outbound",
  enrichment_confidence: 0.95
}
```

The enrichment is clearly marked as inferred, not original. The original event is untouched. Projections can use enrichments or ignore them.

Data that genuinely needs to change — a customer wants to update their company name, or delete their account (GDPR) — gets handled through tombstone events and identity resolution:

```text
e005: { type: customer_updated_name, customer: c1,
         new_name: "Acme Corp", old_name: "Acme Inc" }
e006: { type: customer_requested_deletion, customer: c1,
         scope: all_data }
```

The event log records the intent to change, not the change itself. Projections interpret these events. A deletion event means projections must exclude that customer's data. The raw events get cryptographically shredded (delete the encryption key for that customer's events, rendering them unrecoverable without actually modifying the log structure).

## Verifying Data Survives Evolution

Before any draft gets promoted, the stability membrane runs a data completeness check:

```text
For every entity class in the intent layer:
  - Can all existing instances be queried through the new projection?
  - Do all invariants still hold? (customer data encrypted,
    append-only fields unmodified, retention rules respected)
  - Are all derived fields recomputable from the event log?
  - Round-trip test: read entity through old projection,
    read same entity through new projection,
    semantic equivalence check
```

If any primary data becomes inaccessible through the new projection, the draft is rejected. Period. The agent has to find another approach.

## The Practical Architecture

The intent layer (data semantics plus invariants) feeds into the immutable event log (append-only, encrypted, the one source of truth, never touched by agents). From the event log, a projector (controlled by agents) produces disposable, rebuildable views — SQL, graph, search indexes, whatever the current system topology requires.

The event log is the one thing in the whole framework that's truly permanent. Everything above it (intent) is human-controlled. Everything below it (projections) is agent-controlled and disposable. The log itself is sacred ground — append-only, replicated, encrypted, and untouchable by any agent.

This means an agent could literally throw away the entire application layer and rebuild it from scratch, and no customer would lose a single data point. That's what makes "living system" safe rather than terrifying.

---
