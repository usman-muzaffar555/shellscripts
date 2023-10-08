#!/bin/sh
a=(10 11)

function a()
{
echo ""

sudo -i -u enterprisedb /bin/sh << EOF
echo `whoami`
    # get port for server 
    getPortForServer $server
    port=$?
    #echo "port is $port"
    #echo "within initilize server1"
    # switch user to enterprisedb
    
    echo "user changed to enterprisedb"
    echo " "
    echo "initializing server $server ..."
    `/usr/edb/as$server/bin/initdb -D /var/lib/edb/as$server/data` 1>/dev/null
    echo " "
    echo "configuring server ..."
    `/usr/edb/as$server/bin/pg_ctl -D /var/lib/edb/as$server/data -o "-p $port" start` 1>/dev/null
    echo "initilization of server completes for $server "
EOF

}

c=(10 11)
for value in ${c[@]}
do
{
a
}
done
~    