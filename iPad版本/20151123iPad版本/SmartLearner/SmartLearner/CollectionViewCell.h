//
//  CollectionViewCell.h
//  SmartLearner
//
//  Created by 李青山 on 15/11/26.
//  Copyright (c) 2015年 liuhaoxian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell
@property(retain,nonatomic)IBOutlet UIImageView* im_view;
@property (retain, nonatomic) IBOutlet UILabel *lb_curriculum;
@property (retain, nonatomic) IBOutlet UILabel *lb_catelog;
@end
