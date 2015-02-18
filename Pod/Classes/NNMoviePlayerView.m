//
//  NNMoviePlayerView.m
//  Pods
//
//  Created by noughts on 2015/02/18.
//
//

#import "NNMoviePlayerView.h"
@import AVFoundation;
#import <FTGNotificationController.h>
#import <FBKVOController.h>

@implementation NNMoviePlayerView{
	FBKVOController* _kvoController;
	FTGNotificationController* _notificationController;
	AVPlayer        *_player;
}

+(Class)layerClass{
	return [AVPlayerLayer class];
}


-(void)awakeFromNib{
	[super awakeFromNib];
	_kvoController = [FBKVOController controllerWithObserver:self];
	_notificationController = [FTGNotificationController controllerWithObserver:self];
}



-(void)playWithURL:(NSURL*)url{
	_player = [[AVPlayer alloc]initWithURL:url];
	[(AVPlayerLayer*)self.layer setPlayer:_player];
	
	[_kvoController unobserveAll];
	[_kvoController observe:_player keyPath:@"status" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
		if([_player status] == AVPlayerItemStatusReadyToPlay){
			NSLog( @"再生開始" );
			[_player play];
			return;
		}
	}];
	
	[_notificationController unobserveAll];
	[_notificationController observeNotificationName:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem queue:nil block:^(NSNotification *note, id observer) {
		NSLog( @"再生終了" );
	}];
}


-(void)replay{
	[_player seekToTime:kCMTimeZero];
	[_player play];
}




@end
