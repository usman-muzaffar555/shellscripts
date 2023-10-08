#!/bin/bash

MAJOR_VERSION=6.0.6
LOCATION=UK
PLATFORM=Linux64
HOME=/opt/CTO
export ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe
export PATH=$PATH:$ORACLE_HOME
export LD_LIBRARY_PATH=$ORACLE_HOME/lib:$LD_LIBRARY_PATH
export TNS_ADMIN=$ORACLE_HOME/network/admin
RSYNC_QUEUE=$HOME/rsync.queue
export RSYNC_PASSWORD=buildfarm
export TZ=Asia/Karachi

DATE=`date +%Y-%m-%d`
export BUILDS_LOCATION=buildfarm@builds.enterprisedb.com:/mnt/builds/DailyBuilds/Installers/XDB/$DATE/$MAJOR_VERSION/$LOCATION

XDB_Install ()
{
     sudo /opt/PostgreSQL/EnterpriseDB-xDBReplicationServer/uninstall-xdbreplicationserver --mode unattended
     sudo rm -rf /opt/PostgreSQL/EnterpriseDB-xDBReplicationServer
     sudo rm -rf /var/log/xdb*
     sudo rm -rf /var/run/edb/xdb*
     rm -rf $HOME/install
     sudo $HOME/xdbreplicationserver*linux-x64.run --admin_password edb --register 0 --mode unattended
     sudo sed -i "s,#logging.level=WARNING,logging.level=INFO," /opt/PostgreSQL/EnterpriseDB-xDBReplicationServer/etc/xdb_pubserver.conf
     sudo sed -i "s,#logging.level=WARNING,logging.level=INFO," /opt/PostgreSQL/EnterpriseDB-xDBReplicationServer/etc/xdb_subserver.conf
     if [[ $1 != *"control" ]]; then
     sudo sed -i "s,#persistZeroTxRepEvent=false,persistZeroTxRepEvent=true," /opt/PostgreSQL/EnterpriseDB-xDBReplicationServer/etc/xdb_pubserver.conf
     fi
}

Fresh_InitDB ()
{
      MODE=''
      if [ $1 = ppas ]; then
          DB_PATH=/opt/PostgresPlus/9.4AS
          DATA=$HOME/data-ppas
          USER=enterprisedb
          if [ $2 = pg ]; then
             USER=postgres 
             MODE=--no-redwood-compat
          fi
      else
         DB_PATH=/opt/PostgreSQL/9.4
         DATA=$HOME/data-pg
         USER=postgres
      fi

      $DB_PATH/bin/pg_ctl -D $DATA stop
      rm -rf $DATA
      $DB_PATH/bin/initdb -D $DATA -U $USER $MODE --no-locale -E UTF8
      sed -i "s,#listen_addresses = 'localhost',listen_addresses = '*'," $DATA/postgresql.conf
      sed -i "s,#wal_level = minimal,wal_level = logical," $DATA/postgresql.conf
      sed -i "s,#max_wal_senders = 0,max_wal_senders = 20," $DATA/postgresql.conf
      sed -i "s,#max_replication_slots = 0,max_replication_slots = 10," $DATA/postgresql.conf
      sed -i "/IPv4 local connections/ a\host    all             all               0.0.0.0/0            trust" $DATA/pg_hba.conf
      sed -i "/replication privilege/ a\host   replication    all                   0.0.0.0/0            trust" $DATA/pg_hba.conf
      sed -i "/replication privilege/ a\host   replication    all                   127.0.0.1/32            trust" $DATA/pg_hba.conf
      sed -i "/replication privilege/ a\host   replication    all                   ::1/128            trust" $DATA/pg_hba.conf
      sed -i "s,#local   replication,local   replication," $DATA/pg_hba.conf
      sed -i "s,#host   replication,host   replication," $DATA/pg_hba.conf
      $DB_PATH/bin/pg_ctl -D $DATA start -U $USER
}

