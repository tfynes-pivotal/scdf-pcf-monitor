#!/bin/bash

if [ "$#" -ne 1 ];
  then 
     echo "Usage rmq-admin-fix-queue.sh <queue-name>" && exit 1
fi

queue=$1

rmq_si_name=$(cf services | grep -m 1 messaging | awk '{print $1}')

#cf delete-service-key $rmq_si_name sk1 -f --wait
#cf create-service-key $rmq_si_name sk1 --wait

rmq_db_url=$(cf service-key $rmq_si_name sk1 | tail -n +2 | jq -r .credentials.dashboard_url)
echo "rmq_db_url $rmq_db_url"
#open $rmq_db_url

rmq_username=$(cf service-key $rmq_si_name sk1 | tail -n +2 | jq -r .credentials.username)
echo "rmq_username $rmq_username"

rmq_password=$(cf service-key $rmq_si_name sk1 | tail -n +2 | jq -r .credentials.password)
echo "rmq_password $rmq_password"
echo $rmq_password | pbcopy

rmq_host=$(cf service-key $rmq_si_name sk1 | tail -n +2 | jq -r '.credentials.http_api_uri | sub(".*?@";"") | sub("\/.*";"")')
echo "rmq_host $rmq_host"

vhost=$(cf service-key $rmq_si_name sk1 | tail -n +2 | jq -r .credentials.protocols.amqp.vhost)
echo "vhost $vhost"

echo "$queue"
/usr/local/sbin/rabbitmqadmin --host $rmq_host --port 443 --ssl  -u $rmq_username -p $rmq_password --vhost $vhost  delete queue name=$queue
#/usr/local/sbin/rabbitmqadmin --host $rmq_host --port 443 --ssl  -u $rmq_username -p $rmq_password --vhost $vhost declare queue name=$queue durable=false arguments='{"x-message-ttl":60000,"x-expires":600000,"x-overflow":"drop-head"}'
/usr/local/sbin/rabbitmqadmin --host $rmq_host --port 443 --ssl  -u $rmq_username -p $rmq_password --vhost $vhost declare queue name=$queue arguments='{"x-message-ttl":60000}'
#/usr/local/sbin/rabbitmqadmin --host $rmq_host --port 443 --ssl  -u $rmq_username -p $rmq_password --vhost $vhost declare queue name=$queue durable=false
