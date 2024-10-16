#!/bin/bash

if [ "$#" -ne 1 ];
  then
     echo "Usage shrinkApp.sh <app-name>" && exit 1
fi

appName=$1
echo
echo App Name = $appName
echo
cf stop $appName
cf set-env $appName JAVA_OPTS "-Xmx64m -Xms64m"
#cf scale $appName -m 1024M -k 1024M -f 
cf scale $appName -m 512M -k 512M -f 
#cf scale $appName -m 256M -k 512M -f 
cf restage $appName &