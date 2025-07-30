#!/bin/bash

# Sync front matter dates with filename dates
echo "Syncing front matter dates with filename dates..."

for file in content/posts/*.md; do
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