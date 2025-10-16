# Quick Reference: Shell Scripting Best Practices

## Script Header

```bash
#!/bin/bash
set -euo pipefail
# -e: exit on error
# -u: exit on undefined variable  
# -o pipefail: exit on pipe failure
```

## Variable Quoting

❌ **Wrong:**
```bash
file=$1
echo $file
cat $file
```

✅ **Correct:**
```bash
file="$1"
echo "$file"
cat "$file"
```

## Error Checking

❌ **Wrong:**
```bash
cd /some/directory
rm -rf $backup_dir/*
```

✅ **Correct:**
```bash
cd /some/directory || { echo "Error: Cannot access directory" >&2; exit 1; }
if [ -n "$backup_dir" ] && [ -d "$backup_dir" ]; then
    rm -rf "${backup_dir:?}"/*
fi
```

## File Loops

❌ **Wrong:**
```bash
for file in $(ls *.txt)
do
    echo $file
done
```

✅ **Correct:**
```bash
for file in *.txt; do
    [ -e "$file" ] || continue
    echo "$file"
done
```

## Conditionals

❌ **Wrong:**
```bash
if [ $var = "value" ]; then  # Fails if $var is empty
    echo "match"
fi
```

✅ **Correct:**
```bash
if [ "$var" = "value" ]; then
    echo "match"
fi

# Even better in bash:
if [[ "$var" == "value" ]]; then
    echo "match"
fi
```

## Arithmetic

❌ **Wrong:**
```bash
count=$count+1              # String concatenation
counter=`expr $counter + 1` # External command, slow
```

✅ **Correct:**
```bash
((count++))
# or
count=$((count + 1))
# or
((counter += 1))
```

## Input Validation

❌ **Wrong:**
```bash
read name
find / -name $name  # Command injection risk!
```

✅ **Correct:**
```bash
read -r name
if [[ "$name" =~ ^[a-zA-Z0-9._-]+$ ]]; then
    find . -name "$name"
else
    echo "Invalid input" >&2
    exit 1
fi
```

## Arrays

❌ **Wrong:**
```bash
files="file1.txt file2.txt file3.txt"
for f in $files
do
    echo $f  # Breaks with spaces in filenames
done
```

✅ **Correct:**
```bash
files=("file1.txt" "file2.txt" "file3.txt")
for f in "${files[@]}"; do
    echo "$f"
done
```

## Shebang Selection

- `#!/bin/bash` - Use when you need bash features (arrays, `[[ ]]`, etc.)
- `#!/bin/sh` - Use for maximum portability (POSIX-compliant only)
- `#!/usr/bin/env bash` - Use when bash location might vary

## Command Substitution

❌ **Wrong:**
```bash
output=`command`  # Deprecated backticks
```

✅ **Correct:**
```bash
output=$(command)
```

## Exit Status Checking

❌ **Wrong:**
```bash
grep "pattern" file
echo "Done"  # Prints even if grep failed
```

✅ **Correct:**
```bash
if grep -q "pattern" file; then
    echo "Pattern found"
else
    echo "Pattern not found" >&2
fi
```

## Common ShellCheck Codes

- **SC2086**: Double quote to prevent globbing and word splitting
- **SC2115**: Use `"${var:?}"` to ensure never expands to `/*`
- **SC2164**: Use `cd ... || exit` in case cd fails
- **SC2045**: Don't iterate over ls output
- **SC2162**: Use `read -r` to prevent backslash mangling
- **SC2006**: Use `$(...)` instead of backticks
- **SC2003**: Use `$((...))` instead of `expr`

## Testing Checklist

- [ ] Run ShellCheck: `shellcheck script.sh`
- [ ] Test with empty arguments
- [ ] Test with spaces in arguments
- [ ] Test with special characters
- [ ] Test error conditions
- [ ] Verify error messages go to stderr (`>&2`)
- [ ] Check exit codes are appropriate

## Resources

- ShellCheck: https://www.shellcheck.net/
- Google Shell Style Guide: https://google.github.io/styleguide/shellguide.html
- Bash Manual: https://www.gnu.org/software/bash/manual/
