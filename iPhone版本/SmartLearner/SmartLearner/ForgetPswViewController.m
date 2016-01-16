//
//  ForgetPswViewController.m
//  SmartLearner
//
//  Created by mmy on 15-9-27.
//  Copyright (c) 2015年 liuhaoxian. All rights reserved.
//

#import "ForgetPswViewController.h"
#import "URLParamter.h"
#import "ConnectUtil.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "AllClassHomePageViewController.h"
@interface ForgetPswViewController ()

@end

@implementation ForgetPswViewController
@synthesize isForgetPsw,process,backBtn,myNavigationBar;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewInit];
    // Do any additional setup after loading the view.
    isForgetPsw=true;
    //添加键盘消失事件
    UIGestureRecognizer* gest=[[UIGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    gest.delegate=self;
    [self.view addGestureRecognizer:gest];
    //[self.view addGestureRecognizer:[[UIGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    self.process=[[Tools alloc]init];
}
- (void)viewInit{
    
    float windowW = self.view.frame.size.width;
    [self.myNavigationBar setFrame:CGRectMake(0, 0, windowW, 44)];
    [self.myNavigationBar setBackgroundImage:[UIImage imageNamed: @"msnav_bg.png"] forBarMetrics:UIBarMetricsDefault];
    self.myNavigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    [self.backBtn setFrame:CGRectMake(10, 9, 27, 30)];
}
-(void)tap:(id)sender{
        [self.tv_tele resignFirstResponder];
        [self.tv_number resignFirstResponder];
        [self.tv_psw resignFirstResponder];
        [self.tv_conirmPsw resignFirstResponder];
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    NSLog(@"click gestrer");
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    else
        return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickBack:(id)sender {
    if ([sender isKindOfClass:[UIButton class]]) {
       [self dismissViewControllerAnimated:NO completion:nil];
    }
}
- (IBAction)clickSubmit:(id)sender {
    NSString* reCode=@"";
    if(isForgetPsw){//忘记密码
        if([self.tv_number.text isEqualToString:@""]||[self.tv_tele.text isEqualToString:@""])
        {
            NSLog(@"input empty");
            reCode=@"输入不能为空";
            [process showToast:self withMessage:reCode];
            return ;
        }
        else
        {
            [NSThread detachNewThreadSelector:@selector(submitToForgetPsw) toTarget:self withObject:nil];
        }
            
    }
    else//重置密码
    {
        if([self.tv_conirmPsw.text isEqualToString:@""]||[self.tv_psw.text isEqualToString:@""])
        {
            NSLog(@"input empty");
            reCode=@"输入不能为空";
            [process showToast:self withMessage:reCode];
            return ;
        }
        else if(![self.tv_conirmPsw.text isEqualToString:self.tv_psw.text])
        {
            NSLog(@"psw and confirm_psw is not same");
            reCode=@"密码与确认密码不一样";
            [process showToast:self withMessage:reCode];
        }
        else
        {
            [NSThread detachNewThreadSelector:@selector(submitResetPsw) toTarget:self withObject:nil];
        }

    }
}
//忘记密码
-(void)submitToForgetPsw{
    NSString* url=[[AppDelegate getBaseUrl] stringByAppendingString:@"/user/forget"];
     URLParamter* username=[[URLParamter alloc]initWithKey:@"username" value:self.tv_number.text];
     URLParamter* tele=[[URLParamter alloc]initWithKey:@"telphone" value:self.tv_tele.text];
     NSArray* params=[[NSArray alloc]initWithObjects:username,tele, nil];
    NSDictionary* json=[ConnectUtil getNSDataFromURL:url parameters:params httpMethod:@"POST"];
    
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       NSString* msg=@"";
                       if(json!=nil){
                           
                           NSNumber* reCode=[json objectForKey:@"resultcode"];
                           if([reCode intValue]==1){
                               NSLog(@"forget success");
                               //设置重置密码页面
                               self.tv_title.text=@"重置密码";
                               self.isForgetPsw=false;
                               self.tv_number.hidden=true;
                               self.tv_tele.hidden=true;
                               self.tv_conirmPsw.hidden=false;
                               self.tv_psw.hidden=false;
                           }
                           else
                           {
                               NSLog(@"forget fail");
                               msg=@"验证失败";
                               [process showToast:self withMessage:msg];
                           }
                           
                           
                       }
                       else
                       {
                           NSLog(@"server not work");
                           [process showToast:self withMessage:@"服务器不可用"];
                       }
                   });
    
}
//重置密码
-(void)submitResetPsw{
    NSString* url=[[AppDelegate getBaseUrl] stringByAppendingString:@"/user/reset"];
    URLParamter* password=[[URLParamter alloc]initWithKey:@"password" value:self.tv_psw.text];
    URLParamter* confirm_password=[[URLParamter alloc]initWithKey:@"confirm_password" value:self.tv_conirmPsw.text];
    NSArray* params=[[NSArray alloc]initWithObjects:password,confirm_password, nil];
    NSDictionary* json=[ConnectUtil getNSDataFromURL:url parameters:params httpMethod:@"POST"];
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       NSString* msg=@"";
                       if(json!=nil){
                           NSNumber* reCode=[json objectForKey:@"resultcode"];
                           if([reCode intValue]==1){
                               NSLog(@"reset success");
                               [self gotoMainView];
                           }
                           else
                           {
                               NSLog(@"reset fail");
                               [process showToast:self withMessage:@"重置密码失败"];
                           }
                           
                           
                       }
                       else
                       {
                           NSLog(@"server not work");
                            [process showToast:self withMessage:@"服务器不可用"];
                       }
                   });
    

}
-(void)gotoMainView{
    AllClassHomePageViewController* homePage=[[UIStoryboard storyboardWithName:@"AllClass" bundle:nil]instantiateViewControllerWithIdentifier:@"AllClassHomePageViewController"];
    [self presentViewController:homePage animated:YES completion:nil];
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
