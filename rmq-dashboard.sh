#!/bin/bash


rmq_si_name=$(cf services | grep -m 1 messaging | awk '{print $1}')

cf delete-service-key $rmq_si_name sk1 -f --wait
cf create-service-key $rmq_si_name sk1 --wait

rmq_db_url=$(cf service-key $rmq_si_name sk1 | tail -n +2 | jq -r .credentials.dashboard_url)
echo "rmq_db_url $rmq_db_url"
open $rmq_db_url

rmq_db_username=$(cf service-key $rmq_si_name sk1 | tail -n +2 | jq -r .credentials.username)
echo "rmq_db_username $rmq_db_username"

rmq_db_password=$(cf service-key $rmq_si_name sk1 | tail -n +2 | jq -r .credentials.password)
echo "rmq_db_password $rmq_db_password"
echo $rmq_db_password | pbcopy
