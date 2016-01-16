//
//  VideoPage3.m
//  SmartLearner
//
//  Created by mmy on 15-10-8.
//  Copyright (c) 2015年 liuhaoxian. All rights reserved.
//

#import "VideoPage3.h"
#define FONT_SIZE 15.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f

@implementation VideoPage3
@synthesize datas;

+ (VideoPage3 *)contentTableView {
    VideoPage3 *contentTV = [[VideoPage3 alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    contentTV.backgroundColor = [UIColor clearColor];
    contentTV.dataSource = contentTV;
    contentTV.delegate = contentTV;
    
    return contentTV;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    static NSString *cellIdentifier = @"VideoPage3Cell";
    NSInteger row = indexPath.row;
    VideoPage3VO *item = [datas objectAtIndex:row];
    VideoPage3Cell *cell = (VideoPage3Cell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell= (VideoPage3Cell *)[[[NSBundle  mainBundle]  loadNibNamed:@"VideoPage3" owner:self options:nil]  lastObject];
    }
    cell.contentView.frame = cell.bounds;
    [cell.cellTitle setText:item.title];
    
//    [cell.cellContent setNumberOfLines:0];
//    [cell.cellContent setFont:[UIFont systemFontOfSize:FONT_SIZE]];
//    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000);
//    CGSize labelSize = [item.content sizeWithFont:cell.cellContent.font constrainedToSize:constraint lineBreakMode:NSLineBreakByClipping];
//    [cell.cellContent setFrame: CGRectMake(cell.cellContent.frame.origin.x, cell.cellTitle.frame.origin.y+cell.cellTitle.frame.size.height, self.frame.size.width, labelSize.height)];
//    [cell.cellContent setText:item.content];
    cell.cellContent.numberOfLines = 0;
    cell.cellContent.lineBreakMode = NSLineBreakByCharWrapping;
    CGRect tempRect = [item.content boundingRectWithSize:CGSizeMake(self.frame.size.width-2, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:cell.cellContent.font, NSFontAttributeName,nil] context:nil];
    CGFloat contentH = tempRect.size.height;
    CGFloat contentW = tempRect.size.width-6;
    cell.cellContent.frame = CGRectMake(3, cell.cellTitle.frame.origin.y+cell.cellTitle.frame.size.height, contentW, contentH);
    [cell.cellContent setText:item.content];

    
    [cell.readTitle setFrame: CGRectMake(2, cell.cellContent.frame.origin.y+cell.cellContent.frame.size.height, self.frame.size.width-2, 22)];
    [cell.readTitle setText:item.read];
    
    cell.readContent.numberOfLines = 0;
    cell.readContent.lineBreakMode = NSLineBreakByCharWrapping;
    CGRect tempRect1 = [item.readContent boundingRectWithSize:CGSizeMake(self.frame.size.width-2, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:cell.cellContent.font, NSFontAttributeName,nil] context:nil];
    CGFloat contentH1 = tempRect1.size.height;
    CGFloat contentW1 = tempRect1.size.width-6;
    cell.readContent.frame = CGRectMake(3, cell.readTitle.frame.origin.y+cell.readTitle.frame.size.height, contentW1, contentH1);
    [cell.readContent setText:item.readContent];

    
//    [cell.readContent setNumberOfLines:0];
//    [cell.readContent setFont:[UIFont systemFontOfSize:FONT_SIZE]];
//    constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000);
//    labelSize = [item.readContent sizeWithFont:cell.readContent.font constrainedToSize:constraint lineBreakMode:NSLineBreakByClipping];
//    [cell.readContent setFrame: CGRectMake(cell.readContent.frame.origin.x, cell.readTitle.frame.origin.y+20, self.frame.size.width, labelSize.height)];
    [cell.readContent setText:item.readContent];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [datas count];
    
}
//设置高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger height = 0;
    NSInteger row = indexPath.row;
    //        NSLog(@"2222222   cell for row at indexpath");
    VideoPage3VO *elem = [datas objectAtIndex:row];
    NSString *text = [NSString stringWithFormat:@"%@%@%@%@",elem.content,elem.readContent,elem.title,elem.read];
    
    CGRect tempRect = [text boundingRectWithSize:CGSizeMake(self.frame.size.width-2, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:FONT_SIZE], NSFontAttributeName,nil] context:nil];
    CGFloat contentH = tempRect.size.height;

    height = MAX(contentH + 1000, 83);

    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
