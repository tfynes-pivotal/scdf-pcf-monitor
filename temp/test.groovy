import groovy.json.JsonSlurper

// Sample JSON string
def jsonString = '''
{2024-07-31T11:22:54.69-0400 [APP/PROC/WEB/0] OUT 2024-07-31 15:22:54.692  INFO [auth-failures-test-log-v1,9dfe05ff39dce643,c41faa363b4804ae] 20 --- [failures-test-1] auth-failures-test-log-v1                : {"syslog_FACILITY":1,"syslog_SEVERITY":6,"syslog_SEVERITY_TEXT":"INFO","syslog_VERSION":1,"syslog_MESSAGE":"[2024-07-31T15:22:53.687871Z] uaa - 12 [https-jsse-nio-8443-exec-10] - [a1c7d102fc2b48397577918e5c290694,7577918e5c290694] ....  INFO --- Audit: PrincipalAuthenticationFailure ('null'): principal=baduser, origin=[192.168.0.87], identityZoneId=[uaa]","syslog_DECODE_ERRORS":"false","syslog_TIMESTAMP":"2024-07-31T15:22:54.534535Z","syslog_HOST":"192.168.0.221","syslog_APP_NAME":"uaa","syslog_PROCID":"rs2","syslog_MSGID":"-","syslog_STRUCTURED_DATA":["[instance@47450 director=\"\" deployment=\"cf-af8c3af3f5908531ed5a\" group=\"control\" az=\"az1\" id=\"d69c9b76-ecf3-4e86-846f-cebefda74d46\"]"]}
'''

// Parse the JSON string
def jsonSlurper = new JsonSlurper()
def json = jsonSlurper.parseText(jsonString)

println(json);

// Process the JSON object
// println "Name: ${json.name}"
// println "Age: ${json.age}"
// println "Address: ${json.address.street}, ${json.address.city}, ${json.address.zipcode}"

// json.phones.each { phone ->
//     println "Phone (${phone.type}): ${phone.number}"
// }