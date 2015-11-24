//
//  NNMoviePlayerView.h
//  Pods
//
//  Created by noughts on 2015/02/18.
//
//

#import <UIKit/UIKit.h>
@protocol NNMoviePlayerViewDelegate;




@interface NNMoviePlayerView : UIView

/// 自動リピート
@property BOOL autoRepeat;
@property(nonatomic,weak) id<NNMoviePlayerViewDelegate> delegate;
-(void)playWithURL:(NSURL*)url;

/// NSBundleから取得したpathを渡して再生
-(void)playWithPath:(NSString*)path;

-(void)replay;

/// 一時停止
-(void)pause;

/// ローディング中ならロードを止め、再生中なら再生を止める
-(void)stop;

@end












#pragma mark - delegate定義

@protocol NNMoviePlayerViewDelegate <NSObject>
-(void)moviePlayerDidStartPlaying:(NNMoviePlayerView*)player;
-(void)moviePlayerDidFinishPlaying:(NNMoviePlayerView*)player;
-(void)moviePlayer:(NNMoviePlayerView*)player playProgressChanged:(CGFloat)progress;
@end