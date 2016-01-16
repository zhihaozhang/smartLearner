//
//  MainTextListViewController.m
//  Course
//
//  Created by 李青山 on 15/9/26.
//  Copyright (c) 2015年 ASELab. All rights reserved.
//

#import "MainTextListViewController.h"

@interface MainTextListViewController ()

@end

@implementation MainTextListViewController
@synthesize dialog;
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:nil];
    [self initData];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"----");
    // Do any additional setup after loading the view.
    //设置导航栏背景
    //不是自带的导航条不能这么用
    [self.navigationBar setBackgroundImage:[UIImage imageNamed: @"msnav_bg.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    
}
-(void)initData{
    dialog = [[Tools alloc] init];
    
    self.textArray = [[NSMutableArray alloc] init];
    [self getDataFromServer];
//    for (int i=0; i<3; i++) {
//        MyText* myText = [[MyText alloc]init];
//        myText.noteTitle = @"BigBang";
//        myText.textName = @"AG";
//        myText.note = @"Bigbang是于2006年出道的韩国组合，由队长权志龙、崔胜贤、东永裴、姜大声、李胜贤五位成员组成。2006年8月19日，Bigbang在YG Family世界巡回演唱会首尔站上正式出道，并于同年12月22日发行首张正规专辑《BIGBANGVOL.1 SINCE2007》。2007年5月，Bigbang开始进行全国巡回演唱会，并于7月推出了第一张迷你专辑《谎言》。2011年，BigBang成为历史上第一个获得MTV 欧洲音乐大奖“Worldwide Act”的亚洲组合，并于2012年上半年登上美国格莱美官方网页，成为首个被格莱美介绍的韩国歌手。";
//        [self.textArray addObject:myText];
//    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 获取我的笔记
-(void)getDataFromServer{
    if (![AppDelegate isNetworkAvailable]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [dialog hideProgressHUD:self];
            [dialog showToast:self withMessage:@"网络不可用，暂无内容..."];
        });
    } else {
        UserVo* uv=[AppDelegate getUserVo];
        
        URLParamter *param1=[[URLParamter alloc]initWithKey:@"username" value:uv.number];
        NSArray *params=[[NSArray alloc]initWithObjects:param1, nil];
        NSDictionary *dict=[ConnectUtil getNSDataFromURL:[ConnectUtil getMY_NOTE] parameters:params httpMethod:[ConnectUtil getPOST]];
        
        //返回主线程进行操作
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //do something here
            [dialog hideProgressHUD:self];
            if (dict!=nil) {
                [self parseJsonData:dict withURL:[ConnectUtil getMY_NOTE]];
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
    self.textArray = [[NSMutableArray alloc] init] ;
    NSMutableArray* notes=[[NSMutableArray alloc] init];
    notes = [dict objectForKey:@"note"];
    for (int i=0; i<[notes count]; i++) {
        NSDictionary* noteDic = [notes objectAtIndex:i];
        MyText* note = [[MyText alloc]init];
        note.note = noteDic[@"note"];
        note.noteId = noteDic[@"id"];
        note.textId = noteDic[@"curriculum_id"];
        note.noteTitle = noteDic[@"note_title"];
        note.textName = noteDic[@"curriculum_name"];

        [self.textArray addObject:note];
        
        
    }
    
    
    [self.tableView reloadData];

    
    
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.textArray.count;
    
        //[self.interactionCommentList count];
}

- (TextListCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier;
    TextListCell* cell1;
    
    CellIdentifier = @"TextListCell";
    cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell1) {
        cell1 = [[TextListCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    else//当页面拉动的时候 当cell存在并且最后一个存在 把它进行删除就出来一个独特的cell我们在进行数据配置即可避免
    {
//        while ([cell1.contentView.subviews lastObject] != nil) {
//            [(UIView *)[cell1.contentView.subviews lastObject] removeFromSuperview];
//        }
    }
    
//    InteractionCommentVo *comment=[self.interactionCommentList objectAtIndex:indexPath.row];
    MyText *note=[self.textArray objectAtIndex:indexPath.row];
    
    cell1.titleLabel.text = [NSString stringWithFormat:@"标题: %@",note.noteTitle];
    cell1.textLabel.text = note.textName;
    
    [cell1 setIntroductionText:note.note];

    
    return cell1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
    
    
}
- (IBAction)clickGetMore:(id)sender {
    [self getDataFromServer];
    //[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickNewText:(id)sender {
    NewTextViewController *homeViewController =[[UIStoryboard storyboardWithName:@"MainTextListViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"NewTextViewController"];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    MyQuestion *question=[MyQuestion shareInstance];
    [self presentViewController:homeViewController animated:YES completion:nil];
}
- (IBAction)clickRight:(id)sender {
    
//    PersonalCenterView* personalCenter=[[[NSBundle mainBundle]loadNibNamed:@"PersonalCenterView" owner:self options:nil]objectAtIndex:0];
//    [personalCenter setViewController:self];
//    [self.view addSubview:personalCenter];
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
