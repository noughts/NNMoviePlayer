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
#import <NBULog.h>

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
	
	AVPlayerLayer* layer = (AVPlayerLayer*)self.layer;
	[layer setPlayer:_player];
	
	/// 表示モード設定
	switch (self.contentMode) {
		case UIViewContentModeScaleAspectFill:
			layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
			break;
		case UIViewContentModeScaleToFill:
			layer.videoGravity = AVLayerVideoGravityResize;
			break;
		default:
			layer.videoGravity = AVLayerVideoGravityResizeAspect;
			break;
	}
	
	/// もろもろ監視開始
	[_kvoController observe:_player keyPath:@"status" options:NSKeyValueObservingOptionNew block:^(id observer, AVPlayer* object, NSDictionary *change) {
		if( _player.status == AVPlayerItemStatusReadyToPlay){
			NBULogVerbose( @"再生開始 item=%@", object.currentItem );
			[_player play];
		} else {
			NBULogVerbose( @"%@", @(_player.status) );
		}
	}];
	[_notificationController observeNotificationName:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem queue:nil block:^(NSNotification *note, id observer) {
		AVPlayerItem* item = note.object;
		NBULogVerbose( @"再生終了 item=%@", item );
		if( _autoRepeat ){
			[self replay];
		}
		[_delegate moviePlayerDidFinishPlaying:self];
	}];
}


-(void)removeFromSuperview{
	[_notificationController unobserveAll];
	[_kvoController unobserveAll];
	[super removeFromSuperview];
	[_player pause];
	AVPlayerLayer* layer = (AVPlayerLayer*)self.layer;
	layer.player = nil;
	_player = nil;
	
}

-(void)dealloc{
	NSLog( @"dealloc" );
}



-(void)playWithURL:(NSURL*)url{
	AVPlayerItem* item = [[AVPlayerItem alloc] initWithURL:url];
	[_player replaceCurrentItemWithPlayerItem:item];
}


-(void)replay{
	[_player seekToTime:kCMTimeZero];
	[_player play];
}



-(void)pause{
	[_player pause];
}




@end
