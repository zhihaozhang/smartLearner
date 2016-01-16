//
//  AppDelegate.m
//  SmartLearner
//
//  Created by mmy on 15-9-24.
//  Copyright (c) 2015年 liuhaoxian. All rights reserved.
//

#import "AppDelegate.h"
#import "Reachability.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
static bool networkState;
@synthesize userVo,reachability;
static NSString* baseUrl=@"http://120.24.94.254:8181/index.php";
+(NSString*)getBaseUrl{
    return baseUrl;
}
+(UserVo*)getUserVo{
    AppDelegate* delegete=[UIApplication sharedApplication].delegate;
    return delegete.userVo;
}
+(void)setUserVo:(UserVo*)v_userVo{
    AppDelegate* delegete=[UIApplication sharedApplication].delegate;
    delegete.userVo=v_userVo;
}
+(BOOL)isNetworkAvailable{
    return networkState;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [application setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    NSLog(@"init loader");
    //开启网络监听
    [self listenNetworkState];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(void)listenNetworkState{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.reachability=[Reachability reachabilityWithHostname:@"www.baidu.com"];
    [self.reachability startNotifier];
    
}
-(void)reachabilityChanged:(NSNotification *)notice{
    
    Reachability* currReachability=notice.object;
    NetworkStatus state=[currReachability currentReachabilityStatus];
    
    networkState=TRUE;
    if (state==NotReachable) {
        networkState=FALSE;
    }
}

@end
