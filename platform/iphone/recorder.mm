//
//  Recorder.m
//  recordexample
//
//  Created by Taeyoon Lee on 3/31/21.
//

#import "recorder.h"
extern "C" {
#import <AVFoundation/AVFoundation.h>
}

@interface MyObject: NSObject <AVAudioRecorderDelegate, AVAudioPlayerDelegate> {
}
@end

@implementation MyObject

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
  if (!flag) {
    [recorder stop];
  }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
}
@end

void Recorder::_bind_methods() {
	// ClassDB::bind_method(D_METHOD("start_recording"), &Recorder::start_recording);
	// ClassDB::bind_method(D_METHOD("finish_recording"), &Recorder::finish_recording);
	// ClassDB::bind_method(D_METHOD("start_playback"), &Recorder::start_playback);
};

AVAudioRecorder* audioRecorder = nullptr;
AVAudioPlayer* audioPlayer = nullptr;
MyObject* myObject = [MyObject alloc];

void Recorder::start_recording()
{
  NSLog(@"Recorder::start_recording");

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

    audioRecorder = [[AVAudioRecorder alloc] initWithURL:audioFilename settings:recordSettings error:nil];
    audioRecorder.delegate = myObject;
    [audioRecorder record];
}

void Recorder::stop_recording()
{
  NSLog(@"Recorder::stop_recording");
  if (audioRecorder != nil)
	  [audioRecorder stop];
  audioRecorder = nil;
}

bool Recorder::is_recording()
{
  if (audioRecorder == nil)
		return false;
	return [audioRecorder isRecording];
}

void Recorder::start_playback()
{
  NSLog(@"Recorder::start_playback");
  NSURL* docu = [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
  NSURL* audioFilename = [docu URLByAppendingPathComponent:@"recording.wav"];
  @try {
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioFilename error:nil];
    // audioPlayer.delegate = myObject;
    [audioPlayer play];
  }
  @catch (NSException *exception){
  }
}

/* Recorder *Recorder::get_singleton() {
	return instance;
}; */

Recorder::Recorder() {}
