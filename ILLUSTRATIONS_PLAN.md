# Blog Illustrations Pipeline — Plan

Add a per-post illustration to each blog post, generated with **Google "Nano Banana"** (Gemini 2.5 Flash Image) in a consistent **Cubo-Futurism** visual style.

## Decisions (locked)

- **Generator:** Google Nano Banana = `gemini-2.5-flash-image` via the Generative Language REST API (`curl` + `jq`, matching the repo's existing `scripts/*.sh` convention). Overridable via `GEMINI_IMAGE_MODEL` env var (e.g. Nano Banana Pro = `gemini-3-pro-image`).
- **Style:** Cubo-Futurism — shared style preamble prepended to every per-post prompt so all illustrations look like one set.
- **Prompt per post:** stored in each post's front matter as `illustration: "..."`. Lives next to the content, version-controlled.
- **Placement:** cover image at the **top of each post**, **3:2 landscape**, also reusable as the OG/social-share image.
- **Scope now:** wire up the full pipeline + theme, do the last post with the user-supplied prompt, then **auto-draft a Cubo-Futurism prompt for every other post** (~40) from its content for review before generating.

## Architecture

```
front matter: illustration: "<scene prompt>"
        │
        ▼
scripts/generate_illustrations.sh
  STYLE_PREAMBLE (Cubo-Futurism) + illustration  ──►  Nano Banana API
        │                                                   │
        │                                          base64 PNG (3:2, via imageConfig)
        ▼                                                   ▼
   skip if image exists (unless --force)        validate response → static/images/covers/<base-name>.png
        │
        ▼
theme single.html  ──►  renders cover by convention (ContentBaseName → /images/covers/<base-name>.png)
```

- **Image path by convention:** `static/images/covers/<content-base-name>.png`, where `<content-base-name>` is the post filename without extension (e.g. `2026-06-26-the-work-moved-up-the-stack`), exposed in the theme as `.File.ContentBaseName`. No extra front-matter wiring needed — the theme derives the path from the page and renders it only if the file exists. **The script and the theme MUST agree on this same key** (see note on slug vs. ContentBaseName below).
- **Alt text:** see accessibility note — default to decorative (`alt=""`) rather than duplicating the title.

---

## API: the corrected request shape (read this first)

The original plan's "POST … 3:2 aspect" was the single biggest latent bug. **Aspect ratio is not controlled by prompt text.** Gemini image models default to a 1:1 square at ~1024×1024 and ignore size hints written into the prose. Ratio is a structured field under `generationConfig.imageConfig.aspectRatio`.

**Endpoint**

```
POST https://generativelanguage.googleapis.com/v1beta/models/${GEMINI_IMAGE_MODEL}:generateContent
Header: x-goog-api-key: ${GEMINI_API_KEY}
Header: Content-Type: application/json
```

**Body**

```json
{
  "contents": [
    { "role": "user", "parts": [ { "text": "<STYLE_PREAMBLE + post illustration>" } ] }
  ],
  "generationConfig": {
    "responseModalities": ["IMAGE"],
    "imageConfig": { "aspectRatio": "3:2" }
  }
}
```

- `3:2` is one of the supported ratios for the GA `gemini-2.5-flash-image` model, so no compromise needed.
- **Response parsing — do not assume `parts[0]` is the image.** Filter for the part carrying `inlineData`, ignore any text part. This makes the `["IMAGE"]` vs `["TEXT","IMAGE"]` modality question a non-issue:

  ```bash
  jq -r '.candidates[0].content.parts[] | select(.inlineData) | .inlineData.data'
  ```

- **Pro override caveat:** `gemini-3-pro-image` (Nano Banana Pro) is the GA identifier (was `-preview`). `aspectRatio` is the same key, so the script stays compatible. Pro additionally accepts `imageConfig.imageSize` (`1K`/`2K`/`4K`, uppercase K) and costs more per image.

---

## Components to build

### 1. `scripts/generate_illustrations.sh`

- Iterate `content/posts/*.md` (skip `*.backup`).
- Read `illustration:` from front matter; skip posts without it.
- Skip if `static/images/covers/<base-name>.png` already exists, unless `--force`.
- Compose full prompt = `STYLE_PREAMBLE` + post's `illustration`.
- POST to `…/models/$GEMINI_IMAGE_MODEL:generateContent` with `x-goog-api-key: $GEMINI_API_KEY`, body per the corrected shape above (`responseModalities` + `imageConfig.aspectRatio: "3:2"`).
- **Validate before writing** (new — prevents corrupt-file storms on batch runs):
  - check HTTP status is 2xx;
  - assert `.candidates[0].content.parts[] | select(.inlineData)` exists;
  - check for a blocking `finishReason` (e.g. `IMAGE_SAFETY`, `PROHIBITED_CONTENT`, `RECITATION`) and report it per-post;
  - after decode, assert the file is non-zero and begins with the PNG magic bytes (`\x89PNG`);
  - on any failure: print the post slug + the API error/finishReason and continue (or exit non-zero with `--strict`), but **never** leave a partial/garbage PNG in place.
- Decode `inlineData.data` (base64) → save PNG to a temp path, validate, then move into place atomically.
- **Rate limiting:** small `sleep` between calls and a retry-with-backoff on HTTP 429.
- Flags:
  - `--force` — regenerate even if the file exists.
  - `--post <base-name>` — single post.
  - `--dry-run` — print the composed prompt only, no API call.
  - `--list` — show which posts have an `illustration:` but no cover yet (new, helps drive the rollout).
  - `--strict` — exit non-zero on the first failure (for CI-ish runs).
- Fails clearly if `GEMINI_API_KEY` is unset.

### 2. Cubo-Futurism style preamble (constant in the script; documented here)

Fragmented geometric planes, intersecting facets, dynamic diagonal motion, muted industrial palette with bold accents, mechanical + human forms interlocked, early-20th-century avant-garde poster feel. **No text, letters, numbers, or diagram labels in the image.** 3:2 landscape.

> **Caveat to verify, not assume:** Nano Banana's headline strength is legible in-image text, so "no text" fights the model's grain — especially on technical topics that pull it toward labels and diagrams. Keep the instruction, but confirm it holds on the most "diagrammy" posts during the validation pass (below) before trusting it across the batch.

### 3. Theme support — `themes/freerange/layouts/_default/single.html`

- Derive cover path from `.File.ContentBaseName`; render `<img class="post-cover">` above content **only if the file exists** (`os.FileExists`).
- Allow explicit `.Params.cover` override.
- **Cover is the LCP element** (above the fold): do **not** lazy-load it; set `fetchpriority="high"`, `decoding="async"`, and explicit `width`/`height` (e.g. 1200×800) to prevent layout shift.
- Minimal CSS (rounded corners, responsive width) in the theme stylesheet.
- **Accessibility:** the cover is decorative and sits next to the H1 title, so prefer `alt=""` over repeating the title (which is redundant for screen readers). If you want descriptive alt, derive it from the `illustration:` scene, not the title.

### 4. OG / social wiring — `head.html`

- **Absolute URL required** — social crawlers reject relative `og:image`:
  ```go-html-template
  {{ with .File }}{{ $cover := printf "/images/covers/%s.png" .ContentBaseName }}
    {{ if (fileExists (printf "static%s" $cover)) }}
      <meta property="og:image" content="{{ $cover | absURL }}">
      <meta property="og:image:width" content="1200">
      <meta property="og:image:height" content="800">
      <meta name="twitter:card" content="summary_large_image">
    {{ end }}
  {{ end }}
  ```
  (Adjust the existence check to whatever helper the theme uses; the key points are `absURL`, explicit width/height, and `summary_large_image`.)
- Falls back to the site-wide default OG image when no cover exists.

### 5. Image format / weight decision (decide deliberately)

The API returns **PNG**. Forty page-top PNG photos is a real weight hit, and `static/` files are **not** processed by Hugo (no auto-WebP, no `srcset`). Two clean options — pick one rather than defaulting:

- **A — keep it simple (static/):** accept PNG, run a one-off `oxipng`/`pngquant` or convert to WebP in the script after generation. Smallest theme change.
- **B — use Hugo image processing (assets/):** put covers under `assets/images/covers/` and use `resources.Get` + `.Process`/`.Resize` to emit responsive WebP `srcset`. More theme code, materially better LCP/page weight.

For a personal blog either is fine; B pays off if cover weight shows up in Core Web Vitals.

### 6. Last post wired end-to-end

- Add to `content/posts/2026-06-26-the-work-moved-up-the-stack.md`:
  `illustration: "happy workers relaxing in the park. robots help people. factory in the background."`
- Generate `static/images/covers/2026-06-26-the-work-moved-up-the-stack.png`.
- Use this as the **validation post** for the style preamble before any batch run.

### 7. Auto-drafted prompts for all other posts (its own mini-project)

This is the hardest 80% of the work and the main quality bottleneck — treat it as a scoped sub-project, not a single pipeline step.

- **Metaphor strategy first.** Abstract topics (e.g. "ECS task definition hits the 65,536-byte limit") have no literal scene. Define one rule for translating a post's core tension into a concrete industrial/human Cubo-Futurist scene, plus a small fixed vocabulary of recurring motifs (figures, machines, planes, palette accents) so 40 covers read as one set.
- **Draft, then review in small batches.** Write the drafted one-liner into each post's `illustration:` front matter; review in groups before generating.
- **Validate cheaply before scaling.** At ~$0.039/image, generate 2–3 test covers, tune the preamble + metaphor rule, *then* batch. Iteration is the whole advantage.
- Generation remains a separate, explicit run from drafting.

---

## Prerequisites / open items

- `GEMINI_API_KEY` must be set in the environment (not currently set). The script will not run without it.
- ~~Confirm responseModalities~~ — **resolved:** parse for the `inlineData` part regardless of modality; `["IMAGE"]` is the default.
- **Verify the default 3:2 output is ≥1200px wide** for OG (the 1K preset at 3:2 lands around 1248×832). If it isn't, set `imageConfig.imageSize` (Pro) or upscale in the script.
- Optional: sidecar prompt-hash (`<base-name>.png.prompt`) so editing `illustration:` later auto-invalidates the stale cover. For a one-person blog, `--post <base-name>` after edits is sufficient.
- **Note: covers are not reproducible** — Nano Banana doesn't expose a reliable seed, so `--force` yields a different image each run.
- Every output carries a non-removable invisible SynthID watermark (irrelevant for this use; noted to avoid surprise).

## Cost

~40 generations at **$0.039/image ≈ $1.60** total on `gemini-2.5-flash-image` (~$5 on Pro). Cost is **not** a real constraint. The reason to keep generation as a manual local script is quality control and determinism of the committed assets, not spend.

## Naming note: slug vs. ContentBaseName

The path is keyed on `.File.ContentBaseName` (filename without extension), **not** Hugo's `slug` — these differ when `slug:` is set in front matter or permalinks rewrite URLs. The convention works as long as the script and theme both use `ContentBaseName`. Use that term consistently in code and docs so nobody wires one side to `slug` and the other to `ContentBaseName`. (If a post ever becomes a leaf bundle / `index.md`, `ContentBaseName` becomes the directory name — flat `content/posts/*.md` avoids this.)

## Out of scope (for now)

- List/card thumbnails on homepage and taxonomy pages.
- Regenerating the site-wide default OG image.
- Automating generation in CI (kept as a manual local script for quality control / deterministic committed assets).
