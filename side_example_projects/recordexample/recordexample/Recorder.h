//
//  Recoder.h
//  recordexample
//
//  Created by Taeyoon Lee on 3/31/21.
//

#ifndef Recorder_h
#define Recorder_h

#include <AVFoundation/AVFoundation.h>

@interface MyObject: NSObject <AVAudioRecorderDelegate, AVAudioPlayerDelegate> {
}
@end

class Recorder {
public:
  static MyObject* myObject;
  static AVAudioRecorder* audioRecorder;
  static AVAudioPlayer* audioPlayer;
  static void startRecording();
  static void finishRecording(bool);
  static void startPlayback();
};

#endif /* Recoder_h */
