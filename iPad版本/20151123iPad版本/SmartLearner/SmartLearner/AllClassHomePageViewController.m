//
//  AllClassHomePageViewController.m
//  SmartLearner
//
//  Created by mmy on 15-9-25.
//  Copyright (c) 2015年 liuhaoxian. All rights reserved.
//

#import "AllClassHomePageViewController.h"
#import "PersonalCenterView.h"
@interface AllClassHomePageViewController ()

@end
@implementation AllClassHomePageViewController

@synthesize datas,myTimer,imageArray,imageNames;
@synthesize myPageControl,myScrollView;
@synthesize page,totalData;
@synthesize process,collections;
@synthesize picCache,myNavigationBar,btn_search;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewInit];
    [self initData];
//    [self configScrollView];
    
    NSThread* myThread2 = [[NSThread alloc] initWithTarget:self
                                                 selector:@selector(getData)
                                                   object:nil];
    [myThread2 start];
}
-(void)viewInit{
    float windowH = self.view.frame.size.height;
    float windowW = self.view.frame.size.width;
    float scrollViewH = windowH/3;
    [self.myScrollView setFrame:CGRectMake(0, 44, self.view.frame.size.width, scrollViewH)];
    [self.collections setFrame:CGRectMake(5, 50+scrollViewH, windowW-10, self.view.frame.size.height-(50+scrollViewH))];
    [self.myPageControl setFrame:CGRectMake(windowW-100, self.collections.frame.origin.y-40, 100, 20)];
    [self.myNavigationBar setFrame:CGRectMake(0, 0, windowW, 44)];
    [self.myNavigationBar setBackgroundImage:[UIImage imageNamed: @"msnav_bg.png"] forBarMetrics:UIBarMetricsDefault];
    self.myNavigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    myScrollView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToPage)];
    [myScrollView addGestureRecognizer:singleTap];
    [btn_search setFrame:CGRectMake(windowW-37, 9, 27, 27)];
    //添加向右滑动的手势
    
    UISwipeGestureRecognizer* gister=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(scrolltoRight)];
    [gister setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:gister];
    
    //注册collectionViewCell
    NSString* CellIdentifier1=@"CollectionViewCell";
    UINib* nib=[UINib nibWithNibName:CellIdentifier1 bundle:nil];
    
    [self.collections registerNib:nib forCellWithReuseIdentifier:CellIdentifier1];
    //collectionViewLoadMore
    [self.collections registerNib:[UINib nibWithNibName:@"CollectionLoadMore" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"CollectionLoadMore"];
}
-(void)scrolltoRight{
    NSLog(@"scroll to right");
    PersonalCenterView* personalCenter=[[[NSBundle mainBundle]loadNibNamed:@"PersonalCenterView" owner:self options:nil]objectAtIndex:0];
    [personalCenter setViewController:self];
    [self.view addSubview:personalCenter];
}
-(void)initData{
    page = 1;
    totalData = [[NSMutableDictionary alloc] init];
    datas = [[NSMutableArray alloc]init];
    process = [[Tools alloc] init];
    picCache = [[AsynLoaderPic alloc] init:@"ha"];
    imageArray = [[NSMutableArray alloc]init];
    imageNames = [[NSMutableArray alloc] init];
 
}
-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"viewWillAppear");
    //注册服务器返回信息通知接收器
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveClassList:) name:@"AllClassList" object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    
    //注销
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AllClassList" object:nil ];
}
-(void)receiveClassList:(NSNotification*)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (notification.object!=nil) {
            NSString* state = (NSString*)notification.object;
            if ([state isEqualToString:@"success"]) {
                NSArray *temp = [totalData objectForKey:@"curriculum"];
                for (int j=0; j<[temp count]; j++) {
                    ClassVO *elem = [[ClassVO alloc] init];
                    NSString *sid = [[temp objectAtIndex:j] objectForKey:@"id"];
                    elem.cid = [sid intValue];
                    elem.classification = [[temp objectAtIndex:j] objectForKey:@"category"];
                    elem.name = [[temp objectAtIndex:j] objectForKey:@"curriculum_name"];
                    elem.url = [[temp objectAtIndex:j] objectForKey:@"curriculum_img"];
                    [datas addObject:elem];
                }
                
                NSArray *tempimg = [[NSArray alloc] init];
                tempimg = [totalData objectForKey:@"banner"];
                [imageNames removeAllObjects];
                [imageArray removeAllObjects];
                for (int i=0; i<tempimg.count; i++) {
                    NSString *tempUrl = [[tempimg objectAtIndex:i] objectForKey:@"img"];
                    if (![tempUrl containsString:@"http://120.24.94.254:8181/"]) {
                        tempUrl = [NSString stringWithFormat:@"http://120.24.94.254:8181/%@",tempUrl];
                    }
                    NSString *imgname = [[tempimg objectAtIndex:i] objectForKey:@"curriculum_id"];
                    [imageNames addObject:imgname];
                    //                    NSLog(@"nav image id is %@",tempUrl);
                    [imageArray addObject:tempUrl];
                }
                
                NSThread* myThread1 = [[NSThread alloc] initWithTarget:self
                                                              selector:@selector(configScrollView)
                                                                object:nil];
                [myThread1 start];
                //放在这里为了第一次出现该页面时，广告自动切换
                myTimer=[NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(scrollToNextPage:) userInfo:nil repeats:YES];
                for (int i=0; i<[datas count]; i++) {
                    ClassVO *item = [datas objectAtIndex:i];
                    NSLog(@"datas item name %@",item.name);
                }
                [self.collections reloadData];
            }
            else{
                [self.process showToast:self withMessage:@"没有获取到快讯"];
            }
        }
        else//null == msg.obj
        {
            NSLog(@"服务器故障，请稍后再试");
        }
        
    });
}


