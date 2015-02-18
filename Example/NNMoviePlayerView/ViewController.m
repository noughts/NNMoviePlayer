//
//  NNViewController.m
//  NNMoviePlayerView
//
//  Created by koichi yamamoto on 02/18/2015.
//  Copyright (c) 2014 koichi yamamoto. All rights reserved.
//

#import "ViewController.h"
#import <NNMoviePlayerView.h>

@implementation ViewController{
	__weak IBOutlet NNMoviePlayerView* _player_view;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}




-(IBAction)onPlayRemoveMovieButtonTap:(id)sender{
	NSURL* url = [NSURL URLWithString:@"http://casio.jp/file/dc/CIMG1226.mov"];
	[_player_view playWithURL:url];
}

-(IBAction)onPlayLocalMovieButtonTap:(id)sender{
	NSURL* url = [[NSBundle mainBundle] URLForResource:@"sample_iTunes" withExtension:@"mov"];
	[_player_view playWithURL:url];
}


-(IBAction)onReplayButton:(id)sender{
	[_player_view replay];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
