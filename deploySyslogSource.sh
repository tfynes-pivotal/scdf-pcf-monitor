#!/bin/bash

if [ "$#" -ne 5 ];
  then
     echo "Usage deploySyslogSource.sh <dataflow-service-name> <stream-name> <syslog-port> <cf-space> <cf-tcp-domain>" && exit 1
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

#WIP CF deployer not picking up required env update
#stream deploy $streamname --properties "deployer.*.cloudfoundry.health-check=process, deployer.*.cloudfoundry.enable-random-app-name-prefix=false, deployer.*.cloudfoundry.env='JAVA_OPTS=\'-Xmx64m -Xms64m\'', deployer.*.disk=512, deployer.*.memory=256"

# stream create --name $streamname --definition "syslog --rfc=5424 --port=$port > : $streamname"
# --properties "spring.cloud.stream.rabbit.bindings.output.producer.exchangeDurable=false"

cf dfsh $dfservice <<EOF
stream create --name $streamname --definition "syslog --rfc=5424 --port=$port > :$streamname"  
stream deploy $streamname --properties "deployer.*.memory=1024, deployer.*.cloudfoundry.health-check=process, deployer.*.cloudfoundry.enable-random-app-name-prefix=false"
quit
EOF
echo


#stream deploy $streamname --properties "app.*.spring.cloud.stream.rabbit.bindings.input.consumer.durableSubscription=false,app.*.spring.cloud.stream.rabbit.bindings.output.producer.durableSubscription=false,spring.rabbitmq.template.delivery-mode=NON_PERSISTENT,app.*.spring.cloud.stream.rabbit.bindings.output.producer.exchangeDurable=false, deployer.*.memory=1024, deployer.*.cloudfoundry.health-check=process, deployer.*.cloudfoundry.enable-random-app-name-prefix=false"

#echo press any key when syslog source adapter app has started
#read -n 1 -s
echo
syslogappname=$(cf apps | grep $streamname | grep -m 1 syslog | awk '{print $1}')
echo "syslogappname = $syslogappname"

echo
echo Invoking port-adder script
./addAppPort2024.sh $syslogappname $port $space $domain


#stream deploy $streamname --properties "deployer.*.memory=1024, deployer.*.cloudfoundry.health-check=HTTP"
#stream create --name $streamname --definition "syslog --syslog.rfc=5424 --syslog.port=$port | log"
#stream deploy $streamname --properties "deployer.*.memory=1024"
#stream deploy $streamname --properties "deployer.*.memory=1024, deployer.*.cloudfoundry.health-check=HTTP"
