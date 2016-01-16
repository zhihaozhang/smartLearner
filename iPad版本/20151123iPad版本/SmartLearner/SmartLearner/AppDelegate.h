//
//  AppDelegate.h
//  SmartLearner
//
//  Created by mmy on 15-9-24.
//  Copyright (c) 2015年 liuhaoxian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserVo.h"
@class Reachability;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(strong,nonatomic)UserVo* userVo;
@property(retain,nonatomic)Reachability* reachability;
+(UserVo*)getUserVo;
+(void)setUserVo:(UserVo*)userVo;
+(NSString*)getBaseUrl;
//得到当前网络状态
+(BOOL)isNetworkAvailable;

//开启网络状态监听
-(void)listenNetworkState;
//当网络发生改变时的响应
-(void)reachabilityChanged:(NSNotification*)notice;
@end

