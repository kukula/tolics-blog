# Cubo-Futurism Cover — Drafting Guide

## Setup: the Gemini API key

Cover generation calls Google's Gemini image API and needs `GEMINI_API_KEY`.

1. Go to **Google AI Studio → <https://aistudio.google.com/apikey>** (sign in
   with a Google account), click **Create API key**, and copy it.
2. Put it in a gitignored `env` file at the repo root (already ignored):

   ```sh
   GEMINI_API_KEY=your-key-here
   ```

   `scripts/generate_illustrations.sh` auto-loads this file. Point elsewhere with
   `ENV_FILE=/path/to/env`, or just export `GEMINI_API_KEY` in your shell instead.
3. Image generation is billed per image (~$0.039 on `gemini-2.5-flash-image`);
   enable billing on the key's Google Cloud project if you hit free-tier limits.
   Keep the key secret — never commit `env`.

---

This guide governs the `illustration:` prompt written into each post's front
matter. The **style** (palette, faceting, "no text") is fixed once in
`scripts/generate_illustrations.sh` as `STYLE_PREAMBLE` and prepended to every
prompt. The `illustration:` value is therefore **only the SCENE** — concrete
subject, setting, and action. Do not repeat style words there.

Goal: ~70 covers that read as **one cohesive set**. Same world, same cast.

## The metaphor rule

Most posts are abstract (a tension, an idea, an argument). There is no literal
scene. So:

1. Find the post's **central tension or movement** in one phrase
   (e.g. *craft → automation*, *order vs. chaos*, *climbing an abstraction
   ladder*, *a rigid thing breaking under load*, *many parts becoming one
   system*).
2. Stage that tension **physically**, with figures and machines from the shared
   vocabulary below. One clear focal action. No screens, UI, code, or charts
   unless the post is literally about an editor/tool.
3. Write it as a short, plain, concrete scene — 1–2 sentences, lowercase,
   object/figure/action nouns. Model line:
   `happy workers relaxing in the park. robots help people. factory in the background.`

Avoid abstract nouns in the value ("complexity", "intent", "ambiguity"). Render
them as *things*: a tangled belt, a forking path, a fog over the factory floor.

## Shared motif vocabulary (reuse these — that's what unifies the set)

- **Figures:** angular faceted worker-figures; a lone architect/foreman figure;
  small human silhouettes for scale.
- **Machines:** gears, pistons, conveyor belts, looms, presses, cranes, pipes,
  turbines, scaffolding.
- **Structures:** ladders and staircases (abstraction/levels), bridges, grids,
  towers, factory halls, archways.
- **Nature accents** (for personal / reflective / spiritual posts): faceted
  trees, a sun disc, mountains, rivers, birds — same Cubo-Futurist faceting,
  not photographic.
- **Composition:** strong diagonals, intersecting planes, a single focal point.

## Recurring sub-themes → suggested staging (keep consistent across the set)

- **AI / agents / automation:** robot or machine figures working *alongside*
  human figures — collaboration, not replacement.
- **Abstraction / layers / "moving up the stack":** ladders, staircases,
  stacked platforms, a figure climbing.
- **Systems / graphs / models:** interlocking gears, pipe networks, a lattice of
  beams.
- **ADHD / focus / personal:** a single figure amid swirling fragmented planes;
  calm vs. storm.
- **Breaking / limits / risk:** a cracked beam, an overloaded conveyor, a tower
  leaning.

Keep generation a separate, explicit step (`scripts/generate_illustrations.sh`).
Drafting only writes the `illustration:` line.
