//
//  MultiSelectViewController.m
//  Course
//
//  Created by 李青山 on 15/10/8.
//  Copyright (c) 2015年 ASELab. All rights reserved.
//

#import "MultiSelectViewController.h"

@interface MultiSelectViewController ()

@end

@implementation MultiSelectViewController

@synthesize mark,selected;
- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    //设置导航栏背景
    //不是自带的导航条不能这么用
    [self.navigationBar setBackgroundImage:[UIImage imageNamed: @"msnav_bg.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    //[self initData];
    
    mark = [[NSMutableArray alloc] init];
    [self markInit];
    self.titleLabel.text = self.exercise.exerciseTitle;
    self.dialog = [[Tools alloc]init];
}
-(void)initData{
    //selected = [[NSMutableArray alloc] init];
    
    self.exercise = [[Exercise alloc]init];
    self.exercise.exerciseAnswer=@"Bigbang是于2006年出道的韩国组合,Bigbang是于2006年出道的韩国组合";
    self.exercise.exerciseTitle=@"Bigbang是于2006年出道的韩国组合，由队长权志龙、崔胜贤、东永裴、姜大声、李胜贤五位成员组成。";
    NSMutableArray *opion = [[NSMutableArray alloc]init];
    for (int i=0; i<3; i++) {
        NSString* str= @"Bigbang是于2006年出道的韩国组合";
        [opion addObject:str];
    }
    self.exercise.exerciseOption = opion;
    
}
-(void)markInit
{
    NSMutableArray *mMark = [[NSMutableArray alloc] init];
    for(int i=0; i<[self.exercise.exerciseOption count];i++)
    {
        mMark[i]=@0;
    }
    mark = mMark;

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier;
    UITableViewCell* cell;
    NSInteger row = indexPath.row;
    CellIdentifier = @"MultiSelectCell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //    InteractionCommentVo *comment=[self.interactionCommentList objectAtIndex:indexPath.row];
    NSString *comment=[self.exercise.exerciseOption objectAtIndex:indexPath.row];

    UIImageView *image = (UIImageView *)[cell viewWithTag:300];
    UILabel *selection = (UILabel *)[cell viewWithTag:301];
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
    return cell;
}

//点击后的动作
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"selected");
    int row = indexPath.row;
    UITableViewCell *myCell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *image = (UIImageView *)[myCell viewWithTag:300];
    int temp = [mark[row] integerValue];
    NSLog(@"temp---%d",temp);
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


- (IBAction)clickBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)clickNext:(id)sender {
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self gotoSelectPage];
}
-(void)gotoSelectPage{
    MyQuestion* question = [MyQuestion shareInstance];
    question.count++;
    int page=question.count;
    NSLog(@"%d----%lu",question.count+1,(unsigned long)question.exerciseArray.count);
    if (question.count+1>question.exerciseArray.count) {
        [self.dialog showToast:self withMessage:@"这是最后一道习题"];
        return;
    }
    Exercise* exercise = [question.exerciseArray objectAtIndex:page];
    if ([exercise.exerciseType isEqualToString:@"单选"]) {
        SingleSelectViewController *homeViewController = [[UIStoryboard storyboardWithName:@"MyQuestionStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"SingleSelectViewController"];
        homeViewController.exercise=exercise;
        [self presentViewController:homeViewController animated:YES completion:nil];
    }else{
        mark = [[NSMutableArray alloc] init];
        self.exercise = exercise;
        self.titleLabel.text = self.exercise.exerciseTitle;
        self.answerLabel.text=@"";
        [self markInit];
        self.selected=@"";
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
    selected = @"";
    for (int j=0; j<[mark count]; j++) {
        if ([mark[j] isEqual:@1]) {
            NSString * string= [NSString stringWithFormat:@"%@",[self mySelection:j]];
            selected = [selected stringByAppendingString:string];
            selected=[selected stringByAppendingString:@","];
            
        }
    }

    NSString* answer =@"";
    answer=[self.exercise.exerciseAnswer stringByAppendingString:@","];
    NSLog(@"%@--%@",selected,answer);
    if ([selected isEqualToString:answer]) {
        self.answerLabel.text= @"正确";
    }
    else{
        self.answerLabel.text= @"错误";
    }
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
