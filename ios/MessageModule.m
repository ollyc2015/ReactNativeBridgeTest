//
//  MessageModule.m
//  ReactNativeBridgeIos
//
//  Created by Oliver Curtis on 22/09/2023.
//

#import <Foundation/Foundation.h>
#import "React/RCTBridgeModule.h"

@interface RCT_EXTERN_MODULE(Message, NSObject)
RCT_EXTERN_METHOD(printHelloWorld)
RCT_EXTERN_METHOD(getUnreadCount: (RCTResponseSenderBlock)callback)
@end
