//
//  PersonalCenterView.m
//  SmartLearner
//
//  Created by mmy on 15-9-27.
//  Copyright (c) 2015年 liuhaoxian. All rights reserved.
//

#import "PersonalCenterView.h"
#import "AllClassHomePageViewController.h"
#import "MyClassMainPageViewController.h"
#import "MainTextListViewController.h"
#import "AppDelegate.h"
#import "UserVo.h"
@implementation PersonalCenterView

@synthesize delegate;
-(instancetype)initWithFrame:(CGRect)frame{
    
    NSLog(@"click persnalCenter");
    return self;
}
-(void)setViewController:(UIViewController *)v_delegate{
    
    self.frame=v_delegate.view.frame;
    self.delegate=v_delegate;
    //点击添加效果
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidePersonalCenter)]];
    NSLog(@"set click button ok");
    self.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    UserVo* userVo=[AppDelegate getUserVo];
    [self.lb_number setText:userVo.number];
    //设置向左滑动的手势
    UISwipeGestureRecognizer* gister=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(scrolltoLeft)];
    [gister setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self addGestureRecognizer:gister];
    
    }
-(void)scrolltoLeft{
    NSLog(@"scroll to left");

    self.hidden=true;
}
-(void)hidePersonalCenter{
    NSLog(@"click hiden button");
    self.hidden=true;
}
- (IBAction)clickAllCourses:(id)sender {
    if(self.delegate!=nil)
    {
        NSLog(@"click allCourses");
        [self hideView:true];
        AllClassHomePageViewController* view=[[UIStoryboard storyboardWithName:@"AllClass" bundle:nil]instantiateViewControllerWithIdentifier:@"AllClassHomePageViewController"];
        [self.delegate presentViewController:view animated:YES completion:nil];
    }
    else
        NSLog(@"没有实现clickAllCourses该代理");
}

- (IBAction)clickMyCourse:(id)sender {
    if(self.delegate!=nil)
    {
        NSLog(@"click myCourses");
        [self hideView:true];
        MyClassMainPageViewController* view=[[UIStoryboard storyboardWithName:@"AllClass" bundle:nil]instantiateViewControllerWithIdentifier:@"MyClassMainPageViewController"];
        [self.delegate presentViewController:view animated:YES completion:nil];
    }
    else
        NSLog(@"没有实现clickMyCourses该代理");
}

- (IBAction)clickTextBook:(id)sender {
    if(self.delegate!=nil)
    {
        NSLog(@"click textBook");
        [self hideView:true];
        MainTextListViewController* view=[[UIStoryboard storyboardWithName:@"MainTextListViewController" bundle:nil]instantiateViewControllerWithIdentifier:@"MainTextListViewController"];
        [self.delegate presentViewController:view animated:YES completion:nil];

    }
    else
        NSLog(@"没有实现clickMyTextBook该代理");
}

- (IBAction)clickLogout:(id)sender {
    if(self.delegate!=nil)
    {
        NSLog(@"click logout");
        exit(0);
    }
    else
        NSLog(@"没有实现clickLogout该代理");
    
}
-(void)hideView:(bool)flag{
    [self removeFromSuperview];
    self.hidden=flag;
}
@end
