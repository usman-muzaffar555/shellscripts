#!/bin/bash
#
a=5
b=5

if [ "$a" -eq "$b" ]; then
  echo "a is equal to b"
fi



a=10
b=5

if [ "$a" -ne "$b" ]; then
  echo "a is not equal to b"
fi


x=8
y=3

if [ "$x" -gt "$y" ]; then
  echo "$x is greater than $y"
fi

if [ "$y" -lt "$x" ]; then
  echo "$y is less than $x"
fi


num=7

if [ "$num" -ge 7 ]; then
  echo "num is greater than or equal to 7"
fi

if [ "$num" -le 10 ]; then
  echo "num is less than or equal to 10"
fi


a=3
b=5

if [[ $a -lt $b ]]; then
  echo "$a is less than $b"
fi



a=4
b=2

if (( a > b )); then
  echo "$a is greater than $b"
fi


a=6
b=10

if [ "$a" -gt 5 ] && [ "$b" -lt 20 ]; then
  echo "Both conditions are true"
fi


if [[ $a -gt 5 && $b -lt 20 ]]; then
  echo "Both conditions are true"
fi



