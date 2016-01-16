//
//  RegistViewController.h
//  SmartLearner
//
//  Created by mmy on 15-9-26.
//  Copyright (c) 2015年 liuhaoxian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tools.h"
@interface RegistViewController : UIViewController
- (IBAction)clickBackBtn:(id)sender;
- (IBAction)clickSubmit:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *tv_number;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UINavigationBar *myNavigationBar;
@property (weak, nonatomic) IBOutlet UITextField *tv_tele;
@property (weak, nonatomic) IBOutlet UITextField *tv_psw;
@property (weak, nonatomic) IBOutlet UITextField *tv_confirmPsw;
@property(nonatomic,retain)Tools* process;
@end
