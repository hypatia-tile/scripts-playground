# Shell Script Review Summary

## Overview

This repository was created as a hands-on learning playground for shell scripting. When asked to "review the shell scripts and point out the issue," I found that **the repository had no shell scripts yet**. 

Therefore, I created a comprehensive educational resource with:

1. **Broken shell scripts** demonstrating common issues
2. **Fixed versions** showing the correct approach
3. **Detailed documentation** explaining each issue
4. **Quick reference guide** for best practices

## What Was Created

### Broken Scripts (with intentional issues)

1. **broken_scripts/file_processor.sh**
   - Missing quotes around variables
   - No file existence checks
   - Using `ls` in loops (fragile)
   - Word splitting problems

2. **broken_scripts/backup.sh**
   - Shebang mismatch (sh vs bash)
   - Missing error checking for `cd`
   - Dangerous unquoted `rm -rf` command
   - No input validation

3. **broken_scripts/user_input.sh**
   - No input validation
   - Command injection vulnerability
   - Not checking command exit status
   - Unquoted variables in conditionals

4. **broken_scripts/loop_counter.sh**
   - Using `expr` instead of built-in arithmetic
   - String concatenation instead of arithmetic
   - Inefficient subshell usage

### Fixed Scripts (best practices)

All scripts in `fixed_scripts/` directory demonstrate:
- Proper variable quoting
- Error handling with `set -euo pipefail`
- Input validation
- Safe command usage
- Built-in arithmetic
- Correct use of arrays

### Documentation

1. **ISSUES.md** - Comprehensive review of every issue with explanations and fixes
2. **QUICK_REFERENCE.md** - Quick lookup guide for common patterns
3. **README.md** - Updated with full project overview and learning guide

## Verification

All scripts have been verified with ShellCheck:
- ✅ Broken scripts show appropriate warnings/errors
- ✅ Fixed scripts pass all ShellCheck checks
- ✅ Fixed scripts tested and working correctly

## Key Issues Identified

### Critical Security Issues
- **SC2115**: Unquoted variables in `rm -rf` commands (can delete entire filesystem)
- **Command injection**: Unvalidated user input in commands

### Robustness Issues
- **SC2164**: Not checking if `cd` fails
- Missing input validation
- Not quoting variables (word splitting/globbing issues)

### Portability Issues
- Using bash-specific syntax with sh shebang
- Using `[[ ]]` in POSIX sh scripts

### Performance Issues
- Using external commands (`expr`, `seq`) instead of bash built-ins
- Inefficient subshell usage

### Style Issues
- Using backticks instead of `$(...)` for command substitution
- Not using `read -r` (backslash mangling)

## How to Use This Repository

1. Read the broken scripts and try to identify issues
2. Check your answers against ISSUES.md
3. Study the fixed versions
4. Run ShellCheck on the scripts to see what it catches
5. Practice writing your own scripts with proper error handling

## Tools Used

- **ShellCheck**: Static analysis for shell scripts
  - All broken scripts intentionally fail ShellCheck
  - All fixed scripts pass ShellCheck
  
## Learning Outcomes

After studying these scripts, you should be able to:
- Quote variables properly to prevent word splitting
- Check for errors and handle them appropriately
- Validate user input to prevent injection attacks
- Use bash built-ins instead of external commands
- Write portable shell scripts
- Use ShellCheck to catch common mistakes

---

This repository serves as a practical learning resource for anyone learning shell scripting best practices.
