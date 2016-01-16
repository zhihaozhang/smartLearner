//
//  MyClassMainPageViewController.m
//  SmartLearner
//
//  Created by mmy on 15-9-26.
//  Copyright (c) 2015年 liuhaoxian. All rights reserved.
//

#import "MyClassMainPageViewController.h"
#import "AppDelegate.h"
#import "URLParamter.h"
#import "ConnectUtil.h"
#import "UserVo.h"
#import "MyClassCTableViewCell.h"
#import "PersonalCenterView.h"
#import "CollectionViewCell.h"
#import "CollectionLoadMore.h"
@interface MyClassMainPageViewController ()

@end

@implementation MyClassMainPageViewController
@synthesize datas,userVo,imageLoader,tableview,process,myNavigationBar,collections;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self viewInit];
    [self dataInit];
}
- (void)viewInit{
    float windowW = self.view.frame.size.width;
    [self.myNavigationBar setFrame:CGRectMake(0, 0, windowW, 44)];
    [self.myNavigationBar setBackgroundImage:[UIImage imageNamed: @"msnav_bg.png"] forBarMetrics:UIBarMetricsDefault];
    self.myNavigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    [self.collections setFrame:CGRectMake(4, 50, windowW-10, self.view.frame.size.height-50)];
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
-(void)clickLoadMore{
    //加载更多
    NSLog(@"click laod more");
    [[[Tools alloc]init]showToast:self withMessage:@"已无更多"];
}
-(void)scrolltoRight{
    NSLog(@"scroll to right");
    PersonalCenterView* personalCenter=[[[NSBundle mainBundle]loadNibNamed:@"PersonalCenterView" owner:self options:nil]objectAtIndex:0];
    [personalCenter setViewController:self];
    [self.view addSubview:personalCenter];

}
- (void)dataInit{
    self.datas=[[NSMutableArray alloc]initWithCapacity:200];
    self.userVo=[AppDelegate getUserVo];
    self.imageLoader=[[AsynLoaderPic alloc]init:@"images"];
    process=[[Tools alloc]init];
    [process createProgressHUD:self withMessage:@"正在获取..."];
    //获取数据
    [NSThread detachNewThreadSelector:@selector(getMyCourse) toTarget:self withObject:nil];
}
-(void)getMyCourse{
    NSString* url=[[AppDelegate getBaseUrl]stringByAppendingString:@"/curriculum/mycurriculum"];
    URLParamter* username=[[URLParamter alloc]initWithKey:@"username" value:userVo.userID];
     URLParamter* pageP=[[URLParamter alloc]initWithKey:@"page" value:@"1"];
    NSArray* params=[[NSArray alloc]initWithObjects:username,pageP, nil];
    
    
    NSDictionary* reCodeDict=[ConnectUtil getNSDataFromURL:url parameters:params];
    NSLog(@"toString=%@",reCodeDict);
     dispatch_async(dispatch_get_main_queue(),^{
         [process hideProgressHUD:self];
       if(reCodeDict!=nil){
           int flag=[[reCodeDict objectForKey:@"resultcode"]intValue];
           if(flag==1){
               NSArray* array=[reCodeDict objectForKey:@"curriculum"];
                  for (NSDictionary* dict in array) {
                     ClassVO* vo=[[ClassVO alloc]init];
                     vo.name=[dict objectForKey:@"curriculum_name"];
                     vo.url=[dict objectForKey:@"curriculum_img"];
                     vo.cid=[[dict objectForKey:@"curriculum_id"]intValue];
                     vo.classification=[dict objectForKey:@"category"];
                     [datas addObject:vo];
                  }
               NSLog(@"datas count=%d",[datas count]);
               
               if([array count]==0)
                   [process showToast:self withMessage:@"当前没有课程"];
               else
                   [self.collections reloadData];
            }
           else{
                  NSLog(@"empty");
               [process showToast:self withMessage:@"当前没有课程"];
               }
           }
       else{
            NSLog(@"server or network error");
           [process showToast:self withMessage:@"服务连接到服务器"];
       }
       });
       
    
    
    
    
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
    [self.imageLoader getPicFromURL:item.url UIImageView:cell.im_view defaultImage:@"msallclass_list_item_bg.png"];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)moreAction:(id)sender {
    PersonalCenterView* personalCenter=[[[NSBundle mainBundle]loadNibNamed:@"PersonalCenterView" owner:self options:nil]objectAtIndex:0];
    [personalCenter setViewController:self];
    [self.view addSubview:personalCenter];

}
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
