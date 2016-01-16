//
//  VideoMSG.h
//  SmartLearner
//
//  Created by 李青山 on 15/10/12.
//  Copyright (c) 2015年 liuhaoxian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoMSG : NSObject
@property int videoCId;
@property (nonatomic, strong) NSString *videoCDetail;
@property (nonatomic, strong) NSString *videoCContent;
@property (nonatomic, strong) NSString *videoCRead;
@property (nonatomic, strong) NSString *videoCSound;

@end
