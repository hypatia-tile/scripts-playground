# Shell Script Issues Review

This document identifies common issues found in shell scripts and provides guidance on how to fix them.

## broken_scripts/file_processor.sh

### Issue 1: Missing quotes around variable with spaces (Line 5-6)
**Problem:**
```bash
filename=$1
echo Processing $filename
```
**Issue:** If `$filename` contains spaces, it will be word-split and interpreted as multiple arguments.

**Fix:**
```bash
filename="$1"
echo "Processing $filename"
```

### Issue 2: Not checking if file exists (Line 9)
**Problem:**
```bash
cat $filename
```
**Issue:** If the file doesn't exist, the script will fail with an error but continue executing. Also, the variable is unquoted.

**Fix:**
```bash
if [ -f "$filename" ]; then
    cat "$filename"
else
    echo "Error: File '$filename' not found" >&2
    exit 1
fi
```

### Issue 3: Using ls for file iteration (Line 12-15)
**Problem:**
```bash
for file in $(ls *.txt)
do
    echo "Processing: $file"
done
```
**Issue:** Using `ls` in a for loop is problematic because:
- Fails with filenames containing spaces
- Fails with filenames containing newlines
- Glob expansion is disabled in command substitution

**Fix:**
```bash
for file in *.txt; do
    [ -e "$file" ] || continue  # Skip if no matches
    echo "Processing: $file"
done
```

### Issue 4: Word splitting on variable (Line 18-22)
**Problem:**
```bash
files="file1.txt file2.txt file3.txt"
for f in $files
do
    echo $f
done
```
**Issue:** The variable `$files` will be word-split, which is intentional here but can cause issues with filenames containing spaces. Also, `echo $f` should be quoted.

**Fix:** Use an array for better handling:
```bash
files=("file1.txt" "file2.txt" "file3.txt")
for f in "${files[@]}"; do
    echo "$f"
done
```

---

## broken_scripts/backup.sh

### Issue 1: Shebang mismatch (Line 1, Line 12-14)
**Problem:**
```bash
#!/bin/sh
...
if [[ -d $backup_dir ]]; then
```
**Issue:** The shebang says `#!/bin/sh` but the script uses `[[ ]]` which is a bash-specific feature. On systems where `/bin/sh` is not bash (like Debian/Ubuntu with dash), this will fail.

**Fix:** Either change shebang to `#!/bin/bash` or use POSIX-compliant syntax:
```bash
#!/bin/sh
...
if [ -d "$backup_dir" ]; then
```

