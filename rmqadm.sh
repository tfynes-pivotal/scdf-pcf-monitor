#!/bin/bash


rmq_si_name=$(cf services | grep -m 1 messaging | awk '{print $1}')
rmq_db_url=$(cf service-key $rmq_si_name sk1 | tail -n +2 | jq -r .credentials.dashboard_url)
rmq_username=$(cf service-key $rmq_si_name sk1 | tail -n +2 | jq -r .credentials.username)
rmq_password=$(cf service-key $rmq_si_name sk1 | tail -n +2 | jq -r .credentials.password)
rmq_host=$(cf service-key $rmq_si_name sk1 | tail -n +2 | jq -r '.credentials.http_api_uri | sub(".*?@";"") | sub("\/.*";"")')
vhost=$(cf service-key $rmq_si_name sk1 | tail -n +2 | jq -r .credentials.protocols.amqp.vhost)
/usr/local/sbin/rabbitmqadmin --host $rmq_host --port 443 --ssl  -u $rmq_username -p $rmq_password --vhost $vhost $*