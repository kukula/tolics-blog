#!/bin/bash

# Fix em dash spacing in all markdown files
# Changes em dashes without spaces to em dashes with spaces

echo "Fixing em dash spacing in all blog posts..."

# Process all markdown files in content/posts/
for file in content/posts/*.md; do
    if [[ -f "$file" ]]; then
        echo "Processing: $file"
        
        # Create backup
        cp "$file" "$file.backup"
        
        # Fix em dashes - add spaces around them
        # This regex looks for em dashes that don't have spaces on both sides
        sed -i '' 's/\([^ ]\)—\([^ ]\)/\1 — \2/g' "$file"
        sed -i '' 's/\([^ ]\)—\( \)/\1 — \2/g' "$file"
        sed -i '' 's/\( \)—\([^ ]\)/\1— \2/g' "$file"
    fi
done

echo "Done! Backups created with .backup extension"
echo "Run 'rm content/posts/*.backup' to remove backups if you're satisfied with the results"