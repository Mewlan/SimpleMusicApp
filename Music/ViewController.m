//
//  ViewController.m
//  SimplePlayer
//
//  Created by Mewlan Musajan on 11/17/13.
//  Copyright (c) 2013 Mewlan Musajan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{NSLog(@"%s", __func__);
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.pause = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(playPausePressed:)];
    [self.pause setStyle:UIBarButtonItemStyleBordered];
    self.player = [MPMusicPlayerController iPodMusicPlayer];
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(nowPlayingItemChanged:)
                               name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:self.player];

    [self.player beginGeneratingPlaybackNotifications];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)rewindPressed:(id)sender {
    if ([self.player indexOfNowPlayingItem] == 0) {
        [self.player skipToBeginning];
    } else {
        [self.player endSeeking];
        [self.player skipToPreviousItem];
    }
}

- (IBAction)playPausePressed:(id)sender {
    [self.pause setTintColor:[UIColor blackColor]];
    MPMusicPlaybackState playbackState = [self.player playbackState];
    NSMutableArray *items = [NSMutableArray arrayWithArray:[self.toolbar items]];
    if (playbackState == MPMusicPlaybackStateStopped || playbackState == MPMusicPlaybackStatePaused) {
        [self.player play];
        [items replaceObjectAtIndex:3 withObject:self.pause];
    } else if (playbackState == MPMusicPlaybackStatePlaying) {
        [self.player pause];
        [items replaceObjectAtIndex:3 withObject:self.play];
    }
    [self.toolbar setItems:items animated:NO];
}

- (IBAction)fastForwardPressed:(id)sender {
    NSUInteger nowPlayingIndex = [self.player indexOfNowPlayingItem];
    [self.player endSeeking];
    [self.player skipToNextItem];
    if ([self.player nowPlayingItem] == nil) {
        if ([self.collection count] > nowPlayingIndex+1) {
            // added more songs while playing
            [self.player setQueueWithItemCollection:self.collection];
            MPMediaItem *item = [[self.collection items] objectAtIndex:nowPlayingIndex+1];
            [self.player setNowPlayingItem:item];
            [self.player play];
        }
        else {
            // no more songs
            [self.player stop];
            NSMutableArray *items = [NSMutableArray arrayWithArray:[self.toolbar items]];
            [items replaceObjectAtIndex:3 withObject:self.play];
            [self.toolbar setItems:items];
        }
    }
}

- (IBAction)addPressed:(id)sender {
    MPMediaType mediaType = MPMediaTypeMusic;
    MPMediaPickerController *picker = [[MPMediaPickerController alloc] initWithMediaTypes:mediaType];
    picker.delegate = self;
    [picker setAllowsPickingMultipleItems:YES];
    picker.prompt = NSLocalizedString(@"Select items to play", @"Select items to play");
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - Media Picker Delegate Methods

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {NSLog(@"%s", __func__);
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
    
    if (self.collection == nil) {
        self.collection = mediaItemCollection;
        [self.player setQueueWithItemCollection:self.collection];
        MPMediaItem *item = [[self.collection items] objectAtIndex:0];
        [self.player setNowPlayingItem:item];
        [self playPausePressed:self];
    } else {
        NSArray *oldItems = [self.collection items];
        NSArray *newItems = [oldItems arrayByAddingObjectsFromArray:[mediaItemCollection items]];
        self.collection = [[MPMediaItemCollection alloc] initWithItems:newItems];
    }
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Notification Methods

- (void)nowPlayingItemChanged:(NSNotification *)notification
{
	MPMediaItem *currentItem = [self.player nowPlayingItem];
    if (nil == currentItem) {
        [self.imageView setImage:nil];
        [self.imageView setHidden:YES];
        [self.artist setText:nil];
        [self.song setText:nil];
    }
    else {
        MPMediaItemArtwork *artwork = [currentItem valueForProperty: MPMediaItemPropertyArtwork];
        if (artwork) {
            UIImage *artworkImage = [artwork imageWithSize:CGSizeMake(320, 320)];
            [self.imageView setImage:artworkImage];
            [self.imageView setHidden:NO];
        }
        
        // Display the artist and song name for the now-playing media item
        NSString *artistStr = [currentItem valueForProperty:MPMediaItemPropertyArtist];
        NSString *albumStr = [currentItem valueForProperty:MPMediaItemPropertyAlbumTitle];
        [self.artist setText:[NSString stringWithFormat:@"%@ — %@", artistStr,albumStr]];
        [self.song setText:[currentItem valueForProperty:MPMediaItemPropertyTitle]];
    }
}

@end
