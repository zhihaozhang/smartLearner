//
//  SingleSelectViewController.m
//  SmartLearner
//
//  Created by 李青山 on 15/10/12.
//  Copyright (c) 2015年 liuhaoxian. All rights reserved.
//

#import "SingleSelectViewController.h"

@interface SingleSelectViewController ()

@end

@implementation SingleSelectViewController
@synthesize mark;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    //[self initData];
    [self markInit];
    
    self.questionLabel.text = self.exercise.exerciseTitle;
    
    if ([self.exercise.exerciseType isEqualToString:@"单选"]) {//单选
        if ([self.exercise.exerciseOption count]>0) {
            mark[0]=@1;
            self.selected=0;
        }
    }
    else{//多选
    
        self.selectedStr=@"";
    }
    
    
}
-(void) initView{
    //设置导航栏背景
    //不是自带的导航条不能这么用
    [self.navigationBar setBackgroundImage:[UIImage imageNamed: @"msnav_bg.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    [self.myNavigationItem setTitle:self.exercise.exerciseType];
    self.dialog = [[Tools alloc]init];
    
    //手势
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:recognizer];
}
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        //向右滑动
        
    }
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        //向左滑动
//        PersonalCenterView* personalCenter=[[[NSBundle mainBundle]loadNibNamed:@"PersonalCenterView" owner:self options:nil]objectAtIndex:0];
//        [personalCenter setViewController:self];
//            [self.view addSubview:personalCenter];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}
-(void)markInit
{
    mark = [[NSMutableArray alloc] init];
    NSMutableArray *mMark = [[NSMutableArray alloc] init];
    
    
    for(int i=0; i<[self.exercise.exerciseOption count];i++)
    {
        mMark[i]=@0;
    }
    
    mark = mMark;
    
}
-(void)initData{
    self.exercise = [[Exercise alloc]init];
    self.exercise.exerciseAnswer=@"1";
    self.exercise.exerciseTitle=@"Bigbang是于2006年出道的韩国组合，由队长权志龙、崔胜贤、东永裴、姜大声、李胜贤五位成员组成。";
    NSMutableArray *opion = [[NSMutableArray alloc]init];
    for (int i=0; i<3; i++) {
        NSString* str= @"Bigbang是于2006年出道的韩国组合";
        [opion addObject:str];
    }
    self.exercise.exerciseOption = opion;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.exercise.exerciseOption.count;
    
    //[self.interactionCommentList count];
}

