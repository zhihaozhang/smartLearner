//
//  MusicViewController.h
//  MusicPlayer
//
//  Created by 千里马LZZ on 13-10-19.
//  Copyright (c) 2013年 Lizizheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AudioPlayer.h"
#import "AudioButton.h"
@interface MusicViewController : UIViewController
{
    AudioPlayer *audioPlayer;
    BOOL isPlay;
}


@property (nonatomic, strong) NSString *musicUrl;
- (IBAction)clickBack:(id)sender;

@property (strong, nonatomic) IBOutlet AudioButton *playButton;
- (IBAction)clickPlay:(id)sender;

@end
