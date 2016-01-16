//
//  SharePreferenceUtil.m
//  krbb_teacher
//
//  Created by liuhaoxian on 12/10/13.
//  Copyright (c) 2013 liuhaoxian. All rights reserved.
//

#import "SharePreferenceUtil.h"

@implementation SharePreferenceUtil

-(id)init
{
    
    self=[super init];
    if(self)
    {
        
        userInfos=[NSUserDefaults standardUserDefaults];
    }
    return self;
}
-(BOOL)getIsFirst
{
    NSNumber* isFirst=(NSNumber*)[userInfos objectForKey:@"isFirst"];
    if (isFirst==nil)
        return true;
    return false;
}
-(void)setIsFirst:(BOOL)isFirst
{
    [userInfos setObject:[NSNumber numberWithBool:isFirst] forKey:@"isFirst"];
}
-(NSString*) getUserAccount//用户帐号
{
    return [userInfos objectForKey:@"userAccount"];
}
-(void)setUserAccount:(NSString*)account
{
    NSString* str=[account copy];
    [userInfos setObject:str forKey:@"userAccount"];
    [userInfos synchronize];
}
-(NSString*) getUserId//用户id
{
    return [userInfos objectForKey:@"userId"];
}
-(void)setUserId:(NSString *)userId
{
    NSString* str=[userId copy];
    [userInfos setObject:str forKey:@"userId"];
    [userInfos synchronize];
}


-(NSString*) getUserName//用户名字
{
    return [userInfos objectForKey:@"userName"];
}
-(void)setUserName:(NSString *)userName
{
    NSString* str=[userName copy];
    [userInfos setObject:str forKey:@"userName"];
    [userInfos synchronize];
}
-(NSString*)getUserPassword//用户密码
{
    return [userInfos objectForKey:@"password"];
}
-(void)setUserPassword:(NSString*)password{
    NSString* str=[password copy];
    [userInfos setObject:str forKey:@"password"];
    [userInfos synchronize];
}
@end
