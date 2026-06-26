#!/bin/bash

# Generate per-post cover illustrations with Google "Nano Banana"
# (gemini-2.5-flash-image) in a consistent Cubo-Futurism style.
#
# Reads the `illustration:` prompt from each post's front matter, prepends a
# shared style preamble, and writes a 3:2 cover to assets/images/covers/<base>.webp
# by convention (a compact WebP master, re-encoded from the API's PNG via cwebp;
# falls back to .png if cwebp is missing). Hugo derives the responsive served
# renditions from this master. The theme renders the cover by the same
# convention — no extra front-matter wiring.
#
# Usage:
#   ./scripts/generate_illustrations.sh                 # all posts missing a cover
#   ./scripts/generate_illustrations.sh --force         # regenerate everything
#   ./scripts/generate_illustrations.sh --post <base>   # single post (filename w/o .md)
#   ./scripts/generate_illustrations.sh --dry-run       # print composed prompts only
#   ./scripts/generate_illustrations.sh --list          # show posts w/ illustration: but no cover
#   ./scripts/generate_illustrations.sh --strict        # exit non-zero on first failure
#
# Requires: GEMINI_API_KEY in the environment. curl + jq.
# Override the model with GEMINI_IMAGE_MODEL (e.g. gemini-3-pro-image for Pro).

set -euo pipefail

# ---------------------------------------------------------------------------
# Config
# ---------------------------------------------------------------------------

# Repo root = parent of this script's directory. Lets the script run from
# anywhere and still resolve content/, assets/, and the env file.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT"

# Load secrets from a gitignored env file if GEMINI_API_KEY isn't already set.
# Override the path with ENV_FILE=/some/path.
ENV_FILE="${ENV_FILE:-$REPO_ROOT/env}"
if [[ -z "${GEMINI_API_KEY:-}" && -f "$ENV_FILE" ]]; then
    set -a
    # shellcheck disable=SC1090
    source "$ENV_FILE"
    set +a
fi

GEMINI_IMAGE_MODEL="${GEMINI_IMAGE_MODEL:-gemini-2.5-flash-image}"
API_BASE="https://generativelanguage.googleapis.com/v1beta/models"
POSTS_DIR="content/posts"
COVERS_DIR="assets/images/covers"
ASPECT_RATIO="3:2"
WEBP_QUALITY=90         # cwebp quality for the committed master (visually lossless, ~6x smaller than PNG)
SLEEP_BETWEEN=2          # seconds between successful calls (rate-limit courtesy)
MAX_RETRIES=4           # retries on HTTP 429 / transient errors
BACKOFF_BASE=5          # seconds; doubles each retry

# Shared Cubo-Futurism style preamble — prepended to every per-post prompt so
# the whole set reads as one cohesive collection. Keep edits here, not per post.
STYLE_PREAMBLE="""
A modern continuation of early-20th-century geometric avant-garde — Suprematist-style planes and Constructivist heroic-worker imagery carried forward a century into contemporary digital illustration. Not a period reproduction or pastiche: the lineage evolved, not frozen. Faceted geometric construction — figures and surroundings built from interlocking planes, shards and dynamic diagonals — rendered in clean modern concept-art: bold confident outlines, flat cel shading, crisp digital finish. Strong diagonal energy, off-axis dynamic composition, radiating shafts of light.

Lively, joyful, warm-hearted mood — a candid, animated collective of workers genuinely happy together, laughing, gesturing, leaning into one another, full of life and optimism. A densely populated, busy composition: many figures and robots close together and interacting, layered front to back, the frame full and energetic rather than sparse or posed. Celebratory and human, not solemn or statuesque.

Vivid high-chroma palette, warm tones clearly dominant — roughly two-thirds warm to one-third cool. Figures and foreground lead in coral, terracotta, burnt orange, gold and amber (#CB6440, #CA5551, #E8AA4E, #E7D6AB); cool teal, blue, deep navy and sage confined to sky, distance, depth and shadow (#00B6BE, #007BAD, #142F4B, #73B598); prominent radiating rays in pink and teal, bold but subordinate to the figures (#D7506E, #B950B2). Saturated and energetic but harmonised, warm tones the clear hero so the image pops beside a teal-led brand.

Crisp highlights, bright radiant backlighting and glowing light energy from behind the scene (no requirement for a visible sun), visible facet edges, clear focal hierarchy. No text, letters, numbers, words, signage, or labels anywhere in the image. 3:2 landscape aspect ratio.

Scene:
"""

# ---------------------------------------------------------------------------
# Flags
# ---------------------------------------------------------------------------

