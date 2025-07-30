---
title: "Building Hybrid Declarative Systems: A Practical Architecture Guide"
date: 2025-01-20
lastmod: 2025-01-20
draft: false
author: "Tolic Kukul"
description: "Learn how to architect hybrid declarative systems that combine symbolic reasoning with machine learning for trustworthy, explainable AI decisions."
tags: ["hybrid-systems", "declarative-programming", "software-architecture", "ai", "proof-systems", "machine-learning"]
categories: ["Software Architecture"]
series: ["Declarative Systems"]
---

Back in 2012, I built medical software that tracked drug interactions and provided decision support doctors could review. It combined hard rules with statistical inference. Here's how I'd build it today.

## The Four-Layer Architecture

Think of a hybrid system like a brain with specialised regions that collaborate:

**Knowledge Layer**: Your symbolic foundation where hard truths live — facts, rules, and constraints that must always hold.

```prolog
% Hard rules
contraindicated(Med, Patient) :- allergy(Med, Patient, confirmed).

% Decision rules with confidence thresholds
recommend(antibiotic, Patient) :-
    xray_finding(pneumonia, Patient, _, P), P >= 0.7,
    \+ contraindicated(antibiotic, Patient).
```

**Learning Layer**: Statistical models handling messy, uncertain reality — perception models, risk scoring, uncertainty quantification. The key is calibration. Raw neural outputs are often overconfident.

**Integration Layer**: The critical bridge where most systems fail. ML outputs become predicates with confidence:

```json
{"type":"pneumonia", "source":"chest_xray", "confidence":0.81}
```

Becomes:

```prolog
xray_finding(pneumonia, patient_123, t456, p=0.81).
```

**Control Layer**: Orchestrates everything — goal management, planning under constraints, execution, and explanation generation.

## When Rules and ML Disagree

This is the crux of hybrid systems. Three patterns work:

**Thresholding**: Simple but brittle. Promote to hard fact if confidence exceeds threshold.

**Weighted Logic**: Use Markov Logic Networks. Inference optimises agreement with weighted constraints.

**Two-Tier Logic**: Best for safety. Hard constraints never violated. Soft preferences guide choices among safe options.

```prolog
% Hard safety rule (always enforced)
contraindicated(Treatment, Patient) :-
    severe_allergy(Patient, Component),
    contains(Treatment, Component).

% Soft preference (guides selection)
prefer(Treatment1, Treatment2, Patient) :-
    \+ contraindicated(Treatment1, Patient),
    efficacy(Treatment1, Patient, E1),
    efficacy(Treatment2, Patient, E2),
    E1 > E2.
```

## The Minimal Stack

Don't overcomplicate:
1. **Reasoner**: Soufflé (Datalog) or SWI-Prolog
2. **Probabilistic layer**: ProbLog or custom thresholds
3. **Bridge service**: Simple HTTP/gRPC microservice
4. **Explainer**: Template-based natural language generation

## Versioning and Trust

Every decision records model version, rule version, and schema version. Run shadow evaluations before promoting changes. Monitor calibration drift and proof completeness.

Hybrid declarative systems aren't academic curiosities. They're running in production, making critical decisions that require both learning and reasoning. Start simple with the minimal stack, then evolve based on your constraints.

**Proof trees give structure, ML gives adaptability.** Together, they create systems that learn, reason, and explain — exactly what we need for trustworthy AI.
