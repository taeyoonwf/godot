#ifndef AUDIO_STREAM_VORBIS_ENCODER_H
#define AUDIO_STREAM_VORBIS_ENCODER_H

#include "scene/resources/audio_stream_sample.h"

class AudioStreamVorbisEncoder;

class AudioStreamVorbisEncoder : public AudioStreamSample {
  GDCLASS(AudioStreamVorbisEncoder, AudioStream);
  OBJ_SAVE_TYPE(AudioStream);
  RES_BASE_EXTENSION("oggenc")

protected:
  static void _bind_methods();

public:
  Error save_to_ogg(const String &p_path);
};

#endif
