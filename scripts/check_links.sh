#!/bin/bash

# Check for dead internal links in all blog posts
# Finds markdown links pointing to /posts/... and verifies a matching file exists

dead=0

for file in content/posts/*.md; do
    [[ -f "$file" ]] || continue

    # Extract internal post links: [text](/posts/slug/)
    grep -oE '\[.*?\]\(/posts/[^)]+\)' "$file" | while IFS= read -r match; do
        slug=$(echo "$match" | grep -oE '/posts/[^)]+' | sed 's|^/posts/||' | sed 's|/$||')

        # Look for a file matching *slug.md in content/posts/
        if ! ls content/posts/*"$slug".md &>/dev/null; then
            echo "DEAD LINK in $file"
            echo "  $match"
            echo "  No file matching slug: $slug"
            echo ""
            echo "FOUND" >> /tmp/check_links_dead_$$
        fi
    done
done

if [[ -f /tmp/check_links_dead_$$ ]]; then
    count=$(wc -l < /tmp/check_links_dead_$$)
    rm -f /tmp/check_links_dead_$$
    echo "Found $count dead link(s)"
    exit 1
fi

echo "All internal links OK"
exit 0
