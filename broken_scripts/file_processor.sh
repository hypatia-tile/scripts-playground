#!/bin/bash
# File processor script with issues

# Issue 1: Missing quotes around variable with spaces
filename=$1
echo Processing $filename

# Issue 2: Not checking if file exists
cat $filename

# Issue 3: Using ls for file iteration (problematic with spaces)
for file in $(ls *.txt)
do
    echo "Processing: $file"
done

# Issue 4: Word splitting on variable
files="file1.txt file2.txt file3.txt"
for f in $files
do
    echo $f
done
