//
//  HHContentTableView.h
//  HHHorizontalPagingView
//
//  Created by Huanhoo on 15/7/16.
//  Copyright (c) 2015年 Huanhoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoPage1Cell.h"
#import "VideoPage1VO.h"

@interface HHContentTableView : UITableView
+ (HHContentTableView *)contentTableView;
@property (nonatomic, strong)NSMutableArray *datas;


@end
