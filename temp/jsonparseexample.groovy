import groovy.json.JsonSlurper

// Sample JSON string
def jsonString = '''
{
    "name": "John Doe",
    "age": 30,
    "address": {
        "street": "123 Main St",
        "city": "Anytown",
        "zipcode": "12345"
    },
    "phones": [
        {
            "type": "home",
            "number": "555-555-5555"
        },
        {
            "type": "mobile",
            "number": "555-555-5556"
        }
    ]
}
'''

// Parse the JSON string
def jsonSlurper = new JsonSlurper()
def json = jsonSlurper.parseText(jsonString)

// Process the JSON object
println "Name: ${json.name}"
println "Age: ${json.age}"
println "Address: ${json.address.street}, ${json.address.city}, ${json.address.zipcode}"

json.phones.each { phone ->
    println "Phone (${phone.type}): ${phone.number}"
}