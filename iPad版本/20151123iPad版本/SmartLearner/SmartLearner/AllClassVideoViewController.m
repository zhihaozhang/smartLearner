//
//  AllClassVideoViewController.m
//  SmartLearner
//
//  Created by mmy on 15-9-26.
//  Copyright (c) 2015年 liuhaoxian. All rights reserved.
//

#import "AllClassVideoViewController.h"

@interface AllClassVideoViewController ()

@end

@implementation AllClassVideoViewController
@synthesize totaldata,data1,data2,data3,videoId,datas,videoNum;
@synthesize daoxueBtn,yuanwenBtn,yueduBtn;
@synthesize player,playUrl,dialog,videoData,videoUrl;
HHContentTableView *tableView1;
VideoPage2 *tableView2;
VideoPage3 *tableView3;
AudioButton *readBtn;
int readCount=0;
float videoH;
float windowW;
float windowH;
int curPage;
bool isFullScreen;
NSMutableArray *buttonArray;
HHHorizontalPagingView *pagingView;
- (void)viewDidLoad {
    [super viewDidLoad];
    //mmy
    isPlay = YES;
    self.dialog =[[Tools alloc] init];
//    MyQuestion* question=[MyQuestion shareInstance];
//    question
    //----
    [self viewInit];
    [self dataInit];
    self.wantsFullScreenLayout = true;
    NSLog(@"video page videoid is %d",videoId);
    NSThread* myThread = [[NSThread alloc] initWithTarget:self
                                                 selector:@selector(getData)
                                                   object:nil];
    [myThread start];
    NSThread* myThread1 = [[NSThread alloc] initWithTarget:self
                                                 selector:@selector(markRead)
                                                   object:nil];
    [myThread1 start];
}
- (void)viewInit{
    windowH = self.view.frame.size.height;
    windowW = self.view.frame.size.width;
    videoH = windowH/3;
    tableView1           = [HHContentTableView contentTableView];
    tableView2 = [VideoPage2 contentTableView];
    tableView3         = [VideoPage3 contentTableView];
    
    [tableView1 setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-videoH-44)];
    [tableView2 setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-videoH-44)];
    [tableView3 setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-videoH-44)];
    buttonArray = [NSMutableArray array];
    [self setBtnState];
    [buttonArray addObject:daoxueBtn];
    [buttonArray addObject:yuanwenBtn];
    [buttonArray addObject:yueduBtn];

    pagingView = [HHHorizontalPagingView pagingViewWithHeaderView:nil headerHeight:0.f segmentButtons:buttonArray segmentHeight:40 contentViews:@[tableView1, tableView2, tableView3]];
    [pagingView setFrame:CGRectMake(0, videoH, self.view.frame.size.width, 100)];
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [pagingView addGestureRecognizer:recognizer];
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [pagingView addGestureRecognizer:recognizer];
    //    pagingView.segmentButtonSize = CGSizeMake(60., 30.);        //自定义segmentButton的大小
