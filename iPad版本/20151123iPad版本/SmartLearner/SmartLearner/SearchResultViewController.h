//
//  SearchResultViewController.h
//  SmartLearner
//
//  Created by mmy on 15-9-26.
//  Copyright (c) 2015年 liuhaoxian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassVO.h"
#import "AllClassHomePageCell.h"
#import "URLParamter.h"
#import "ConnectUtil.h"
#import "AsynLoaderPic.h"
#import "AllClassVideoViewController.h"

@interface SearchResultViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) NSMutableArray *datas;
@property(nonatomic,strong) NSMutableArray *imageArray;
- (IBAction)backAction:(id)sender;
- (IBAction)searchAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *searchBtn;
@property (strong, nonatomic) IBOutlet UINavigationBar *myNavigationBar;
@property (weak, nonatomic) IBOutlet UITextField *searchContext;
@property (weak, nonatomic) IBOutlet UITableView *mytableview;
@property(nonatomic,retain)AsynLoaderPic* picCache;
@end
