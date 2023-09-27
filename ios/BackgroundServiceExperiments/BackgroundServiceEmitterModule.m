//
//  BackgroundServiceEmitterModule.m
//  ReactNativeBridgeIos
//
//  Created by Oliver Curtis on 23/09/2023.
//
#import <Foundation/Foundation.h>
#import "React/RCTBridgeModule.h"
#import "React/RCTEventEmitter.h"
#import <BackgroundTasks/BackgroundTasks.h>

@interface RCT_EXTERN_MODULE(BackgroundServiceEmitter, RCTEventEmitter)
RCT_EXTERN_METHOD(emitBackgroundSync)
RCT_EXTERN_METHOD(completedBackgroundSync: (NSString *)taskName result: (BOOL)result)
@end

