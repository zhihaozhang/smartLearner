//
//  NewTextViewController.m
//  Course
//
//  Created by 李青山 on 15/9/26.
//  Copyright (c) 2015年 ASELab. All rights reserved.
//

#import "NewTextViewController.h"

@interface NewTextViewController ()

@end

@implementation NewTextViewController
@synthesize isFirstEdit;
@synthesize dialog;
@synthesize TEXT_MAXLENGTH;
@synthesize TEXT_MAXLENGTH2;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBar setBackgroundImage:[UIImage imageNamed: @"msnav_bg.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    self.textView.delegate=self;
    isFirstEdit=TRUE;
    TEXT_MAXLENGTH=300;
    TEXT_MAXLENGTH=20;
    [self initData];
    if (self.textTitle==nil||[self.textTitle.text isEqualToString:@""]) {
        self.textTitle.userInteractionEnabled=YES;
    }
    else{
        self.textTitle.userInteractionEnabled=NO;
        [self.textTitle setTextColor:[UIColor colorWithRed:141.0/255 green:141.0/255 blue:142.0/255 alpha:1]];
    }
    // Do any additional setup after loading the view.
}
-(void)initData{
    self.toast = [[Tools alloc]init];
    self.dialog = [[Tools alloc]init];
    self.util = [[SharePreferenceUtil alloc]init];
    MyQuestion *question = [MyQuestion shareInstance];
    self.textId = question.textId;
    self.textTitle.text = question.textName;
//    self.textId = @"1";
//    self.textView.set
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if (isFirstEdit) {
        isFirstEdit=FALSE;
        self.textView.text=@"";
    }
}
-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self.textView resignFirstResponder];
    [self.textTitle resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.textTitle resignFirstResponder];
    return NO;
}
#pragma mark - Navigation
- (IBAction)clickSubmit:(id)sender {
    if ([self.toast isEmpty:self.textTitle.text]) {
        
        [self.toast showToast:self withMessage:@"请输入笔记标题"];
        return;
    }
    
    if ([self.textView.text isEqualToString:@"输入笔记内容，最多300字"]||
        [self.textView.text isEqualToString:@""]) {
        [self.toast showToast:self withMessage:@"请输入笔记内容"];
        return;
    }
    if ([self.toast isEmpty:self.textView.text]) {
        
        [self.toast showToast:self withMessage:@"请输入笔记内容"];
        return;
    }
    [self getDataFromServer];
    //[self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)clickBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 获取我的笔记
-(void)getDataFromServer{
    if (![AppDelegate isNetworkAvailable]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [dialog hideProgressHUD:self];
            [dialog showToast:self withMessage:@"网络不可用，暂无内容..."];
        });
    } else {
        UserVo *uv= [AppDelegate getUserVo];
        URLParamter *param1=[[URLParamter alloc]initWithKey:@"username" value:uv.number];
        URLParamter *param2=[[URLParamter alloc]initWithKey:@"curriculum_id" value:self.textId];
        URLParamter *param3=[[URLParamter alloc]initWithKey:@"note" value:self.textView.text];
        URLParamter *param4=[[URLParamter alloc]initWithKey:@"note_title" value:self.textTitle.text];
        NSArray *params=[[NSArray alloc]initWithObjects:param1,param2,param3,param4, nil];
        NSDictionary* dict=[ConnectUtil httpPostSyn:[ConnectUtil getADD_NOTE] parameters:params];
        NSLog(@"-----%@",dict);
        
        //返回主线程进行操作
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //do something here
            [dialog hideProgressHUD:self];
            if (dict!=nil) {             
                [self parseJsonData:dict withURL:[ConnectUtil getADD_NOTE]];
            }
            else{
                [dialog showToast:self withMessage:@"暂无法获取数据..."];
            }
            
        });
    }
}
#pragma mark - 解析json数据
-(void)parseJsonData:(NSDictionary*) dict withURL:(NSString*)URL{
    //解析json返回的数据
    NSNumber* resultCode = [dict objectForKey:@"resultcode"];
    
    if ([resultCode intValue]==1) {
        [dialog showToast:self withMessage:@"新建笔记成功"];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        [dialog showToast:self withMessage:@"新建笔记失败"];
    }
    
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([@"\n"isEqualToString:string]==YES) {
        [textField resignFirstResponder];
    }
    NSString *new = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSInteger res= TEXT_MAXLENGTH2-[new length];
    if (res>=0) {
        return YES;
    }else{
        NSRange rg={0,[string length]+res};
        if (rg.length>0) {
            NSString* s=[string substringWithRange:rg];
            [textField setText:[textField.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
    
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([@"\n"isEqualToString:text]==YES) {
        [textView resignFirstResponder];
    }
    NSString *new = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger res= TEXT_MAXLENGTH-[new length];
    if (res>=0) {
        return YES;
    }else{
        NSRange rg={0,[text length]+res};
        if (rg.length>0) {
            NSString* s=[text substringWithRange:rg];
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
    
}


@end
