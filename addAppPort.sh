#!/bin/bash

if [ "$#" -ne 4 ];
  then 
     echo "Usage addAppPort.sh <app-name> <app-port> <cf-space> <cf-tcp-domain>" && exit 1
fi



# app name is $1
appname=$1
echo "appname = $appname"
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

# need app guid
appguid=$(cf app $1 --guid)
echo "app guid = $appguid"
echo

# add port to app - assumes that exist port 8080 is only one in use
addAppPortArgs="{\"ports\":[8080, $port]}"
addAppPortCommand="cf curl /v2/apps/$appguid -X PUT -d ""'"$addAppPortArgs"'"""
eval $addAppPortCommand
sleep 2
appports=`cf curl /v2/apps/$appguid | jq .entity.ports`
echo "App Ports = $appports"

#delete route to ensure it's not locked
cf delete-route $domain --port $port -f
sleep 2
#create route if it doesn't exist
cf create-route $space $domain --port $port
sleep 2

# need route guid
routeguid=$(cf curl /v2/routes | jq -r ".resources[] | select(.entity.port==$2)" | jq -r .metadata.guid)
echo "route guid = $routeguid"
echo

postdata="{\"app_guid\":\"$appguid\",\"route_guid\":\"$routeguid\",\"app_port\":$port}"
cf curl /v2/route_mappings -X POST -d "'"$postdata"'"
sleep 2

cf restage $appname
