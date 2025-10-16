#!/bin/bash
# File processor script - FIXED VERSION
set -euo pipefail

# Check if filename argument was provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <filename>" >&2
    exit 1
fi

# Quote variables to handle spaces
filename="$1"
echo "Processing $filename"

# Check if file exists before processing
if [ -f "$filename" ]; then
    cat "$filename"
else
    echo "Error: File '$filename' not found" >&2
    exit 1
fi

# Use glob expansion directly, not ls
for file in *.txt; do
    # Skip if no matches (glob doesn't expand)
    [ -e "$file" ] || continue
    echo "Processing: $file"
done

# Use arrays for lists instead of string variables
files=("file1.txt" "file2.txt" "file3.txt")
for f in "${files[@]}"; do
    echo "$f"
done
