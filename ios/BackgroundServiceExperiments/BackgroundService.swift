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
class BackgroundService: RCTEventEmitter {

    override static func moduleName() -> String {
        return "BackgroundService"
    }

    override func supportedEvents() -> [String] {
        return ["BackgroundTaskExpired", "BackgroundProcessingExecuting", "BackgroundProcessingExpired"]
    }

    var pendingTimers: [String: DispatchWorkItem] = [:]
    var pendingBackgroundTasks: [String: UIBackgroundTaskIdentifier] = [:]
    var executingTasks: [String: BGProcessingTask] = [:]
    var hasListeners: Bool = false

    override init() {
        super.init()
        self.hasListeners = false
    }

    override func startObserving() {
        self.hasListeners = true
    }

    override func stopObserving() {
        self.hasListeners = false
    }

    @objc(backgroundTaskExecuting:)
    func backgroundTaskExecuting(_ task: BGProcessingTask) {
        let identifier = task.identifier

        print("Background task executing: \(identifier)")
        if self.hasListeners {
            task.expirationHandler = { [weak self] in
                guard let self = self else { return }

                if self.hasListeners {
                    self.sendEvent(withName: "BackgroundProcessingExpired", body: ["taskName": identifier])
                } else {
                    print("No listeners to handle expiration. Aborting.")
                    if let executingTask = self.executingTasks[identifier] {
                        self.executingTasks.removeValue(forKey: identifier)
                        executingTask.setTaskCompleted(success: true)
                    }
                }
            }

            executingTasks[identifier] = task
            self.sendEvent(withName: "BackgroundProcessingExecuting", body: ["taskName": identifier])
        } else {
            print("No listeners to handle task execution. Aborting.")
            task.setTaskCompleted(success: true)
        }
    }

    @objc(setTimeout:timeoutId:resolver:rejecter:)
    func setTimeout(_ timeout: NSNumber, timeoutId: String, resolver: @escaping RCTPromiseResolveBlock, rejecter: @escaping RCTPromiseRejectBlock) {
        print("Started timeout nr \(timeoutId) for \(timeout)")
        let work = DispatchWorkItem { [weak self] in
            guard let self = self else { return }

            print("Got timeout nr \(timeoutId)")
            self.pendingTimers.removeValue(forKey: timeoutId)
            resolver(timeoutId)
        }
        let delayTime = DispatchTime.now() + .milliseconds(Int(timeout.doubleValue * 1000))
        DispatchQueue.main.asyncAfter(deadline: delayTime, execute: work)
        pendingTimers[timeoutId] = work
    }

    @objc(clearTimeout:)
    func clearTimeout(_ timeoutId: String) {
        print("Cleared timeout nr \(timeoutId)")
        if let block = pendingTimers[timeoutId] {
            block.cancel()
            pendingTimers.removeValue(forKey: timeoutId)
        }
    }

    @objc(startBackgroundTask:resolver:rejecter:)
    func startBackgroundTask(_ taskName: String, resolver: @escaping RCTPromiseResolveBlock, rejecter: @escaping RCTPromiseRejectBlock) {
        let identifier = UIApplication.shared.beginBackgroundTask(withName: taskName) {
            print("Background task \(taskName) expired")
            if let taskId = self.pendingBackgroundTasks[taskName] {
                if self.hasListeners {
                    self.sendEvent(withName: "BackgroundTaskExpired", body: ["taskName": taskName])
                } else {
                    print("Automatically ending background task \(taskName)")
                    UIApplication.shared.endBackgroundTask(taskId)
                    self.pendingBackgroundTasks.removeValue(forKey: taskName)
                }
            }
        }

        if identifier == UIBackgroundTaskIdentifier.invalid {
            print("Failed to start background task \(taskName)")
            rejecter("ReactNativeBackgroundService", "Cannot start background task with id: \(taskName)", nil)
            return
        }

        print("Started background task \(taskName) with id: \(identifier.rawValue)")
        pendingBackgroundTasks[taskName] = identifier
        resolver(taskName)
    }

    @objc(endBackgroundTask:)
    func endBackgroundTask(_ taskName: String) {
        print("Ending background task \(taskName)")
        if let taskId = pendingBackgroundTasks[taskName] {
          UIApplication.shared.endBackgroundTask(UIBackgroundTaskIdentifier(rawValue: taskId.rawValue))
            pendingBackgroundTasks.removeValue(forKey: taskName)
        }
    }

    @objc(completeBackgroundProcessing:result:)
    func completeBackgroundProcessing(_ taskName: String, result: Bool) {
        print("Finished background processing with result: \(result)")
        if let task = executingTasks[taskName] {
            executingTasks.removeValue(forKey: taskName)
            task.setTaskCompleted(success: result)
        }
    }

  @objc(scheduleBackgroundProcessing:timeout:resolver:rejecter:)
  func scheduleBackgroundProcessing(_ taskName: String, timeout: NSNumber, resolver: @escaping RCTPromiseResolveBlock, rejecter: @escaping RCTPromiseRejectBlock) {
      let taskRequest = BGProcessingTaskRequest(identifier: taskName)
      taskRequest.earliestBeginDate = Date(timeIntervalSinceNow: timeout.doubleValue)
      taskRequest.requiresNetworkConnectivity = true

      do {
          try BGTaskScheduler.shared.submit(taskRequest)
          resolver(taskName)
      } catch {
          rejecter("ReactNativeBackgroundService", "Cannot schedule task: '\(taskName)' with timeout: \(timeout), error: \(error.localizedDescription)", nil)
      }
  }

    @objc(cancelBackgroundProcess:)
    func cancelBackgroundProcess(_ taskName: String) {
        BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: taskName)
    }

    @objc(cancelAllScheduledBackgroundProcesses)
    func cancelAllScheduledBackgroundProcesses() {
        BGTaskScheduler.shared.cancelAllTaskRequests()
    }
}
