#!/bin/bash
file='serverinfo.data'
server=$1
while read line; do
if [[ $line == "epas$server"* ]]
then
for serverInfo in $line
do
servers="$server " 
done

fi

done < $file

echo $servers

# on the basis of server info
# i) pick server info and divide into differnt parts e.g. prot, user etc
#  ii) decide how second part of the string is port, third part username etc.
# iii) replace characters in postgreql.conf file. in the format "host    all             all             127.0.0.1/32            trust"
# iv)



