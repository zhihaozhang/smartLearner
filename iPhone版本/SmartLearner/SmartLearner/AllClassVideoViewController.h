//
//  AllClassVideoViewController.h
//  SmartLearner
//
//  Created by mmy on 15-9-26.
//  Copyright (c) 2015年 liuhaoxian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoTableViewCell.h"
#import "MediaPlayer/MediaPlayer.h"
#import "HHHorizontalPagingView.h"
#import "VideoPage3.h"
#import "VideoPage2.h"
#import "HHContentTableView.h"
#import "MusicViewController.h"
#import "AppDelegate.h"
#import "Tools.h"
#import "SharePreferenceUtil.h"
#import "URLParamter.h"
#import "ConnectUtil.h"
#import "Exercise.h"
#import "SingleSelectViewController.h"
#import "ConnectUtil.h"
#import "URLParamter.h"
#import "VideoMSG.h"
#import "VideoVO.h"
#import "MultiSelectViewController.h"
#import "MyQuestion.h"
#import "Exercise.h"
#import "AppDelegate.h"
#import "AudioButton.h"
#import "MainTextListViewController.h"
@interface AllClassVideoViewController : UIViewController{
    AudioPlayer *audioPlayer;
    BOOL isPlay;
}
@property (nonatomic, strong) NSDictionary *totaldata;
@property (nonatomic, strong) NSString *playUrl;
@property (nonatomic, strong) NSString *videoUrl;
@property int videoId;
@property int videoNum;
@property (nonatomic, strong) MPMoviePlayerController *player;
@property (nonatomic, strong) NSMutableArray *data1,*data2,*data3,*datas;
@property (nonatomic, strong) VideoVO *videoData;

@property (weak, nonatomic) IBOutlet UIButton *daoxueBtn;
@property (weak, nonatomic) IBOutlet UIButton *yuanwenBtn;
@property (weak, nonatomic) IBOutlet UIButton *yueduBtn;


- (IBAction)slip1Action:(id)sender;
- (IBAction)slip2Action:(id)sender;
- (IBAction)slip3Action:(id)sender;

@property (strong, nonatomic) Tools * dialog;
@property (strong,nonatomic)NSMutableArray* questionArray;
@end
