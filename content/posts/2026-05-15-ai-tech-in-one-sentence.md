---
title: "AI Tech in One Sentence"
date: 2026-05-15
lastmod: 2026-05-15
draft: false
author: "Tolic Kukul"
description: "Fifteen core AI concepts — from machine learning to agentic AI — each defined in a single sentence, ordered to build on each other into a mental model."
tags: ["ai", "llms", "machine-learning", "ai-agents", "software-development"]
categories: ["AI"]
illustration: "worker-figures stack labeled blocks into a tall tower while a robot hands up the next piece, gears turning at the base."
---

> If you can't explain it simply, you don't understand it.
> — commonly attributed to Albert Einstein

The AI field has accumulated a fog of acronyms. Most explanations either bury the reader in jargon or hand-wave the concept into uselessness. Below is an attempt at the discipline of one sentence per concept — enough precision to hold the actual idea in your head, no more.

The order builds: the field, the hardware that enabled it, the process that produces models, the representations they learn, the models themselves, how we use them, and how we extend them.

## 1. AI

AI is the broad effort to make machines perform tasks (perception, reasoning, language, decision-making) that we once assumed required human intelligence.

## 2. ML

Machine learning is the subset of AI where systems learn patterns from examples rather than being explicitly programmed with rules.

## 3. GPU/TPU

GPUs and Google's TPUs are chips optimised for parallel math; modern AI exists because they make the matrix multiplications behind neural networks fast enough to be practical at scale.

## 4. Training

Training is the process where a model learns by adjusting billions of internal weights to minimise the gap between its predictions and the right answers across enormous datasets — the heavy, expensive computation that produces the model in the first place.

## 5. Inference

Inference is what happens every time you actually use a trained model — running input through its fixed weights to produce an output, cheap per call but huge in aggregate, which is why it dominates the cost of serving AI at scale.

## 6. Embeddings

Embeddings are vectors that represent text or other data as points in a high-dimensional space, positioned so semantically similar things end up close together — making meaning something you can measure with distance.

## 7. LLM

An LLM is a neural network trained on massive amounts of text to predict the next token, which at sufficient scale produces fluent language and surprising reasoning.

## 8. GPT

GPT names a specific architecture (Generative Pre-trained Transformer) that OpenAI used for its models, though the acronym has become a generic stand-in for any modern LLM.

## 9. Context

Context is everything the model can see when generating its next response (system prompt, conversation history, retrieved documents, tool results), all packed into a finite window it attends to as one.

## 10. Context engineering

Context engineering is the discipline of deciding what to put in the model's context window and how to structure it, increasingly replacing "prompt engineering" as the more accurate name for getting useful outputs from LLMs.

## 11. Chain of thought

Chain of thought is the technique (first a prompting trick, now also a training pattern) where the model reasons step by step before answering, which dramatically improves performance on complex problems.

## 12. Fine-tuning

Fine-tuning takes a pre-trained model and continues training it on a smaller, specialised dataset, adapting its behaviour to a specific domain or task without starting from scratch.

## 13. RAG

RAG is the pattern of retrieving relevant documents at query time and feeding them into the LLM's prompt, so its answers can draw on specific or up-to-date information beyond its training data.

## 14. MCP

MCP is an open protocol for connecting AI applications to external tools and data sources through a standard interface, so every integration doesn't have to be rebuilt from scratch.

## 15. Agentic AI

Agentic AI is an LLM in a loop where its outputs can act on the world via tools, and the results of those actions feed back into its next decision.

---

Read top to bottom, the list adds up to a conceptual machine. Once you have a model (trained from data, run via inference), shaped representations (embeddings), a way to feed it the right context, and tools it can use in a loop — you have an agent. Everything else is engineering.

For the lineage of that last idea — where the agentic loop actually came from — see [Agentic AI Was Invented in Melbourne](/posts/2026-05-22-agentic-ai-was-invented-in-melbourne/).
