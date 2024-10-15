#!/bin/bash

if [ "$#" -ne 5 ];
  then
     echo "Usage deploySyslogToLogComplete.sh <dataflow-service-name> <stream-name> <syslog-port> <cf-space> <cf-tcp-domain>" && exit 1
fi

dfservice=$1
# app name is $2
streamname=$2
echo "stream_name = $streamname"
# port is $3
port=$3
echo "port = $port"
echo
space=$4
echo "space = $space"
echo
domain=$5
echo "domain = $domain"
echo

cf dfsh $dfservice <<EOF
stream create --name $streamname --definition "syslog --rfc=5424 --port=$port | log"
stream deploy $streamname --properties "deployer.*.memory=1024, deployer.*.cloudfoundry.health-check=process"
quit
EOF
echo
#echo press any key when syslog source adapter app has started
#read -n 1 -s
echo
syslogappname=$(cf apps | grep $streamname | grep -m 1 syslog | awk '{print $1}')
echo "syslogappname = $syslogappname"

echo
echo Invoking port-adder script
./addAppPort.sh $syslogappname $port $space $domain


#stream deploy $streamname --properties "deployer.*.memory=1024, deployer.*.cloudfoundry.health-check=HTTP"
#stream create --name $streamname --definition "syslog --syslog.rfc=5424 --syslog.port=$port | log"
#stream deploy $streamname --properties "deployer.*.memory=1024"
#stream deploy $streamname --properties "deployer.*.memory=1024, deployer.*.cloudfoundry.health-check=HTTP"
