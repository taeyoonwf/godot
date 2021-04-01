//
//  Recoder.h
//  recordexample
//
//  Created by Taeyoon Lee on 3/31/21.
//

#ifndef Recorder_h
#define Recorder_h

#include "core/object.h"

class Recorder : public Object {
  GDCLASS(Recorder, Object);

  static void _bind_methods();
public:
  static void start_recording();
  static void finish_recording(bool);
  static void startPlayback();
	Recorder();
};

#endif /* Recoder_h */
