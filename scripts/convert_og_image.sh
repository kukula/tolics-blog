#!/bin/bash

# Script to convert SVG to PNG for Open Graph images
# Run this script after installing ImageMagick or librsvg

# Check if we have conversion tools
if command -v magick &> /dev/null; then
    echo "Converting with ImageMagick..."
    magick static/og-default.svg static/og-default.png
elif command -v rsvg-convert &> /dev/null; then
    echo "Converting with rsvg-convert..."
    rsvg-convert -w 1200 -h 630 static/og-default.svg > static/og-default.png
else
    echo "Please install ImageMagick or librsvg:"
    echo "  brew install imagemagick"
    echo "  # or"
    echo "  brew install librsvg"
    echo ""
    echo "Then run this script again to generate the PNG."
    echo ""
    echo "Alternatively, you can:"
    echo "1. Open static/og-default.svg in a browser"
    echo "2. Take a screenshot at 1200x630 pixels"
    echo "3. Save as static/og-default.png"
    exit 1
fi

echo "Open Graph image created at static/og-default.png"