stream create --name PC --definition "syslog --syslog.rfc=5424 --syslog.port=51514 > :PAS-SYSLOG" --deploy
stream create --name pctest --definition ":PAS-SYSLOG > log" --deploy
stream create --name PIS --definition ":PAS-SYSLOG > filter --filter.expression=#jsonPath(payload,'$.syslog_APP_NAME')=='iptables-logger' > :PAS-IP-SYSLOG" --deploy
stream create --name pisgtest --definition ":PAS-IP-SYSLOG > groovy-transform --groovy-transformer.script=https://EgressFieldFormatter.homelab.fynesy.com/screen.groovy > :EGRESS-LOGS" --deploy
stream create --name egresslogtest --definition ":EGRESS-LOGS > log"


# USE C2C TO RESTRICT ACCESS TO GUID->NAME-ENRICHING PROCESSOR
#stream create --name pisgtest --definition ":PAS-IP-SYSLOG > groovy-transform --groovy-transformer.script=http://EgressFieldFormatter.apps.internal:8080/screen.groovy | log" --deploy

# PUT LOGS INTO GEMFIRE!!!
#stream create --name pcctest9 --definition ":EGRESS-LOGS > gemfire --connect-type=locator --host-addresses=10.0.0.126:55221 --key-expression=payload.getField('timestamp') --json=true --region-name=LT --password=xxx --username=xxx" --deploy
