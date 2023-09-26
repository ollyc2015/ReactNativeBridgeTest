//
//  BackgroundServiceModule.m
//  ReactNativeBridgeIos
//
//  Created by Oliver Curtis on 23/09/2023.
//
#import <Foundation/Foundation.h>
#import "React/RCTBridgeModule.h"
#import "React/RCTEventEmitter.h"
#import "ReactNativeBridgeIos-Swift.h"
#import <BackgroundTasks/BackgroundTasks.h>

@interface RCT_EXTERN_MODULE(BackgroundService, RCTEventEmitter)
RCT_EXTERN_METHOD(scheduleBackgroundProcessing:(NSString *)taskName timeout:(nonnull NSNumber *)timeout resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
RCT_EXTERN_METHOD(cancelBackgroundProcess:(NSString *)taskName)
RCT_EXTERN_METHOD(cancelAllScheduledBackgroundProcesses)
RCT_EXTERN_METHOD(backgroundTaskExecuting:(NSString *)taskName)
@end

