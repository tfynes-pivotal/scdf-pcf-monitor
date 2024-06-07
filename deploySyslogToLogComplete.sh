#!/bin/bash

if [ "$#" -ne 4 ];
  then
     echo "Usage deploySyslogToLogComplete.sh <stream-name> <syslog-port> <cf-space> <cf-tcp-domain>" && exit 1
fi

# app name is $1
streamname=$1
echo "stream_name = $streamname"
# port is $2
port=$2
echo "port = $port"
echo
space=$3
echo "space = $space"
echo
domain=$4
echo "domain = $domain"
echo

cf dfsh ds1 <<EOF
stream create --name $streamname --definition "syslog --syslog.rfc=5424 --syslog.port=$port | log"
stream deploy $streamname --properties "deployer.*.memory=1024"
#stream deploy $streamname --properties "deployer.*.memory=1024, deployer.*.cloudfoundry.health-check=HTTP"
quit
EOF
echo
echo press any key when syslog source adapter app has started
read -n 1 -s
echo
syslogappname=$(cf apps | grep $streamname | grep -m 1 syslog | awk '{print $1}')
echo "syslogappname = $syslogappname"

echo
echo Invoking port-adder script
./addAppPort2024.sh $syslogappname $port $space $domain


