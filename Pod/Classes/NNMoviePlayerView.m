//
//  NNMoviePlayerView.m
//  Pods
//
//  Created by noughts on 2015/02/18.
//
//

#import "NNMoviePlayerView.h"
@import AVFoundation;


@implementation NNMoviePlayerView{
	AVPlayer        *_player;
}

+(Class)layerClass{
	return [AVPlayerLayer class];
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
