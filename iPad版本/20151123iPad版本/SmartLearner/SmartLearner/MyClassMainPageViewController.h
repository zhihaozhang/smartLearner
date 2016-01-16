//
//  MyClassMainPageViewController.h
//  SmartLearner
//
//  Created by mmy on 15-9-26.
//  Copyright (c) 2015年 liuhaoxian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassVO.h"
#import "AllClassHomePageCell.h"
#import "MoreTableViewCell.h"
#import "UserVo.h"
#import "AsynLoaderPic.h"
#import "Tools.h"
#import "AllClassVideoViewController.h"

@interface MyClassMainPageViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic,retain)UserVo* userVo;
@property(nonatomic,strong) NSMutableArray *datas;
- (IBAction)moreAction:(id)sender;
@property (strong, nonatomic) IBOutlet UINavigationBar *myNavigationBar;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(retain,nonatomic)IBOutlet UICollectionView* collections;
@property(retain,nonatomic)AsynLoaderPic* imageLoader;
@property(retain,nonatomic)Tools* process;
@end
