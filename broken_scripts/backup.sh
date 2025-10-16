#!/bin/sh
# Backup script with issues

# Issue 1: Using bash-specific syntax with sh shebang
source_dir=$1
backup_dir=$2

# Issue 2: No error checking
cd $source_dir

# Issue 3: Unquoted variables in dangerous commands
rm -rf $backup_dir/*

# Issue 4: Using [[ ]] which is bash-specific but shebang says sh
if [[ -d $backup_dir ]]; then
    echo "Backup directory exists"
fi

# Issue 5: Not using proper error handling
cp -r * $backup_dir
echo "Backup completed"
