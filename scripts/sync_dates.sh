#!/bin/bash

# Sync front matter dates with filename dates
# Works regardless of current directory

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "Syncing front matter dates with filename dates..."

for file in "$PROJECT_ROOT"/content/posts/*.md; do
  if [ -f "$file" ]; then
    # Extract date from filename (YYYY-MM-DD)
    basename_file=$(basename "$file")
    filename_date=$(echo "$basename_file" | cut -d'-' -f1-3)
    
    # Skip if filename doesn't start with a date pattern
    if [[ ! $filename_date =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
      echo "Skipping $file - no date prefix"
      continue
    fi
    
    # Update date and lastmod in front matter
    sed -i '' "s/^date: .*/date: $filename_date/" "$file"
    sed -i '' "s/^lastmod: .*/lastmod: $filename_date/" "$file"
    
    echo "Updated $file: date and lastmod set to $filename_date"
  fi
done

echo "Date sync complete!"