- (SingleSelectCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier,*CellIdentifier2;
    SingleSelectCell* cell1;
    int row = indexPath.row;
    CellIdentifier = @"SingleSelectCell";
    CellIdentifier2 = @"MultiSelectCell";
    if ([self.exercise.exerciseType isEqualToString:@"单选"]) {//单选
        cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
        if (!cell1) {
            cell1 = [[SingleSelectCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        else//当页面拉动的时候 当cell存在并且最后一个存在 把它进行删除就出来一个独特的cell我们在进行数据配置即可避免
        {
        }
        
        NSMutableArray *option=self.exercise.exerciseOption;
        NSInteger temp = [mark[row] integerValue];
        if(!temp)
        {
            [cell1.button setBackgroundImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
        }
        else
        {
            [cell1.button setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
        }
        cell1.label.text = [NSString stringWithFormat:@"%@",[option objectAtIndex:indexPath.row]];
        //    [cell1.button setTag:row];
        //    [cell1.button addTarget:self action:@selector(butonChange:) forControlEvents:UIControlEventTouchUpInside];
    }
    else{//多选
        cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        //    InteractionCommentVo *comment=[self.interactionCommentList objectAtIndex:indexPath.row];
        NSString *comment=[self.exercise.exerciseOption objectAtIndex:indexPath.row];
        
        UIImageView *image = (UIImageView *)[cell1 viewWithTag:300];
        UILabel *selection = (UILabel *)[cell1 viewWithTag:301];
        selection.text =comment;
        NSInteger temp = [mark[row] integerValue];
        if(!temp)
        {
            [image setImage:[UIImage imageNamed:@"unchecked.png"]];
        }
        else
        {
            [image setImage:[UIImage imageNamed:@"checked.png"]];
        }
    
    }
    return cell1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    int row = indexPath.row;
    UITableViewCell *myCell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    int temp = [mark[row] integerValue];
    if ([self.exercise.exerciseType isEqualToString:@"单选"]) {//单选
        UIButton *button = (UIButton *)[myCell viewWithTag:10];
        if(!temp)
        {
            [self markInit];
            mark[row] = @1;
            [button setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
            self.selected=row;
            [tableView reloadData];
            NSLog(@"selected---%d",self.selected);
        }
    }
    else{//多选
        UIImageView *image = (UIImageView *)[myCell viewWithTag:300];
        if(temp)
        {
            mark[row] = @0;
            [image setImage:[UIImage imageNamed:@"unchecked.png"]];
            [tableView reloadData];
        }
        else
        {
            mark[row] = @1;
            //[myCell setBackgroundColor:[UIColor grayColor]];
            [image setImage:[UIImage imageNamed:@"checked.png"]];
            [tableView reloadData];
        }
    }
    
    
    
    
    
}
//-(void)butonChange:(UIButton*)button{
//    NSInteger row = button.tag;
//    NSInteger temp = [mark[row] integerValue];
//    //NSLog(@"temp---%d",temp);
//    if(!temp)
//    {
//        [self markInit];
//        mark[row] = @1;
//        [button setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
//        self.selected=[NSString stringWithFormat:@"%ld",row];
//        NSLog(@"selected---%d",self.selected);
//        [self.tableView reloadData];
//    }
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
//    return cell.frame.size.height;
    return 70;
    
}

- (IBAction)clickBack:(id)sender {
    //[self dismissViewControllerAnimated:YES completion:nil];
    MyQuestion* question = [MyQuestion shareInstance];
    
    if (question.count<=0) {
        [self.dialog showToast:self withMessage:@"已经是第一题了"];
        return;
    }
    question.count--;
    int page=question.count;
    Exercise* exercise = [question.exerciseArray objectAtIndex:page];
    if ([exercise.exerciseType isEqualToString:@"单选"]) {
        [self.myNavigationItem setTitle:@"单选"];
        
        self.exercise =exercise;
        [self markInit];
        self.questionLabel.text = self.exercise.exerciseTitle;
        if ([self.exercise.exerciseOption count]>0) {
            mark[0]=@1;
            self.selected=0;
        }
        self.answerLabel.text=@"";
        [self.tableView reloadData];
        
        
    }else{
        [self.myNavigationItem setTitle:@"多选"];
        
        mark = [[NSMutableArray alloc] init];
        self.exercise = exercise;
        self.questionLabel.text = self.exercise.exerciseTitle;
        self.answerLabel.text=@"";
        [self markInit];
        self.selectedStr=@"";
        [self.tableView reloadData];
        
    }
}

- (IBAction)clickNext:(id)sender {
    
    [self gotoSelectPage];
    
}
-(void)gotoSelectPage{
    MyQuestion* question = [MyQuestion shareInstance];
    question.count++;
    
    int page=question.count;
    if (question.count+1>question.exerciseArray.count) {
        [self.dialog showToast:self withMessage:@"题目都被你做完啦"];
        return;
    }
    //[self dismissViewControllerAnimated:YES completion:nil];
    Exercise* exercise = [question.exerciseArray objectAtIndex:page];
    if ([exercise.exerciseType isEqualToString:@"单选"]) {
        [self.myNavigationItem setTitle:@"单选"];
        self.exercise =exercise;
        [self markInit];
        self.questionLabel.text = self.exercise.exerciseTitle;
        if ([self.exercise.exerciseOption count]>0) {
            mark[0]=@1;
            self.selected=0;
        }
        self.answerLabel.text=@"";
        [self.tableView reloadData];
        

    }else{
        mark = [[NSMutableArray alloc] init];
        [self.myNavigationItem setTitle:@"多选"];
        self.exercise = exercise;
        self.questionLabel.text = self.exercise.exerciseTitle;
        self.answerLabel.text=@"";
        [self markInit];
        self.selectedStr=@"";
        [self.tableView reloadData];
        
        
    }
    
}

-(NSString*)mySelection:(int) str {
    if (str ==0) {
        return @"a";
    }
    else if (str ==1) {
        return @"b";
    }
    else if (str ==2) {
        return @"c";
    }else if (str ==3) {
        return @"d";
    }
    else if (str ==4) {
        return @"e";
    }
    return @"";
}
- (IBAction)submit:(id)sender {
    if ([self.exercise.exerciseType isEqualToString:@"单选"]) {//单选
        NSString* answer = [NSString stringWithFormat:@"%@",[self mySelection:self.selected]];
        
        if ([answer isEqualToString:self.exercise.exerciseAnswer]) {
            self.answerLabel.text= @"正确";
        }
        else{
            self.answerLabel.text= @"错误";
        }
    
    }
    else{
        self.selectedStr = @"";
        for (int j=0; j<[mark count]; j++) {
            if ([mark[j] isEqual:@1]) {
                NSString * string= [NSString stringWithFormat:@"%@",[self mySelection:j]];
                self.selectedStr = [self.selectedStr stringByAppendingString:string];
                self.selectedStr=[self.selectedStr stringByAppendingString:@","];
                
            }
        }
        
        NSString* answer =@"";
        answer=[self.exercise.exerciseAnswer stringByAppendingString:@","];
        NSLog(@"%@--%@",self.selectedStr,answer);
        if ([self.selectedStr isEqualToString:answer]) {
            self.answerLabel.text= @"正确";
        }
        else{
            self.answerLabel.text= @"错误";
        }
    
    }
    
}
-(void)viewDidDisappear:(BOOL)animated{
    //[self dismissViewControllerAnimated:YES completion:nil];
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
