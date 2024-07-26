stream create --name "iptables-logger-syslog" --definition ":cf-syslog > filter --filter.expression=#jsonPath(payload,'$.syslog_APP_NAME')==iptables-logger > :iptables-logger-syslog"
stream deploy "iptables-logger-syslog" --properties "deployer.*.memory=1024, deployer.*.cloudfoundry.health-check=process, deployer.*.cloudfoundry.enable-random-app-name-prefix=false"
