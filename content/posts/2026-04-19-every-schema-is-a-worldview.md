---
title: "Every Schema Is a Worldview"
date: 2026-04-19
lastmod: 2026-04-19
draft: false
author: "Tolic Kukul"
description: "SUMO tried to encode all of reality into first-order logic. Its directory listing is a philosophical argument most AI engineers have never encountered."
tags: ["ai", "llms", "software-architecture", "philosophy", "abstractions"]
categories: ["AI Engineering"]
illustration: "a lone archivist figure files labeled boxes into a tall grid of shelves while a robot sorts more boxes off a conveyor belt."
---

**The ambition: write down how the world works in a form a machine can reason over.**

That's the thing that hooked me this week. Not a new paper, not a launch — just the idea that at some point in the last forty years, some people took it literally enough to actually try. To sit down and type out, in formal logic, what a country is, what an emotion is, what weather does.

The most famous attempt is [Cyc](https://en.wikipedia.org/wiki/Cyc), Doug Lenat's forty-year project — mostly commercial, mostly closed. The more legible cousin is [SUMO: the Suggested Upper Merged Ontology](https://github.com/ontologyportal/sumo), and you can clone it tonight. Its filenames are a ledger of what someone decided reality consists of: `Anatomy.kif`, `ArabicCulture.kif`, `Cars.kif`, `Dining.kif`, `Economy.kif`, `emotion.kif`, `Facebook.kif`, `Government.kif`, `Hotel.kif`, `Justice.kif`, `Military.kif`, `Trees.kif`, `VirusProteinAndCellPart.kif`, `Weather.kif`, `WMD.kif`, etc.

About seventy files, nearly a quarter-century of commits, mostly one person — Adam Pease — and a handful of collaborators. Written in KIF, a Lisp-flavoured syntax from the early nineties. One of the most serious public attempts ever made to hand-encode reality into first-order logic.

I opened `Economy.kif` expecting dry maths. I found [6,922 lines](https://github.com/ontologyportal/sumo/blob/master/Economy.kif) declaring what the world's economies are:

```lisp
(instance DevelopedCountry UNEconomicDevelopmentLevel)
(formerName "First World" DevelopedCountry)
(economyType Australia DevelopedCountry)
(economyType SouthAfrica LessDevelopedCountry)
```

This is not a maths file. This is a knowledge corpus in S-expressions.

A genre I didn't know existed: formal ontology as philosophical claim, written in enough parentheses that you forget you're reading an argument.

## The lineage

Cyc has the bigger legend but also the bigger paywall. Lenat died in August 2023 still believing symbolic knowledge engineering was the missing piece of AI. [Gary Marcus's tribute](https://garymarcus.substack.com/p/doug-lenat-1950-2023) and [Stephen Wolfram's longer reflection](https://writings.stephenwolfram.com/2023/09/remembering-doug-lenat-1950-2023-and-his-quest-to-capture-the-world-with-logic/) are the way into the human story.

The technical lineage runs KIF → Ontolingua → OIL → [OWL](https://www.w3.org/OWL/) → SHACL. Each generation sanded down the rigour to widen adoption. We ended up at schema.org JSON-LD sprinkled on product pages. The literal version of the ambition — the one where you *really* try to write the whole world down — peaked with Cyc and SUMO, and then quietly got replaced with whatever developers would actually put up with.

Most AI engineers under thirty have never heard of any of this.

## Borges got there first

In a 1942 essay, the Argentine writer Jorge Luis Borges invented a fictional Chinese encyclopedia — the *Celestial Emporium of Benevolent Knowledge* — which divided animals into "those that belong to the emperor," "embalmed ones," "those that tremble as if they were mad," "those drawn with a very fine camel's-hair brush," "those that from a long way off look like flies." Michel Foucault borrowed the list to open *The Order of Things* and make one point: every taxonomy is a worldview. What feels natural is only natural inside the system that produced it.

SUMO is a Celestial Emporium with a build pipeline. The repo directory **is** the list of categories. Each `.kif` file is an argument about where its domain ends and another begins — and the arguments are surprisingly specific.

Military is split into four files: `Military.kif`, `MilitaryDevices.kif`, `MilitaryPersons.kif`, `MilitaryProcesses.kif`. Emotion fits in one, and the filename isn't even capitalised — `emotion.kif` — as though someone added it in an afternoon and never came back. That contrast is a theory about human life, even if nobody sat down to write it as one.

`ArabicCulture.kif` is a standalone domain. No other culture is. There is no `JapaneseCulture.kif`, no `MexicanCulture.kif`, no `YorubaCulture.kif`. One guess which government funded that addition and when.

`Cars.kif`, `Hotel.kif`, `HouseholdAppliances.kif` — late-twentieth-century suburban American life, promoted to ontological primitives. `Dining.kif` is separate from `Food.kif`, because eating in a restaurant and eating in general are different enough kinds of activity to deserve their own axioms.

`Facebook.kif` exists. One company, frozen in amber at the moment it felt permanent enough to warrant formal logic. No `Twitter.kif`. No `TikTok.kif`. The repo records which platforms looked eternal in which years.

`WMD.kif` is a claim that weapons of mass destruction are a coherent ontological category rather than a political designation applied after the fact. `WeatherStatecraft.kif` sitting next to `Weather.kif` hints at the funding model: the same repo that models rainfall also models rainfall-as-geopolitics. `NavalModeling.kif` exists; there is no `ArmyModeling.kif`. The grant history is legible in the file tree.

Inside `Economy.kif` the specificity gets denser. Three tiers of nation preserved with `(formerName "First World" DevelopedCountry)` as though First World were an older label for an eternal category. A parallel IMF hierarchy axiomatised alongside the UN's, because the two disagree about the Asian Tigers and the ontology won't choose. CapitalistEconomy and SocialistEconomy as mutually exclusive attributes with MixedEconomy as their reconciliation — a political philosophy dressed as a type system.

You can agree with every framing and still notice that they *are* framings. SUMO made its cuts around 2001, cited the CIA World Factbook, and has been propagating those cuts downstream ever since.

The formal logic is the boring part. The curated choice of *what to formalise* is where the philosophy lives.

## What this has to do with LLMs

Lenat's last paper — posted to arXiv on July 31, 2023, a month before he died, with Gary Marcus — is [*Getting from Generative AI to Trustworthy AI: What LLMs might learn from Cyc*](https://arxiv.org/abs/2308.04445). The argument, stripped down: LLMs have absorbed a vast implicit ontology from their training corpus, and nobody can inspect it, audit it, or patch it.

SUMO is legible. Every axiom is a sentence someone wrote and defended. Model weights aren't.

When an LLM confidently tells you South Africa is a developing economy, or that the Asian Tigers are emerging markets, it's drawing on an implicit worldview absorbed from billions of tokens, with no `(formerName ...)` annotation to say which decade the classification comes from. **SUMO is a time capsule that labels itself. GPT is a time capsule that pretends to be the present.**

The symbolic-AI winter was partly a rejection of the premise that you *could* write the world down. The neural thaw was built on the premise that you don't need to — the world writes itself down, statistically. As models get deployed into decisions that matter, *whose ontology is the model using?* starts mattering again. There are essentially no tools for answering it, because the industry moved on from exactly those tools.

## The legibility we lost

The Semantic Web was going to make all human knowledge machine-readable. OWL, RDF, ontology design — a generation of researchers studied it, funded it, believed in it. The industry chose statistical patterns over hand-authored logic and never looked back.

Finding SUMO twenty years later feels like opening a time capsule from a parallel timeline where that bet paid off. The code is still there, still maintained, still making philosophical claims in parentheses — while the rest of us moved on to systems that make the same claims invisibly. Every schema is an argument. SUMO had the honesty to write it in a format where you can read the argument back. The models that replaced it absorbed the same arguments and buried them in weights no one can inspect.
