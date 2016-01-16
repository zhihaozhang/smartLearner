//
//  ForgetPswViewController.h
//  SmartLearner
//
//  Created by mmy on 15-9-27.
//  Copyright (c) 2015年 liuhaoxian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tools.h"
@interface ForgetPswViewController : UIViewController<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *tv_title;
@property (strong, nonatomic) IBOutlet UINavigationBar *myNavigationBar;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property bool isForgetPsw;
@property (weak, nonatomic) IBOutlet UITextField *tv_number;
@property (weak, nonatomic) IBOutlet UITextField *tv_tele;
@property (weak, nonatomic) IBOutlet UITextField *tv_psw;
@property (weak, nonatomic) IBOutlet UITextField *tv_conirmPsw;
@property(nonatomic,retain)Tools* process;
- (IBAction)clickSubmit:(id)sender;
- (IBAction)clickBack:(id)sender;
@end