//    pagingView.segmentView.backgroundColor = [UIColor grayColor]; //设置segmentView的背景色
    UIImageView *navBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"msnav_bg.png"]];
    navBG.userInteractionEnabled = true;
    float btn_width = self.view.frame.size.width/4;
    float btn_height = 44;
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btn_width, btn_height)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"msbottom_back.png"] forState:(UIControlStateNormal)];
//    [backBtn setFrame:CGRectMake(16, 8, 27, 27)];
    [backBtn addTarget:self action:@selector(backToHomePage:) forControlEvents:UIControlEventTouchUpInside];
    [navBG addSubview:backBtn];
    

    UIButton *noteBtn = [[UIButton alloc] initWithFrame:CGRectMake(btn_width, 0, btn_width, btn_height)];
    [noteBtn setBackgroundImage:[UIImage imageNamed:@"msbottom_btn_bg.png"] forState:(UIControlStateNormal)];
    [noteBtn setTitle:@"笔记" forState:UIControlStateNormal];
    noteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [noteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [noteBtn setFrame:CGRectMake(btn_width, 8, btn_width, 27)];
    [noteBtn addTarget:self action:@selector(goToNotePage:) forControlEvents:UIControlEventTouchUpInside];
    [navBG addSubview:noteBtn];
    
    UIButton *lianxiBtn = [[UIButton alloc] initWithFrame:CGRectMake(noteBtn.frame.origin.x+noteBtn.frame.size.width, 0, btn_width, btn_height)];
    lianxiBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [lianxiBtn setBackgroundImage:[UIImage imageNamed:@"msbottom_btn_bg.png"] forState:(UIControlStateNormal)];
    [lianxiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [lianxiBtn setTitle:@"习题" forState:UIControlStateNormal];
//    [lianxiBtn setFrame:CGRectMake(noteBtn.frame.origin.x+noteBtn.frame.size.width, 8, btn_width, 27)];
    [lianxiBtn addTarget:self action:@selector(goToLianxiPage:) forControlEvents:UIControlEventTouchUpInside];
    [navBG addSubview:lianxiBtn];

    readBtn = [[AudioButton alloc] initWithFrame:CGRectMake(lianxiBtn.frame.origin.x+lianxiBtn.frame.size.width, 0, btn_width, btn_height)];
    readBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [readBtn setBackgroundImage:[UIImage imageNamed:@"msbottom_btn_bg.png"] forState:(UIControlStateNormal)];
    [readBtn setTitle:@"朗读" forState:UIControlStateNormal];
//    [readBtn setFrame:CGRectMake(lianxiBtn.frame.origin.x+lianxiBtn.frame.size.width, 8, btn_width, 27)];
    if (self.videoUrl==nil||[self.dialog isEmpty:self.videoUrl]) {
        readBtn.userInteractionEnabled=NO;
        //readBtn.alpha=0.4;
        [readBtn setBackgroundColor:[UIColor colorWithRed:188.0/255 green:188.0/255 blue:188.0/255 alpha:1]];
    }
    else{
        readBtn.userInteractionEnabled=YES;
        [readBtn setBackgroundColor:[UIColor clearColor]];
    }
    [readBtn addTarget:self action:@selector(goToReadPage:) forControlEvents:UIControlEventTouchUpInside];
    [navBG addSubview:readBtn];
    
    [navBG setFrame:CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, btn_height)];
    [self.view addSubview:pagingView];
    [self.view addSubview:navBG];
}
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
       //向右滑动
        if (curPage<3) {
            curPage ++;
        }
        NSLog(@"scroll right!");
//        [self checkVideoBtn:curPage];
    }
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        //向左滑动
        if (curPage>1) {
            curPage--;
        }
        NSLog(@"scroll left!");
//        [self checkVideoBtn:curPage];
    }
    [pagingView segmentButtonEvent:[buttonArray objectAtIndex:curPage-1]];
}
- (void)dataInit{
    curPage = 1;
    readCount=0;
    isFullScreen = NO;
    totaldata = [[NSDictionary alloc] init];
    data1 = [[NSMutableArray alloc] init];
    data2 = [[NSMutableArray alloc] init];
    data3 = [[NSMutableArray alloc] init];
    datas = [[NSMutableArray alloc] init];
    videoData = [[VideoVO alloc] init];
    
//    [player play];
    // 注册一个播放结束的通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self   selector:@selector(myMovieFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification   object:player];
}
- (void)playVideo{
    player = [[MPMoviePlayerController alloc] init];
    
    NSURL *movieUrl = [NSURL URLWithString:playUrl];
    MPMoviePlayerViewController *playViewController=[[MPMoviePlayerViewController alloc] initWithContentURL:movieUrl];
    
//    player.controlStyle = MPMovieControlStyleEmbedded;
//    player.controlStyle = MPMovieControlStyleFullscreen;
//    player.controlStyle = MPMovieControlStyleEmbedded;//内嵌的方式
    
    player=[playViewController moviePlayer];
    player.scalingMode = MPMovieScalingModeAspectFill;
    player.scalingMode=MPMovieScalingModeFill;
    player.controlStyle=MPMovieControlStyleEmbedded;
    [player.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, videoH)];
    
    [self.view addSubview:player.view];
    
