//
//  AudioPlayer.m
//  Share
//
//  Created by Lin Zhang on 11-4-26.
//  Copyright 2011年 www.eoemobile.com. All rights reserved.
//

#import "AudioPlayer.h"
#import "AudioButton.h"
#import "AudioStreamer.h"

@implementation AudioPlayer

@synthesize streamer, button, url;


- (id)init
{
    self = [super init];
    if (self) {
        
    }

    return self;
}

- (void)dealloc
{
    [super dealloc];
    [url release];
    [streamer release];
    [button release];
    [timer invalidate];
}


- (BOOL)isProcessing
{
    return [streamer isPlaying] || [streamer isWaiting] || [streamer isFinishing] ;
}

- (void)play
{        
    if (!streamer) {
        
        self.streamer = [[AudioStreamer alloc] initWithURL:self.url];
        
        // set up display updater
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                    [self methodSignatureForSelector:@selector(updateProgress)]];    
        [invocation setSelector:@selector(updateProgress)];
        [invocation setTarget:self];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                             invocation:invocation 
                                                repeats:YES];
        
        // register the streamer on notification
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playbackStateChanged:)
                                                     name:ASStatusChangedNotification
                                                   object:streamer];
    }
    
    if ([streamer isPlaying]) {
        [streamer pause];
    } else {
        [streamer start];
    }
}


- (void)stop
{    
    [button setProgress:0];
    [button stopSpin];

    button.image = [UIImage imageNamed:playImage];
    button = nil; // 避免播放器的闪烁问题        
    [button release];     
    
    // release streamer
	if (streamer)
	{        
		[streamer stop];
		[streamer release];
		streamer = nil;
        
        // remove notification observer for streamer
		[[NSNotificationCenter defaultCenter] removeObserver:self 
                                                        name:ASStatusChangedNotification
                                                      object:streamer];		
	}
}

- (void)updateProgress
{
    if (streamer.progress <= streamer.duration ) {
        [button setProgress:streamer.progress/streamer.duration];        
    } else {
        [button setProgress:0.0f];        
    }
}


/*
 *  observe the notification listener when loading an audio
 */
- (void)playbackStateChanged:(NSNotification *)notification
{
	if ([streamer isWaiting])
	{
        button.image = [UIImage imageNamed:stopImage];
        [button setTitle:@"加载中" forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor colorWithRed:188.0/255 green:188.0/255 blue:188.0/255 alpha:1]];
        [button startSpin];
    } else if ([streamer isIdle]) {
        [button setBackgroundColor:[UIColor clearColor]];
        [button setTitle:@"继续" forState:UIControlStateNormal];
        button.image = [UIImage imageNamed:playImage];
		[self stop];		
	} else if ([streamer isPaused]) {
        [button setBackgroundColor:[UIColor clearColor]];
        [button setTitle:@"朗读" forState:UIControlStateNormal];
        button.image = [UIImage imageNamed:playImage];
        [button stopSpin];
        [button setColourR:0.0 G:0.0 B:0.0 A:0.0];
    } else if ([streamer isPlaying] || [streamer isFinishing]) {
        [button setBackgroundColor:[UIColor clearColor]];
        [button setTitle:@"暂停" forState:UIControlStateNormal];
        button.image = [UIImage imageNamed:stopImage];
        [button stopSpin];        
	} else {
        
    }
    
    [button setNeedsLayout];
    //[button setNeedsDisplay];
}


@end