### Issue 2: No error checking for cd (Line 8)
**Problem:**
```bash
cd $source_dir
```
**Issue:** If `cd` fails (directory doesn't exist), the script continues in the wrong directory. Also, variable is unquoted.

**Fix:**
```bash
cd "$source_dir" || { echo "Error: Cannot access $source_dir" >&2; exit 1; }
```

### Issue 3: Unquoted variables in dangerous commands (Line 11)
**Problem:**
```bash
rm -rf $backup_dir/*
```
**Issue:** If `$backup_dir` is empty or contains spaces, this could delete unintended files. This is a **critical security issue**.

**Fix:**
```bash
if [ -n "$backup_dir" ] && [ -d "$backup_dir" ]; then
    rm -rf "${backup_dir:?}"/*
else
    echo "Error: Invalid backup directory" >&2
    exit 1
fi
```

### Issue 4: Missing input validation
**Problem:** No validation that arguments were provided or are valid directories.

**Fix:**
```bash
if [ $# -ne 2 ]; then
    echo "Usage: $0 <source_dir> <backup_dir>" >&2
    exit 1
fi

source_dir="${1%/}"  # Remove trailing slash
backup_dir="${2%/}"

if [ ! -d "$source_dir" ]; then
    echo "Error: Source directory '$source_dir' does not exist" >&2
    exit 1
fi
```

### Issue 5: No proper error handling for cp (Line 17)
**Problem:**
```bash
cp -r * $backup_dir
echo "Backup completed"
```
**Issue:** If `cp` fails, the script still reports success.

**Fix:**
```bash
if cp -r ./* "$backup_dir/"; then
    echo "Backup completed successfully"
else
    echo "Error: Backup failed" >&2
    exit 1
fi
```

---

## broken_scripts/user_input.sh

### Issue 1: Not validating user input (Line 4-7)
**Problem:**
```bash
echo "Enter your name:"
read name
echo Welcome $name
```
**Issue:** No validation that input was provided. Variable is unquoted in echo.

**Fix:**
```bash
echo "Enter your name:"
read -r name
if [ -z "$name" ]; then
    echo "Error: Name cannot be empty" >&2
    exit 1
fi
echo "Welcome $name"
```

### Issue 2: Command injection vulnerability (Line 10-12)
**Problem:**
```bash
echo "Enter filename to search:"
read search_file
find / -name $search_file
```
**Issue:** Unquoted variable allows command injection. A user could enter `file.txt -o -name secret.txt` to modify the find command. Also searching from `/` requires elevated permissions and is inefficient.

**Fix:**
```bash
echo "Enter filename to search:"
read -r search_file
# Validate input - allow only alphanumeric, dots, underscores, hyphens
if [[ "$search_file" =~ ^[a-zA-Z0-9._-]+$ ]]; then
    find . -name "$search_file" -type f
else
    echo "Error: Invalid filename pattern" >&2
    exit 1
fi
```

### Issue 3: Not checking command exit status (Line 15-16)
**Problem:**
```bash
grep "pattern" /etc/passwd
echo "Search completed successfully"
```
**Issue:** Even if grep fails (pattern not found or file not readable), the script reports success.

**Fix:**
```bash
if grep -q "pattern" /etc/passwd; then
    echo "Pattern found"
else
    echo "Pattern not found or error occurred" >&2
fi
```

### Issue 4: Using test with unquoted variable (Line 19-21)
**Problem:**
```bash
if [ $name = "admin" ]; then
```
**Issue:** If `$name` is empty, this becomes `[ = "admin" ]` which is a syntax error.

**Fix:**
```bash
if [ "$name" = "admin" ]; then
    echo "Admin access granted"
fi
```

---

## broken_scripts/loop_counter.sh

### Issue 1: Using expr instead of arithmetic expansion (Line 4-5)
**Problem:**
```bash
counter=0
counter=`expr $counter + 1`
```
**Issue:** `expr` is an external command, making it slow. Backticks are deprecated. Modern bash has built-in arithmetic.

**Fix:**
```bash
counter=0
((counter++))
# or
counter=$((counter + 1))
```

### Issue 2: String concatenation instead of arithmetic (Line 8-13)
**Problem:**
```bash
count=0
for i in 1 2 3 4 5
do
    count=$count+1
    echo $count
done
```
**Issue:** This does string concatenation, not arithmetic. Output will be: `0+1`, `0+1+1`, `0+1+1+1`, etc.

**Fix:**
```bash
count=0
for i in 1 2 3 4 5; do
    ((count++))
    echo "$count"
done
```

### Issue 3: Inefficient subshell usage (Line 16-20)
**Problem:**
```bash
total=0
for num in $(seq 1 100)
do
    total=`expr $total + $num`
done
```
**Issue:** Spawning external processes (`seq` and `expr`) for each iteration is extremely inefficient.

**Fix:**
```bash
total=0
for num in {1..100}; do
    ((total += num))
done
# or even better:
total=$((100 * 101 / 2))  # Mathematical formula for sum
```

---

## Common Best Practices

1. **Always quote variables** unless you specifically need word splitting
2. **Use `shellcheck`** to lint your scripts
3. **Enable strict mode** at the start of scripts:
   ```bash
   #!/bin/bash
   set -euo pipefail
   ```
   - `-e`: Exit on error
   - `-u`: Exit on undefined variable
   - `-o pipefail`: Exit on pipe failure

4. **Check command exit statuses** for critical operations
5. **Validate input** before using it
6. **Use arrays** instead of string variables for lists
7. **Prefer `[[ ]]`** over `[ ]` in bash (but remember `[[ ]]` is not POSIX)
8. **Use `$(...)` instead of backticks** for command substitution
9. **Use arithmetic expansion `$((...))` or `((...))` instead of `expr`**
10. **Handle errors explicitly** - don't assume commands will succeed

---

## Testing Your Scripts

To check your scripts for common issues, use ShellCheck:

```bash
shellcheck script.sh
```

Install ShellCheck:
- Ubuntu/Debian: `sudo apt-get install shellcheck`
- macOS: `brew install shellcheck`
- Or use online: https://www.shellcheck.net/

---

## Summary

The scripts in the `broken_scripts/` directory contain intentional errors for educational purposes. They demonstrate common mistakes that developers make when writing shell scripts:

- **Security issues**: Unquoted variables, command injection, dangerous rm commands
- **Portability issues**: Using bash features with sh shebang
- **Robustness issues**: Not checking for errors, not validating input
- **Performance issues**: Using external commands when built-ins are available
- **Syntax issues**: Word splitting, globbing, missing quotes

Always test your scripts thoroughly and use tools like ShellCheck to catch these issues early!
