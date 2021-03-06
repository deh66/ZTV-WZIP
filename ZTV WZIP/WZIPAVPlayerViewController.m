//
//  WZIPAVPlayerViewController.m
//  ZTV WZIP
//
//  Created by Timothy Transue on 11/3/14.
//  Copyright (c) 2014 Timothy Transue. All rights reserved.
//

#import "WZIPAVPlayerViewController.h"
@import MediaPlayer;

@interface WZIPAVPlayerViewController ()

@property (nonatomic, strong) NSString *artist;
@property (nonatomic, strong) NSString *songTitle;
@property (nonatomic, strong) NSURL *imageURL;

@end

@implementation WZIPAVPlayerViewController

// Below method allows for the view controller to assume First Responder status
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Establish that this is the first responder
    [self becomeFirstResponder];
    [self generatePlayer];
    
    // Get the AV Asset from the web
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.player.rate == 0)
    {
        [self generatePlayer];
    }
}

- (void)wzipAudioSession
{
    // Establish the audio session to allow background playback
    AVAudioSession *wzip = [AVAudioSession sharedInstance];
    [wzip setCategory:AVAudioSessionCategoryPlayback error:nil];
    [wzip setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
}

- (void)generatePlayer
{
    AVAsset *asset = [AVAsset assetWithURL:[NSURL URLWithString:@"http://www.live365.com/play/wzip?now=51&tag=live365&auth=594e8e429ab0395a72e3d5169201e886-1422579873-wzip&membername=&session=1422551073-659445&rnd=0.3082329868339002"]];
    //AVAsset *asset = [AVAsset assetWithURL:[NSURL URLWithString:@"http://www.live365.com/web/components/top/playlist.html?site=web&ads=1&size=125&station=wzip&tm=0.3618873665109277"]];
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
    AVMetadataItem *metaData = [item.asset.metadata firstObject];
    
    //  Attempt to parse metadata (Album, Artist, Track name, etc) from the asset
    [metaData loadValuesAsynchronouslyForKeys:@[AVMetadataCommonKeyTitle, AVMetadataCommonKeyArtist, AVMetadataCommonKeyAlbumName,  AVMetadataCommonKeyArtwork] completionHandler:^{
        NSError *error = nil;
        if ([metaData statusOfValueForKey:AVMetadataCommonKeyTitle error:&error] == AVKeyValueStatusLoaded) {
            NSString *title = [metaData stringValue];
            NSLog(@"%@", title);
        }
        if ([metaData statusOfValueForKey:AVMetadataCommonKeyArtist error:&error] == AVKeyValueStatusLoaded) {
            NSString *artist = [metaData stringValue];
            NSLog(@"%@", artist);
        }
        if ([metaData statusOfValueForKey:AVMetadataCommonKeyArtwork error:&error]) {
            //NSData *artwork = [metaData dataValue];
        }
        if ([metaData statusOfValueForKey:AVMetadataCommonKeyAlbumName error:&error]) {
            NSString *album = [metaData stringValue];
            NSLog(@"%@", album);
        }
    }];
    // Run the background audio session
    [self wzipAudioSession];
    // Give the player the asset
    self.player = [AVPlayer playerWithPlayerItem:item];
    // Pause the player until later
    self.player.rate = 0.0;
    // Allows playback via AirPlay and other external means
    self.player.allowsExternalPlayback = YES;
    [self configureControlCenter];
}


- (void)configureControlCenter
{
    MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
    //center.nowPlayingInfo = self.playlistDictionary;
    //UIImage *image = [UIImage imageNamed:@"s24354q.png"];
    //NSDictionary *infoDictionary = @{MPMediaItemPropertyArtist:@"WZIP",MPMediaItemPropertyArtwork:image};
    NSDictionary *infoDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"WZIP", MPMediaItemPropertyArtist, nil];
    center.nowPlayingInfo = infoDictionary;
}


- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent {
    
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        
        switch (receivedEvent.subtype) {
                
            case UIEventSubtypeRemoteControlTogglePlayPause:
                // This allows the Control Center to play or pause the playback of the stream
                [self playOrStop];
                break;
                
                /*case UIEventSubtypeRemoteControlPreviousTrack:
                 [self previousTrack: nil];
                 break;*/
                
                /*case UIEventSubtypeRemoteControlNextTrack:
                 [self nextTrack: nil];
                 break;*/
                
            default:
                break;
        }
    }
}

- (void)playOrStop
{
    //  Referenced earlier, plays or pauses the stream from the Control Center
    if (self.player.rate == 1.0)
    {
        self.player.rate = 0.0;
    }
    else if (self.player.rate == 0.0) self.player.rate = 1.0;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    // This is part of the failed experiment to get the metadata from XML Files
    if ([elementName isEqualToString:@"Title"])
    {
        self.title = [attributeDict objectForKey:@"Title"];
    }
    if ([elementName isEqualToString:@"Artist"])
    {
        self.artist = [attributeDict objectForKey:@"Artist"];
    }
    if ([elementName isEqualToString:@"visualURL"])
    {
        self.imageURL = [NSURL URLWithString:[attributeDict objectForKey:@"visualURL"]];
    }
    if ([elementName isEqualToString:@"Refresh"])
    {
        /*NSNumber *refresh = [attributeDict objectForKey:@"Refresh"];
         NSTimeInterval refreshInterval = refresh.doubleValue;
         NSDate *refreshTime = [[NSDate alloc] initWithTimeInterval:refreshInterval sinceDate:[NSDate date]];*/
    }
    NSArray *keys = [[NSArray alloc] initWithObjects:@"Title", @"Artist", @"visualURL", nil];
    NSArray *objects = [[NSArray alloc] initWithObjects:self.title, self.artist, self.imageURL, nil];
    NSLog(@"Title is %@, Artist is %@, Artwork address is %@", self.title, self.artist, self.imageURL);
    NSDictionary *musicInfoDictionary = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    self.playlistDictionary = musicInfoDictionary;
}


- (void)didReceiveMemoryWarning
{
    
}


- (void)dealloc
{
    // This ensures that the first responder status of the player is given up when the view controller is destroyed.
    [self resignFirstResponder];
}




@end
