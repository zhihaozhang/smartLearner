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
@interface MyClassMainPageViewController ()

@end

@implementation MyClassMainPageViewController
@synthesize datas,userVo,imageLoader,tableview,process,myNavigationBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    //注册myClassCell
    NSString* CellIdentifier1=@"myClassTableViewCell";
    UINib* nib=[UINib nibWithNibName:@"MyClassCTableViewCell" bundle:nil];
    [self.tableview registerNib:nib forCellReuseIdentifier:CellIdentifier1];
    [self viewInit];
    [self dataInit];
}
- (void)viewInit{
    
    float windowW = self.view.frame.size.width;
    [self.myNavigationBar setFrame:CGRectMake(0, 0, windowW, 44)];
    [self.myNavigationBar setBackgroundImage:[UIImage imageNamed: @"msnav_bg.png"] forBarMetrics:UIBarMetricsDefault];
    self.myNavigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    [self.tableview setFrame:CGRectMake(0, 44, windowW, self.view.frame.size.height-44)];
    //添加向右滑动的手势
    
    UISwipeGestureRecognizer* gister=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(scrolltoRight)];
    [gister setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:gister];
    

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
                   [self.tableview reloadData];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.datas count]>0) {
        return [self.datas count]+1;
    }
    NSLog(@"tableview size=%d",[self.datas count]);
    return [self.datas count];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//得到tableViewCell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier1 = @"myClassTableViewCell";
    static NSString *CellIdentifier2 = @"moreCell";
    int position = indexPath.row;
    int totalNum = [datas count];
    
    [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    if(totalNum>0){
        if (position==totalNum) {
            MoreTableViewCell *cell = nil;
            cell = (MoreTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
            if (cell==nil) {
                cell = [[MoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
            }
            [cell.cellMore setFrame:CGRectMake(0, 10, self.view.frame.size.width, 21)];
            [cell.cellMore setText:@"获取更多"];
            return cell;
        }else{
            
            ClassVO *item = [datas objectAtIndex:position];
            MyClassCTableViewCell *cell = nil;
            cell = (MyClassCTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
            //[cell setFrame:CGRectMake(0, 0, self.view.frame.size.width,70)];
            [cell.lb_curriculum setText:item.name];
            //异步加载图片
            [self.imageLoader getPicFromURL:item.url UIImageView:cell.im_cell defaultImage:@"msallclass_list_item_bg.png"];
            //[cell.cellImage setImage:[UIImage imageNamed:item.url]];
            return cell;
        }
    }else{
        AllClassHomePageCell *cell = nil;
        cell = (AllClassHomePageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        
        return cell;
    }
}
//某一行被点击的事件响应
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    if (row<[datas count]) {
        //记录已经查看了
        //        [self markRead:row];
        //点击跳转
        AllClassVideoViewController *video = [[UIStoryboard storyboardWithName:@"AllClass" bundle:nil] instantiateViewControllerWithIdentifier:@"videoPage"];
        ClassVO *elem = [datas objectAtIndex:row];
        video.videoId = elem.cid;
        
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];//oglFlip, fromRight
        [self presentViewController:video animated:YES completion:nil];
    }else{
        // 1.网络重新获取数据
       
    }
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
