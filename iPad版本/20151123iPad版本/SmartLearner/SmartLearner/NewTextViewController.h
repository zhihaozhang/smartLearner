//
//  NewTextViewController.h
//  Course
//
//  Created by 李青山 on 15/9/26.
//  Copyright (c) 2015年 ASELab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyText.h"
#import "AppDelegate.h"
#import "Tools.h"
#import "SharePreferenceUtil.h"
#import "URLParamter.h"
#import "ConnectUtil.h"
#import "MyQuestion.h"
@interface NewTextViewController : UIViewController<UITextViewDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property bool isFirstEdit;
@property(strong,nonatomic) NSString* textId;
@property (strong, nonatomic) Tools* toast;
@property (strong, nonatomic) Tools* dialog;
@property (strong, nonatomic) IBOutlet UITextField *textTitle;

- (IBAction)clickSubmit:(id)sender;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
- (IBAction)clickBack:(id)sender;
@property(strong,nonatomic) SharePreferenceUtil* util;
@property int TEXT_MAXLENGTH;
@property int TEXT_MAXLENGTH2;
@end