Extract_CTO ()
{
    cd $HOME
    unzip CTO.linux-x64.zip
    rm -rf $HOME/install/conf/*
    rm -rf $HOME/install/expected-results/*
    rm -rf $HOME/install/testcases/*
    sudo cp -rp $HOME/ojdbc6.jar /opt/PostgreSQL/EnterpriseDB-xDBReplicationServer/lib/jdbc/
    cp -rp /opt/PostgreSQL/EnterpriseDB-xDBReplicationServer/lib/jdbc/* $HOME/install/lib
}

Copy_Setup ()
{
    if [[ ! -z "$4" ]]; then
       cd $HOME/XDB/CTO/QMG/xdb/$1/$3/$2-$4/
    else
       cd $HOME/XDB/CTO/QMG/xdb/$1/$3/$2-$2/
    fi
    cp -rp install/* $HOME/install/
    cp -rp conf/* $HOME/install/conf
    cp -rp testcases/* $HOME/install/testcases
    cp -rp expected-results/* $HOME/install/expected-results
    sed -i 's/localhost/192.168.1.117/g' $HOME/install/conf/config.xml
    sed -i 's/localhost/192.168.1.117/g' $HOME/install/pubsvr.prop
    sed -i 's/localhost/192.168.1.117/g' $HOME/install/subsvr.prop
}

Service_Restart ()
{
   sudo /etc/init.d/edb-xdbpubserver restart
   sudo /etc/init.d/edb-xdbsubserver restart
}

Rsync_Results ()
{
   cd $HOME/install
   RSYNC_FILENAME_BASE="XDB$(echo $MAJOR_VERSION | cut -f1-2 -d"." --output-delimiter="")$LOCATION-$PLATFORM-CTO.$1-`date +%Y-%m-%d_%H-%M-%S_%s`"
   find actual-results/* | xargs -I{} echo "diff -u expected-results/\`basename {}\` actual-results/\`basename {}\`" | sh > $RSYNC_FILENAME_BASE.diff
   mv $1.cto $RSYNC_FILENAME_BASE.cto
   mkdir -p $RSYNC_QUEUE/Temp
   cp -rp $RSYNC_FILENAME_BASE.* $RSYNC_QUEUE/Temp
   cp -rp $HOME/xdb-6.0/* $RSYNC_QUEUE/Temp
   cd $RSYNC_QUEUE/Temp/
   mv mtk.log $RSYNC_FILENAME_BASE.mtk
   mv edb-xdbpubserver.log $RSYNC_FILENAME_BASE.xdbpubserver
   mv edb-xdbsubserver.log $RSYNC_FILENAME_BASE.xdbsubserver
   mv pubserver.log.0 $RSYNC_FILENAME_BASE.pubserver
   mv subserver.log.0 $RSYNC_FILENAME_BASE.subserver
   zip -r $RSYNC_FILENAME_BASE.zip $RSYNC_FILENAME_BASE*
   mv $RSYNC_FILENAME_BASE.zip $RSYNC_QUEUE
   cd $HOME
   rm -rf $RSYNC_QUEUE/Temp
   RSYNC_PASSWORD=$RSYNC_PASSWORD; export $RSYNC_PASSWORD; rsync -azv --remove-source-files $RSYNC_QUEUE/* edb@cm-dashboard.enterprisedb.com::buildfarm
}

Clean_Up ()
{
     cd $HOME
     mkdir $1-$DATE
     cp -rp install $1-$DATE
     sudo cp -rp /var/log/xdb* .
     sudo chown -R enterprisedb:enterprisedb xdb-6.0
     cp -rp xdb-6.0/* $1-$DATE
     tar cvfz $1-$DATE.tar.gz $1-$DATE
     mv $1-$DATE.tar.gz $HOME/logs
     rm -rf $1-$DATE
     sudo rm -rf /tmp/.s.PGSQL.54*
     sudo pkill -9 postgres
}

Execute_CTO ()
{
cd $HOME

   XDB_Install $2-$1
   Extract_CTO
   if [[ ! -z "$5" ]]; then
      Copy_Setup $3 $2 $4 $5
      Fresh_InitDB $2 $5
      Fresh_InitDB $5
   else
     Copy_Setup $3 $2 $4
     Fresh_InitDB $2
    fi
   Service_Restart
   cd $HOME/install
   chmod +x runCTO.sh
   if [[ ! -z "$5" ]]; then
       ./runCTO.sh > $22$5.$1.cto 2>&1
       Clean_Up $2-$1
       Rsync_Results $22$5.$1
  else
       ./runCTO.sh > $22$2.$1.cto 2>&1
       Clean_Up $2-$1
       Rsync_Results $22$2.$1
   fi
   rm -rf $HOME/xdb-*
}

#Deleting old installers
cd $HOME
rm -rf xdbreplicationserver*linux-x64.run
rm -rf CTO.linux-x64.zip
sudo /etc/init.d/ppas-9.4 stop
sudo /etc/init.d/postgresql-9.4 stop

#Copying new installer from builds

if scp $BUILDS_LOCATION/xdbreplicationserver*linux-x64.run ./ >&/dev/null ;
   then
{
    scp $BUILDS_LOCATION/CTO.linux-x64.zip .
}
else
{
     echo "No Installer Found..Exiting " 
     exit 0 ;
}
fi

cd $HOME/XDB
git pull

pkill -9 enterprisedb

Execute_CTO logical ppas xdb-Logical mmr

Execute_CTO logical pg xdb-Logical mmr

Execute_CTO trigger ppas xdb-trigger mmr

Execute_CTO trigger pg xdb-trigger mmr

Execute_CTO SMR sqlserver xdb-trigger smr ppas

Execute_CTO SMR ora xdb-trigger smr ppas

Execute_CTO SMR ppas xdb-trigger smr

Execute_CTO SMR pg xdb-trigger smr

Execute_CTO SMR pg xdb-trigger smr ppas

Execute_CTO SMR ppas xdb-trigger smr pg

Execute_CTO SMRlogical ppas xdb-Logical smr

Execute_CTO SMRlogical pg xdb-Logical smr

Execute_CTO SMRlogical ppas xdb-Logical smr pg

Execute_CTO SMRlogical pg xdb-Logical smr ppas

Execute_CTO triggercontrol ppas control_schema_trigger mmr

Execute_CTO triggercontrol pg control_schema_trigger mmr

Execute_CTO logicalcontrol ppas control_schema_logical mmr

Execute_CTO logicalcontrol pg control_schema_logical mmr

pkill -9 enterprisedb
