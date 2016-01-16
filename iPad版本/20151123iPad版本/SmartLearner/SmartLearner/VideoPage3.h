//
//  VideoPage3.h
//  SmartLearner
//
//  Created by mmy on 15-10-8.
//  Copyright (c) 2015年 liuhaoxian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoPage3Cell.h"
#import "VideoPage3VO.h"

@interface VideoPage3 : UITableView
+ (VideoPage3 *)contentTableView;
@property (nonatomic, strong) NSMutableArray *datas;

@end
