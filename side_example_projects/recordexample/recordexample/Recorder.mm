//
//  Recorder.m
//  recordexample
//
//  Created by Taeyoon Lee on 3/31/21.
//

#include "Recorder.h"

@implementation MyObject

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
  if (!flag) {
    Recorder::finishRecording(false);
  }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
}
@end

AVAudioRecorder* Recorder::audioRecorder = nullptr;
AVAudioPlayer* Recorder::audioPlayer = nullptr;
MyObject* mo = [MyObject alloc];

void Recorder::startRecording()
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
    audioRecorder.delegate = mo;
    [audioRecorder record];
}

void Recorder::finishRecording(BOOL success)
{
  [audioRecorder stop];
  audioRecorder = nil;
}

void Recorder::startPlayback()
{
  NSURL* docu = [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
  NSURL* audioFilename = [docu URLByAppendingPathComponent:@"recording.wav"];
  @try {
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioFilename error:nil];
    audioPlayer.delegate = mo;
    [audioPlayer play];
  }
  @catch (NSException *exception){
  }
}