-(void)getData
{
    URLParamter* param1=[[URLParamter alloc]initWithKey:@"page" value:[NSString stringWithFormat:@"%d",page]];
    NSArray* params=[[NSArray alloc]initWithObjects:param1,nil];
    [process hideProgressHUD:self];
    totalData = [ConnectUtil getNSDataFromURL:[ConnectUtil getALLCLASS_HOME_LIST] parameters:params httpMethod:[ConnectUtil getPOST]];
    int istate = 0;
    if (totalData!=nil) {
        NSString *state = [totalData objectForKey:@"resultcode"];
        istate = [state intValue];
    }
    
    if (istate) {
        NSLog(@"data count is :%lu",(unsigned long)totalData.count);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"AllClassList" object:@"success"];
    }
    else{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"AllClassList" object:@"fail"];
    }
}


- (void)configScrollView{
    UIImageView *firstView=[[UIImageView alloc]init];
    
    [self.picCache getPicFromURL:[imageArray objectAtIndex:0] UIImageView:firstView defaultImage:@"default.png"];
    CGFloat Width=self.myScrollView.frame.size.width;
    CGFloat Height=self.myScrollView.frame.size.height;
    firstView.frame=CGRectMake(0, 0, Width, Height);
    [self.myScrollView addSubview:firstView];
    
    //    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToPage)];
    //    [firstView addGestureRecognizer:singleTap];
    
    for (int i=0; i<[imageArray count]; i++) {
        
        UIImageView *subViews=[[UIImageView alloc]init];
        [self.picCache getPicFromURL:[imageArray objectAtIndex:i] UIImageView:subViews defaultImage:@"msallclass_list_item_bg.png"];
        subViews.frame=CGRectMake(Width*(i+1), 0, Width, Height);
        subViews.userInteractionEnabled = YES;
        [subViews targetForAction:@selector(goToPage) withSender:self];
        [self.myScrollView addSubview: subViews];
    }
    
    UIImageView *lastView=[[UIImageView alloc]init];
    [self.picCache getPicFromURL:[imageArray objectAtIndex:0] UIImageView:lastView defaultImage:@"msallclass_list_item_bg.png"];
    lastView.frame=CGRectMake(Width*(imageArray.count+1), 0, Width, Height);
    [self.myScrollView addSubview:lastView];
    //set the first as the last
    [self.myScrollView setContentSize:CGSizeMake(Width*(imageArray.count+2), Height)];
    [self.view addSubview:self.myScrollView];
    [self.myScrollView scrollRectToVisible:CGRectMake(Width, 0, Width, Height) animated:NO];
    self.myPageControl.numberOfPages=imageArray.count;
    self.myPageControl.currentPage=0;
    self.myPageControl.enabled=YES;
    [self.view addSubview:self.myPageControl];
    [self.view bringSubviewToFront:myPageControl];
    [self.myPageControl addTarget:self action:@selector(turnPage:)forControlEvents:UIControlEventValueChanged];
    
    //    myTimer=[NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(scrollToNextPage:) userInfo:nil repeats:YES];
    //这里启动计时器当页面刚加载时，广告并不自动滑动
}
#pragma UIScrollView delegate
-(void)scrollToNextPage:(id)sender
{
    int pageNum=self.myPageControl.currentPage;
    CGSize viewSize=self.myScrollView.frame.size;
    CGRect rect=CGRectMake((pageNum+2)*viewSize.width, 0, viewSize.width, viewSize.height);
    [self.myScrollView scrollRectToVisible:rect animated:NO];
    pageNum++;
    if (pageNum==imageArray.count) {
            CGRect newRect=CGRectMake(viewSize.width, 0, viewSize.width, viewSize.height);
        [self.myScrollView scrollRectToVisible:newRect animated:NO];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth=self.myScrollView.frame.size.width;
    int currentPage=floor((self.myScrollView.contentOffset.x-pageWidth/2)/pageWidth)+1;
    if (currentPage==0) {
        self.myPageControl.currentPage=imageArray.count-1;
    }else if(currentPage==imageArray.count+1){
        self.myPageControl.currentPage=0;
    }
    self.myPageControl.currentPage=currentPage-1;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [myTimer invalidate];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    myTimer=[NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(scrollToNextPage:) userInfo:nil repeats:YES];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth=self.myScrollView.frame.size.width;
    CGFloat pageHeigth=self.myScrollView.frame.size.height;
    int currentPage=floor((self.myScrollView.contentOffset.x-pageWidth/2)/pageWidth)+1;
    NSLog(@"the current offset==%f",self.myScrollView.contentOffset.x);
    NSLog(@"the current page==%d",currentPage);
    
    if (currentPage==0) {
        [self.myScrollView scrollRectToVisible:CGRectMake(pageWidth*imageArray.count, 0, pageWidth, pageHeigth) animated:NO];
        self.myPageControl.currentPage=imageArray.count-1;
        NSLog(@"pageControl currentPage==%d",self.myPageControl.currentPage);
        NSLog(@"the last image");
        return;
    }else  if(currentPage==[imageArray count]+1){
        [self.myScrollView scrollRectToVisible:CGRectMake(pageWidth, 0, pageWidth, pageHeigth) animated:NO];
                    self.myPageControl.currentPage=0;
        NSLog(@"pageControl currentPage==%d",self.myPageControl.currentPage);
        NSLog(@"the first image");
        return;
    }
    self.myPageControl.currentPage=currentPage-1;
    NSLog(@"pageControl currentPage==%d",self.myPageControl.currentPage);
}
-(IBAction)turnPage:(UIPageControl *)sender
{
    int pageNum=myPageControl.currentPage;
    CGSize viewSize=self.myScrollView.frame.size;
    [self.myScrollView setContentOffset:CGPointMake((pageNum+1)*viewSize.width, 0)];
    NSLog(@"myscrollView.contentOffSet.x==%f",myScrollView.contentOffset.x);
    [myTimer invalidate];
}
-(void)goToPage
{
    int pageNum=myPageControl.currentPage;
    NSString *curNum = [imageNames objectAtIndex:pageNum];
    int icurNum = [curNum intValue];
    NSLog(@"******** you clicked image number %d",pageNum);
    //点击跳转
    AllClassVideoViewController *video = [[UIStoryboard storyboardWithName:@"AllClass" bundle:nil] instantiateViewControllerWithIdentifier:@"videoPage"];
    video.videoId = icurNum;
    
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];//oglFlip, fromRight
    [self presentViewController:video animated:YES completion:nil];
}

