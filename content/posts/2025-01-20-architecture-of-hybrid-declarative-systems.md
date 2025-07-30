---
title: "Building Hybrid Declarative Systems: A Practical Architecture Guide"
date: 2025-01-20
lastmod: 2025-01-20
draft: false
author: "Tolic Kukul"
description: "Learn how to architect hybrid declarative systems that combine symbolic reasoning with machine learning for trustworthy, explainable AI."
tags: ["hybrid-systems", "declarative-programming", "software-architecture", "ai", "proof-systems", "machine-learning"]
categories: ["Software Architecture"]
series: ["Declarative Systems"]
---

Yesterday I explored how proof trees and machine learning can work together. Today, let's get practical: how do you actually build these hybrid declarative systems?

Back in 2012, I built a proof of concept for medical software that tracked drug interactions, advised on dosage, and provided decision support that human doctors could review. It was a glimpse into what's now becoming mainstream. Here's how I'd build it now.

## The Four-Layer Architecture

Think of a hybrid declarative system like a brain with specialized regions that collaborate:

## Knowledge Layer: Your Symbolic Foundation

This is where your hard truths live. The facts, rules, and constraints that must always hold.

```prolog
% Schema (types)
type(patient).
type(condition(pneumonia)).
type(medication(antibiotic)).
type(contraindication(allergy)).

% Facts (time-stamped)
xray_finding(pneumonia, patient_123, t456, p=0.81).
allergy(penicillin, patient_123, confirmed).
vital_signs(fever, patient_123, t456, temp=101.5).

% Hard rules
contraindicated(Med, Patient) :- allergy(Med, Patient, confirmed).
requires_treatment(Condition, Patient) :- condition_confirmed(Condition, Patient).

% Decision rules
recommend(antibiotic, Patient) :- 
    xray_finding(pneumonia, Patient, _, P), P >= 0.7,
    \+ contraindicated(antibiotic, Patient).
```

**Components:**
- **Schema**: Define your types, relations, and constraints upfront
- **Facts**: Ground truths, often time-stamped for temporal reasoning
- **Rules**: Stratify into hard (safety) vs soft (preferences)
- **Reasoner**: Proof search (Prolog-style) or materialization (Datalog-style)
- **Explainer**: Generates proof trees and justification graphs

## Learning Layer: Your Statistical Engine

This handles the messy, uncertain real world that symbolic logic struggles with.

**Components:**
- **Perception models**: Medical imaging analysis, clinical note NLP, lab result interpretation
- **Scoring models**: Risk stratification, treatment response prediction, diagnostic confidence
- **Uncertainty quantification**: Calibrated confidences for clinical decisions, not just raw logits

The key is calibration. Raw neural network outputs are often overconfident. Apply temperature scaling or conformal prediction to get honest probabilities.

## Integration Layer: The Critical Bridge

This is where most systems fail. You need a robust bridge between symbols and statistics.

```json
{
  "patient_id": "patient_123",
  "timestamp": "t456",
  "findings": [
    {"type":"pneumonia", "source":"chest_xray", "confidence":0.81},
    {"type":"fever", "value":101.5, "confidence":0.95}
  ],
  "history": {
    "allergies": ["penicillin"],
    "conditions": ["hypertension"]
  }
}
```

Becomes:

```prolog
xray_finding(pneumonia, patient_123, t456, p=0.81).
vital_signs(fever, patient_123, t456, temp=101.5).
allergy(penicillin, patient_123, confirmed).
history(hypertension, patient_123).
```

**Components:**
- **Symbolizer**: Maps ML outputs to predicates with confidence
- **Probabilistic glue**: Attaches weights to facts/rules
- **Conflict resolver**: When rules and ML disagree, who wins?

## Control Layer: Decision and Action

This orchestrates everything and makes actual decisions.

**Components:**
- **Goal manager**: What are we trying to achieve?
- **Planner**: Search the policy space under constraints
- **Executor**: Issue commands, handle rollbacks
- **Explanation API**: Generate human-readable explanations

## Handling Uncertainty: Three Patterns

### Pattern 1: Thresholding (Simple but Brittle)
```prolog
% Promote to hard fact if confidence >= 0.7
fact(X) :- probabilistic_fact(X, P), P >= 0.7.
```

Fast and simple, but arbitrary thresholds create brittleness.

### Pattern 2: Weighted Logic (More Robust)
Use Markov Logic Networks or Probabilistic Soft Logic. Inference optimizes agreement with weighted constraints.

```
0.9: pneumonia_detected(P,T) => recommend_antibiotic(P,T)
0.8: allergy_risk(P,Med) => avoid_medication(P,Med)
0.4: mild_symptoms(P,T) => consider_watchful_waiting(P,T)
```

