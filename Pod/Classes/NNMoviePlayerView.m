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
	_player = [[AVPlayer alloc] init];
	[(AVPlayerLayer*)self.layer setPlayer:_player];
}



-(void)playWithURL:(NSURL*)url{
	AVPlayerItem* item = [[AVPlayerItem alloc] initWithURL:url];
	[_player replaceCurrentItemWithPlayerItem:item];
	
	
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
		[_delegate moviePlayerDidFinishPlaying:self];
	}];
}


-(void)replay{
	[_player seekToTime:kCMTimeZero];
	[_player play];
}




@end
