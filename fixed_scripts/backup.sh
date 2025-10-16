#!/bin/bash
# Backup script - FIXED VERSION
set -euo pipefail

# Validate arguments
if [ $# -ne 2 ]; then
    echo "Usage: $0 <source_dir> <backup_dir>" >&2
    exit 1
fi

source_dir="${1%/}"  # Remove trailing slash
backup_dir="${2%/}"

# Validate source directory exists
if [ ! -d "$source_dir" ]; then
    echo "Error: Source directory '$source_dir' does not exist" >&2
    exit 1
fi

# Create backup directory if it doesn't exist
if [ ! -d "$backup_dir" ]; then
    mkdir -p "$backup_dir" || {
        echo "Error: Cannot create backup directory '$backup_dir'" >&2
        exit 1
    }
fi

# Change to source directory with error checking
cd "$source_dir" || {
    echo "Error: Cannot access source directory '$source_dir'" >&2
    exit 1
}

# Clean backup directory safely
if [ -n "$backup_dir" ] && [ -d "$backup_dir" ]; then
    # Use parameter expansion with :? to prevent empty variable
    rm -rf "${backup_dir:?}"/* 2>/dev/null || true
fi

# Perform backup with error handling
if cp -r ./* "$backup_dir/"; then
    echo "Backup completed successfully"
    echo "Source: $source_dir"
    echo "Destination: $backup_dir"
else
    echo "Error: Backup failed" >&2
    exit 1
fi
