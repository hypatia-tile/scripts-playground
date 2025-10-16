#!/bin/bash
# User input script - FIXED VERSION
set -euo pipefail

# Validate user input properly
echo "Enter your name:"
read -r name

if [ -z "$name" ]; then
    echo "Error: Name cannot be empty" >&2
    exit 1
fi

echo "Welcome $name"

# Validate filename input to prevent command injection
echo "Enter filename to search (alphanumeric, dots, underscores, hyphens only):"
read -r search_file

if [[ ! "$search_file" =~ ^[a-zA-Z0-9._-]+$ ]]; then
    echo "Error: Invalid filename pattern" >&2
    exit 1
fi

# Search in current directory, not root
echo "Searching for '$search_file' in current directory..."
if find . -name "$search_file" -type f -print -quit | grep -q .; then
    find . -name "$search_file" -type f
else
    echo "No files found matching '$search_file'"
fi

# Check command exit status properly
if grep -q "root" /etc/passwd 2>/dev/null; then
    echo "Root user found in passwd file"
else
    echo "Root user not found or cannot read passwd file" >&2
fi

# Use quoted variable in test
if [ "$name" = "admin" ]; then
    echo "Admin access granted"
else
    echo "Regular user access"
fi
