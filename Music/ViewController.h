//
//  ViewController.h
//  SimplePlayer
//
//  Created by Mewlan Musajan on 11/17/13.
//  Copyright (c) 2013 Mewlan Musajan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController : UIViewController <MPMediaPickerControllerDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *song;
@property (weak, nonatomic) IBOutlet UILabel *artist;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UILabel *status;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *play;
@property (strong, nonatomic)          UIBarButtonItem *pause;

@property (strong, nonatomic) MPMusicPlayerController *player;
@property (strong, nonatomic) MPMediaItemCollection *collection;

- (IBAction)rewindPressed:(id)sender;
- (IBAction)playPausePressed:(id)sender;
- (IBAction)fastForwardPressed:(id)sender;
- (IBAction)addPressed:(id)sender;

- (void)nowPlayingItemChanged:(NSNotification *)notification;

@end
