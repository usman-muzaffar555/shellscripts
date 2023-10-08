#!/bin/sh
#===============================================================================
#to-do
#get the password from file
#make it platform independent e.g.for ubuntu, centos etc
#make it for start, restart, initialize, install
# get server detail from outside like port etc
# get credentials of yum from outside

#===============================================================================
# global varialbe 'port' e.g. server port
port=0000
servers=""

# install required EPAS AS server through 'Yum'.
# qmg credential are sued.
installServer() {
  # Install the repository configuration
  echo " "
  echo "step # 1 - installing edb repo rpm."
  yum -y install https://yum.enterprisedb.com/edbrepos/edb-repo-latest.noarch.rpm 1>/dev/null
  echo "step # 2. update username/password."
  sed -i "s@<username>:<password>@qmg:EdB123@" /etc/yum.repos.d/edb.repo 1>/dev/null

  # Install EPEL repository
  echo " "
  echo "step # 3 - installing epel rpm."
  yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm 1>/dev/null

  # Install selected packages
  echo " "
  echo "step # 4 - install advanced server $server."
  yum -y install edb-as$server-server 1>/dev/null
  echo "instalation completes for EPAS $server server"
}

## based on the server provide its associated port
#getPortForServer() {
#  if [[ $server == 10 ]]; then
#    port=5444
#  fi
#  if [[ $server == 11 ]]; then
#    port=5445
#  fi
#  if [[ $server == 12 ]]; then
#    port=5446
#  fi
#  if [[ $server == 13 ]]; then
#    port=5447
#  fi
#  if [[ $server == 14 ]]; then
#    port=5448
#  fi
#  #  echo "port from port area $port"
#  # return "$port"
#}

# initialize and configure server on default paths
initializeServer() {
  echo "server is: $server"
  # get port for server
#  getPortForServer $server
#
#  echo "port is: $port"
  echo "within initialize server1"
  sudo -i -u enterprisedb /bin/sh <<EOF
  sleep 10
  echo $(whoami)
  echo "user changed to enterprisedb"
  # update allowed ips list
  sed -i '/IPv4 local connections/ a\host    all             all               0.0.0.0/0            trust' /var/lib/edb/as$server/data/pg_hba.conf

  cd /usr/edb/as$server/bin
  echo "initializing server $server ..."

  ./initdb -D /var/lib/edb/as$server/data 1>/dev/null
  echo " "
  echo "configuring server ..."
  ./pg_ctl -D /var/lib/edb/as$server/data -o "-p $port" start 1>/dev/null
    echo "initialization of server completes for $server"
EOF
}

#=============
# picks the servers to be installed/configured from 'serverinfo.data' file
getServersForConfigurations() {
  echo "inside fun1"
  file='serverinfo.data'
  while read line; do

    if [[ $line == "epas10"* ]]; then
      servers+=" 10"
    fi

    if [[ $line == "epas11"* ]]; then
      servers+=" 11"
    fi

    if [[ $line == "epas12"* ]]; then
      servers+=" 12"
    fi

    if [[ $line == "epas13"* ]]; then
      servers+=" 13"
    fi

    if [[ $line == "epas14"* ]]; then
      servers+=" 14"
    fi

  done <$file

}

# get server information from file
getServerDetails() {
  serverDetailLine=""
  file='serverinfo.data'
  while read line; do

    if [[ $line == "epas$server"* ]]; then
      serverDetailLine=$line
      break
    fi
  done <$file

  mystring=$requiredInfo
  #for ((i=0; i<${#mystring}; ++i)) ; do
  #    echo "${mystring:i:1}"
  #done

  itr=0
  for serverRequiredInfo in $serverDetailLine; do

    if [ $itr -eq 0 ]; then
      servername=$serverRequiredInfo
    #echo $servername
    fi

    if [ $itr -eq 1 ]; then
      port=$serverRequiredInfo
    #echo $port
    fi

    if [ $itr -eq 2 ]; then
      username=$serverRequiredInfo
    #echo $username
    fi

    if [ $itr -eq 3 ]; then
      databasename=$serverRequiredInfo
    #echo $databasename
    fi

    if [ $itr -eq 4 ]; then
      ipwildcard=$serverRequiredInfo
    #echo $ipwildcard
    fi

    if [ $itr -eq 5 ]; then
      connectiontype=$serverRequiredInfo
    #echo $connectiontype
    fi

    ((itr++))
  done

  # print the detail
  echo "server $server detail is: port $port username $username databasename $databasename ipdwildcard $ipdwildcard "
}
#============

#servers=(10 11 12 13 14)
getServersForConfigurations
for server in ${servers[@]}; do
  {
    echo " "
    echo "installing $server starts."
    echo $server
    getServerDetails $server
    #install server
    installServer $server

    # initialize and configure server
    initializeServer $server $port
    echo "installing $server finished."
    echo " "
  }
done
