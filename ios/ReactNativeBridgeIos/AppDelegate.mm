#import "AppDelegate.h"
#import <BackgroundTasks/BackgroundTasks.h>
#import <React/RCTBundleURLProvider.h>
#import <UIKit/UIKit.h>
#import "ReactNativeBridgeIos-Swift.h"

@implementation AppDelegate

static NSString* uploadTask = @"MyLongRunningTask";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.moduleName = @"ReactNativeBridgeIos";
  self.initialProps = @{};

  // Register your background task
      if (@available(iOS 13.0, *)) {
          [[BGTaskScheduler sharedScheduler] registerForTaskWithIdentifier:uploadTask usingQueue:nil launchHandler:^(__kindof BGTask *task) {
              [self handleBackgroundFetchTask:task];
          }];
      }

  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)handleBackgroundFetchTask:(BGTask *)task {
  NSLog(@"Background sync triggered!!");
 // BackgroundService *backgroundService = [[BackgroundService alloc] init];
  //[backgroundService emitBackgroundSync];
    // Complete the task with the appropriate result
    [self completeBackgroundTask:task];
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // This method is called when a background fetch is triggered.
     NSLog(@"Background sync triggered!");
    // Add your custom logic here to handle the background fetch.

   BackgroundService *backgroundService = [[BackgroundService alloc] init];
   [backgroundService emitBackgroundSync];
    
  //Maybe we should call the completionHandler once our background sync completes?
    completionHandler(UIBackgroundFetchResultNoData);
}

- (void)completeBackgroundTask:(BGTask *)task {
    [task setTaskCompletedWithSuccess:YES];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  BackgroundService *backgroundService = [[BackgroundService alloc] init];
  
  [backgroundService scheduleBackgroundProcessing:uploadTask timeout:@60 resolver:^(id result) {
      NSLog(@"Background sync scheduled!");
  } rejecter:^(NSString *code, NSString *message, NSError *error) {
      // Handle the rejection or error
      NSLog(@"Background sync schedule failed!");
  }];
}

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
#if DEBUG
  return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index"];
#else
  return [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
#endif
}

@end

