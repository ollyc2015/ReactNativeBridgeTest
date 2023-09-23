//
//  EmitterModule.m
//  ReactNativeBridgeIos
//
//  Created by Oliver Curtis on 22/09/2023.
//

#import <Foundation/Foundation.h>
#import "React/RCTBridgeModule.h"
#import "React/RCTEventEmitter.h"

@interface RCT_EXTERN_MODULE(Emitter, RCTEventEmitter)
RCT_EXTERN_METHOD(startListening)
RCT_EXTERN_METHOD(stopListening)
@end
