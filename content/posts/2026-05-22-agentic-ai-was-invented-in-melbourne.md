---
title: "Agentic AI Was Invented in Melbourne"
date: 2026-05-22
lastmod: 2026-05-22
draft: false
author: "Tolic Kukul"
description: "The agentic AI loop wasn't born in 2024. It was shipped from a Melbourne lab in 1991 — the BDI architecture — inspired by a Stanford philosopher's 1987 book."
tags: ["ai", "ai-agents", "software-architecture", "philosophy", "reflection", "adhd"]
categories: ["AI"]
---

Provocative claim. Bear with me.

The current agentic AI boom — [LLMs](/posts/2026-05-15-ai-tech-in-one-sentence/#7-llm) in loops, calling tools, reasoning about their next action — has an intellectual lineage. And the most load-bearing node in that lineage isn't in Silicon Valley. It's in Melbourne.

In 1991, two researchers at the **Australian Artificial Intelligence Institute** — Michael Georgeff and Anand Rao — published *Modeling Rational Agents within a BDI-Architecture*. BDI stands for Belief–Desire–Intention. It's the framework that gave AI a working theory of how a software agent could form goals, plan actions, and *commit* to them over time without throwing the plan out the moment something twitched.

Every modern LLM agent loop — every "thought / action / observation" cycle, every persistent task list, every agent that holds [context](/posts/2026-05-15-ai-tech-in-one-sentence/#9-context) across turns — sits downstream of this idea.

But here's the twist. Georgeff and Rao didn't invent the philosophy. They industrialised it.

The philosophy belongs to **Michael Bratman**, a Stanford philosopher who in 1987 published *Intention, Plans, and Practical Reason*. Bratman wasn't thinking about computers. He was thinking about humans — specifically, why we treat our intentions as commitments and not just predictions. Why "I'm going to write that blog post" is a different kind of mental state than "I predict I'll write that blog post."

His answer: intentions are filters. They constrain what you reconsider. Once you commit to a plan, you stop re-deliberating every five seconds. That's how rational agents act under bounded resources. It's also, not coincidentally, the only way anyone with ADHD ever ships anything.

Georgeff and Rao read this and saw an architecture. They turned a theory of human practical reason into a running system — PRS (Procedural Reasoning System), then dMARS, then the whole BDI tradition that quietly seeded how we now think about LLM agents.

There's a second thread worth naming. A year earlier, in 1986, **Rodney Brooks** at MIT had published *A Robust Layered Control System for a Mobile Robot* — the subsumption architecture. Brooks rejected planning entirely. His robots reacted to the world directly through layered behaviours: no model, no goals, just sensors wired to actuators. Reactive, fast, robust. The opposite of Bratman.

BDI is what happens when you sit those two camps in the same room and refuse to pick a side.

Three of the four threads in modern agentic AI — Brooks's reactive layer, Bratman's intentions, the Georgeff–Rao synthesis — happened decades before anyone called it "agentic AI." Only the LLM layer on top is new. And the keystone shipped from Melbourne, at a research institute most of the AI discourse on Twitter has never heard of.

Next time someone tells you the agentic AI revolution is a 2024 phenomenon, you can tell them it's actually 35 years old, and the original blueprint shipped from a Melbourne lab inspired by a philosopher who'd never written a line of code.

## The lesson, 35 years later

Hybrid wins. BDI was right all along.

Maintain an intention (deliberative anchor — what am I trying to do, what's the rough shape of the plan). Then act reactively within it (next step is driven by the last observation, not by a pre-baked script). When reality diverges enough, re-form the intention. That's it. That's the loop that works.

This is also why ReAct, Plan-and-Solve, Reflexion, and Claude's own [agentic loop](/posts/2026-05-15-ai-tech-in-one-sentence/#15-agentic-ai) all look roughly the same: light planning, tight reactive loop, occasional re-planning. Pure-reactive is too dumb. Pure-deliberative is too brittle. The middle is where everything ships.

## The four patterns in skeleton form

### ReAct ([Yao et al., 2022](https://arxiv.org/abs/2210.03629))

Interleave reasoning and action in one tight loop. The model writes a thought, picks a tool, sees the result, repeats.

```text
Tools: [search, calculator, ...]
Goal:  <user task>

Thought: I need to find X. I'll search.
Action: search("X")
Observation: <result>

Thought: Now I need to compute Y from this.
Action: calculator("...")
Observation: <result>

Thought: I have what I need.
Final Answer: <answer>
```

The whole "agent" is just a prompt that forces this `Thought / Action / Observation` rhythm, plus a runtime that parses `Action:` lines and runs them.

### Plan-and-Solve ([Wang et al., 2023](https://arxiv.org/abs/2305.04091))

Split the brain in two. One LLM plans. Another LLM (or the same one in a different role) executes. Optionally re-plan when reality diverges.

```text
PHASE 1 — Planner
  System: "Given the goal, produce a numbered list of steps."
  Goal: <user task>
  → Plan:
      1. Gather X
      2. Compute Y
      3. Draft Z

PHASE 2 — Executor (one call per step, ReAct-style with tools)
  For step N in plan:
      run step using tools
      append result to state

PHASE 3 — Replanner (only if a step fails or state surprises us)
  Given current state + remaining steps, revise the plan.
```

More deliberative than ReAct. Better for long horizons. Brittle if the planner is overconfident.

### Reflexion ([Shinn et al., 2023](https://arxiv.org/abs/2303.11366))

Add a self-critique loop. The agent tries, fails, *writes a lesson*, tries again with the lesson in its context. The lessons are the memory.

```text
lessons = []

repeat up to N times:

    ACTOR
      Task: <goal>
      Past lessons: <lessons>
      → produces trajectory + answer

    EVALUATOR
      Did this succeed? (binary or score)
      → if yes: stop

    REFLECTOR
      "Read the trajectory. Why did it fail?
       Write ONE short lesson for next time."
      → append to lessons
```

Cheap, powerful, surprisingly effective. The reflection is what turns a one-shot agent into something that learns *within a single task*.

### Claude's agentic loop (tool use)

The native pattern. No `Thought:` / `Action:` formatting trick — tool calls are first-class structured outputs. The model decides each turn whether to emit a final answer or a `tool_use` block. The harness runs the tool, returns a `tool_result`, and the loop continues.

```text
messages = [
  {role: "system",  content: "Tools: [...]. Goal: ..."},
  {role: "user",    content: "<task>"}
]

while True:
    response = claude(messages)

    if response has tool_use:
        result = run_tool(response.tool_use)
        messages.append(response)            # assistant turn
        messages.append({                    # tool result
            role: "user",
            content: [{type: "tool_result", content: result}]
        })
    else:
        return response.text                 # final answer
```

This is the cleanest of the four because the loop logic is in the harness, not in the prompt. The model just decides *what to do next*; the runtime handles *how*.

---

Four patterns, one shape. Intention up top, reaction in the loop, reflection or replanning when reality pushes back. Brooks supplied the reactive half. Bratman supplied the deliberative half. Georgeff and Rao stitched them together in Melbourne in 1991. Everything since has been refinement.