//    [player play];
    //不用play而是采用下面的方式时，打开视频时不直接播放，
    [player setShouldAutoplay:NO];
    [player prepareToPlay];
}
- (void)showFullScreen{
    //全屏设置
    isFullScreen = !isFullScreen;
    [player setFullscreen:YES animated:YES];
}
-(void)getData
{
    //从服务器获取数据
    URLParamter* param1=[[URLParamter alloc]initWithKey:@"curriculum_id" value:[NSString stringWithFormat:@"%d",videoId]];
    
    NSArray* params=[[NSArray alloc]initWithObjects:param1,nil];
    totaldata=[ConnectUtil getNSDataFromURL:[ConnectUtil getVIDEOCLASSDETAIL] parameters:params httpMethod:[ConnectUtil getPOST]];
    int istate = 0;
    if (totaldata!=nil) {
        NSString *state = [totaldata objectForKey:@"resultcode"];
        istate = [state intValue];
    }
    NSLog(@"data state is %d",istate);
    if (istate==1) {
        //传回的数据不为空
        NSString *content = [totaldata objectForKey:@"text"];
        NSLog(@"data count is success");
        [[NSNotificationCenter defaultCenter]postNotificationName:@"VideoMessage" object:@"success"];    }
    else{
        //获取数据失败
        NSLog(@"data count is fail");
        [[NSNotificationCenter defaultCenter]postNotificationName:@"VideoMessage" object:@"fail"];
    }
}
-(void)receiveList:(NSNotification*)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (notification.object!=nil) {
            NSString* state = (NSString*)notification.object;
            if ([state isEqualToString:@"success"]) {
                NSLog(@"receiveList success");
                NSArray *videoOutline = [totaldata objectForKey:@"outline"];
                if (videoOutline!=nil) {
                    playUrl = [[videoOutline objectAtIndex:0] objectForKey:@"video"];
                    videoUrl = [[videoOutline objectAtIndex:0] objectForKey:@"audio"];
                }
                NSLog(@"video url is %@",playUrl);
                NSLog(@"audio url is %@",videoUrl);
                [self playVideo];
                
                data1 = [[NSMutableArray alloc] init];
                data3 = [[NSMutableArray alloc] init];
                data2 = [[NSMutableArray alloc] init];
                NSMutableArray *tempDatasNum = [[NSMutableArray alloc] init];
                
                NSDictionary *text = [totaldata objectForKey:@"text"];
                NSDictionary *lead = [totaldata objectForKey:@"lead"];
                NSDictionary *read = [totaldata objectForKey:@"read"];
                NSString *ctext,*rtext;
                VideoPage1VO *vo1 = [[VideoPage1VO alloc] init];
                [vo1 setTitle:[lead objectForKey:@"title"]];
                NSString *tempcontent = [[lead objectForKey:@"content"] stringByReplacingOccurrencesOfString:@"t" withString:@"\t"];
                tempcontent = [tempcontent stringByReplacingOccurrencesOfString:@"n" withString:@"\n"];
                [vo1 setContent:tempcontent];
                [data1 addObject:vo1];
                ctext = [text objectForKey:@"jiexuan"];
                rtext = [text objectForKey:@"zhushi"];
                ctext = [ctext stringByReplacingOccurrencesOfString:@"t" withString:@"\t"];
                ctext = [ctext stringByReplacingOccurrencesOfString:@"n" withString:@"\n"];
                rtext = [rtext stringByReplacingOccurrencesOfString:@"t" withString:@"\t"];
                rtext = [rtext stringByReplacingOccurrencesOfString:@"n" withString:@"\n"];
                NSArray *textContentArray = [ctext componentsSeparatedByString:@"||"];
                NSArray *textReferenceArray = [rtext componentsSeparatedByString:@"||"];
                for (int i=0; i<textContentArray.count; ++i) {
                    VideoPage22VO *vo2 = [[VideoPage22VO alloc] init];
                    [vo2 setTitle:[text objectForKey:@"title"]];
                    [vo2 setContent:[textContentArray objectAtIndex:i]];
                    [vo2 setReference:[textContentArray objectAtIndex:i]];
                    [vo2 setShow:NO];
                    [data2 addObject:vo2];
                }
                [tempDatasNum addObject:[NSString stringWithFormat:@"%d",[textContentArray count]]];
                
                NSString *title1 = [text objectForKey:@"title1"];
                if ([title1 isEqualToString:@""]) {
                    //only one jiexuan
                }else{
                    ctext = [text objectForKey:@"jiexuan1"];
                    rtext = [text objectForKey:@"zhushi1"];
                    ctext = [ctext stringByReplacingOccurrencesOfString:@"t" withString:@"\t"];
                    ctext = [ctext stringByReplacingOccurrencesOfString:@"n" withString:@"\n"];
                    rtext = [rtext stringByReplacingOccurrencesOfString:@"t" withString:@"\t"];
                    rtext = [rtext stringByReplacingOccurrencesOfString:@"n" withString:@"\n"];

                    NSArray *textContentArray = [ctext componentsSeparatedByString:@"||"];
                    NSArray *textReferenceArray = [rtext componentsSeparatedByString:@"||"];
                    for (int i=0; i<textContentArray.count; ++i) {
                        VideoPage22VO *vo2 = [[VideoPage22VO alloc] init];
                        [vo2 setTitle:[text objectForKey:@"title1"]];
                        
                        [vo2 setContent:[textContentArray objectAtIndex:i]];
                        
                        [vo2 setReference:[textReferenceArray objectAtIndex:i]];
                        [vo2 setShow:NO];
                        [data2 addObject:vo2];
                    }
                    [tempDatasNum addObject:[NSString stringWithFormat:@"%d",[textContentArray count]]];
                }
                
                VideoPage3VO *vo3 = [[VideoPage3VO alloc] init];
                [vo3 setTitle:[read objectForKey:@"title"]];
                NSString *tempcontent2 = [read objectForKey:@"content"];
                tempcontent2 = [tempcontent2 stringByReplacingOccurrencesOfString:@"t" withString:@"\t"];
                tempcontent2 = [tempcontent2 stringByReplacingOccurrencesOfString:@"n" withString:@"\n"];
                [vo3 setContent:tempcontent2];
                
                NSString *tempreference2 = [read objectForKey:@"dianjing"];
                tempreference2 = [tempreference2 stringByReplacingOccurrencesOfString:@"t" withString:@"\t"];
                tempreference2 = [tempreference2 stringByReplacingOccurrencesOfString:@"n" withString:@"\n"];
                [vo3 setReadContent:tempreference2];
                [vo3 setRead:@"【阅读点津】"];
                [data3 addObject:vo3];
       
                tableView1.datas = data1;
                tableView2.datas = data2;
                tableView2.dataNums = tempDatasNum;
                tableView2.curentPage = 0;
                tableView3.datas = data3;
                
                [tableView1 reloadData];
                [tableView2 reloadData];
                [tableView3 reloadData];
                //mmy
                if (self.videoUrl==nil||[self.dialog isEmpty:self.videoUrl]) {
                    readBtn.userInteractionEnabled=NO;
                    //readBtn.alpha=0.4;
                    [readBtn setBackgroundColor:[UIColor colorWithRed:188.0/255 green:188.0/255 blue:188.0/255 alpha:1]];
                }
                else{
                    readBtn.userInteractionEnabled=YES;
                    [readBtn setBackgroundColor:[UIColor clearColor]];
                }
            }
            else{
                //mmy
                if (self.videoUrl==nil||[self.dialog isEmpty:self.videoUrl]) {
                    readBtn.userInteractionEnabled=NO;
                    //readBtn.alpha=0.4;
                    [readBtn setBackgroundColor:[UIColor colorWithRed:188.0/255 green:188.0/255 blue:188.0/255 alpha:1]];
                }
                else{
                    readBtn.userInteractionEnabled=YES;
                    [readBtn setBackgroundColor:[UIColor clearColor]];
                }
            }
        }
        else//null == msg.obj
        {
            NSLog(@"服务器故障，请稍后再试");
            //mmy
            if (self.videoUrl==nil||[self.dialog isEmpty:self.videoUrl]) {
                readBtn.userInteractionEnabled=NO;
                //readBtn.alpha=0.4;
                [readBtn setBackgroundColor:[UIColor colorWithRed:188.0/255 green:188.0/255 blue:188.0/255 alpha:1]];
            }
            else{
                readBtn.userInteractionEnabled=YES;
                [readBtn setBackgroundColor:[UIColor clearColor]];
            }
        }
        
    });
}
-(void)markRead
{
    UserVo *uv= [AppDelegate getUserVo];
    URLParamter* param1=[[URLParamter alloc]initWithKey:@"username" value:uv.number];
    URLParamter* param2=[[URLParamter alloc]initWithKey:@"curriculum_id" value:[NSString stringWithFormat:@"%ld",videoId]];
    NSArray* params=[[NSArray alloc]initWithObjects:param1,param2,nil];
    NSDictionary *totalData = [ConnectUtil getNSDataFromURL:[ConnectUtil getADDCLASS] parameters:params httpMethod:[ConnectUtil getPOST]];
    int istate = 0;
    NSLog(@"add totaldata! %@",totalData);
    if (totalData!=nil) {
        NSString *state = [totalData objectForKey:@"resultcode"];
        istate = [state intValue];
    }
    if (istate) {
        NSLog(@"add success!");
    }
    else{
        NSLog(@"add failed!");
    }
}

