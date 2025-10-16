#!/bin/bash
# Counter script - FIXED VERSION
set -euo pipefail

# Use arithmetic expansion instead of expr
counter=0
counter=$((counter + 1))
echo "Counter: $counter"

# Use proper arithmetic in loops
count=0
for _ in 1 2 3 4 5; do
    count=$((count + 1))
    echo "Count: $count"
done

# Use brace expansion and arithmetic expansion for efficiency
total=0
for num in {1..100}; do
    total=$((total + num))
done
echo "Total (loop method): $total"

# Or use mathematical formula for even better performance
total_formula=$((100 * 101 / 2))
echo "Total (formula method): $total_formula"

# Demonstrate other arithmetic operations
a=10
b=3

echo "Addition: $((a + b))"
echo "Subtraction: $((a - b))"
echo "Multiplication: $((a * b))"
echo "Division: $((a / b))"
echo "Modulo: $((a % b))"

# Increment/decrement with assignment
x=5
echo "Original: $x"
x=$((x + 1))
echo "After increment: $x"
x=$((x - 1))
echo "After decrement: $x"
