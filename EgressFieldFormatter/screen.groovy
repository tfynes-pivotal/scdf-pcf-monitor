import groovy.json.JsonSlurper

def jsonSlurper = new JsonSlurper()
def object = jsonSlurper.parseText(new String(payload))
def smjson = jsonSlurper.parseText(object.syslog_MESSAGE)
def logMap = [:]
logMap['timestamp'] = smjson.timestamp
logMap['src_container_ip'] = smjson.data.packet.src_ip
logMap['src_host_ip']      = smjson.data.source.host_ip
logMap['src_port']   	   = smjson.data.packet.src_port
logMap['dst_ip']     	   = smjson.data.packet.dst_ip
logMap['dst_port']   	   = smjson.data.packet.dst_port
logMap['app_name']         = new URL("https://GuidEnricher.homelab.fynesy.com/AppGuidToName?guid="+smjson.data.source.app_guid).text.trim()
logMap['space_name']       = new URL("https://GuidEnricher.homelab.fynesy.com/SpaceGuidToName?guid="+smjson.data.source.space_guid).text.trim()
logMap['org_name']         = new URL("https://GuidEnricher.homelab.fynesy.com/OrgGuidToName?guid="+smjson.data.source.organization_guid).text.trim()
logMap['app_guid']         = smjson.data.source.app_guid
logMap['space_guid']       = smjson.data.source.space_guid
logMap['org_guid']         = smjson.data.source.organization_guid

return logMap

