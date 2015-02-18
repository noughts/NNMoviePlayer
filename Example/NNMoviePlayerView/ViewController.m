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
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	_player_view.delegate = self;
}




-(IBAction)onPlayRemoveMovieButtonTap:(id)sender{
	NSURL* url = [NSURL URLWithString:@"http://casio.jp/file/dc/CIMG1226.mov"];
	[_player_view playWithURL:url];
	[self onPlayButtonTap];
}

-(IBAction)onPlayLocalMovieButtonTap:(id)sender{
	NSURL* url = [[NSBundle mainBundle] URLForResource:@"sample_mpeg4" withExtension:@"mov"];
	[_player_view playWithURL:url];
	[self onPlayButtonTap];
}


-(IBAction)onReplayButton:(id)sender{
	[_player_view replay];
	[self onPlayButtonTap];
}


-(void)onPlayButtonTap{
	[UIView animateWithDuration:0.25 animations:^{
		_playLocal_btn.alpha = 0.25;
		_playRemote_btn.alpha = 0.25;
	}];
}



-(void)moviePlayerDidFinishPlaying:(NNMoviePlayerView *)player{
	[UIView animateWithDuration:0.25 animations:^{
		_playLocal_btn.alpha = 1;
		_playRemote_btn.alpha = 1;
	}];
}








@end
