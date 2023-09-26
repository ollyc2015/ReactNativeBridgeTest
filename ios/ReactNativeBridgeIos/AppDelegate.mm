#import "AppDelegate.h"
#import <BackgroundTasks/BackgroundTasks.h>
#import <React/RCTBundleURLProvider.h>
#import <UIKit/UIKit.h>

@implementation AppDelegate

static NSString* uploadTask = @"MyLongRunningTask";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.moduleName = @"ReactNativeBridgeIos";
  self.initialProps = @{};

  
  // Add code to configure and schedule processing task if running on iOS 13 or later
  if (@available(iOS 13.0, *)) {
    [[BGTaskScheduler sharedScheduler] registerForTaskWithIdentifier:uploadTask usingQueue:nil launchHandler:^(__kindof BGTask *task) {
            [self handleBackgroundFetchTask:task];
        }];
  }
  
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)handleBackgroundFetchTask:(BGTask *)task {
    // This method is called when the background fetch task is executed.
     NSLog(@"Background sync triggered!");
    // Add your custom logic here to handle the background fetch.
    
    // Complete the task with the appropriate result
    [task setTaskCompletedWithSuccess:YES];
}


//- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//    // This method is called when a background fetch is triggered.
//     NSLog(@"Background sync triggered!");
//    // Add your custom logic here to handle the background fetch.
//
//    // For example, you can post a notification to inform other parts of your app:
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"BackgroundFetchDidOccur" object:nil];
//
//    // After handling the background fetch, call the completionHandler with the appropriate result.
//    // For example, if you successfully fetched new data:
//    completionHandler(UIBackgroundFetchResultNewData);
//}

//- (void)applicationDidEnterBackground:(UIApplication *)application {
//    // This method is called when your app enters the background state.
//    // You can do additional background-related tasks here if needed.
//}



- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
#if DEBUG
  return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index"];
#else
  return [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
#endif
}

@end

