//
// BackgroundServiceEmitter.swift
// ReactNativeBridgeIos
//
// Created by Oliver Curtis on 23/09/2023.
//

import Foundation
import UIKit
import React
import BackgroundTasks

@objc(BackgroundServiceEmitter)
class BackgroundServiceEmitter: RCTEventEmitter {

  override func supportedEvents() -> [String] {
    return ["BackgroundTaskExpired", "BackgroundProcessingExecuting", "BackgroundProcessingExpired"]
  }
  
  public static var shared: BackgroundServiceEmitter?
  var executingTasks: [String: BGProcessingTask] = [:]
  
  override init() {
      super.init()
    BackgroundServiceEmitter.shared = self
    }

  func scheduleBackgroundProcessing(_ taskName: String, timeout: NSNumber, resolver: @escaping RCTPromiseResolveBlock, rejecter: @escaping RCTPromiseRejectBlock) {
    let taskRequest = BGProcessingTaskRequest(identifier: taskName)
    taskRequest.earliestBeginDate = Date(timeIntervalSinceNow: timeout.doubleValue)
    taskRequest.requiresNetworkConnectivity = true

    do {
      try BGTaskScheduler.shared.submit(taskRequest)
      print("Success submit request \(taskRequest)")
      resolver(taskName)
    } catch {
      rejecter("ReactNativeBackgroundService", "Cannot schedule task: '\(taskName)' with timeout: \(timeout), error: \(error.localizedDescription)", nil)
    }
  }

  @objc(emitBackgroundSync)
  func emitBackgroundSync() {
      self.sendEvent(withName: "BackgroundProcessingExecuting", body: ["result": "Sync triggered"])
  }

  @objc(completeBackgroundProcessing:result:)
  func completeBackgroundProcessing(_ taskName: String, result: Bool) {
    print("Finished background processing with result: \(result)")
    if let task = executingTasks[taskName] {
      executingTasks.removeValue(forKey: taskName)
      task.setTaskCompleted(success: result)
    }
  }

  override static func requiresMainQueueSetup() -> Bool { return true }
}
