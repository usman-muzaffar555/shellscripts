#!/bin/bash

file="example.txt"

if [ -e "$file" ]; then
    echo "$file exists."

    if [ -f "$file" ]; then
        echo "$file is a regular file."
    fi

    if [ -r "$file" ]; then
        echo "$file is readable."
    else
        echo "$file is not readable."
    fi

    if [ -s "$file" ]; then
        echo "$file is not empty."
    else
        echo "$file is empty."
    fi

    if [[ -z "$file" ]] ; then
        echo "file name is not provided"
    else
	echo "file name is provided"
    fi
else
    echo "$file does not exist."
fi



file2="example2.txt"
if [[ ! -e "$file" || ! -e "$file2" ]]; then
    echo "Error: One or both files do not exist."
    exit 1
fi

if [[ "$file" -nt "$file2" ]]; then
    echo "$file is newer than $file2"
elif [[ "$file" -ot "$file2" ]]; then
    echo "$file is older than $file2"
else
    echo "$file and $file2 have the same modification time"
fi

