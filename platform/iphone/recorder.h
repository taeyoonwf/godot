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
  void start_recording();
  bool is_recording();
  void stop_recording();
  void start_playback();
	static Recorder *get_singleton();

	Recorder();
};

#endif /* Recoder_h */
