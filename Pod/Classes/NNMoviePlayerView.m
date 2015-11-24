//
//  NNMoviePlayerView.m
//  Pods
//
//  Created by noughts on 2015/02/18.
//
//

#import "NNMoviePlayerView.h"
@import AVFoundation;
#import "FTGNotificationController.h"
#import "FBKVOController.h"
#import "NBULogStub.h"

@implementation NNMoviePlayerView{
	FBKVOController* _kvoController;
	FTGNotificationController* _notificationController;
	AVPlayer        *_player;
	id _playbackTimeObserver;
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
        switch (_player.status) {
            case AVPlayerStatusReadyToPlay:
                NBULogInfo( @"再生準備が完了したので再生を開始します item=%@", object.currentItem );
                [_player play];
                break;
            case AVPlayerStatusFailed:
                NBULogError(@"再生の準備に失敗した模様");
                break;
            case AVPlayerStatusUnknown:
                NBULogError(@"再生の準備の結果が不明");
                break;
        }
	}];
    [_kvoController observe:_player keyPath:@"currentItem.loadedTimeRanges" options:NSKeyValueObservingOptionNew block:^(id observer, AVPlayer* object, NSDictionary *change) {
        NSArray *timeRanges = (NSArray *)[change objectForKey:NSKeyValueChangeNewKey];
        if (timeRanges && [timeRanges count]) {
            CMTimeRange timerange = [[timeRanges objectAtIndex:0] CMTimeRangeValue];
            NBULogVerbose(@" . . . %.5f -> %.5f", CMTimeGetSeconds(timerange.start), CMTimeGetSeconds(CMTimeAdd(timerange.start, timerange.duration)));
            [object play];/// ここで再生を再開しないと、回線が遅い時にとまったままになってしまいます
        }
    }];
    [_kvoController observe:_player keyPath:@"rate" options:NSKeyValueObservingOptionNew block:^(id observer, AVPlayer* object, NSDictionary *change) {
        NBULogVerbose(@"Player playback rate changed: %.5f", object.rate);
        if (object.rate == 0.0) {
            NBULogVerbose(@" . . . PAUSED (or just started)");
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
	
	/// 再生時間監視
	__weak typeof(_player) __player = _player;
	__weak typeof(self) _self = self;
	CMTime interval = CMTimeMakeWithSeconds(1/30.0, NSEC_PER_SEC);
	_playbackTimeObserver = [_player addPeriodicTimeObserverForInterval:interval queue:nil usingBlock:^(CMTime time) {
		float duration = CMTimeGetSeconds(__player.currentItem.duration);
        if( duration != duration ){/// nanチェックのトリック http://stackoverflow.com/questions/2109257/isnan-in-objective-c
            return;
        }
		float currentTime = CMTimeGetSeconds(time);
		float pct = currentTime / duration;
//		NBULogInfo(@"currentTime=%@ duration=%@ pct=%@", @(currentTime), @(duration), @(pct));
        if( currentTime == 0 ){
            [_self.delegate moviePlayerDidStartPlaying:_self];
        }
		[_self.delegate moviePlayer:_self playProgressChanged:pct];
	}];
}



-(void)removeFromSuperview{
	[_notificationController unobserveAll];
	[_kvoController unobserveAll];
	[super removeFromSuperview];
	
	/*
	[_player pause];
	AVPlayerLayer* layer = (AVPlayerLayer*)self.layer;
	layer.player = nil;
	_player = nil;
	 */
}

-(void)dealloc{
	NBULogVerbose( @"dealloc" );
}


/// NSBundleから取得したpathを渡して再生
-(void)playWithPath:(NSString*)path{
	NSURL* url = [NSURL fileURLWithPath:path];
	[self playWithURL:url];
}

-(void)playWithURL:(NSURL*)url{
    NSOperationQueue* queue = [NSOperationQueue new];
    [queue addOperationWithBlock:^{
        AVPlayerItem* item = [[AVPlayerItem alloc] initWithURL:url];
        [_player replaceCurrentItemWithPlayerItem:item];
        [_player play];
    }];
}


-(void)replay{
	[_player seekToTime:kCMTimeZero];
	[_player play];
}



-(void)pause{
	[_player pause];
}




@end
