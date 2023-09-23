// Emitter.swift
import Foundation
import React
import RxSwift

@objc(Emitter)
class Emitter: RCTEventEmitter {
  let C_UNREAD_EVENT: String = "EventUnread";
  var disposableEmitter: Disposable? = nil;
  
  override func supportedEvents() -> [String]! {
    return [C_UNREAD_EVENT]
  }
    
  @objc
  func startListening() {
    if(disposableEmitter == nil){
      disposableEmitter = Observable<Int>.interval(.milliseconds(1000), scheduler: MainScheduler.instance)
        .subscribe({ longTimed in
          self.sendEvent(withName: self.C_UNREAD_EVENT, body: ["count": longTimed.element])
        });
    }
  }
  
  @objc
  func stopListening() {
    disposableEmitter?.dispose()
    disposableEmitter = nil
  }
  
  override static func requiresMainQueueSetup() -> Bool { return false }
}
