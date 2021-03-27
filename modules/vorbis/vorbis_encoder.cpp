#include "vorbis_encoder.h"
#include <vorbis/vorbisenc.h>

Error VorbisEncoder::save_to_ogg(const String &p_path, const PoolVector<uint8_t>& p_data) {
  ogg_stream_state os; /* take physical pages, weld into a logical
                          stream of packets */
  ogg_page         og; /* one Ogg bitstream page.  Vorbis packets are inside */
  ogg_packet       op; /* one raw packet of data for decode */

  vorbis_info      vi; /* struct that stores all the static vorbis bitstream
                          settings */
  vorbis_comment   vc; /* struct that stores all the user comments */

  vorbis_dsp_state vd; /* central working state for the packet->PCM decoder */
  vorbis_block     vb; /* local working space for packet->PCM decode */

  int datalen = p_data.size();
  print_line("datalen " + itos(datalen));

	return OK;
}

void VorbisEncoder::_bind_methods() {
	/* ClassDB::bind_method(D_METHOD("set_data", "data"), &AudioStreamSample::set_data);
	ClassDB::bind_method(D_METHOD("get_data"), &AudioStreamSample::get_data);

	ClassDB::bind_method(D_METHOD("set_format", "format"), &AudioStreamSample::set_format);
	ClassDB::bind_method(D_METHOD("get_format"), &AudioStreamSample::get_format);

	ClassDB::bind_method(D_METHOD("set_loop_mode", "loop_mode"), &AudioStreamSample::set_loop_mode);
	ClassDB::bind_method(D_METHOD("get_loop_mode"), &AudioStreamSample::get_loop_mode);

	ClassDB::bind_method(D_METHOD("set_loop_begin", "loop_begin"), &AudioStreamSample::set_loop_begin);
	ClassDB::bind_method(D_METHOD("get_loop_begin"), &AudioStreamSample::get_loop_begin);

	ClassDB::bind_method(D_METHOD("set_loop_end", "loop_end"), &AudioStreamSample::set_loop_end);
	ClassDB::bind_method(D_METHOD("get_loop_end"), &AudioStreamSample::get_loop_end);

	ClassDB::bind_method(D_METHOD("set_mix_rate", "mix_rate"), &AudioStreamSample::set_mix_rate);
	ClassDB::bind_method(D_METHOD("get_mix_rate"), &AudioStreamSample::get_mix_rate);

	ClassDB::bind_method(D_METHOD("set_stereo", "stereo"), &AudioStreamSample::set_stereo);
	ClassDB::bind_method(D_METHOD("is_stereo"), &AudioStreamSample::is_stereo);

	ClassDB::bind_method(D_METHOD("save_to_wav", "path"), &AudioStreamSample::save_to_wav); */
	ClassDB::bind_method(D_METHOD("save_to_ogg", "path", "data"), &VorbisEncoder::save_to_ogg);

	/* ADD_PROPERTY(PropertyInfo(Variant::POOL_BYTE_ARRAY, "data", PROPERTY_HINT_NONE, "", PROPERTY_USAGE_NOEDITOR), "set_data", "get_data");
	ADD_PROPERTY(PropertyInfo(Variant::INT, "format", PROPERTY_HINT_ENUM, "8-Bit,16-Bit,IMA-ADPCM"), "set_format", "get_format");
	ADD_PROPERTY(PropertyInfo(Variant::INT, "loop_mode", PROPERTY_HINT_ENUM, "Disabled,Forward,Ping-Pong,Backward"), "set_loop_mode", "get_loop_mode");
	ADD_PROPERTY(PropertyInfo(Variant::INT, "loop_begin"), "set_loop_begin", "get_loop_begin");
	ADD_PROPERTY(PropertyInfo(Variant::INT, "loop_end"), "set_loop_end", "get_loop_end");
	ADD_PROPERTY(PropertyInfo(Variant::INT, "mix_rate"), "set_mix_rate", "get_mix_rate");
	ADD_PROPERTY(PropertyInfo(Variant::BOOL, "stereo"), "set_stereo", "is_stereo");

	BIND_ENUM_CONSTANT(FORMAT_8_BITS);
	BIND_ENUM_CONSTANT(FORMAT_16_BITS);
	BIND_ENUM_CONSTANT(FORMAT_IMA_ADPCM);

	BIND_ENUM_CONSTANT(LOOP_DISABLED);
	BIND_ENUM_CONSTANT(LOOP_FORWARD);
	BIND_ENUM_CONSTANT(LOOP_PING_PONG);
	BIND_ENUM_CONSTANT(LOOP_BACKWARD); */
}
