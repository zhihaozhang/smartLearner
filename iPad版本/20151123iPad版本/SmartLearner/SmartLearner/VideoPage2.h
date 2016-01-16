//
//  VideoPage2.h
//  SmartLearner
//
//  Created by mmy on 15-10-8.
//  Copyright (c) 2015年 liuhaoxian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoPage22Cell.h"
#import "VideoPage2Cell.h"
#import "VideoPage2.h"
#import "VideoPage22VO.h"
#import "Tools.h"

@interface VideoPage2 : UITableView 
+ (VideoPage2 *)contentTableView;
@property (nonatomic) NSMutableArray *dataNums;
@property NSInteger curentPage;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) Tools *tool;
@end
