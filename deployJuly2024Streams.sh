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
stream deploy "$streamName"
stream list
quit
EOF
cat $tmpfile | cf dfsh $scdf_si_name

echo stream created
sleep 5
echo shrinking stream app
echo appname=$(cf apps | grep $streamName | awk '{print $1}')
#appname=$(cf apps | grep $streamName | awk '{print $1}')

for appname in $(cf apps | grep $streamName | awk '{print $1}')
do
echo ./shrinkApp.sh $appname
./shrinkApp.sh $appname &
echo shrink complete
done
}

createDeployShrinkStream "cf-test" ":cf-syslog > log" 
createDeployShrinkStream "uaa-syslog" ":cf-syslog > filter --filter.function.expression='#jsonPath(payload,''$.syslog_APP_NAME'').equals(''uaa'')' > :uaa-syslog" 
createDeployShrinkStream "uaa-test" ":uaa-syslog > log" 

createDeployShrinkStream "auth-failures-syslog" ":uaa-syslog > filter --filter.function.expression='#jsonPath(payload,''$.syslog_MESSAGE'').contains(''PrincipalAuthenticationFailure'')' > :auth-failures-syslog" 
createDeployShrinkStream "auth-failures-test" ":auth-failures-syslog > log" 

createDeployShrinkStream "iptables-logger-syslog" ":cf-syslog > filter --filter.function.expression='#jsonPath(payload,''$.syslog_APP_NAME'').equals(''iptables\-logger'')' > :iptables-logger-syslog" 
createDeployShrinkStream "iptables-logger-test" ":iptables-logger-syslog > log" 

#createDeployShrinkStream "iptables-logger-transform" ":iptables-logger-syslog > groovy --script=https://groovyfilter.homelab.fynesy.com/screen.groovy > :egress-logs" 
#createDeployShrinkStream "iptables-logger-transform-test" ":egress-logs > log"

createDeployShrinkStream "kernel-syslog" ":cf-syslog > filter --filter.function.expression='#jsonPath(payload,''$.syslog_APP_NAME'').equals(''kernel'')' > :kernel-syslog" 
createDeployShrinkStream "kernel-test" ":kernel-syslog > log" 


####createDeployShrinkStream "egress-syslog-message" "kernel-syslog: filter --expression=#jsonPath(payload,'$.syslog_APP_NAME').equals('kernel') :input<:cf-syslog || kernel-syslog-message: transform --expression=#jsonPath(payload,'.syslog_MESSAGE') :input<:kernel-syslog.output || egress-syslog-message: filter --expression=#jsonPath(payload,'$.syslog_APP_NAME').contains('PROTO') :input<:kernel-syslog-message.output || log :input<:egress-syslog-message.output"



#createDeployShrinkStream "appnames-list" ":cf-syslog > transform --expression=#jsonPath(payload,'.syslog_APP_NAME') | file --directory=/tmp/logs --mode=APPEND :input<:transform.output"




# kernel-syslog: filter --expression=#jsonPath(payload,'$.syslog_APP_NAME').equals('kernel') :input<:cf-syslog || egress-syslog: filter --expression=#jsonPath(payload,'$.syslog_APP_NAME').contains('PROTO') :input<:kernel-syslog.output || egress-log-message: transform --expression=#jsonPath(payload,'.syslog_MESSAGE') :input<:egress-syslog.output || log :input<:egress-log-message.output
#


# rabbitmqadmin -H 192.168.0.233 -u 48ba159d-74d4-4f7d-a24c-4cdb562d582c -p YRs7WoAkUxtZwDcVGrH20MBB list queues