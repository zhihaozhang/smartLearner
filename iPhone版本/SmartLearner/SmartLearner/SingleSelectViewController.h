//
//  SingleSelectViewController.h
//  SmartLearner
//
//  Created by 李青山 on 15/10/12.
//  Copyright (c) 2015年 liuhaoxian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Exercise.h"
#import "SingleSelectCell.h"
#import "MyQuestion.h"
#import "Tools.h"
#import "MultiSelectViewController.h"
#import "PersonalCenterView.h"
@interface SingleSelectViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
- (IBAction)clickBack:(id)sender;
- (IBAction)clickNext:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *answerLabel;
@property (strong, nonatomic) IBOutlet UILabel *questionLabel;
- (IBAction)submit:(id)sender;
@property (strong, nonatomic)Exercise * exercise;
@property (nonatomic, strong) NSMutableArray *mark;
@property int selected;
@property(nonatomic, strong)  NSString* selectedStr;
@property(strong,nonatomic)Tools* dialog;
@property (strong, nonatomic) IBOutlet UINavigationItem *myNavigationItem;


//@property(strong,nonatomic)NSMutableArray* exerciseArray;
//@property int count;
@end
