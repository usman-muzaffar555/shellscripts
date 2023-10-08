#!/bin/sh

# This will check if server is running, the reqquired server info will be sent through
# function call.
function checkServerRunning()
{
cmd_first_part="pgrep -fa -- "
cmd_second_part="-D /var/lib/edb/as$1/data"
cmd_second_part=\'${cmd_second_part}\'

cmd=${cmd_first_part}
cmd+=$cmd_second_part
status=`$cmd_first_part "-D /var/lib/edb/as$1/data"`
if [[ $status =~ $1 ]]; then
#echo "The server $1 is running"
return 1
else
#echo "EPAS server $1 is not running..."
return 0
fi
}


servers=("10" "11" "12" "13" "14")
for server in ${servers[@]};
do
{
server_data_dir=/var/lib/edb/as$server/data
server_bin_dir=/usr/edb/as$server/bin

if [[ $server == 10 ]]
then
port=5444
fi
if [ $server==11 ]
then
port=5445
fi
if [ $server==12 ]
then
port=5446
fi
if [ $server==13 ]
then
port=5447
fi
if [ $server==14 ]
then
port=5448
fi

#echo "server data dir is $server_data_dir"
#echo "server bin dir is $server_bin_dir"
 checkServerRunning $server
a=$?
if [[ $a -eq 0 ]]
then
echo "server $server is not running"
sudo -i -u  enterprisedb /bin/sh << EOF
echo "we are going to run server $server with port $port"
cd $server_bin_dir
./pg_ctl -D $server_data_dir -o "-p $port" start
EOF
fi


if [[ $a == 1 ]]
then
echo "server $server is running"
fi
}
done

