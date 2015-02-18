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

@property(nonatomic,assign) id<NNMoviePlayerViewDelegate> delegate;
-(void)playWithURL:(NSURL*)url;
-(void)replay;

@end












#pragma mark - delegate定義

@protocol NNMoviePlayerViewDelegate <NSObject>
-(void)moviePlayerDidFinishPlaying:(NNMoviePlayerView*)player;
@end