### Pattern 3: Two-Tier Logic (Best for Safety)
- **Hard tier**: Safety constraints that must never be violated
- **Soft tier**: Preferences that guide choices among safe options

```prolog
% Hard safety rule
contraindicated(Treatment, Patient) :- 
    severe_allergy(Patient, Component),
    contains(Treatment, Component).

% Soft preference
prefer(Treatment1, Treatment2, Patient) :- 
    \+ contraindicated(Treatment1, Patient), 
    \+ contraindicated(Treatment2, Patient),
    efficacy(Treatment1, Patient, E1),
    efficacy(Treatment2, Patient, E2),
    E1 > E2.
```

## When Rules and ML Disagree

This is the crux of hybrid systems. You need clear policies:

### Safety First
```
if hard_rule_fires():
    follow_rule()  # Even if ML is uncertain
```

### Model Override (With Audit)
```python
if imaging_confidence > 0.95 and guidelines_outdated():
    flag_for_physician_review()
    log_clinical_override(reason, evidence)
    escalate_to_attending()
```

### Utility-Based Resolution
```
utility = task_reward - risk_penalty - uncertainty_penalty
action = argmax(utility) over safe_candidates
```

## The Minimal Starter Stack

Don't overcomplicate. Start with:

1. **Reasoner**: Soufflé (Datalog) or SWI-Prolog
2. **Probabilistic layer**: ProbLog or custom thresholds
3. **Bridge service**: Simple HTTP/gRPC microservice
4. **Planner**: Rule-based initially, upgrade to MDP later
5. **Explainer**: Template-based natural language generation

## End-to-End Flow Example

Let's trace a clinical decision through the system:

1. **Perception**: X-ray analysis detects pneumonia (81% conf), NLP extracts fever from notes (95% conf)
2. **Bridge**: Converts clinical findings to time-stamped predicates
3. **Reasoner**: Derives `pneumonia_likely()` and `treatment_indicated()`, both suggest `antibiotic_therapy()`
4. **Planner**: Checks contraindications, selects appropriate antibiotic and dosage
5. **Executor**: Generates treatment recommendation with safety checks
6. **Explainer**: "Antibiotic recommended: X-ray suggests pneumonia (81% confidence), no contraindications found, follows clinical guidelines."

If the patient's allergy profile updates, the system recomputes. The pneumonia finding remains, but antibiotic selection changes to avoid contraindicated medications.

## Common Pitfalls and Fixes

### Symbol Explosion
**Problem**: Too many noisy predicates overwhelm the reasoner.
**Fix**: Add schemas, namespaces, and minimum confidence filters.

### Uncalibrated Probabilities
**Problem**: Neural networks are overconfident.
**Fix**: Apply temperature scaling or conformal prediction. Monitor calibration drift.

### Rule Brittleness
**Problem**: Binary rules fail at edge cases.
**Fix**: Encode ranges and tolerances. Add soft preferences.

### Opaque Overrides
**Problem**: System bypasses rules without explanation.
**Fix**: Require signed policies and audit trails for every override.

## Lifecycle and Operations

### Version Everything
Every decision should record:
- Model version hash
- Rule version hash
- Schema version hash
- Bridge configuration hash

### Shadow Evaluation
Run new models/rules in parallel before promotion:
```python
decision_old = current_system.decide(input)
decision_new = shadow_system.decide(input)
if decision_old != decision_new:
    log_divergence(input, decision_old, decision_new)
```

### Counterfactual Testing
Generate synthetic scenarios to stress-test:
- What if the pneumonia confidence was 55%?
- What if treatment guidelines conflict with patient allergies?
- What if all diagnostic systems produce uncertain results?

### Trust Telemetry
Monitor:
- Percentage of decisions with complete proof trees
- Average proof depth
- Calibration error over time
- Frequency of rule overrides

## Your Quick-Start Template

When designing a hybrid system, fill this out:

1. **Goal**: What's the top-level objective?
2. **Hard rules**: Safety/regulatory invariants
3. **Soft rules**: Preferences with weights
4. **Evidence sources**: Diagnostic tools and their reliability
5. **Decision space**: Possible actions
6. **Explanation needs**: Who needs what level of detail?

## The Path Forward

Hybrid declarative systems aren't just academic curiosities anymore. They're running in production, making critical decisions that require both learning and reasoning.

The architecture I've outlined handles the messiness of the real world while maintaining the explainability we need for trust and compliance. Start simple with the minimal stack, then evolve based on your specific constraints.

Remember: **proof trees give structure, ML gives adaptability**. Together, they create systems that can learn, reason, and explain — exactly what we need for trustworthy AI.
