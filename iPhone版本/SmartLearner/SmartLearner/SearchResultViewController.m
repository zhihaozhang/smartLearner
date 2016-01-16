//
//  SearchResultViewController.m
//  SmartLearner
//
//  Created by mmy on 15-9-26.
//  Copyright (c) 2015年 liuhaoxian. All rights reserved.
//

#import "SearchResultViewController.h"

@interface SearchResultViewController ()

@end

@implementation SearchResultViewController
@synthesize datas,imageArray,searchContext,mytableview,picCache,myNavigationBar,searchBtn;
NSDictionary* data;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewInit];
    [self dataInit];
}
- (void)viewInit{
    [self.myNavigationBar setBackgroundImage:[UIImage imageNamed: @"msnav_bg.png"] forBarMetrics:UIBarMetricsDefault];
    self.myNavigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    float windowW = self.view.frame.size.width;
    [self.searchBtn setFrame:CGRectMake(windowW-37, 8, 27, 27)];
    float tempW = windowW - 100;
    float controlW = tempW>170?tempW:170;
    [self.searchContext setFrame:CGRectMake(0, 8, controlW, 30)];
    [self.searchContext setCenter:CGPointMake(windowW/2, 22)];
    [self.mytableview setFrame:CGRectMake(0, 44, windowW, self.view.frame.size.height-44)];
}
- (void)dataInit{
    self.datas = [[NSMutableArray alloc]init];
    picCache = [[AsynLoaderPic alloc] init:@"ha"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.datas count];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//得到tableViewCell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"SearchCell";
    int position = indexPath.row;
    ClassVO *item = [datas objectAtIndex:position];
    AllClassHomePageCell *cell = nil;
    
    [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    cell = (AllClassHomePageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell = [[AllClassHomePageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSLog(@"cell name is %@",item.name);
    [cell.cellTitle setText:item.name];
    if (item.url) {
//        NSURL *imageUrl = [NSURL URLWithString:@"http://pic1.bbzhi.com/dongwubizhi/labuladuoxunhuiquanbizhi/animal_labrador_retriever_1600x1200_44226_2.jpg"];
//        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
       // [self.picCache getPicFrom:item.url URL:item.url UIImageView:cell.cellImage];
//        [cell.cellImage setImage:image];
        [self.picCache getPicFromURL:item.url UIImageView:cell.cellImage defaultImage:@"msallclass_list_item_bg.png"];
    }else{
        [cell.cellImage setImage:[UIImage imageNamed:@"msallclass_list_item_bg.png"]];
    }
    [cell.cellClasification setText:item.classification];
    return cell;
}
- (void)setExtracellLineHidden:(UITableView *)tableView{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
//某一行被点击的事件响应
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"you click item %d",indexPath.row);
    NSInteger row = indexPath.row;
    AllClassVideoViewController *video = [[UIStoryboard storyboardWithName:@"AllClass" bundle:nil] instantiateViewControllerWithIdentifier:@"videoPage"];
    ClassVO *elem = [datas objectAtIndex:row];
    video.videoId = elem.cid;
    
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];//oglFlip, fromRight
    [self presentViewController:video animated:YES completion:nil];

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)viewWillAppear:(BOOL)animated
{
    //注册服务器返回信息通知接收器
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveList:) name:@"SearchClassList" object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    
    //注销
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SearchClassList" object:nil ];
}
- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)searchAction:(id)sender {
    NSThread* myThread = [[NSThread alloc] initWithTarget:self
                                                 selector:@selector(getData)
                                                   object:nil];
    [myThread start];
}
-(void)getData
{
    
    URLParamter* param1=[[URLParamter alloc]initWithKey:@"curriculum_title" value:searchContext.text];
    
    NSArray* params=[[NSArray alloc]initWithObjects:param1,nil];
    data=[ConnectUtil getNSDataFromURL:[ConnectUtil getSEARCHCLASS] parameters:params httpMethod:[ConnectUtil getPOST]];
    NSString *state = [data objectForKey:@"resultcode"];
    int istate = [state intValue];
    if (istate) {
        NSLog(@"data count is :%lu",(unsigned long)[data count]);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"SearchClassList" object:@"success"];    }
    else{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"SearchClassList" object:@"fail"];
    }
}
-(void)receiveList:(NSNotification*)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (notification.object!=nil) {
            [datas removeAllObjects];
            NSString* state = (NSString*)notification.object;
            if ([state isEqualToString:@"success"]) {
                 NSArray *temp = [data objectForKey:@"curriculum"];
                for (int i=0; i<temp.count; i++) {
                    ClassVO *elem = [[ClassVO alloc] init];
                    NSString *iid = [[temp objectAtIndex:i] objectForKey:@"id"];
                    elem.cid = [iid intValue];
                    elem.name = [[temp objectAtIndex:i] objectForKey:@"curriculum_name"];
                    elem.url = [[temp objectAtIndex:i] objectForKey:@"curriculum_img"];
                    elem.classification = [[temp objectAtIndex:i] objectForKey:@"category"];
                    [datas addObject:elem];
                }
//                for(int i=0;i<datas.count;i++){
//                    ClassVO*elem=[datas objectAtIndex:i];
//                    NSLog(@"elem name is %@",elem.name);
//                }

                //                }
                [mytableview reloadData];
            }
            else{
                //                [self.toast showToast:self withMessage:@"没有获取到快讯"];
            }
        }
        else//null == msg.obj
        {
            NSLog(@"服务器故障，请稍后再试");
        }
        
    });
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
