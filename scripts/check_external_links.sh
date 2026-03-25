#!/bin/bash

# Check external links in blog posts for HTTP status and page title
# Usage: ./scripts/check_external_links.sh [file]
#   No argument → scan all content/posts/*.md
#   With file   → scan just that file

set -euo pipefail

TIMEOUT=10
seen_file=$(mktemp)
broken_file=$(mktemp)
trap 'rm -f "$seen_file" "$broken_file"' EXIT

# Domains that block automated requests (403) but work in browsers
BOT_BLOCKED_DOMAINS=(
    "gartner.com"
)

check_url() {
    local file="$1" line_num="$2" url="$3"

    # Skip if already checked
    if grep -qFx "$url" "$seen_file" 2>/dev/null; then
        return 0
    fi
    echo "$url" >> "$seen_file"

    # Fetch headers + body, capture status code
    local tmpfile
    tmpfile=$(mktemp)
    local status
    status=$(curl -sL -o "$tmpfile" -w "%{http_code}" --max-time "$TIMEOUT" "$url" 2>/dev/null) || status="000"

    # Extract <title> from response body
    local title="(no title)"
    if [[ -f "$tmpfile" ]]; then
        local extracted
        extracted=$(sed -n 's/.*<[tT][iI][tT][lL][eE][^>]*>\([^<]*\)<.*/\1/p' "$tmpfile" 2>/dev/null | head -1 | sed 's/^[[:space:]]*//;s/[[:space:]]*$//') || true
        [[ -n "$extracted" ]] && title="$extracted"
    fi
    rm -f "$tmpfile"

    # Print result
    printf "  %-4s  %s:%d  %s\n" "$status" "$file" "$line_num" "$title"

    # Track broken links (skip domains known to block bots)
    if [[ "$status" =~ ^(0|4|5) ]]; then
        local is_blocked=false
        for domain in "${BOT_BLOCKED_DOMAINS[@]}"; do
            if [[ "$url" == *"$domain"* ]]; then
                is_blocked=true
                break
            fi
        done
        if [[ "$is_blocked" == true ]]; then
            printf "  ⚠ SKIP  %s:%d  (bot-blocked domain)\n" "$file" "$line_num"
        else
            echo "[$status] $file:$line_num $url" >> "$broken_file"
        fi
    fi
}

scan_file() {
    local file="$1"
    # Extract markdown links with line numbers: [text](https://...)
    while IFS=: read -r line_num content; do
        while IFS= read -r url; do
            check_url "$file" "$line_num" "$url"
        done < <(echo "$content" | grep -oE 'https?://[^)]+')
    done < <(grep -nE '\[.*?\]\(https?://[^)]+\)' "$file" || true)
}

# Determine files to scan
if [[ $# -gt 0 ]]; then
    files=("$@")
else
    files=(content/posts/*.md)
fi

echo "Checking external links..."
echo ""

for file in "${files[@]}"; do
    [[ -f "$file" ]] || { echo "File not found: $file"; continue; }
    scan_file "$file"
done

echo ""

if [[ -s "$broken_file" ]]; then
    count=$(wc -l < "$broken_file" | tr -d ' ')
    echo "BROKEN LINKS ($count):"
    while IFS= read -r entry; do
        echo "  $entry"
    done < "$broken_file"
    exit 1
else
    echo "All external links OK"
    exit 0
fi
