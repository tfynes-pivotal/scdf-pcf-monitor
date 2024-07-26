stream create --name "tas-syslog" --definition "syslog --rfc=5424 --port=51000 > :tas-syslog" --deploy
stream create --name "tas-syslog-tester" --definition ":tas-syslog > log" --deploy
stream create --name "tas-cc-syslog" --definition ":tas-syslog  > filter --filter.expression=#jsonPath(payload,'$.syslog_APP_NAME')=='cloud_controller_ng' > :tas-cc-syslog" --deploy
stream create --name "tas-cc-syslog-tester" --definition ":tas-cc-syslog > log" --deploy
stream create --name "tas-cc-transform" --definition ":tas-cc-syslog > transform --transformer.expression=#jsonPath(payload,'.syslog_MESSAGE') | log" --deploy
