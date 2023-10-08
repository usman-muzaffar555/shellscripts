#!/bin/bash

file='serverinfo.data'
while read line; do

if [[ $line == "epas10"* ]]
 then
servers+=" 10"
fi

if [[ $line == "epas11"* ]]
 then
servers+=" 11"
fi

if [[ $line == "epas12"* ]]
 then
servers+=" 12"
fi

if [[ $line == "epas13"* ]]
 then
servers+=" 13"
fi

if [[ $line == "epas14"* ]]
 then
servers+=" 14"
fi

done < $file

echo $servers

for server in $servers
do
echo $server
done








#!/bin/bash
#file='serverinfo.data'
#server=$1
#while read line; do
#if [[ $line == "epas$server"* ]]
#then
#for serverInfo in $line
#do
#servers="$server "
#done

#fi

#done < $file

#echo $servers

