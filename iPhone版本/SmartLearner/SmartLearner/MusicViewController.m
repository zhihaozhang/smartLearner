//
//  MusicViewController.m
//  MusicPlayer
//
//  Created by 千里马LZZ on 13-10-19.
//  Copyright (c) 2013年 Lizizheng. All rights reserved.
//

#import "MusicViewController.h"


@interface MusicViewController ()

@end
//用静态全局变量来保存这个单例
//static MusicViewController *instance = nil;


@implementation MusicViewController

@synthesize  playButton;







- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    isPlay = YES;
    self.view.backgroundColor=[[UIColor alloc]initWithRed:0 green:0 blue:0 alpha:0.4];
    [self.playButton setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    
    
    //self.musicUrl = @"http://sc.111ttt.com/up/mp3/55560/901EC36230B7BA2F1FB8324810088B62.mp3";
    
    
    
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
- (void)playAudio:(AudioButton *)button
{
    
    NSDictionary *item = [NSDictionary dictionaryWithObjectsAndKeys:  self.musicUrl, @"url", nil];
    if (audioPlayer == nil) {
        audioPlayer = [[AudioPlayer alloc] init];
    }
    
    if ([audioPlayer.button isEqual:button]) {
        
        [audioPlayer play];
    } else {
        [self.playButton setBackgroundImage:nil forState:UIControlStateNormal];
        [audioPlayer stop];
        
        audioPlayer.button = button;
        audioPlayer.url = [NSURL URLWithString:[item objectForKey:@"url"]];
        
        [audioPlayer play];
    }
}


- (IBAction)clickBack:(id)sender {
    [audioPlayer stop];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)clickPlay:(id)sender {
    [self playAudio:sender];
    
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
