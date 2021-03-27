#include "core/math/math_funcs.h"
#include "vorbis_encoder.h"
#include <vorbis/vorbisenc.h>

PoolVector<uint8_t> VorbisEncoder::wav_to_ogg(const PoolVector<uint8_t>& p_data) {
	PoolVector<uint8_t> ret;
  const int READ = 1024;
  signed char readbuffer[READ*4+44];

	ogg_stream_state os; /* take physical pages, weld into a logical
													stream of packets */
	ogg_page         og; /* one Ogg bitstream page.	Vorbis packets are inside */
	ogg_packet       op; /* one raw packet of data for decode */

	vorbis_info      vi; /* struct that stores all the static vorbis bitstream
													settings */
	vorbis_comment   vc; /* struct that stores all the user comments */

	vorbis_dsp_state vd; /* central working state for the packet->PCM decoder */
	vorbis_block     vb; /* local working space for packet->PCM decode */

  int eos=0, check;
  int begin = 0;

  for (int i=0; i<30; i++)
  {
    if (p_data[i] == 'd' && p_data[i+1] == 'a') {
			i += 6;
			begin = i;
      break;
    }
  }

	vorbis_info_init(&vi);
	check = vorbis_encode_init_vbr(&vi,2,44100,0.4);
  if (check) {
		return ret;
	}

  vorbis_comment_init(&vc);
  vorbis_comment_add_tag(&vc,"ENCODER","langcord");
  vorbis_analysis_init(&vd,&vi);
  vorbis_block_init(&vd,&vb);

	ogg_stream_init(&os, Math::rand());


  {
    ogg_packet header;
    ogg_packet header_comm;
    ogg_packet header_code;

    vorbis_analysis_headerout(&vd,&vc,&header,&header_comm,&header_code);
    ogg_stream_packetin(&os,&header); /* automatically placed in its own
                                         page */
    ogg_stream_packetin(&os,&header_comm);
    ogg_stream_packetin(&os,&header_code);

    /* This ensures the actual
     * audio data will start on a new page, as per spec
     */
    while(!eos){
      int result=ogg_stream_flush(&os,&og);
      if(result==0)break;

			for (int i = 0; i < (int)og.header_len; i++)
				ret.push_back(og.header[i]);
			for (int i = 0; i < (int)og.body_len; i++)
				ret.push_back(og.body[i]);
    }
  }

	int datalen = p_data.size();
  while(!eos){
    long i;
    long bytes = 0;
		for (int j = begin; j < begin + READ * 4 && j < datalen; j++) {
			readbuffer[j - begin] = p_data[j];
			bytes++;
		}
		begin += bytes;
    // long bytes=fread(readbuffer,1,READ*4,stdin); /* stereo hardwired here */

    if(bytes==0){
      vorbis_analysis_wrote(&vd,0);

    }else{
      /* data to encode */

      /* expose the buffer to submit data */
      float **buffer=vorbis_analysis_buffer(&vd,READ);

      /* uninterleave samples */
      for(i=0;i<bytes/4;i++){
        buffer[0][i]=((readbuffer[i*4+1]<<8)|
                      (0x00ff&(int)readbuffer[i*4]))/32768.f;
        buffer[1][i]=((readbuffer[i*4+3]<<8)|
                      (0x00ff&(int)readbuffer[i*4+2]))/32768.f;
      }

      /* tell the library how much we actually submitted */
      vorbis_analysis_wrote(&vd,i);
    }

    /* vorbis does some data preanalysis, then divvies up blocks for
       more involved (potentially parallel) processing.  Get a single
       block for encoding now */
    while(vorbis_analysis_blockout(&vd,&vb)==1){

      /* analysis, assume we want to use bitrate management */
      vorbis_analysis(&vb,NULL);
      vorbis_bitrate_addblock(&vb);

      while(vorbis_bitrate_flushpacket(&vd,&op)){

        /* weld the packet into the bitstream */
        ogg_stream_packetin(&os,&op);

        /* write out pages (if any) */
        while(!eos){
          int result=ogg_stream_pageout(&os,&og);
          if(result==0)break;
					for (int j = 0; j < (int)og.header_len; j++)
						ret.push_back(og.header[j]);
					for (int j = 0; j < (int)og.body_len; j++)
						ret.push_back(og.body[j]);

          if(ogg_page_eos(&og))eos=1;
        }
      }
    }
  }

  ogg_stream_clear(&os);
  vorbis_block_clear(&vb);
  vorbis_dsp_clear(&vd);
  vorbis_comment_clear(&vc);
  vorbis_info_clear(&vi);

	return ret;
}

Error VorbisEncoder::save_to_ogg(const String &p_path, const PoolVector<uint8_t>& p_data) {
	PoolVector<uint8_t> ret = wav_to_ogg(p_data);
	if (ret.size() == 0) {
		return ERR_FILE_CORRUPT;
	}

  String file_path = p_path;
  if (!(file_path.substr(file_path.length() - 4, 4) == ".ogg")) {
    file_path += ".ogg";
  }

  FileAccessRef file = FileAccess::open(file_path, FileAccess::WRITE); //Overrides existing

  ERR_FAIL_COND_V(!file, ERR_FILE_CANT_WRITE);

	file->store_buffer(ret.read().ptr(), ret.size());

	file->close();

	return OK;
}

void VorbisEncoder::_bind_methods() {
	ClassDB::bind_method(D_METHOD("wav_to_ogg", "data"), &VorbisEncoder::wav_to_ogg);
	ClassDB::bind_method(D_METHOD("save_to_ogg", "path", "data"), &VorbisEncoder::save_to_ogg);
}
