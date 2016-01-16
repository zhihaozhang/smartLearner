//
//  RadioButton.h
//  WeekTest
//
//  Created by Lily on 14-1-4.
//  Copyright (c) 2014年 Lily. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RadioButton : UIButton

@property (nonatomic, assign) UIButton *selectedButton;

-(void)clickButton:(UIButton *)button;
-(void)radioButton1:(UIButton *)button1 Button2:(UIButton *)button2;
-(void)radioButton1:(UIButton *)button1 Button2:(UIButton *)button2 Button3:(UIButton *)button3;
-(void)radioButton1:(UIButton *)button1 Button2:(UIButton *)button2 Button3:(UIButton *)button3 Button4:(UIButton *)button4;
@end
