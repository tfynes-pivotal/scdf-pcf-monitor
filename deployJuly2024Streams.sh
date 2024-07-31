#!/bin/bash


scdf_si_name=ds1
tmpfile='streams.tmp'

# cat > "./$tmpfile" << EOF 
# stream list
# quit
# EOF

# cat "./$tmpfile" | cf dfsh ds3

# echo done


function createDeployShrinkStream() {
streamName=$1
streamDefinition=$2

tmpfile='streams.tmp'
cat > "$tmpfile" << EOF
stream list
stream create --name "$streamName" --definition "$streamDefinition" 
stream deploy "$streamName" --properties "deployer.*.memory=1024, deployer.*.cloudfoundry.health-check=process"
stacktrace
stream list
quit
EOF
cat $tmpfile
cat $tmpfile | cf dfsh $scdf_si_name

#stream deploy "$streamName" --properties "deployer.*.memory=1024, deployer.*.cloudfoundry.health-check=process, deployer.*.cloudfoundry.enable-random-app-name-prefix=false"

#stream deploy "$streamName"   --properties "deployer.*.memory=1024, deployer.*.cloudfoundry.health-check=process, deployer.*.cloudfoundry.enable-random-app-name-prefix=false"
#stream deploy "$streamName" --properties "app.*.spring.cloud.stream.rabbit.bindings.output.producer.exchangeDurable=false,app.*.spring.cloud.stream.rabbit.bindings.input.consumer.durableSubscription=false,app.*.spring.cloud.stream.rabbit.bindings.output.producer.durableSubscription=false,spring.rabbitmq.template.delivery-mode=NON_PERSISTENT"
#stream deploy "$streamName" --properties "app.*.spring.cloud.stream.rabbit.bindings.input.consumer.durableSubscription=false,app.*.spring.cloud.stream.rabbit.bindings.output.producer.durableSubscription=false,spring.rabbitmq.template.delivery-mode=NON_PERSISTENT"

echo stream created
#sleep 5
#echo shrinking stream app
#echo appname=$(cf apps | grep $streamName | awk '{print $1}')

#for appname in $(cf apps | grep $streamName | awk '{print $1}')
#do
#echo ./shrinkApp.sh $appname
#./shrinkApp.sh $appname &
#echo shrink complete
#done
}

#createDeployShrinkStream "cf-test" ":cf-syslog > log" 

#createDeployShrinkStream "uaa-syslog" ":cf-syslog > filter --filter.function.expression='#jsonPath(payload,''$.syslog_APP_NAME'').equals(''uaa'')' > :uaa-syslog" 
#createDeployShrinkStream "uaa-test" ":uaa-syslog > log" 

#createDeployShrinkStream "kernel-syslog" ":cf-syslog > filter --filter.function.expression='#jsonPath(payload,''$.syslog_APP_NAME'').equals(''kernel'')' > :kernel-syslog" 
#createDeployShrinkStream "kernel-test" ":kernel-syslog > log" 

createDeployShrinkStream "auth-failures-syslog" ":uaa-syslog > filter --filter.function.expression='#jsonPath(payload,''$.syslog_MESSAGE'').contains(''PrincipalAuthenticationFailure'')' > :auth-failures-syslog" 
createDeployShrinkStream "auth-failures-test" ":auth-failures-syslog > log" 

#createDeployShrinkStream "iptables-logger-syslog" ":cf-syslog > filter --filter.function.expression='#jsonPath(payload,''$.syslog_APP_NAME'').equals(''iptables\-logger'')' > :iptables-logger-syslog" 
#createDeployShrinkStream "iptables-logger-test" ":iptables-logger-syslog > log" 

#createDeployShrinkStream "iptables-logger-transform" ":iptables-logger-syslog > groovy --script=https://groovyfilter.homelab.fynesy.com/screen.groovy > :egress-logs" 
#createDeployShrinkStream "iptables-logger-transform-test" ":egress-logs > log"


