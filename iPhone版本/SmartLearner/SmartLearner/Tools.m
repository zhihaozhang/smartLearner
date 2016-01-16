//
//  Tools.m
//  Course
//
//  Created by 李青山 on 15/9/26.
//  Copyright (c) 2015年 ASELab. All rights reserved.
//

#import "Tools.h"

@implementation Tools
-(void)showToast:(UIViewController*)viewControl withMessage:(NSString*)message{
    [OMGToast showWithText:message duration:1.5];
}

#pragma mark ProgressHUD
//创建加载等待框
-(void)createProgressHUD:(UIViewController*)viewControl withMessage:(NSString*)message
{
    //显示加载等待框
    self.progressHUD=[[MBProgressHUD alloc] initWithView:viewControl.view];
    [viewControl.view addSubview:self.progressHUD];
    [viewControl.view bringSubviewToFront:self.progressHUD];
    self.progressHUD.delegate = (id)viewControl;
    self.progressHUD.labelText = message;
    [self.progressHUD show:YES];
    
}
//隐藏加载等待框
-(void)hideProgressHUD:(UIViewController*)viewControl
{
    //若progressHUD为真，则将self.progressHUD移除，设为nil
    if (self.progressHUD){
        [self.progressHUD removeFromSuperview];
        //        --or:
        //        [self.progressHUD hide:YES];
        //        ---
        //  [self.progressHUD release];
        self.progressHUD = nil;
    }
}
-(BOOL) isEmpty:(NSString *) str {
    
    if (!str) {
        return true;
    } else {
        //A character set containing only the whitespace characters space (U+0020) and tab (U+0009) and the newline and nextline characters (U+000A–U+000D, U+0085).
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            return true;
        } else {
            return false;
        }
    }
}

@end