FORCE=false
DRY_RUN=false
LIST_ONLY=false
STRICT=false
SINGLE_POST=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --force)   FORCE=true; shift ;;
        --dry-run) DRY_RUN=true; shift ;;
        --list)    LIST_ONLY=true; shift ;;
        --strict)  STRICT=true; shift ;;
        --post)    SINGLE_POST="${2:-}"; shift 2 ;;
        -h|--help)
            sed -n '3,21p' "$0" | sed 's/^# \{0,1\}//'
            exit 0 ;;
        *)
            echo "Unknown argument: $1" >&2
            exit 2 ;;
    esac
done

# ---------------------------------------------------------------------------
# Preconditions
# ---------------------------------------------------------------------------

if ! $DRY_RUN && ! $LIST_ONLY; then
    if [[ -z "${GEMINI_API_KEY:-}" ]]; then
        echo "ERROR: GEMINI_API_KEY is not set. Export it, or add it to '$ENV_FILE'." >&2
        exit 1
    fi
    for bin in curl jq; do
        command -v "$bin" >/dev/null 2>&1 || { echo "ERROR: '$bin' is required." >&2; exit 1; }
    done
fi
command -v jq >/dev/null 2>&1 || { echo "ERROR: 'jq' is required." >&2; exit 1; }

mkdir -p "$COVERS_DIR"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

# Extract the `illustration:` value from a post's YAML front matter.
# Handles double-quoted, single-quoted, and bare values. Empty if absent.
extract_illustration() {
    local file="$1"
    awk '
        BEGIN { in_fm = 0 }
        /^---[[:space:]]*$/ { in_fm++; next }
        in_fm == 1 && /^illustration:[[:space:]]*/ {
            sub(/^illustration:[[:space:]]*/, "")
            # strip surrounding matching quotes
            if (($0 ~ /^".*"$/) || ($0 ~ /^'"'"'.*'"'"'$/)) {
                $0 = substr($0, 2, length($0) - 2)
            }
            print
            exit
        }
        in_fm >= 2 { exit }
    ' "$file"
}

# True if a cover master (webp or png) already exists for this base name.
cover_exists() {
    [[ -f "$COVERS_DIR/$1.webp" || -f "$COVERS_DIR/$1.png" ]]
}

# Generate one cover. Returns 0 on success, 1 on failure.
generate_one() {
    local base="$1" illustration="$2"
    local out
    local prompt="$STYLE_PREAMBLE $illustration"

    if $DRY_RUN; then
        echo "── $base ──"
        echo "$prompt"
        echo
        return 0
    fi

    local body
    body=$(jq -n \
        --arg text "$prompt" \
        --arg ratio "$ASPECT_RATIO" \
        '{
            contents: [ { role: "user", parts: [ { text: $text } ] } ],
            generationConfig: {
                responseModalities: ["IMAGE"],
                imageConfig: { aspectRatio: $ratio }
            }
        }')

    local attempt=0 http_code resp_file
    while :; do
        attempt=$((attempt + 1))
        resp_file=$(mktemp)
        http_code=$(curl -sS -o "$resp_file" -w '%{http_code}' \
            -X POST "$API_BASE/$GEMINI_IMAGE_MODEL:generateContent" \
            -H "x-goog-api-key: $GEMINI_API_KEY" \
            -H "Content-Type: application/json" \
            -d "$body" 2>/dev/null) || http_code="000"

        # Retry on rate limit / transient server errors with backoff.
        if [[ "$http_code" == "429" || "$http_code" =~ ^5 || "$http_code" == "000" ]]; then
            if (( attempt <= MAX_RETRIES )); then
                local wait=$(( BACKOFF_BASE * (2 ** (attempt - 1)) ))
                echo "  [$base] HTTP $http_code — retry $attempt/$MAX_RETRIES in ${wait}s" >&2
                rm -f "$resp_file"
                sleep "$wait"
                continue
            fi
        fi
        break
    done

    # --- Validate response before touching the filesystem ---
    if [[ ! "$http_code" =~ ^2 ]]; then
        local apierr
        apierr=$(jq -r '.error.message // empty' "$resp_file" 2>/dev/null || true)
        echo "  [$base] FAIL: HTTP $http_code ${apierr:+— $apierr}" >&2
        rm -f "$resp_file"
        return 1
    fi

    # Surface a blocking finishReason if no image came back.
    local finish
    finish=$(jq -r '.candidates[0].finishReason // empty' "$resp_file" 2>/dev/null || true)

    local data
    data=$(jq -r '.candidates[0].content.parts[]? | select(.inlineData) | .inlineData.data' \
        "$resp_file" 2>/dev/null | head -1 || true)

    if [[ -z "$data" ]]; then
        local reason="${finish:-no inlineData part in response}"
        echo "  [$base] FAIL: no image returned (finishReason: $reason)" >&2
        rm -f "$resp_file"
        return 1
    fi
    rm -f "$resp_file"

    # Decode to a temp file, validate, then move into place atomically.
    local tmp_png
    tmp_png=$(mktemp "${TMPDIR:-/tmp}/cover.XXXXXX")
    if ! printf '%s' "$data" | base64 --decode > "$tmp_png" 2>/dev/null; then
        echo "  [$base] FAIL: base64 decode error" >&2
        rm -f "$tmp_png"
        return 1
    fi

    if [[ ! -s "$tmp_png" ]]; then
        echo "  [$base] FAIL: decoded image is empty" >&2
        rm -f "$tmp_png"
        return 1
    fi

    # PNG magic bytes: 89 50 4E 47
    local magic
    magic=$(od -An -tx1 -N4 "$tmp_png" 2>/dev/null | tr -d ' \n')
    if [[ "$magic" != "89504e47" ]]; then
        echo "  [$base] FAIL: output is not a valid PNG (magic: $magic)" >&2
        rm -f "$tmp_png"
        return 1
    fi

    # Re-encode the decoded PNG into a compact WebP master — Hugo derives the
    # served renditions from it, and a WebP master is ~6x smaller than the PNG
    # the API returns. Falls back to the raw PNG if cwebp isn't installed.
    if command -v cwebp >/dev/null 2>&1; then
        out="$COVERS_DIR/$base.webp"
        if ! cwebp -quiet -q "$WEBP_QUALITY" "$tmp_png" -o "$tmp_png.webp" 2>/dev/null; then
            echo "  [$base] FAIL: cwebp encode error" >&2
            rm -f "$tmp_png" "$tmp_png.webp"
            return 1
        fi
        rm -f "$tmp_png"
        mv "$tmp_png.webp" "$out"
        rm -f "$COVERS_DIR/$base.png"   # drop any stale PNG master
    else
        out="$COVERS_DIR/$base.png"
        mv "$tmp_png" "$out"
    fi

    local bytes
    bytes=$(wc -c < "$out" | tr -d ' ')
    echo "  [$base] OK → $out (${bytes} bytes)"
    return 0
}

