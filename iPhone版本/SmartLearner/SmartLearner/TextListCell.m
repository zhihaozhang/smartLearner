//
//  TextListCell.m
//  Course
//
//  Created by 李青山 on 15/9/26.
//  Copyright (c) 2015年 ASELab. All rights reserved.
//

#import "TextListCell.h"

@implementation TextListCell
@synthesize textLabel,contentLabel,with,titleLabel;
- (void)awakeFromNib {
    // Initialization code
}


//赋值 and 自动换行,计算出cell的高度
-(void)setIntroductionText:(NSString*)text{
    //labelContent = [[UILabel alloc] initWithFrame:CGRectMake(65, 63, 232, 40)];
    //[labelContent setFrame:CGRectMake(65, 63, 220, 20)];
    //[self addSubview:labelContent];
    //获得当前cell高度
    CGRect frame = [self frame];
    //文本赋值
    //labelContent.text = text;
    //设置label的最大行数
    [contentLabel setNumberOfLines:0];
    CGRect rx = [UIScreen mainScreen].bounds;
    with = rx.size.width-16;//contentLabel.frame.size.width
    CGSize size = CGSizeMake(with, 20000.0f);
    CGSize labelSize = [text sizeWithFont:contentLabel.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
    self.mySize = labelSize;
    self.myStr = text;
    [contentLabel setFrame: CGRectMake(contentLabel.frame.origin.x, contentLabel.frame.origin.y, labelSize.width, labelSize.height)];
    
    
    contentLabel.text = text;

    //计算出自适应的高度
    frame.size.height = labelSize.height+40;
    
    self.frame = frame;
    //[self reloadInputViews];
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(UpdateText:) userInfo:nil repeats:NO];
}

-(void)UpdateText:(NSTimer *)timer{
    //NSLog(@"*********");
    [contentLabel setFrame: CGRectMake(contentLabel.frame.origin.x, contentLabel.frame.origin.y, self.mySize.width, self.mySize.height)];
    contentLabel.text = self.myStr;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
