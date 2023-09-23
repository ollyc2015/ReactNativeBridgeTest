//
//  BackgroundServiceModule.m
//  ReactNativeBridgeIos
//
//  Created by Oliver Curtis on 23/09/2023.
//

#if __has_include(<React/RCTBridgeModule.h>)
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#elif __has_include(“RCTBridgeModule.h”)
#import "RCTBridgeModule.h"
#import "RCTEventEmitter.h"
#else
#import "React/RCTBridgeModule.h"
#import "React/RCTEventEmitter.h"
#endif

#import <BackgroundTasks/BackgroundTasks.h>

#import <Foundation/Foundation.h>
#import "React/RCTBridgeModule.h"
#import "React/RCTEventEmitter.h"

@interface RCT_EXTERN_MODULE(BackgroundService, RCTEventEmitter)
RCT_EXTERN_METHOD(backgroundTaskExecuting)
RCT_EXTERN_METHOD(setTimeout)
RCT_EXTERN_METHOD(clearTimeout)
RCT_EXTERN_METHOD(startBackgroundTask)
RCT_EXTERN_METHOD(endBackgroundTask)
RCT_EXTERN_METHOD(completeBackgroundProcessing)
RCT_EXTERN_METHOD(scheduleBackgroundProcessing)
RCT_EXTERN_METHOD(cancelBackgroundProcess)
RCT_EXTERN_METHOD(cancelAllScheduledBackgroundProcesses)
@end
