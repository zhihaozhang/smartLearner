//
//  SharePreferenceUtil.h
//  krbb_teacher
//
//  Created by liuhaoxian on 12/10/13.
//  Copyright (c) 2013 liuhaoxian. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BasicInfo;
@interface SharePreferenceUtil : NSObject
{
    NSUserDefaults* userInfos;//存储用户基本信息
    
}
-(void)setIsFirst:(BOOL)isFirst;
-(NSString*) getUserAccount;//用户帐号
-(void) setUserAccount:(NSString*)account;
-(NSString*) getUserId;//用户id
-(void)setUserId:(NSString *)userId;
-(NSString*)getUserPassword;//用户密码
-(void)setUserPassword:(NSString*)password;

-(NSString*) getUserName;//用户名字
-(void)setUserName:(NSString *)userName;

@end
