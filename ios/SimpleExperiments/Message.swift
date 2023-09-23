import Foundation
import React

@objc(Message)
class Message: NSObject {
  @objc
  func constantsToExport() -> [AnyHashable : Any]! {
    return [
      "number": 123.9,
      "string": "foo",
      "boolean": true,
      "array": [1, 22.2, "33"],
      "object": ["a": 1, "b": 2]
    ]
  }
  
  @objc static func requiresMainQueueSetup() -> Bool { return true }
  
  @objc
  func printHelloWorld() {
    print("Hello World from Swift file!")
  }
  
  // Define a typealias for the callback function
  typealias RCTResponseSenderBlock = ([Any]?) -> Void
  
  @objc
  func getUnreadCount(_ callback: @escaping RCTResponseSenderBlock) {
    callback([10])
  }
}