- (IBAction)searchAction:(id)sender {
    AllClassVideoViewController *video = [[UIStoryboard storyboardWithName:@"AllClass" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchPage"];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];//oglFlip, fromRight
    [self presentViewController:video animated:YES completion:nil];
}

- (IBAction)moreAction:(id)sender {
    PersonalCenterView* personalCenter=[[[NSBundle mainBundle]loadNibNamed:@"PersonalCenterView" owner:self options:nil]objectAtIndex:0];
    [personalCenter setViewController:self];
    [self.view addSubview:personalCenter];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)clickLoadMore{
    //加载更多
    NSLog(@"click laod more");
    page ++;//请求次数
    [self getData];
}
# pragma mark -collection data source
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.datas count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString* CellIdentifier1=@"CollectionViewCell";
    CollectionViewCell* cell=(CollectionViewCell*)[collections dequeueReusableCellWithReuseIdentifier:CellIdentifier1 forIndexPath:indexPath];
    ClassVO *item = [datas objectAtIndex:indexPath.row];
    [cell.lb_curriculum setText:item.name];
    [cell.lb_catelog setText:item.classification];
    //异步加载图片
    [self.picCache getPicFromURL:item.url UIImageView:cell.im_view defaultImage:@"msallclass_list_item_bg.png"];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    AllClassVideoViewController *video = [[UIStoryboard storyboardWithName:@"AllClass" bundle:nil] instantiateViewControllerWithIdentifier:@"videoPage"];
    ClassVO *elem = [datas objectAtIndex:row];
    video.videoId = elem.cid;
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];//oglFlip, fromRight
    [self presentViewController:video animated:YES completion:nil];
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    float windowW = self.view.frame.size.width;
    return CGSizeMake((windowW-50-10)/4, 180);
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    CollectionLoadMore* footerView=nil;
    if (kind==UICollectionElementKindSectionFooter) {
        footerView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"CollectionLoadMore" forIndexPath:indexPath];
        [footerView.btn_loadMore addTarget:self action:@selector(clickLoadMore) forControlEvents:UIControlEventTouchUpInside];
        footerView.userInteractionEnabled=true;
    }
    return footerView;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    float windowW = self.view.frame.size.width;
    
    return CGSizeMake(windowW-10, 40);
}

