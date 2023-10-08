#!/bin/bash

LOCATION=UK
PLATFORM=Linux64
HOME=/opt/PEMBuilds

Date=`date -d "24 hours ago" '+%Y-%m-%d'`
DATEForWithinInstaller=`date +%Y%m%d`

export BUILDS_LOCATION=qmg-automation@builds.enterprisedb.com:/mnt/builds/DailyBuilds/Installers/PEM/v7.0/$DATE/$LOCATION

PEM_UnInstall ()
{

if [ -f "/opt/PEM/server/uninstall-pemserver" ]	
   then
     echo "Going to uninstall previous installation"
     sudo /opt/PEM/server/uninstall-pemserver --mode unattended
     echo "Done with uninstallation"
   else
    echo "No previous installation found"
fi

}

#Copying new installer from builds
Copy_installer ()
{
if scp $BUILDS_LOCATION/pem_server-7.0.0-*linux-x64.run $HOME >&/dev/null ;
   then
{
   echo "The installer has been copied"
}
else
{
     echo "No Installer Found..Exiting " 
     exit 0 ;
}
fi
}

#install the pemserver on the machine
PEM_Install ()
{
	echo "Going to install PEM server "
          sudo $HOME/pem_server-7.0.0-$DATEForWithinInstaller*linux-x64.run --mode unattended --existing-user usman.muzaffar@enterprisedb.com --existing-password Postgres123 --pgport 5436 --pguser postgres --pgpassword postgres --systempassword 123456 --cidr-address 172.0.0.0/8
        echo "Done with install activity"
}

PEM_UnInstall
#Copy_installer
PEM_Install

