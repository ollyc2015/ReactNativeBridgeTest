// BackgroundService.swift
// ReactNativeBridgeIos
//
// Created by Oliver Curtis on 23/09/2023.
//
import Foundation
import UIKit
import React
import BackgroundTasks
@objc(BackgroundService)
public class BackgroundService: NSObject {
  
  @objc(scheduleBackgroundProcessing:timeout:resolver:rejecter:)
  public func scheduleBackgroundProcessing(_ taskName: String, timeout: NSNumber, resolver: @escaping RCTPromiseResolveBlock, rejecter: @escaping RCTPromiseRejectBlock) {
    BackgroundServiceEmitter.shared?.scheduleBackgroundProcessing(taskName, timeout: timeout, resolver: resolver, rejecter: rejecter)
  }
  
  @objc(emitBackgroundSync)
  public func emitBackgroundSync() {
    BackgroundServiceEmitter.shared?.emitBackgroundSync()
  }
  
  @objc(completedBackgroundSync:result:)
  public func completedBackgroundSync(_ taskName: String, result: Bool) {
    BackgroundServiceEmitter.shared?.completeBackgroundProcessing(taskName, result: result)
  }
  
}
