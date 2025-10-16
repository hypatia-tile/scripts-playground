#!/bin/bash
# User input script with issues

# Issue 1: Not validating user input
echo "Enter your name:"
read name
echo Welcome $name

# Issue 2: Command injection vulnerability
echo "Enter filename to search:"
read search_file
find / -name $search_file

# Issue 3: Not checking command exit status
grep "pattern" /etc/passwd
echo "Search completed successfully"

# Issue 4: Using test with unquoted variable (fails if empty)
if [ $name = "admin" ]; then
    echo "Admin access granted"
fi
