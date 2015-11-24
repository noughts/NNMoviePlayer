//
//  NNViewController.m
//  NNMoviePlayerView
//
//  Created by koichi yamamoto on 02/18/2015.
//  Copyright (c) 2014 koichi yamamoto. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController{
	__weak IBOutlet NNMoviePlayerView* _player_view;
	__weak IBOutlet UIButton* _playLocal_btn;
	__weak IBOutlet UIButton* _playRemote_btn;
	__weak IBOutlet UIProgressView* _progress_view;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	_player_view.delegate = self;
}




-(IBAction)onPlayRemoveMovieButtonTap:(id)sender{
    NSString* url_str = [NSString stringWithFormat:@"https://s3-ap-northeast-1.amazonaws.com/blinkapp/video/DB07371F-12A9-43B7-82A4-4B1916E7708E.m4v?rnd=%@", @(arc4random())];
	NSURL* url = [NSURL URLWithString:url_str];
	[_player_view playWithURL:url];
	[self onPlayButtonTap];
}

-(IBAction)onPlayLocalMovieButtonTap:(id)sender{
	NSURL* url = [[NSBundle mainBundle] URLForResource:@"sample_mpeg4" withExtension:@"mov"];
	_player_view.autoRepeat = YES;
	[_player_view playWithURL:url];
	[self onPlayButtonTap];
}


-(IBAction)onReplayButton:(id)sender{
	[_player_view replay];
	[self onPlayButtonTap];
}


-(void)onPlayButtonTap{
    _player_view.alpha = 0.5;
	[UIView animateWithDuration:0.25 animations:^{
		_playLocal_btn.alpha = 0.25;
		_playRemote_btn.alpha = 0.25;
	}];
}


-(IBAction)onStopButtonTap:(id)sender{
    [_player_view stop];
}



#pragma mark - delegate


-(void)moviePlayerDidStartPlaying:(NNMoviePlayerView *)player{
    _player_view.alpha = 1;
}

-(void)moviePlayerDidFinishPlaying:(NNMoviePlayerView *)player{
	[UIView animateWithDuration:0.25 animations:^{
		_playLocal_btn.alpha = 1;
		_playRemote_btn.alpha = 1;
	}];
}

-(void)moviePlayer:(NNMoviePlayerView *)player playProgressChanged:(CGFloat)progress{
	_progress_view.progress = progress;
}






@end
