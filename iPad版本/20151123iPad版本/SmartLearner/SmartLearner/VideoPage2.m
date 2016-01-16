//
//  VideoPage2.m
//  SmartLearner
//
//  Created by mmy on 15-10-8.
//  Copyright (c) 2015年 liuhaoxian. All rights reserved.
//

#import "VideoPage2.h"
#define FONT_SIZE 15.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f

@implementation VideoPage2
@synthesize datas,dataNums,curentPage,tool;

+ (VideoPage2 *)contentTableView {
    VideoPage2 *contentTV = [[VideoPage2 alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    contentTV.backgroundColor = [UIColor clearColor];
    contentTV.dataSource = contentTV;
    contentTV.delegate = contentTV;
    
    return contentTV;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier1 = @"VideoPage22Cell";
    static NSString *cellIdentifier2 = @"VideoPage2Cell";
    NSInteger row = indexPath.row;
    NSInteger myrow = 0;
    for (int i =0; i<curentPage; i++) {
        myrow = myrow + [[dataNums objectAtIndex:i] integerValue];
    }
    myrow = myrow + row;
    VideoPage22VO *elem = [datas objectAtIndex:myrow];
    BOOL show = elem.show;
    if (row == 0) {
         VideoPage22Cell *cell = (VideoPage22Cell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        if (cell == nil)
        {
            cell= (VideoPage22Cell *)[[[NSBundle  mainBundle]  loadNibNamed:@"VideoPage22" owner:self options:nil]  lastObject];
        }
        float mx = self.frame.size.width - cell.cellTitle.frame.size.width;
        cell.cellTitle.textAlignment = NSTextAlignmentCenter;
        [cell.cellTitle setFrame:CGRectMake(mx/2, 7, cell.cellTitle.frame.size.width, cell.cellTitle.frame.size.height)];
        [cell.cellTitle setText:elem.title];
        
        int totalNumPage = [dataNums count];
        if (totalNumPage>1) {
            cell.lastButton.hidden = NO;
            cell.nextButton.hidden = NO;
            [cell.lastButton addTarget:self action:@selector(choseLastButton:) forControlEvents:UIControlEventTouchUpInside];
            [cell.nextButton addTarget:self action:@selector(choseNextButton:) forControlEvents:UIControlEventTouchUpInside];
            [cell.nextButton setFrame:CGRectMake(self.frame.size.width-8-cell.nextButton.frame.size.width, 4, cell.nextButton.frame.size.width, cell.nextButton.frame.size.height)];
        }else{
            cell.lastButton.hidden = YES;
            cell.nextButton.hidden = YES;
            
        }
        [cell.cellContent setNumberOfLines:0];
        [cell.cellContent setFont:[UIFont systemFontOfSize:FONT_SIZE]];
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000);
        CGSize labelSize = [elem.content sizeWithFont:cell.cellContent.font constrainedToSize:constraint lineBreakMode:NSLineBreakByClipping];
        [cell.cellContent setFrame: CGRectMake(2, cell.cellContent.frame.origin.y, self.frame.size.width-2, labelSize.height)];
        [cell.cellContent setText:elem.content];
        if (show) {
            [cell.cellReference setNumberOfLines:0];
            [cell.cellReference setFont:[UIFont systemFontOfSize:FONT_SIZE]];
            constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000);
            labelSize = [elem.reference sizeWithFont:cell.cellReference.font constrainedToSize:constraint lineBreakMode:NSLineBreakByClipping];
            [cell.cellReference setFrame: CGRectMake(2, cell.cellContent.frame.origin.y+cell.cellContent.frame.size.height, self.frame.size.width-2, labelSize.height)];
            [cell.cellReference setText:elem.reference];
        }else{
            [cell.cellReference setText:@""];
        }
        
        return cell;
    }else{
        VideoPage2Cell *cell = (VideoPage2Cell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
        if (cell == nil)
        {
            cell= (VideoPage2Cell *)[[[NSBundle  mainBundle]  loadNibNamed:@"VideoPage2" owner:self options:nil]  lastObject];
        }
        [cell.cellContent setNumberOfLines:0];
        [cell.cellContent setFont:[UIFont systemFontOfSize:FONT_SIZE]];
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000);
        CGSize labelSize = [elem.content sizeWithFont:cell.cellContent.font constrainedToSize:constraint lineBreakMode:NSLineBreakByClipping];
        [cell.cellContent setFrame: CGRectMake(2, cell.cellContent.frame.origin.y, self.frame.size.width-2, labelSize.height)];
        [cell.cellContent setText:elem.content];
        if (show) {
            [cell.referenceContent setNumberOfLines:0];
            [cell.referenceContent setFont:[UIFont systemFontOfSize:FONT_SIZE]];
            constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000);
            labelSize = [elem.reference sizeWithFont:cell.referenceContent.font constrainedToSize:constraint lineBreakMode:NSLineBreakByClipping];
            [cell.referenceContent setFrame: CGRectMake(2, cell.cellContent.frame.origin.y+cell.cellContent.frame.size.height, self.frame.size.width-2, labelSize.height)];
            [cell.referenceContent setText:elem.reference];
        }else{
            [cell.referenceContent setText:@""];
        }
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[dataNums objectAtIndex:curentPage] integerValue];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger height = 0;
    NSInteger row = indexPath.row;
    //        NSLog(@"2222222   cell for row at indexpath");
    VideoPage22VO *elem = [[VideoPage22VO alloc] init];
    NSInteger myrow = 0;
    for (int i =0; i<curentPage; i++) {
        myrow = myrow + [[dataNums objectAtIndex:i] integerValue];
    }
    myrow = myrow + row;
    elem = [datas objectAtIndex:myrow];
    NSString *text;
    BOOL show = elem.show;
    if (row==0) {
        if (show){
            text = [NSString stringWithFormat:@"%@%@",elem.content,elem.reference];
            CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000);
            CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint];
            height = MAX(size.height + 60, 78);
            
        }else{
            text = [NSString stringWithFormat:@"%@",elem.content];
            CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000);
            CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint];
            height = MAX(size.height + 40, 57);
            
        }

    }else{
        if (show){
            text = [NSString stringWithFormat:@"%@%@",elem.content,elem.reference];
            CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000);
            CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint];
            height = MAX(size.height+30, 50);
            
        }else{
            text = [NSString stringWithFormat:@"%@",elem.content];
            CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000);
            CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint];
            height = MAX(size.height+10, 25);
            
        }

    }
    return height;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    VideoPage22VO *elem = [[VideoPage22VO alloc] init];
    NSInteger myrow = 0;
    for (int i =0; i<curentPage; i++) {
        myrow = myrow + [[dataNums objectAtIndex:i] integerValue];
    }
    myrow = myrow + row;

    elem = [datas objectAtIndex:myrow];
    BOOL show = elem.show;
    if (show) {
        elem.show = NO;
    }else{
        elem.show = YES;
    }
    [self reloadData];
}
//-(void) lastPage:(UIButton *)button{
//    NSLog(@"lastPage");
//    if (curentPage>0) {
//        curentPage--;
//        [self reloadData];
//    }else{
//        tool = [[Tools alloc] init];
//        [tool showToast:self withMessage:@"已经是第一页了"];
//    }
//}
//-(void) nextPage:(UIButton *)button{
//    NSLog(@"nextPage");
//    int totalNum = [dataNums count];
//    if (curentPage>=(totalNum-1)) {
//        tool = [[Tools alloc] init];
//        [tool showToast:self withMessage:@"已经是最后一页了"];
//    }else{
//        curentPage++;
//        [self reloadData];
//    }
//}
- (void)choseLastButton:(UIButton *)button{
    NSLog(@"lastPage");
    if (curentPage>0) {
        curentPage--;
        [self reloadData];
    }else{
        tool = [[Tools alloc] init];
        [tool showToast:self withMessage:@"已经是第一页了"];
    }
}
- (void)choseNextButton:(UIButton *)button{
    NSLog(@"nextPage");
    int totalNum = [dataNums count];
    if (curentPage>=(totalNum-1)) {
        tool = [[Tools alloc] init];
        [tool showToast:self withMessage:@"已经是最后一页了"];
    }else{
        curentPage++;
        [self reloadData];
    }
}
@end
