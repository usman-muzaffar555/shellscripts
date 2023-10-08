#!/bin/bash

files=/Users/UsmanMuzaffar_1/Desktop/work/other/programming/shell/*
echo "$files"
for file_name in $files
do
  echo "Looping ... i is set to ${file_name}"
done

for single_arg in $@
do
  echo "single argument ... $single_arg"
done

echo "total arguments : $#"
echo "2nd parameter : $2"
