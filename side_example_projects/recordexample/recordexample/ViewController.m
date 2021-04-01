//
//  ViewController.m
//  recordexample
//
//  Created by Taeyoon Lee on 3/31/21.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@end

@implementation ViewController

AVAudioSession* recordingSession;
AVAudioRecorder* audioRecorder;
AVAudioPlayer* audioPlayer;

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  recordingSession = [AVAudioSession sharedInstance];

  [recordingSession setCategory:AVAudioSessionCategoryPlayAndRecord mode:AVAudioSessionModeDefault options:AVAudioSessionCategoryOptionDefaultToSpeaker error:NULL];
  [recordingSession setActive:true error:NULL];
  [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
              if (granted) {
                  // Microphone enabled code
                [self loadRecordingUI];
              }
              else {
                  // Microphone disabled code
              }
          }];
}

- (void)loadRecordingUI {
  [_recordButton setHidden:false];
  [_recordButton setTitle:@"Tap to Record!!" forState:UIControlStateNormal];
  [_playButton setHidden:true];
}

- (IBAction)recordPressed:(id)sender {
  if (audioRecorder == nil) {
    [self startRecording];
  }
  else {
    [self finishRecording:true];
  }
}
- (IBAction)playPressed:(id)sender {
  if (audioPlayer == nil) {
    [self startPlayback];
  } else {
    [self finishPlayback];
  }
}

- (void)startPlayback {
  NSURL* docu = [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
  NSURL* audioFilename = [docu URLByAppendingPathComponent:@"recording.wav"];
  @try {
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioFilename error:nil];
    audioPlayer.delegate = self;
    [audioPlayer play];
    [_playButton setTitle:@"Stop Playback" forState:UIControlStateNormal];
  }
  @catch (NSException *exception){
    [_playButton setHidden:true];
  }
}

- (void)finishPlayback {
  audioPlayer = nil;
  [_playButton setTitle:@"Play Your Recording" forState:UIControlStateNormal];
}

- (void)startRecording {
  NSURL* docu = [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
  NSURL* audioFilename = [docu URLByAppendingPathComponent:@"recording.wav"];
  NSDictionary *recordSettings = [NSDictionary
              dictionaryWithObjectsAndKeys:
              [NSNumber numberWithInt:AVAudioQualityMax],
              AVEncoderAudioQualityKey,
              [NSNumber numberWithInt: 2],
              AVNumberOfChannelsKey,
              [NSNumber numberWithFloat:44100.0],
              AVSampleRateKey,
              [NSNumber numberWithInt:kAudioFormatLinearPCM],
              AVFormatIDKey,
              nil];

  @try {
    audioRecorder = [[AVAudioRecorder alloc] initWithURL:audioFilename settings:recordSettings error:nil];
    audioRecorder.delegate = self;
    [audioRecorder record];
    [_recordButton setTitle:@"Tap to Stop" forState:UIControlStateNormal];
  }
  @catch (NSException *exception){
    [self finishRecording:false];
  }
}

- (void)finishRecording:(BOOL)success {
  [audioRecorder stop];
  audioRecorder = nil;
  if (success) {
    [_recordButton setTitle:@"Tap to Re-record" forState:UIControlStateNormal];
    [_playButton setTitle:@"Play Your Recording" forState:UIControlStateNormal];
    [_playButton setHidden:false];

  } else {
    [_recordButton setTitle:@"Tap to Record" forState:UIControlStateNormal];
    [_playButton setHidden:true];
  }
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
  if (!flag) {
    [self finishRecording:false];
  }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
  [self finishPlayback];
}
@end
