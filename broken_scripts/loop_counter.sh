#!/bin/bash
# Counter script with issues

# Issue 1: Using expr instead of arithmetic expansion
counter=0
counter=`expr $counter + 1`

# Issue 2: Not using proper variable increment
count=0
for i in 1 2 3 4 5
do
    count=$count+1
    echo $count
done

# Issue 3: Inefficient subshell usage
total=0
for num in $(seq 1 100)
do
    total=`expr $total + $num`
done

echo "Total: $total"
