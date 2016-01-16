//
//  MainTextListViewController.h
//  Course
//
//  Created by 李青山 on 15/9/26.
//  Copyright (c) 2015年 ASELab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextListCell.h"
#import "MyText.h"
#import "AppDelegate.h"
#import "Tools.h"
#import "SharePreferenceUtil.h"
#import "URLParamter.h"
#import "ConnectUtil.h"
#import "UserVo.h"
#import "NewTextViewController.h"

#import "PersonalCenterView.h"
@interface MainTextListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
- (IBAction)clickRight:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property(strong,nonatomic)NSMutableArray * textArray;
- (IBAction)clickGetMore:(id)sender;
- (IBAction)clickNewText:(id)sender;
@property (strong, nonatomic) Tools * dialog;
@end