//得到tableViewCell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    static NSString *CellIdentifier1 = @"ItemCell";
    static NSString *CellIdentifier2 = @"MoreCell";
    int position = indexPath.row;
//    NSLog(@"table cell item %d",position);
    
    if (position<[datas count]) {
        AllClassHomePageCell *cell = nil;
        ClassVO *item = [datas objectAtIndex:position];
        cell = (AllClassHomePageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (cell==nil) {
            cell = [[AllClassHomePageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
        }
        [cell.cellTitle setText:item.name];
        [self.picCache getPicFromURL:item.url UIImageView:cell.cellImage defaultImage:@"课程默认图片.png"];
        [cell.cellClasification setText:item.classification];
        return cell;
    }else{
        MoreCell *cell = nil;
        cell = (MoreCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (cell==nil) {
            cell = [[MoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
        }
        [cell.cellMore setFrame:CGRectMake(0, 10, self.view.frame.size.width, 21)];
        [cell.cellMore setText:@"获取更多"];//暂无更多
        return cell;
    }
}
//某一行被点击的事件响应
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"you click item %d",indexPath.row);
    NSInteger row = indexPath.row;
    if (row<[datas count]) {
        //记录已经查看了
//        [self markRead:row];
        //点击跳转
        AllClassVideoViewController *video = [[UIStoryboard storyboardWithName:@"AllClass" bundle:nil] instantiateViewControllerWithIdentifier:@"videoPage"];
        ClassVO *elem = [datas objectAtIndex:row];
        video.videoId = elem.cid;
        NSLog(@"%@",elem.name);
        MyQuestion *question=[MyQuestion shareInstance];
        question.textName=elem.name;
//        video.myTitle = elem.name;
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];//oglFlip, fromRight
        [self presentViewController:video animated:YES completion:nil];
    }else{
        // 1.网络重新获取数据
        page ++;//请求次数
        [self getData];
    }
}
-(void)markRead:(NSInteger) num
{
//    SharePreferenceUtil *util = [[SharePreferenceUtil alloc] init];
    ClassVO *item = [datas objectAtIndex:num];
    UserVo *user = [AppDelegate getUserVo];
    URLParamter* param1=[[URLParamter alloc]initWithKey:@"username" value:user.number];
    URLParamter* param2=[[URLParamter alloc]initWithKey:@"curriculum_id" value:[NSString stringWithFormat:@"%ld",item.cid]];
    NSArray* params=[[NSArray alloc]initWithObjects:param1,param2,nil];
    [process hideProgressHUD:self];
    totalData = [ConnectUtil getNSDataFromURL:[ConnectUtil getADDCLASS] parameters:params httpMethod:[ConnectUtil getPOST]];
    int istate = 0;
    NSLog(@"add totaldata! %@",totalData);
    if (totalData!=nil) {
        NSString *state = [totalData objectForKey:@"resultcode"];
        istate = [state intValue];
    }
    Tools *toast = [[Tools alloc] init];
    if (istate) {
        [toast showToast:self withMessage:@"add success!"];
        NSLog(@"add success!");
    }
    else{
        [toast showToast:self withMessage:@"add failed!"];
        NSLog(@"add failed!");
    }
}

#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
-(BOOL)shouldAutorotate{
    return NO;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}
@end
