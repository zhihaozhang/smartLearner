//
//  HHContentTableView.m
//  HHHorizontalPagingView
//
//  Created by Huanhoo on 15/7/16.
//  Copyright (c) 2015年 Huanhoo. All rights reserved.
//

#import "HHContentTableView.h"
#define FONT_SIZE 15.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f
@interface HHContentTableView ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation HHContentTableView
@synthesize datas;

+ (HHContentTableView *)contentTableView {
    HHContentTableView *contentTV = [[HHContentTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    contentTV.backgroundColor = [UIColor clearColor];
    contentTV.dataSource = contentTV;
    contentTV.delegate = contentTV;
    
    return contentTV;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    static NSString *cellIdentifier = @"VideoPage1Cell";
    NSInteger row = indexPath.row;
    VideoPage1VO *item = [datas objectAtIndex:row];
    VideoPage1Cell *cell = (VideoPage1Cell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell= (VideoPage1Cell *)[[[NSBundle  mainBundle]  loadNibNamed:@"VideoPage1" owner:self options:nil]  lastObject];
    }
    cell.contentView.frame = cell.bounds;
    [cell.lbTitle setText:item.title];
    
    [cell.lbContent setNumberOfLines:0];
    [cell.lbContent setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000);
    CGSize labelSize = [item.content sizeWithFont:cell.lbContent.font constrainedToSize:constraint lineBreakMode:NSLineBreakByClipping];
    [cell.lbContent setFrame: CGRectMake(2, cell.lbContent.frame.origin.y, self.frame.size.width-2, labelSize.height)];
    [cell.lbContent setText:item.content];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [datas count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger height = 0;
    NSInteger row = indexPath.row;
    //        NSLog(@"2222222   cell for row at indexpath");
    VideoPage1VO *elem = [datas objectAtIndex:row];
    NSString *text = elem.content;
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000);
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint];
    height = MAX(size.height + 25, 58);
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

@end