# ---------------------------------------------------------------------------
# Build the work list
# ---------------------------------------------------------------------------

declare -a files
if [[ -n "$SINGLE_POST" ]]; then
    # Look in content/posts first, then top-level content (e.g. about.md).
    if [[ -f "$POSTS_DIR/$SINGLE_POST.md" ]]; then
        files=("$POSTS_DIR/$SINGLE_POST.md")
    elif [[ -f "content/$SINGLE_POST.md" ]]; then
        files=("content/$SINGLE_POST.md")
    else
        echo "ERROR: page not found: $POSTS_DIR/$SINGLE_POST.md or content/$SINGLE_POST.md" >&2
        exit 1
    fi
else
    shopt -s nullglob
    # All posts, plus standalone top-level pages (about.md etc.). Pages without
    # an illustration: prompt are skipped later, so this is safe to over-include.
    for f in "$POSTS_DIR"/*.md content/*.md; do
        [[ "$f" == *.backup ]] && continue
        files+=("$f")
    done
    shopt -u nullglob
fi

# --list: show posts that have an illustration: but no cover yet.
if $LIST_ONLY; then
    echo "Posts with an illustration: prompt but no cover yet:"
    pending=0
    for f in "${files[@]}"; do
        base=$(basename "$f" .md)
        illu=$(extract_illustration "$f")
        [[ -z "$illu" ]] && continue
        if ! cover_exists "$base"; then
            echo "  $base"
            pending=$((pending + 1))
        fi
    done
    echo "($pending pending)"
    exit 0
fi

# ---------------------------------------------------------------------------
# Main loop
# ---------------------------------------------------------------------------

total=0 generated=0 skipped=0 failed=0 no_prompt=0
for f in "${files[@]}"; do
    base=$(basename "$f" .md)
    illu=$(extract_illustration "$f")

    if [[ -z "$illu" ]]; then
        no_prompt=$((no_prompt + 1))
        continue
    fi
    total=$((total + 1))

    if cover_exists "$base" && ! $FORCE; then
        skipped=$((skipped + 1))
        continue
    fi

    if generate_one "$base" "$illu"; then
        generated=$((generated + 1))
        $DRY_RUN || sleep "$SLEEP_BETWEEN"
    else
        failed=$((failed + 1))
        if $STRICT; then
            echo "Aborting (--strict) after failure on: $base" >&2
            exit 1
        fi
    fi
done

echo
echo "Done. ${generated} generated, ${skipped} skipped (cover exists), ${failed} failed; ${no_prompt} posts without an illustration: prompt."
if (( failed > 0 )); then
    exit 1
fi
