//
//  AllClassHomePageViewController.h
//  SmartLearner
//
//  Created by mmy on 15-9-25.
//  Copyright (c) 2015年 liuhaoxian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassVO.h"
#import "AllClassHomePageCell.h"
#import "AllClassVideoViewController.h"
#import "ConnectUtil.h"
#import "URLParamter.h"
#import "MoreCell.h"
#import "SharePreferenceUtil.h"
#import "AsynLoaderPic.h"
#import "UserVo.h"
#import "AppDelegate.h"
#import "MyQuestion.h"
@interface AllClassHomePageViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *btn_search;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (strong, nonatomic) IBOutlet UINavigationBar *myNavigationBar;
@property (weak, nonatomic) IBOutlet UIPageControl *myPageControl;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
- (IBAction)turnPage:(id)sender;
- (IBAction)searchAction:(id)sender;

- (IBAction)moreAction:(id)sender;
@property NSMutableArray *datas;
@property(nonatomic,strong) NSMutableArray *imageArray;
@property(nonatomic, strong) NSMutableArray *imageNames;
@property(nonatomic,strong) NSTimer *myTimer;
@property int page;
@property(nonatomic,strong) NSDictionary *totalData;
@property (nonatomic, strong) Tools *process;
@property(nonatomic,retain)AsynLoaderPic* picCache;


@end
