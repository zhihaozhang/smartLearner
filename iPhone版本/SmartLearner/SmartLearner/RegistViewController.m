//
//  RegistViewController.m
//  SmartLearner
//
//  Created by mmy on 15-9-26.
//  Copyright (c) 2015年 liuhaoxian. All rights reserved.
//

#import "RegistViewController.h"
#import "URLParamter.h"
#import "ConnectUtil.h"
#import "AppDelegate.h"
#import "UserVo.h"
#import "AllClassHomePageViewController.h"
@implementation RegistViewController
@synthesize process,backBtn,myNavigationBar;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewInit];
    // Do any additional setup after loading the view.
    //添加点击消失键盘的效果
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)]];
    process=[[Tools alloc]init];

}
- (void)viewInit{
    
    float windowW = self.view.frame.size.width;
    [self.myNavigationBar setFrame:CGRectMake(0, 0, windowW, 44)];
    [self.myNavigationBar setBackgroundImage:[UIImage imageNamed: @"msnav_bg.png"] forBarMetrics:UIBarMetricsDefault];
    self.myNavigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    [self.backBtn setFrame:CGRectMake(10, 9, 27, 27)];
}
-(void)tap{
    [self.tv_psw resignFirstResponder];
    [self.tv_confirmPsw resignFirstResponder];
    [self.tv_number resignFirstResponder];
    [self.tv_tele resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickBackBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickSubmit:(id)sender {
    if([self isEmpty:self.tv_number.text]||[self isEmpty:self.tv_psw.text]||[self isEmpty:self.tv_confirmPsw.text]||[self isEmpty:self.tv_tele.text]){
        NSLog(@"imput empty");
        [process showToast:self withMessage:@"输入不能为空"];
        return ;
    }
    if(![self.tv_psw.text isEqualToString:self.tv_confirmPsw.text]){
        [process showToast:self withMessage:@"密码与确认密码不同"];
        NSLog(@"psw and confrimPsw is not the same");
        return ;
    }
    //网络请求数据
    [NSThread detachNewThreadSelector:@selector(submit) toTarget:self withObject:nil];
}
-(void)submit{
    NSString* url=[[AppDelegate getBaseUrl]stringByAppendingString:@"/user/register"];
    URLParamter* number=[[URLParamter alloc]initWithKey:@"username" value:self.tv_number.text];
    URLParamter* tele=[[URLParamter alloc]initWithKey:@"telphone" value:self.tv_tele.text];
    URLParamter* psw=[[URLParamter alloc]initWithKey:@"password" value:self.tv_psw.text];
    URLParamter* confrimPsw=[[URLParamter alloc]initWithKey:@"confirm_password" value:self.tv_confirmPsw.text];
    NSArray* params=[[NSArray alloc]initWithObjects:number,tele,psw,confrimPsw,nil];
    
    NSDictionary* json=[ConnectUtil getNSDataFromURL:url parameters:params httpMethod:@"POST"];
    NSLog(@"json=%@",json);
    
    dispatch_async(dispatch_get_main_queue(),^{
        if(json!=nil){
            NSNumber* reCode=[json objectForKey:@"resultcode"];
            if([reCode intValue]==1){
                UserVo* userVo=[[UserVo alloc]init];
                userVo.number=self.tv_number.text;
                NSNumber* userid=[json objectForKey:@"userid"];
                userVo.userID=[NSString stringWithFormat:@"%d",[userid intValue]];
                //设置全局变量UserVo
                [AppDelegate setUserVo:userVo];
                //跳转到主界面
                [self gotoMainView];
            }
            else
            {
                NSString* msg=[json objectForKey:@"error"];
                NSLog(@"register error");
                 [process showToast:self withMessage:msg];
            }
        }
        else{
            [process showToast:self withMessage:@"当前服务器不可用"];
        }
      });
}


-(void)gotoMainView{
    AllClassHomePageViewController* homePage=[[UIStoryboard storyboardWithName:@"AllClass" bundle:nil]instantiateViewControllerWithIdentifier:@"AllClassHomePageViewController"];
    [self presentViewController:homePage animated:YES completion:nil];
}
-(BOOL)isEmpty:(NSString*)str{
    return [str isEqualToString:@""];
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
