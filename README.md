# scripts-playground
Hands-on lessons for shell scripting

## Overview

This repository contains educational shell scripts demonstrating common issues and their fixes. It's designed to help you learn shell scripting best practices by showing real-world mistakes and how to correct them.

## Structure

- **`broken_scripts/`** - Shell scripts with common issues (for learning)
- **`fixed_scripts/`** - Corrected versions of the scripts
- **`ISSUES.md`** - Detailed documentation of all issues and fixes

## Scripts Included

### 1. file_processor.sh
Demonstrates issues with:
- Missing quotes around variables
- File existence checks
- Using `ls` in loops
- Word splitting problems

### 2. backup.sh
Demonstrates issues with:
- Shebang mismatches (sh vs bash)
- Missing error checking
- Dangerous unquoted variables
- Input validation

### 3. user_input.sh
Demonstrates issues with:
- Lack of input validation
- Command injection vulnerabilities
- Not checking command exit status
- Unquoted variables in conditionals

### 4. loop_counter.sh
Demonstrates issues with:
- Using external commands instead of built-ins
- String concatenation vs arithmetic
- Performance inefficiencies

## How to Use

1. **Read the broken scripts** in `broken_scripts/` and try to identify the issues
2. **Check your answers** against `ISSUES.md`
3. **Study the fixed versions** in `fixed_scripts/`
4. **Practice** by writing your own scripts with proper error handling

## Testing Scripts with ShellCheck

Install ShellCheck to automatically detect many of these issues:

```bash
# Ubuntu/Debian
sudo apt-get install shellcheck

# macOS
brew install shellcheck
```

Run it on any script:
```bash
shellcheck broken_scripts/file_processor.sh
```

## Key Takeaways

1. Always quote your variables: `"$var"` not `$var`
2. Check for errors: use `set -euo pipefail`
3. Validate input before using it
4. Use ShellCheck to catch common mistakes
5. Prefer bash built-ins over external commands
6. Test your scripts with edge cases (empty strings, spaces in filenames, etc.)

## Learning Resources

- [ShellCheck](https://www.shellcheck.net/) - Online shell script analyzer
- [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- [Bash Reference Manual](https://www.gnu.org/software/bash/manual/)

## License

MIT License - See LICENSE file for details
