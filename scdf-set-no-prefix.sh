#!/bin/bash

if [ "$#" -ne 1 ];
  then
     echo "Usage scdf-set-no-prefix.sh <dataflow-service-name>" && exit 1
fi

serviceName=$1
dfSpaceName=$(cf service $serviceName --guid)
currentOrg=$(cf target | grep org: | awk '{print $2}')
currentSpace=$(cf target | grep space: | awk '{print $2}')
echo org = $currentOrg
echo space= $currentSpace

cf target -o p-dataflow -s $dfSpaceName
cf set-env skipper SPRING_CLOUD_SKIPPER_SERVER_PLATFORM_CLOUDFOUNDRY_ACCOUNTS[default]_DEPLOYMENT_ENABLERANDOMAPPNAMEPREFIX false
cf restart skipper  
cf target -o $currentOrg -s $currentSpace

