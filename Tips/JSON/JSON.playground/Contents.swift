
import Cocoa
import Foundation

// Working with JSON in Swift
// https://developer.apple.com/swift/blog/?id=37

print("Example JSON with object root.")
var jsonString = "{\"someKey\": 42.0,\"anotherKey\": {\"someNestedKey\": true}}"
var jsonData = jsonString.data(using: String.Encoding.utf8)!
var jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: [])

print(type(of: jsonObject)) // Optional<Any>

if let json = jsonObject as? [String: Any] {
  if let someKey = json["someKey"] as? Double {
    print(someKey)
  }
  
  if let anotherKey = json["anotherKey"] as? [String: Any] {
    if let nestedKey = anotherKey["someNestedKey"] as? Bool {
      print(nestedKey)
    }
  }
}

print("Example JSON with array root.")
jsonString = "[\"Hello\", 12, true]"
jsonData = jsonString.data(using: String.Encoding.utf8)!
jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: [])

if let array = jsonObject as? [Any] {
  if let firstObject = array.first {
    print(firstObject)
  }
  
  for object in array {
    print(object)
  }
  
  for case let str as String in array {
    print(str)
  }
}
