---
title: "A CRM That Knows What It Doesn't Know"
date: 2026-02-09
lastmod: 2026-02-09
draft: false
author: "Tolic Kukul"
description: "Probabilistic lead scoring with Pyro replaces brittle point systems with honest uncertainty, email fatigue modelling, and self-improving predictions."
tags: ["ai", "declarative-programming", "software-architecture", "llms", "hybrid-systems"]
categories: ["AI and Development"]
series: ["AI-Native Programming"]
---

In the previous post we explored what a programming language designed for AI might look like and hit three walls — the training data problem, the interpreter problem, and the bootstrapping paradox. We ended with probabilistic programming as the practical bridge. This post takes that bridge and walks across it into something you can build today.

## From Fantasy Snippet to Real Software

Remember the `solve` block from the previous post?

```
⊕ solve {
    search_space: graph(Σ.map) | prune(P(viable) < 0.3)
    strategy: pareto_front(constraints) → select(
      preference: [safety, time, energy]
    )
    uncertainty: propagate(bayesian, Σ.noise_model)
}
```

That snippet was dense, elegant, and completely impractical — it needed an interpreter that doesn't exist yet. But the *ideas* embedded in it are real: variables as beliefs, constraints as first-class citizens, uncertainty propagated through every decision.

So let's apply those same ideas to something boring and useful. A CRM.

## The Problem With Lead Scoring Today

Every CRM has lead scoring and almost every implementation is the same: opened an email, +5 points. Visited the pricing page, +10. Downloaded a whitepaper, +15. Add it up, call it a "Hot Lead," hand it to sales. The sales team ignores these scores within a week.

The fundamental issue is the same one we identified previously — traditional software pretends certainty exists where it doesn't. A lead score of 73 tells you nothing about whether the system is confident or guessing. It's a deterministic answer to a probabilistic question.

What if we applied the AI-native language's core principle — *variables hold beliefs, not values* — using tools that exist right now?

## A Probabilistic Lead Scoring Model

Using Pyro, the lead scoring model stops being a point system and becomes a generative model of how leads actually behave:

```python
import pyro
import pyro.distributions as dist

def lead_scoring_model(lead_data, converted=None):
    # Purchase intent is latent — we can't observe it directly
    # but we can infer it from behaviour
    intent = pyro.sample(
        "purchase_intent",
        dist.Beta(2, 5)  # prior: most leads aren't ready to buy
    )

    # Time on pricing page is a signal of intent
    # Higher intent → longer time spent
    page_time = lead_data.time_on_pricing
    pyro.sample(
        "pricing_visit",
        dist.Normal(intent * 120, 30),
        obs=page_time
    )

    # Email engagement, but accounting for outreach fatigue
    emails_sent = lead_data.emails_sent
    email_fatigue = pyro.sample(
        "fatigue",
        dist.Beta(emails_sent, 10)
    )
    effective_intent = intent * (1 - email_fatigue * 0.5)

    # Company fit as a separate belief
    fit = pyro.sample(
        "company_fit",
        dist.Beta(lead_data.fit_signals,
                  lead_data.fit_misses + 1)
    )

    # Conversion probability combines intent and fit
    conversion_prob = effective_intent * 0.6 + fit * 0.4

    if converted is not None:
        pyro.sample("converted",
            dist.Bernoulli(conversion_prob),
            obs=converted)

    return conversion_prob, intent, email_fatigue
```

Compare this to the fantasy snippet. The structure is remarkably similar — we have latent variables (like `Σ` in the AI-native language), constraints that condition the model, and uncertainty propagating through every computation. The difference is that this actually runs. Today. On your laptop.

## What You Get That Traditional CRM Can't Do

**Honest uncertainty.** Instead of "this lead scores 73," you get "conversion probability is centred around 70%, but could reasonably be anywhere between 40% and 90%." A lead at 70% with tight confidence is ready for a call. A lead at 70% with massive uncertainty needs more data. That distinction is invisible in traditional scoring.

**Email fatigue modelling.** The `email_fatigue` variable captures diminishing returns on outreach, personalised per contact. The model tells you when to stop emailing before you burn the lead. No one-size-fits-all cadence.

**Pipeline forecasting with integrity.** Aggregate the distributions across your pipeline and instead of "$500K expected this quarter," you get "60% chance of hitting $400K, 30% chance of $500K, 10% chance of $600K." Finance can plan around honest uncertainty rather than a single number everyone knows is wrong.

**Self-improving predictions.** Every closed-won or closed-lost deal updates the model's priors. This is the `learn` block from the previous post — except instead of a fantasy self-modification primitive, it's just Bayesian updating. The posterior from today's inference becomes tomorrow's prior. No quarterly recalibration meetings. The model adapts continuously.

## The Architecture

You don't replace your CRM. The probabilistic engine lives alongside it:

```
CRM (HubSpot / Salesforce / custom)
    ↓ webhooks on lead activity
Probabilistic scoring service (FastAPI + NumPyro)
    ↓ inference on new signals
Results back as custom fields:
  - conversion_probability: 0.72
  - confidence: "low" (wide distribution)
  - top_signal: "pricing_page_engagement"
  - recommended_action: "needs more data"
  - email_fatigue_risk: "high"
```

The CRM pushes events — page visits, email opens, form submissions — to the scoring service via webhooks. The service runs inference, updates beliefs for that lead, and writes enriched fields back. Sales reps see richer signals without changing their workflow.

NumPyro on JAX makes the inference fast enough for near-real-time scoring. For a typical B2B pipeline of a few thousand active leads, you can recompute scores in seconds on modest hardware.

## Connecting Back to the Bigger Picture

In the previous post we imagined a language where every variable is a distribution, every program is a goal declaration, and the runtime infers execution paths rather than following instructions. That language needs an interpreter that doesn't exist yet.

But look at what we just built. The Pyro model *is* a goal declaration — "given these observations, infer purchase intent." The inference engine *is* the runtime — it explores possible execution paths weighted by probability. The `learn` block *is* Bayesian updating.

We didn't need the fantasy language. We needed its ideas, expressed in tools that already exist.

The AI-native language is probably years away. But its core principles — uncertainty as a first-class citizen, inference over execution, beliefs over values — are available right now. And they make real software meaningfully better.