#createDeployShrinkStream "kernel-message-syslog" ":kernel-syslog > transform --expression='#jsonPath(payload,''.syslog_MESSAGE'')' > :kernel-message-syslog" 
#createDeployShrinkStream "kernel-message-test" ":kernel-message-syslog > log" 

####createDeployShrinkStream "egress-syslog-message" "kernel-syslog: filter --expression=#jsonPath(payload,'$.syslog_APP_NAME').equals('kernel') :input<:cf-syslog || kernel-syslog-message: transform --expression=#jsonPath(payload,'.syslog_MESSAGE') :input<:kernel-syslog.output || egress-syslog-message: filter --expression=#jsonPath(payload,'$.syslog_APP_NAME').contains('PROTO') :input<:kernel-syslog-message.output || log :input<:egress-syslog-message.output"



#createDeployShrinkStream "appnames-list" ":cf-syslog > transform --expression=#jsonPath(payload,'.syslog_APP_NAME') | file --directory=/tmp/logs --mode=APPEND :input<:transform.output"




# kernel-syslog: filter --expression=#jsonPath(payload,'$.syslog_APP_NAME').equals('kernel') :input<:cf-syslog || egress-syslog: filter --expression=#jsonPath(payload,'$.syslog_APP_NAME').contains('PROTO') :input<:kernel-syslog.output || egress-log-message: transform --expression=#jsonPath(payload,'.syslog_MESSAGE') :input<:egress-syslog.output || log :input<:egress-log-message.output
#


# rabbitmqadmin -H 192.168.0.233 -u 48ba159d-74d4-4f7d-a24c-4cdb562d582c -p YRs7WoAkUxtZwDcVGrH20MBB list queues
#rabbitmqadmin -u d02a09b8-6b86-4dae-b7e0-d3689baa3f45  -p VzIu8NViUuMc9Z4rMVpvwqMH --port 443 --host rmq-a97fc814-210b-4c05-85b7-c4d3fbd27fe6.homelab.fynesy.com --ssl list queues
# rabbitmqadmin -u d02a09b8-6b86-4dae-b7e0-d3689baa3f45  -p VzIu8NViUuMc9Z4rMVpvwqMH --port 443 --host rmq-a97fc814-210b-4c05-85b7-c4d3fbd27fe6.homelab.fynesy.com --ssl declare queue name=foo.foo --vhost a97fc814-210b-4c05-85b7-c4d3fbd27fe6I

# create queue example
# rabbitmqadmin --host rmq-2aba9696-78ad-41d3-823b-92cac5f0083d.homelab.fynesy.com --port 443 --ssl  -u 050fc8c7-6ac4-48da-aade-9108c5b4ddce -p YbKRE0L42W9gUKxuifoOJPs- --vhost 2aba9696-78ad-41d3-823b-92cac5f0083d declare queue name=foo.foo

#rabbitmqadmin --host rmq-2aba9696-78ad-41d3-823b-92cac5f0083d.homelab.fynesy.com --port 443 --ssl  -u 050fc8c7-6ac4-48da-aade-9108c5b4ddce -p YbKRE0L42W9gUKxuifoOJPs- --vhost 2aba9696-78ad-41d3-823b-92cac5f0083d declare queue name=foo.foo durable=false arguments='{"x-message-ttl":60000,"x-overflow":"drop-head"}'


# SPRING_CLOUD_SKIPPER_SERVER_PLATFORM_CLOUDFOUNDRY_ACCOUNTS[default]_DEPLOYMENT_ENABLERANDOMAPPNAMEPREFIX false
# SPRING_CLOUD_SKIPPER_SERVER_PLATFORM_CLOUDFOUNDRY_ACCOUNTS[default]_DEPLOYMENT_ENABLERANDOMAPPNAMEPREFIX
# SPRING_CLOUD_DATAFLOW_TASK_PLATFORM_CLOUDFOUNDRY_ACCOUNTS[default]_DEPLOYMENT_ENABLE_RANDOM_APP_NAME_PREFIX