- (void)setBtnState{
    float btnw = windowW/3;
    [daoxueBtn setBackgroundImage:[UIImage imageNamed:@"msvideobtn_uncheck.png"] forState:UIControlStateNormal];
    [daoxueBtn setBackgroundImage:[UIImage imageNamed:@"msvideobtn_check.png"] forState:UIControlStateSelected];
    [daoxueBtn setTitle:[NSString stringWithFormat:@"导  语"] forState:UIControlStateNormal];
    [daoxueBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [daoxueBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
    [daoxueBtn setFrame:CGRectMake(daoxueBtn.frame.origin.x, videoH+44, btnw, 30)];
    
    [yuanwenBtn setBackgroundImage:[UIImage imageNamed:@"msvideobtn_uncheck.png"] forState:UIControlStateNormal];
    [yuanwenBtn setBackgroundImage:[UIImage imageNamed:@"msvideobtn_check.png"] forState:UIControlStateSelected];
    [yuanwenBtn setTitle:[NSString stringWithFormat:@"原  文"] forState:UIControlStateNormal];
    [yuanwenBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [yuanwenBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
    [yuanwenBtn setFrame:CGRectMake(yuanwenBtn.frame.origin.x, videoH+54, btnw, 30)];
    
    [yueduBtn setBackgroundImage:[UIImage imageNamed:@"msvideobtn_uncheck.png"] forState:UIControlStateNormal];
    [yueduBtn setBackgroundImage:[UIImage imageNamed:@"msvideobtn_check.png"] forState:UIControlStateSelected];
    [yueduBtn setTitle:[NSString stringWithFormat:@"对照阅读"] forState:UIControlStateNormal];
    [yueduBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [yueduBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
    [yueduBtn setFrame:CGRectMake(yueduBtn.frame.origin.x, videoH+44, btnw, 30)];
}
/*
 @method 当视频播放完毕释放对象
 */
-(void)myMovieFinishedCallback:(NSNotification*)notify
{
    NSLog(@"myMovieFinishedCallback1");
    //视频播放对象
    MPMoviePlayerController* theMovie = [notify object];
    //销毁播放通知
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:theMovie];
    NSLog(@"myMovieFinishedCallback3");
    [theMovie.view removeFromSuperview];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)checkVideoBtn:(int)number{
    [daoxueBtn setBackgroundImage:[UIImage imageNamed:@"msvideobtn_uncheck.png"] forState:UIControlStateNormal];
    [yuanwenBtn setBackgroundImage:[UIImage imageNamed:@"msvideobtn_uncheck.png"] forState:UIControlStateNormal];
    [yueduBtn setBackgroundImage:[UIImage imageNamed:@"msvideobtn_uncheck.png"] forState:UIControlStateNormal];
    switch (number) {
        case 1:
            [daoxueBtn setBackgroundImage:[UIImage imageNamed:@"msvideobtn_check.png"] forState:UIControlStateNormal];
            
            break;
        case 2:
            [yuanwenBtn setBackgroundImage:[UIImage imageNamed:@"msvideobtn_check.png"] forState:UIControlStateNormal];
            break;
        case 3:
            [yueduBtn setBackgroundImage:[UIImage imageNamed:@"msvideobtn_check.png"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (IBAction)slip1Action:(id)sender {
    curPage = 1;
//    [self checkVideoBtn:curPage];
}

- (IBAction)slip2Action:(id)sender {
    curPage = 2;
//    [self checkVideoBtn:curPage];
}

- (IBAction)slip3Action:(id)sender {
    curPage = 3;
//    [self checkVideoBtn:curPage];
}
-(void) backToHomePage:(id)select{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void) goToNotePage:(id)select{
    if (readCount!=0) {
        [audioPlayer stop];
        [readBtn setTitle:@"继续" forState:UIControlStateNormal];
    }
    MainTextListViewController *home  = [[UIStoryboard storyboardWithName:@"MainTextListViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"MainTextListViewController"];
    
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];//oglFlip, fromRight
    MyQuestion *question=[MyQuestion shareInstance];
    question.textId = [NSString stringWithFormat:@"%d", self.videoId] ;
    [self presentViewController:home animated:YES completion:nil];
}
-(void) goToLianxiPage:(id)select{
    if (readCount!=0) {
        [audioPlayer stop];
        [readBtn setTitle:@"继续" forState:UIControlStateNormal];
    }
    [self getDataFromServer];

}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
- (void)playAudio:(AudioButton *)button withURL:(NSString*)url
{
    
    NSDictionary *item = [NSDictionary dictionaryWithObjectsAndKeys:  url, @"url", nil];
    if (audioPlayer == nil) {
        audioPlayer = [[AudioPlayer alloc] init];
    }
    
    if ([audioPlayer.button isEqual:button]) {
        //[button setTitle:@"暂停" forState:UIControlStateNormal];
        [audioPlayer play];
    } else {
        [button setBackgroundImage:nil forState:UIControlStateNormal];
        //[button setTitle:@"继续" forState:UIControlStateNormal];
        [audioPlayer stop];
        
        audioPlayer.button = button;
        audioPlayer.url = [NSURL URLWithString:[item objectForKey:@"url"]];
        
        [audioPlayer play];
    }
}
-(void) goToReadPage:(id)select{
    //NSString* urlStr= [NSString stringWithFormat:@"http://sc.111ttt.com/up/mp3/55560/901EC36230B7BA2F1FB8324810088B62.mp3"];
    readCount=1;
    if (self.videoUrl==nil||[self.dialog isEmpty:self.videoUrl]) {
                [self.dialog showToast:self withMessage:@"暂无音频信息"];
                return;
        }
        else{
            [self playAudio:select withURL:self.videoUrl];
            //[player stop];
        }
    
    
    
//    MusicViewController *homeViewController = [[UIStoryboard storyboardWithName:@"MainMusicView" bundle:nil] instantiateViewControllerWithIdentifier:@"MusicViewController"];
//    if ([self.dialog isEmpty:urlStr]) {
//        [self.dialog showToast:self withMessage:@"暂无音频信息"];
//        return;
//    }
//    else{
//        homeViewController.musicUrl=urlStr;
//        [player stop];
//    }
//    
//    [self presentViewController:homeViewController animated:YES completion:nil];
}
//----------mmy
#pragma mark - 获取我的笔记
-(void)getDataFromServer{
    dialog = [[Tools alloc]init];
    if (![AppDelegate isNetworkAvailable]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [dialog hideProgressHUD:self];
            [dialog showToast:self withMessage:@"网络不可用，暂无内容..."];
        });
    } else {
        UserVo* util=[AppDelegate getUserVo];
        
        URLParamter *param1=[[URLParamter alloc]initWithKey:@"username" value:util.number];
        URLParamter *param2=[[URLParamter alloc]initWithKey:@"curriculum_id" value:[NSString stringWithFormat:@"%d",  self.videoId]];
        NSArray *params=[[NSArray alloc]initWithObjects:param1,param2, nil];
        NSDictionary *dict=[ConnectUtil getNSDataFromURL:[ConnectUtil getEXERCISE] parameters:params httpMethod:[ConnectUtil getPOST]];
        
        //返回主线程进行操作
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //do something here
            [dialog hideProgressHUD:self];
            if (dict!=nil) {
                [self parseJsonData:dict withURL:[ConnectUtil getEXERCISE]];
            }
            else{
                [dialog showToast:self withMessage:@"暂无法获取数据..."];
            }
            
        });
    }
}
#pragma mark - 解析json数据
-(void)parseJsonData:(NSDictionary*) dict withURL:(NSString*)URL{
    NSNumber* resultCode = [dict objectForKey:@"resultcode"];
    if(resultCode==nil || [resultCode intValue]==0){
        [self.dialog showToast:self withMessage:@"获取数据失败"];
        return;
    }
    self.questionArray = [[NSMutableArray alloc] init] ;
    NSMutableArray* exercises=[[NSMutableArray alloc] init];
    exercises = [dict objectForKey:@"exercises"];
    for (int i=0; i<[exercises count]; i++) {
        NSDictionary* exerciseDic = [exercises objectAtIndex:i];
        Exercise* exercise = [[Exercise alloc]init];
        exercise.exerciseTitle= exerciseDic[@"exercises_title"];
        exercise.questinId = exerciseDic[@"id"];
        exercise.exerciseAnswer = exerciseDic[@"exercises_answer"];
        exercise.textId = exerciseDic[@"curriculum_id"];
        exercise.exerciseType = exerciseDic[@"exercises_type"];
        
        NSMutableArray* option=exerciseDic[@"exercises_option"];
        exercise.exerciseOption = [[NSMutableArray alloc] init];
        exercise.exerciseTrue = [[NSMutableArray alloc] init];
        exercise.myAnswer=@"";
        for (int i=0; i<option.count; i++) {
            NSString* str=[[option objectAtIndex:i]objectAtIndex:0];
//            BOOL bo=[[option objectAtIndex:i]objectAtIndex:1];
            if (![str isEqualToString:@""]) {
                [exercise.exerciseOption addObject:str];
//                if (bo==true) {
//                    NSString * string= [NSString stringWithFormat:@"%d",i];
//                    exercise.myAnswer = [exercise.myAnswer stringByAppendingString:string];
//                    exercise.myAnswer=[exercise.myAnswer stringByAppendingString:@","];
//                }
            }
            
            
        }
        [self.questionArray addObject:exercise];
        
        
    }
    MyQuestion* question = [MyQuestion shareInstance];
    question.count=0;
    question.exerciseArray = self.questionArray;
    
    [self gotoSelectPage];
    
}
-(void)gotoSelectPage{
    MyQuestion* question = [MyQuestion shareInstance];
    int page=question.count;
    
    if (question.exerciseArray.count==0||question.exerciseArray==nil) {
        [self.dialog showToast:self withMessage:@"暂无习题"];
        return;
    }
    Exercise* exercise = [question.exerciseArray objectAtIndex:page];
    SingleSelectViewController *homeViewController = [[UIStoryboard storyboardWithName:@"MyQuestionStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"SingleSelectViewController"];
//    question.count++;
    homeViewController.exercise=exercise;
    [self presentViewController:homeViewController animated:YES completion:nil];


}
-(void)viewWillAppear:(BOOL)animated
{
    //注册服务器返回信息通知接收器
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveList:) name:@"VideoMessage" object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    if(readCount!=0){
        [audioPlayer stop];
    }
    //注销
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"VideoMessage" object:nil ];
}
@end
