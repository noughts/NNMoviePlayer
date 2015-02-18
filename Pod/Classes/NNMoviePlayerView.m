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


@implementation NNMoviePlayerView{
	FTGNotificationController* _notificationController;
	AVPlayer        *_player;
}

+(Class)layerClass{
	return [AVPlayerLayer class];
}


-(void)awakeFromNib{
	[super awakeFromNib];
	_notificationController = [FTGNotificationController controllerWithObserver:self];
}



-(void)playWithURL:(NSURL*)url{
	//プレイヤーを設定
	_player = [[AVPlayer alloc]initWithURL:url];
	
	//*1で説明したAVPlayerとViewとを紐づける処理
	[(AVPlayerLayer*)self.layer setPlayer:_player];
	
	//ステータスの変更を受け取るオブサーバの設定
	[_player addObserver:self
			 forKeyPath:@"status"
				options:NSKeyValueObservingOptionNew
				context:&_player];
	
	
	
	[_notificationController observeNotificationName:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem queue:nil block:^(NSNotification *note, id observer) {
		NSLog( @"再生終了" );
	}];
}


-(void)replay{
	[_player seekToTime:kCMTimeZero];
	[_player play];
}



#pragma mark - ステータス変更時に呼ばれるオブサーバ（１）
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
	//再生準備が整い次第、動画を再生させる。
	if([_player status] == AVPlayerItemStatusReadyToPlay){
		[_player removeObserver:self forKeyPath:@"status"];
		[_player play];
		return;
	}
	
	[super observeValueForKeyPath:keyPath
						 ofObject:object
						   change:change
						  context:context];
}




@end
