#ifndef AUDIO_STREAM_VORBIS_ENCODER_H
#define AUDIO_STREAM_VORBIS_ENCODER_H

#include "scene/resources/audio_stream_sample.h"

class VorbisEncoder : public Resource {
  GDCLASS(VorbisEncoder, Resource);
  RES_BASE_EXTENSION("oggenc")

protected:
  static void _bind_methods();

public:
  Error save_to_ogg(const String &p_path, const PoolVector<uint8_t> &p_data);
};

#endif
