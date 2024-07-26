stream create --name appNames --definition ":cf-syslog > transform --transformer.expression=#jsonPath(payload,'.syslog_APP_NAME') | file --file.mode=APPEND --file.directory=/home/vcap/files/"

