//
//  RadioButton.m
//  WeekTest
//
//  Created by Lily on 14-1-4.
//  Copyright (c) 2014年 Lily. All rights reserved.
//

#import "RadioButton.h"

@implementation RadioButton
@synthesize selectedButton;
static NSUInteger flag;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)radioButton1:(UIButton *)button1 Button2:(UIButton *)button2
{
    //两个单选按钮的实现
    [button1 setBackgroundImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
    
    [button1 setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateSelected];
    [button1 addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [button2 setBackgroundImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
    [button2 setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateSelected];
    [button2 addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)radioButton1:(UIButton *)button1 Button2:(UIButton *)button2 Button3:(UIButton *)button3
{
    //三个单选按钮的实现
    [button1 setBackgroundImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
    [button1 setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateSelected];
    [button1 addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [button2 setBackgroundImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
    [button2 setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateSelected];
    [button2 addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [button3 setBackgroundImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
    [button3 setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateSelected];
    [button3 addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)radioButton1:(UIButton *)button1 Button2:(UIButton *)button2 Button3:(UIButton *)button3 Button4:(UIButton *)button4
{
    //四个单选按钮的实现
    [button1 setBackgroundImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
    [button1 setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateSelected];
    [button1 addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [button2 setBackgroundImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
    [button2 setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateSelected];
    [button2 addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [button3 setBackgroundImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
    [button3 setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateSelected];
    [button3 addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [button4 setBackgroundImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
    [button4 setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateSelected];
    [button4 addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)clickButton:(UIButton *)button
{
    if(selectedButton == button) //如果上一次点的是这个按钮
    {
        flag+=1;  //点击次数加1
        
        if(flag%2 == 0) //如果按了数次
        {
            [button setSelected:YES];
            selectedButton = button;
        }
    }
    else{
        [selectedButton setSelected:NO];
        flag=0; //换按钮了
        [button setSelected:YES];
        selectedButton = button;
    }
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
