#! /bin/bash
mystring="epas14 5448 enterprisedb edb 0.0.0.0/0 trust"
#for ((i=0; i<${#mystring}; ++i)) ; do
#    echo "${mystring:i:1}"
#done

itr=0
for substring in $mystring; do
#echo ${mystring};

if [ $itr -eq 0 ]; then
servername=$substring;
echo $servername
fi

if [ $itr -eq 1 ]; then
port=$substring
echo $port
fi

if [ $itr -eq 2 ]; then
username=$substring
echo $username
fi

if [ $itr -eq 3 ]; then
databasename=$substring
echo $databasename
fi 

if [ $itr -eq 4 ]; then
ipwildcard=$substring
echo $ipwildcard
fi

if [ $itr -eq 5 ]; then
connectiontype=$substring
echo $connectiontype
fi

((itr++))
#echo $itr
done

