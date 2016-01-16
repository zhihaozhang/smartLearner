//
//  NetWorkingUtil.m
//  Krbb_Teacher
//
//  Created by Lily on 13-12-12.
//  Copyright (c) 2013年 Lily. All rights reserved.
//

#import "NetWorkingUtil.h"
#import <UIKit/UIKit.h>



@implementation NetWorkingUtil


+ (BOOL) isConnectionAvailable
{
    SCNetworkReachabilityFlags flags;
    BOOL receivedFlags;
    
    SCNetworkReachabilityRef reachability =SCNetworkReachabilityCreateWithName(CFAllocatorGetDefault(), [@"http://www.baidu.com/" UTF8String]);//dipinkrishna.com
    receivedFlags = SCNetworkReachabilityGetFlags(reachability, &flags);
    CFRelease(reachability);
    
    if (!receivedFlags || (flags == 0) )
    {
        return FALSE;
    }
    else {
        return TRUE;
    }
}

+(id)dialogTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle
{
//    UIAlertView * myAlert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:@"确定", nil];
    UIAlertController* test=[UIAlertController alertControllerWithTitle:@"title" message:@"test" preferredStyle:(UIAlertControllerStyleAlert)];
    [test addAction:[UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"响应点击事件");
    }]];
    return test;
}
@end
