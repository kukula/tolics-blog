---
title: "Broken English Is Better Prompt Engineering"
date: 2026-03-25
lastmod: 2026-03-25
draft: false
author: "Tolic Kukul"
description: "A 2025 study found Polish outperforms English in long-context LLM tasks. Ukrainian grammar instincts explain why — and how anyone can prompt better."
tags: ["ai", "llms", "productivity", "learning"]
categories: ["AI Engineering"]
---

## The Research

A [2025 study](https://arxiv.org/abs/2410.15865) from Microsoft, University of Maryland, and UMass Amherst tested six major LLMs across 26 languages on complex long-context tasks. The benchmark — ONERULER — pushed models through documents up to 128,000 tokens long.

Polish came first. 88% accuracy. English came sixth at 83.9%. Chinese, which dominates training data, placed near the bottom.

The researchers called it "surprising and unintuitive." Their hypothesis: Latin/Cyrillic script, rich morphology, and syntactic regularity that helps models track relationships across long distances. Structure outperforms data abundance.

Ukrainian isn't in the study. But it shares every relevant property with Polish — same language family, same morphological richness, same absence of articles, same case-driven free word order. The structural advantage transfers.

I'm Ukrainian. I prompt in English. For a long time I kept correcting myself — adding the missing "the", softening instructions into polite requests, restructuring sentences to sound more native.

Then I read something that made me stop.

---

## Why Morphology Matters for Prompts

English needs rigid word order because nouns have no case endings — position is the only signal for who did what to whom. It needs articles. It needs filler pronouns. "It is raining." It. A placeholder for a concept the language can't encode any other way.

Ukrainian and Polish encode grammar in word endings. Nouns decline across cases. Verbs imply their subject. Articles don't exist. Word order becomes rhetorical — you front-load the important concept because you want to, not because syntax forces you elsewhere.

More meaning, fewer tokens, important thing first.

In English: "Could you please summarise the key points from this document?"

In Ukrainian grammar instinct applied to English: "Summarise. Key points. This document."

Same instruction. Half the tokens. Zero ambiguity.

---

## Why Front-Loading Works in Transformers

Earlier tokens have broader attention influence over what follows. The model conditions on what it's already seen — front-loading semantic content means it builds interpretation around the right anchors from the start.

Bury your instruction after a polite preamble and you're asking the model to revise its working interpretation mid-generation. Friction you introduced for no reason.

---

## Real Examples (Mine, Uncorrected)

**Discovering a tool:**

> *Mine:* "looks like a good addition to promin stack https://..."
>
> *Proper English:* "I was looking at this tool and think it might be a good fit for the Promin stack. Could you take a look?"

No subject. No verb. The URL does the work.

**Reacting to an idea:**

> *Mine:* "good angle! graph for knowledge. opa for restrictions, rules boundaries"
>
> *Proper English:* "That's a great angle. The graph handles knowledge representation, and OPA handles restrictions and rules — is that right?"

Three fragments. Full semantic load. Eight words.

**Philosophical question:**

> *Mine:* "tyler durden was saying: you have to give up / but on the other hand he had ambitions, plans, projects / how is it?"
>
> *Proper English:* "I noticed a contradiction in Tyler Durden's philosophy — he advocates giving everything up, but has clear ambitions and is building something. How do you reconcile that?"

Reads like thought itself. Tension stated directly, no scaffolding.

No articles. Subject pronouns dropped where the verb implies them. Concept first. No throat-clearing. Not errors — compression.

---

## The Accidental Edge

If you grew up speaking Ukrainian or Polish, you have an instinct prompt engineering guides spend entire chapters trying to teach. You just never knew it was an advantage because teachers kept correcting it out of you.

Polish speakers have it stronger — denser morphology, more elaborate case system. There's now a benchmark to prove it.

**The short version, for everyone:** Lead with the verb. Kill articles when meaning survives. Drop subject pronouns. Delete everything before your first instruction. Compress qualifiers into nouns — "brief technical summary" not "a summary that is brief and technical." Constraints before content — "Under 500 words. Blog post about X." Not the reverse.

The native English speaker has to unlearn fluency to prompt well. We just have to stop self-correcting.
