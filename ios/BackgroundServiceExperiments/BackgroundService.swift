//
//  BackgroundService.swift
//  ReactNativeBridgeIos
//
//  Created by Oliver Curtis on 23/09/2023.
//

import Foundation
import UIKit
import React
import BackgroundTasks

@objc(BackgroundService)
public class BackgroundService: NSObject {
  
  private let backgroundServiceEmitter: BackgroundServiceEmitter
  
  @objc public override init() {
    self.backgroundServiceEmitter = BackgroundServiceEmitter()
  }
  
  @objc(scheduleBackgroundProcessing:timeout:resolver:rejecter:)
  public func scheduleBackgroundProcessing(_ taskName: String, timeout: NSNumber, resolver: @escaping RCTPromiseResolveBlock, rejecter: @escaping RCTPromiseRejectBlock) {
      backgroundServiceEmitter.scheduleBackgroundProcessing(taskName, timeout: timeout, resolver: resolver, rejecter: rejecter)
  }
  
  @objc(emitBackgroundSync)
  public func emitBackgroundSync() {
    backgroundServiceEmitter.emitBackgroundSync()
  }
  
  @objc(completedBackgroundSync:result:)
  public func completedBackgroundSync(_ taskName: String, result: Bool) {
      backgroundServiceEmitter.completeBackgroundProcessing(taskName, result: result)
  }
}

