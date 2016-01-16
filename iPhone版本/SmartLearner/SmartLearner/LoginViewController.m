//
//  ViewController.m
//  SmartLearner
//
//  Created by mmy on 15-9-24.
//  Copyright (c) 2015年 liuhaoxian. All rights reserved.
//

#import "LoginViewController.h"
#import "PersonalCenterView.h"
#import "RegistViewController.h"
#import "ForgetPswViewController.h"
#import "AllClassHomePageViewController.h"
#import "URLParamter.h"
#import "ConnectUtil.h"
#import "AppDelegate.h"
#import "UserVo.h"
@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize process,util;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"viewDidLoader");
    //添加点击消失键盘的效果
   [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)]];
    
    self.process=[[Tools alloc]init];
    
    self.wantsFullScreenLayout = true;
    
    util=[[SharePreferenceUtil alloc]init];
    NSString* number=[util getUserAccount];
    NSString* psw=[util getUserPassword];
    if(number!=nil)
        self.tv_number.text=number;
    if(psw!=nil)
        self.tv_psw.text=psw;
   }
-(void)tap{
    NSLog(@"dfsfsdfsdfs");
    [self.tv_number resignFirstResponder];
    [self.tv_psw resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickLoginBtn:(id)sender {
    //[self gotoMainView];
    
    
    NSString* reCode=@"";
    NSLog(@"点击登录按钮");
    if([self.tv_number.text isEqualToString:@""]||[self.tv_psw.text isEqualToString:@""]){
        NSLog(@"input data error");
        reCode=@"用户名或密码不能为空";
        [process showToast:self withMessage:reCode];
        return ;
    }
    [util setUserAccount:self.tv_number.text];
    [util setUserPassword:self.tv_psw.text];
    [process createProgressHUD:self withMessage:@"正在验证..."];
     
     
    [NSThread detachNewThreadSelector:@selector(submit) toTarget:self withObject:nil];
     
    //AllClassHomePageViewController* homePage=[[UIStoryboard storyboardWithName:@"AllClass" bundle:nil]instantiateViewControllerWithIdentifier:@"AllClassHomePageViewController"];
    //[self presentViewController:homePage animated:YES completion:nil];
}
//提交验证
-(void)submit{
    NSLog(@"submit data");
    NSString* url=[[AppDelegate getBaseUrl] stringByAppendingString:@"/user/login"];
    URLParamter* number=[[URLParamter alloc]initWithKey:@"number" value:self.tv_number.text];
    URLParamter* password=[[URLParamter alloc]initWithKey:@"password" value:self.tv_psw.text];
    NSArray* params=[[NSArray alloc]initWithObjects:number,password, nil];
    NSDictionary* temp=[ConnectUtil getNSDataFromURL:url parameters:params httpMethod:@"POST"];
    
    NSLog(@"temp=%@",temp);
    dispatch_async(dispatch_get_main_queue(), ^{
        [process hideProgressHUD:self];
        NSString* reCode=@"";
        if(temp!=nil){
            NSNumber* resultCode=[temp objectForKey:@"resultcode"];
            if([resultCode intValue]==1){
                UserVo* userVo=[[UserVo alloc]init];
                userVo.number=self.tv_number.text;
                //存在全局变量中
                [AppDelegate setUserVo:userVo];
                //跳转到主界面
                [self gotoMainView];
                return ;
             }
            else{
                NSLog(@"reCode=%@",[temp objectForKey:@"error"]);
                reCode=[temp objectForKey:@"error"];
            }
        }
        else{
            NSLog(@"服务器不可用");
            reCode=@"服务器不可用";
        }
        [process showToast:self withMessage:reCode];
    });

    
}
-(void)gotoMainView{
    AllClassHomePageViewController* homePage=[[UIStoryboard storyboardWithName:@"AllClass" bundle:nil]instantiateViewControllerWithIdentifier:@"AllClassHomePageViewController"];
    
    [self presentViewController:homePage animated:YES completion:nil];
}
- (IBAction)clickRegist:(id)sender {
        RegistViewController* test=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"RegistViewController"];
    [self presentViewController:test animated:YES completion:nil];
}

- (IBAction)clickCannotLogin:(id)sender {
//    ForgetPswViewController* fPsw=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ForgetPswViewController"];
//    [self presentViewController:fPsw animated:YES completion:nil];
    RegistViewController* test=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"RegistViewController"];
    [self presentViewController:test animated:YES completion:nil];

}
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
-(BOOL)shouldAutorotate{
    return NO;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}
@end
