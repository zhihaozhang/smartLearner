//
//  PersonalCenterView.h
//  SmartLearner
//
//  Created by mmy on 15-9-27.
//  Copyright (c) 2015年 liuhaoxian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalCenterView : UIView
@property(nonatomic,retain)UIViewController* delegate;
@property (strong, nonatomic) IBOutlet UILabel *lb_number;

-(void)setViewController:(UIViewController*)delegate;

- (IBAction)clickAllCourses:(id)sender;
- (IBAction)clickMyCourse:(id)sender;
- (IBAction)clickTextBook:(id)sender;
- (IBAction)clickLogout:(id)sender;
-(void)hidePersonalCenter;
//是否隐藏
-(void)hideView:(bool)flag;
@end
