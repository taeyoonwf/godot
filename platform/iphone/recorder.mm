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
    Recorder::finish_recording(false);
  }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
}
@end

void Recorder::_bind_methods() {
};

AVAudioRecorder* audioRecorder = nullptr;
AVAudioPlayer* audioPlayer = nullptr;
MyObject* myObject = [MyObject alloc];

void Recorder::start_recording()
{
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

void Recorder::finish_recording(BOOL success)
{
  [audioRecorder stop];
  audioRecorder = nil;
  startPlayback();
}

void Recorder::startPlayback()
{
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

Recorder::Recorder() {}
