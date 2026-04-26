FROM ghcr.io/btbn/ffmpeg-builds/base-win64:latest AS base-layer
ENV TARGET=win64 VARIANT=nonfree REPO=btbn/ffmpeg-builds ADDINS_STR=7.1
COPY --link util/run_stage.sh /usr/bin/run_stage
FROM base-layer AS mingw
ENV SELF="scripts.d/10-mingw.sh" STAGENAME="10-mingw"
RUN --mount=src=scripts.d/10-mingw.sh,dst=/stage.sh --mount=src=.cache/downloads/10-mingw_21499fb48008d07eb015c9486b8ffb97319c8f07b39f8dad2b1fda02642920d7.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS mingw-std-threads
ENV SELF="scripts.d/10-mingw-std-threads.sh" STAGENAME="10-mingw-std-threads"
RUN --mount=src=scripts.d/10-mingw-std-threads.sh,dst=/stage.sh --mount=src=.cache/downloads/10-mingw-std-threads_f6fe5dc5a067e90cd8b37a748b33962ac2eb09f3b486b287265803070dbf02d2.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS base
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/15-base.sh" STAGENAME="15-base"
FROM base-layer AS amf
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/50-amf.sh" STAGENAME="50-amf"
RUN --mount=src=scripts.d/50-amf.sh,dst=/stage.sh --mount=src=.cache/downloads/50-amf_7c9cfe54b42cbba18a2a7e36bb11d0df0c0d0e4d56917652095a3b637d957d6c.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS avisynth
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/50-avisynth.sh" STAGENAME="50-avisynth"
RUN --mount=src=scripts.d/50-avisynth.sh,dst=/stage.sh --mount=src=.cache/downloads/50-avisynth_c70d634648d33b41bbc817183ec7418478a3175fe8a3cac28f059d820656f90b.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS dav1d
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/50-dav1d.sh" STAGENAME="50-dav1d"
RUN --mount=src=scripts.d/50-dav1d.sh,dst=/stage.sh --mount=src=.cache/downloads/50-dav1d_2f18af8d9b8b89ca89fe8ff747baa050fa97b66d0dcf42396fa18d03da1b6310.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS davs2
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/50-davs2.sh" STAGENAME="50-davs2"
RUN --mount=src=scripts.d/50-davs2.sh,dst=/stage.sh --mount=src=.cache/downloads/50-davs2_a2d3a5d05dbd810e7a33f41ca77f70f1775ab8318ffe3e1b365105e8ad813d7e.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS dvd
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/50-dvd/30-libdvdcss.sh" STAGENAME="30-libdvdcss"
RUN --mount=src=scripts.d/50-dvd/30-libdvdcss.sh,dst=/stage.sh --mount=src=.cache/downloads/30-libdvdcss_7ec503fff0222503ad031b91d06f91f7c7bb8742b8c0d545c426b540c8fdf630.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
ENV SELF="scripts.d/50-dvd/40-libdvdread.sh" STAGENAME="40-libdvdread"
RUN --mount=src=scripts.d/50-dvd/40-libdvdread.sh,dst=/stage.sh --mount=src=.cache/downloads/40-libdvdread_77f24b54d41e352883a8bb4b8de04428c2ff7ed0085da03ad9f58667d9c561a1.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
ENV SELF="scripts.d/50-dvd/50-libdvdnav.sh" STAGENAME="50-libdvdnav"
RUN --mount=src=scripts.d/50-dvd/50-libdvdnav.sh,dst=/stage.sh --mount=src=.cache/downloads/50-libdvdnav_b2a6b75c2dd8d96eabeed5b11a685405ce29f2493608c1f7c45b189996e0db84.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS fdk-aac
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/50-fdk-aac.sh" STAGENAME="50-fdk-aac"
RUN --mount=src=scripts.d/50-fdk-aac.sh,dst=/stage.sh --mount=src=.cache/downloads/50-fdk-aac_6a7b1b3c7fc049564253d51a0e99542eef59df4fdc42ead43eddee597e18611a.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS ffnvcodec
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/50-ffnvcodec.sh" STAGENAME="50-ffnvcodec"
RUN --mount=src=scripts.d/50-ffnvcodec.sh,dst=/stage.sh --mount=src=.cache/downloads/50-ffnvcodec_814834eb355d3f831c6dbfdbfb9ba8e036afc94c7d8303b12a31718927599c11.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS fftw3
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/25-fftw3.sh" STAGENAME="25-fftw3"
RUN --mount=src=scripts.d/25-fftw3.sh,dst=/stage.sh --mount=src=.cache/downloads/25-fftw3_481fefd67cb6d473ad0028fdd27d9476a6143f6ccddfb015809b53c819e64bd7.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS frei0r
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/50-frei0r.sh" STAGENAME="50-frei0r"
RUN --mount=src=scripts.d/50-frei0r.sh,dst=/stage.sh --mount=src=.cache/downloads/50-frei0r_a70c688e295fcac74ffd2051dd09f8dceafaf626da858344ef51e6595987ba6e.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS fribidi
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/25-fribidi.sh" STAGENAME="25-fribidi"
RUN --mount=src=scripts.d/25-fribidi.sh,dst=/stage.sh --mount=src=.cache/downloads/25-fribidi_36b6c11866ff7ff311c17f05399ba35999d1fd7dd495126ea8ea4997d658b75d.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS gme
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/50-gme.sh" STAGENAME="50-gme"
RUN --mount=src=scripts.d/50-gme.sh,dst=/stage.sh --mount=src=.cache/downloads/50-gme_1a7169b2c1bd19d842d41b599166667d4ffeca400c16fcc822be21ee8bb17077.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS gmp
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/25-gmp.sh" STAGENAME="25-gmp"
RUN --mount=src=scripts.d/25-gmp.sh,dst=/stage.sh --mount=src=.cache/downloads/25-gmp_4b555c079737ef0f01f15976d7bbbff9d0dc94d7a06edd45d08a6cd2b60bdb86.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS kvazaar
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/50-kvazaar.sh" STAGENAME="50-kvazaar"
RUN --mount=src=scripts.d/50-kvazaar.sh,dst=/stage.sh --mount=src=.cache/downloads/50-kvazaar_3160290e09de6d9fc44bf3b4c7bf65c015b34764058f3df2dc1945bfaea0185a.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS libiconv
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/20-libiconv.sh" STAGENAME="20-libiconv"
RUN --mount=src=scripts.d/20-libiconv.sh,dst=/stage.sh --mount=src=.cache/downloads/20-libiconv_b53a9fb1af23b7715883003e5950f62aba4d8feb200c2431f23cbcd00af8995c.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS libjxl
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/50-libjxl/45-brotli.sh" STAGENAME="45-brotli"
RUN --mount=src=scripts.d/50-libjxl/45-brotli.sh,dst=/stage.sh --mount=src=.cache/downloads/45-brotli_3ad1fbbc0bed88b1872929ff694a44d87d25f549241000f69ea6aa43a7609a75.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
ENV SELF="scripts.d/50-libjxl/45-lcms2.sh" STAGENAME="45-lcms2"
RUN --mount=src=scripts.d/50-libjxl/45-lcms2.sh,dst=/stage.sh --mount=src=.cache/downloads/45-lcms2_d4684894f5421549f4cb1d5ce5075f482d64a973fae49a4e7c05fccd85eddf22.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
ENV SELF="scripts.d/50-libjxl/50-libjxl.sh" STAGENAME="50-libjxl"
RUN --mount=src=scripts.d/50-libjxl/50-libjxl.sh,dst=/stage.sh --mount=src=.cache/downloads/50-libjxl_dbe1d0097ec8ef57fe2e1f231d5dff7b6db95a89851769e9417e0ee27cf5afa4.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS libogg
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/25-libogg.sh" STAGENAME="25-libogg"
RUN --mount=src=scripts.d/25-libogg.sh,dst=/stage.sh --mount=src=.cache/downloads/25-libogg_c646cbcbc565a47f3173449c777f2a2da5798d65fd23e242bb1ddf4077225ab5.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS libopus
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/50-libopus.sh" STAGENAME="50-libopus"
RUN --mount=src=scripts.d/50-libopus.sh,dst=/stage.sh --mount=src=.cache/downloads/50-libopus_5283858ec3d1752eb0c8b88c4f6e8cc2654b36dfcf687a843098c43e91b0eb37.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS librist
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/50-librist/40-mbedtls.sh" STAGENAME="40-mbedtls"
RUN --mount=src=scripts.d/50-librist/40-mbedtls.sh,dst=/stage.sh --mount=src=.cache/downloads/40-mbedtls_26ea19ed3da17f5f6f1f8f72b8dbd2982f22f9d00f7108bdc70784ec1cb37dae.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
ENV SELF="scripts.d/50-librist/50-librist.sh" STAGENAME="50-librist"
RUN --mount=src=scripts.d/50-librist/50-librist.sh,dst=/stage.sh --mount=src=.cache/downloads/50-librist_706a6ea23a6ad691336f061760bf6a0196a17f309a28db96e3d404d818af287b.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS libsamplerate
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/45-libsamplerate.sh" STAGENAME="45-libsamplerate"
RUN --mount=src=scripts.d/45-libsamplerate.sh,dst=/stage.sh --mount=src=.cache/downloads/45-libsamplerate_3ae5a3324e89da0d7254873085ad23e2b1a0cb22c1e330b8d3beb1da0a0c0273.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS libudfread
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/45-libudfread.sh" STAGENAME="45-libudfread"
RUN --mount=src=scripts.d/45-libudfread.sh,dst=/stage.sh --mount=src=.cache/downloads/45-libudfread_96846906ad23aa725778f07ec9cd966348205b22a9b4bed927e1986305b95c7e.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS libvpx
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/50-libvpx.sh" STAGENAME="50-libvpx"
RUN --mount=src=scripts.d/50-libvpx.sh,dst=/stage.sh --mount=src=.cache/downloads/50-libvpx_164e1cde831daf8a1c3598ef6aeff8950a2b2231be6b8e9ad2338925ae55bc83.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS libwebp
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/50-libwebp.sh" STAGENAME="50-libwebp"
RUN --mount=src=scripts.d/50-libwebp.sh,dst=/stage.sh --mount=src=.cache/downloads/50-libwebp_8c2c1deaeaf61bf0e1a3fb1b37128796a406547922bea36cb19927eaa3e0693e.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS libzmq
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/50-libzmq.sh" STAGENAME="50-libzmq"
RUN --mount=src=scripts.d/50-libzmq.sh,dst=/stage.sh --mount=src=.cache/downloads/50-libzmq_dbda4f77090244ab731e7047e6499ef0790698bce6d12eae0885315acf6a3f0d.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS lilv
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/50-lilv/96-lv2.sh" STAGENAME="96-lv2"
RUN --mount=src=scripts.d/50-lilv/96-lv2.sh,dst=/stage.sh --mount=src=.cache/downloads/96-lv2_dab459f43ab5b331024524fe4b1761305a761f213806c0a2ac11e5b80d77702c.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
ENV SELF="scripts.d/50-lilv/96-serd.sh" STAGENAME="96-serd"
RUN --mount=src=scripts.d/50-lilv/96-serd.sh,dst=/stage.sh --mount=src=.cache/downloads/96-serd_92b3857eacfcb321afe870b525c1902f24bb71ca9172d61a478979be3274b7fd.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
ENV SELF="scripts.d/50-lilv/96-zix.sh" STAGENAME="96-zix"
RUN --mount=src=scripts.d/50-lilv/96-zix.sh,dst=/stage.sh --mount=src=.cache/downloads/96-zix_be10e4e79c6318cfbac33c78ba8feeac51d5d054f71a6de15b9356a2b03d79ad.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
ENV SELF="scripts.d/50-lilv/97-sord.sh" STAGENAME="97-sord"
RUN --mount=src=scripts.d/50-lilv/97-sord.sh,dst=/stage.sh --mount=src=.cache/downloads/97-sord_4708ae0a0703232d48ca08d4d5d9a8d0a5bbe60fc1145dd7a3fc8d7371194a53.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
ENV SELF="scripts.d/50-lilv/98-sratom.sh" STAGENAME="98-sratom"
RUN --mount=src=scripts.d/50-lilv/98-sratom.sh,dst=/stage.sh --mount=src=.cache/downloads/98-sratom_b1645950511f39374d220d1a44c849b12431936ba1eeed5028630aa3c67cc5fa.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
ENV SELF="scripts.d/50-lilv/99-lilv.sh" STAGENAME="99-lilv"
RUN --mount=src=scripts.d/50-lilv/99-lilv.sh,dst=/stage.sh --mount=src=.cache/downloads/99-lilv_f1e5978c4963442fcb2391db11ba775069407d6206613389b49a7a3902551805.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS onevpl
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/50-onevpl.sh" STAGENAME="50-onevpl"
RUN --mount=src=scripts.d/50-onevpl.sh,dst=/stage.sh --mount=src=.cache/downloads/50-onevpl_2020d0b871751fac413efdf1c090f681722df39919b44a21e82e062602b99c01.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS openal
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/50-openal.sh" STAGENAME="50-openal"
RUN --mount=src=scripts.d/50-openal.sh,dst=/stage.sh --mount=src=.cache/downloads/50-openal_5afd069c11337efd32813e4fbf20dd675e6310e5a1171811a1dd208bb42dd4b6.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS opencl
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/45-opencl.sh" STAGENAME="45-opencl"
RUN --mount=src=scripts.d/45-opencl.sh,dst=/stage.sh --mount=src=.cache/downloads/45-opencl_49d02bee64836674beb44f594800eb4b8e9e11a1a25d51e324594a3d8cf8b88e.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS opencore-amr
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/50-opencore-amr.sh" STAGENAME="50-opencore-amr"
RUN --mount=src=scripts.d/50-opencore-amr.sh,dst=/stage.sh --mount=src=.cache/downloads/50-opencore-amr_5d7ec3b8ffdd0f32309a659256916e3286724f08acf0f625a4b4f1f9c17ebf7c.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS openh264
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/50-openh264.sh" STAGENAME="50-openh264"
RUN --mount=src=scripts.d/50-openh264.sh,dst=/stage.sh --mount=src=.cache/downloads/50-openh264_f4fc628add7d00287878de2aee4d7d24b0af6fa81fe85dd0249acda814e5a3c3.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS openjpeg
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/50-openjpeg.sh" STAGENAME="50-openjpeg"
RUN --mount=src=scripts.d/50-openjpeg.sh,dst=/stage.sh --mount=src=.cache/downloads/50-openjpeg_61d2acb80fc1663250cf2ffda862add3eb930560fdcf120be91844b3939da1e6.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS rav1e
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/50-rav1e.sh" STAGENAME="50-rav1e"
RUN --mount=src=scripts.d/50-rav1e.sh,dst=/stage.sh --mount=src=.cache/downloads/50-rav1e_3e485d63e1aa8072abed78b0ea708c5283a204827aa9b0bb0f733834c3eeda3a.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS schannel
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/50-schannel.sh" STAGENAME="50-schannel"
FROM base-layer AS snappy
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/50-snappy.sh" STAGENAME="50-snappy"
RUN --mount=src=scripts.d/50-snappy.sh,dst=/stage.sh --mount=src=.cache/downloads/50-snappy_1c31fab1bdc8c349f86de14f25e18476ecc0f4620f9b29f3e11c3b1fe7417606.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS soxr
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/50-soxr.sh" STAGENAME="50-soxr"
RUN --mount=src=scripts.d/50-soxr.sh,dst=/stage.sh --mount=src=.cache/downloads/50-soxr_d24c000584012b62b406f09325af85575932219b972b87ab3e2b1037bdc97c6a.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS svtav1
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/50-svtav1.sh" STAGENAME="50-svtav1"
RUN --mount=src=scripts.d/50-svtav1.sh,dst=/stage.sh --mount=src=.cache/downloads/50-svtav1_ee5fbf77719ac3ec853946d3a58f68e37bbb91b4726fced3afaea74dad4ba5c7.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS twolame
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/50-twolame.sh" STAGENAME="50-twolame"
RUN --mount=src=scripts.d/50-twolame.sh,dst=/stage.sh --mount=src=.cache/downloads/50-twolame_0222bab9e1e6869937be0713572586ff12480843520d525ff38cd76b4667a7a2.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS uavs3d
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/50-uavs3d.sh" STAGENAME="50-uavs3d"
RUN --mount=src=scripts.d/50-uavs3d.sh,dst=/stage.sh --mount=src=.cache/downloads/50-uavs3d_232be137fb1f137591bdf5b3d0787f9904b69f3245f5266ba363cff7d4e2de54.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS vaapi
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/50-vaapi/50-libva.sh" STAGENAME="50-libva"
RUN --mount=src=scripts.d/50-vaapi/50-libva.sh,dst=/stage.sh --mount=src=.cache/downloads/50-libva_08f2d484214b9e811951a60cffec82f329c76dc4047b3a660c6be8e71e4e95d1.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
ENV SELF="scripts.d/50-vaapi/99-finalize.sh" STAGENAME="99-finalize"
RUN --mount=src=scripts.d/50-vaapi/99-finalize.sh,dst=/stage.sh run_stage /stage.sh
FROM base-layer AS vidstab
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/50-vidstab.sh" STAGENAME="50-vidstab"
RUN --mount=src=scripts.d/50-vidstab.sh,dst=/stage.sh --mount=src=.cache/downloads/50-vidstab_adc7d42c0a71fa355a89fc988bd358a711b4f5ca801443b71626770b804dc48d.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS vmaf
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/45-vmaf.sh" STAGENAME="45-vmaf"
RUN --mount=src=scripts.d/45-vmaf.sh,dst=/stage.sh --mount=src=.cache/downloads/45-vmaf_5ce130ba77af76a208da67bed3237967117b662f0d7ad97033a7d5d02eab35ff.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS vulkan
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/47-vulkan/40-vulkan-headers.sh" STAGENAME="40-vulkan-headers"
RUN --mount=src=scripts.d/47-vulkan/40-vulkan-headers.sh,dst=/stage.sh --mount=src=.cache/downloads/40-vulkan-headers_0ee3be8ebb036a0cb30c9e1cd9567a9cb5361bcc90a47a67e3be0e2ac56fdf30.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
ENV SELF="scripts.d/47-vulkan/45-vulkan-loader.sh" STAGENAME="45-vulkan-loader"
RUN --mount=src=scripts.d/47-vulkan/45-vulkan-loader.sh,dst=/stage.sh --mount=src=.cache/downloads/45-vulkan-loader_19f1ae9aff1d11931957b61be833825549001a5e201a5c11e015153cc3781680.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
ENV SELF="scripts.d/47-vulkan/50-shaderc.sh" STAGENAME="50-shaderc"
RUN --mount=src=scripts.d/47-vulkan/50-shaderc.sh,dst=/stage.sh --mount=src=.cache/downloads/50-shaderc_52af9e377cb77ce483982139a1766e177bcc8ad051ef02e098b7b701a7a1f72e.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
ENV SELF="scripts.d/47-vulkan/55-spirv-cross.sh" STAGENAME="55-spirv-cross"
RUN --mount=src=scripts.d/47-vulkan/55-spirv-cross.sh,dst=/stage.sh --mount=src=.cache/downloads/55-spirv-cross_69f7156f82de58450a3063ad6dd36ca0339df98a22ed3c799a8cb005d6632773.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
ENV SELF="scripts.d/47-vulkan/99-enable.sh" STAGENAME="99-enable"
RUN --mount=src=scripts.d/47-vulkan/99-enable.sh,dst=/stage.sh run_stage /stage.sh
FROM base-layer AS vvenc
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/50-vvenc.sh" STAGENAME="50-vvenc"
RUN --mount=src=scripts.d/50-vvenc.sh,dst=/stage.sh --mount=src=.cache/downloads/50-vvenc_2c8f8f02bea57912120164bdab7d2990ca81ed0b76bfbdd85cb7835e0864a922.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS x264
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/50-x264.sh" STAGENAME="50-x264"
RUN --mount=src=scripts.d/50-x264.sh,dst=/stage.sh --mount=src=.cache/downloads/50-x264_7aee4cf46b7c0eff1a5ad3d23ae43a29562065ef2866a4a883d7ad2db0fb755d.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS x265
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/50-x265.sh" STAGENAME="50-x265"
RUN --mount=src=scripts.d/50-x265.sh,dst=/stage.sh --mount=src=.cache/downloads/50-x265_963e6ace8c20cd8244d4638cae841f0cb1f925249100e9d00d890e7b0caa3d75.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS xavs2
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/50-xavs2.sh" STAGENAME="50-xavs2"
RUN --mount=src=scripts.d/50-xavs2.sh,dst=/stage.sh --mount=src=.cache/downloads/50-xavs2_983aacbab6d33318bf9c4742b41a1ed9d42afc12a0493ba97d07404a99734009.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS xvid
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/50-xvid.sh" STAGENAME="50-xvid"
RUN --mount=src=scripts.d/50-xvid.sh,dst=/stage.sh --mount=src=.cache/downloads/50-xvid_46476f3f325fdb9332244b306148afce16e9dd564890446f4d649daa2eb8815a.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS zimg
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/50-zimg.sh" STAGENAME="50-zimg"
RUN --mount=src=scripts.d/50-zimg.sh,dst=/stage.sh --mount=src=.cache/downloads/50-zimg_3818567c53ce46a2212901103d5897da0857b7a0dfff5da125831e42815f8e20.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS zlib
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/20-zlib.sh" STAGENAME="20-zlib"
RUN --mount=src=scripts.d/20-zlib.sh,dst=/stage.sh --mount=src=.cache/downloads/20-zlib_8b6dbc6bce9b1c15ee69e79934f767d341d519d9432e2c94c0e0fc0da3c507e2.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS aom
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=vmaf $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/50-aom.sh" STAGENAME="50-aom"
RUN --mount=src=scripts.d/50-aom.sh,dst=/stage.sh --mount=src=.cache/downloads/50-aom_b0febe01099482795467b639ecdb14428cdf4fff27fcd396b7934b63c5387682.tar.xz,dst=/cache.tar.xz --mount=src=patches/aom,dst=/patches run_stage /stage.sh
FROM base-layer AS aribb24
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=zlib $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/50-aribb24/25-libpng.sh" STAGENAME="25-libpng"
RUN --mount=src=scripts.d/50-aribb24/25-libpng.sh,dst=/stage.sh --mount=src=.cache/downloads/25-libpng_6a4088aea40e3c0cc495e31a64bad88afc6822a8a742f3a322de2ac1b7fa2702.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
ENV SELF="scripts.d/50-aribb24/50-libaribb24.sh" STAGENAME="50-libaribb24"
RUN --mount=src=scripts.d/50-aribb24/50-libaribb24.sh,dst=/stage.sh --mount=src=.cache/downloads/50-libaribb24_3dd74ffb861f7ef9133dab074b9845408d84ebc49db9aee5d91829efba6d52ce.tar.xz,dst=/cache.tar.xz --mount=src=patches/aribb24,dst=/patches run_stage /stage.sh
FROM base-layer AS chromaprint
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=fftw3 $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/50-chromaprint.sh" STAGENAME="50-chromaprint"
RUN --mount=src=scripts.d/50-chromaprint.sh,dst=/stage.sh --mount=src=.cache/downloads/50-chromaprint_a397a01fbb6f6693d13f695dfee49d1b6fc220a818c0a580ac8a69480c5faba3.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS libmp3lame
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=libiconv $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/50-libmp3lame.sh" STAGENAME="50-libmp3lame"
RUN --mount=src=scripts.d/50-libmp3lame.sh,dst=/stage.sh --mount=src=.cache/downloads/50-libmp3lame_572043a74090d765071c155bc1b107920cde3add6ff61932e789f12d75e0c887.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS libplacebo
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=vulkan $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=vulkan /opt/glslc /usr/bin/glslc
ENV SELF="scripts.d/50-libplacebo.sh" STAGENAME="50-libplacebo"
RUN --mount=src=scripts.d/50-libplacebo.sh,dst=/stage.sh --mount=src=.cache/downloads/50-libplacebo_3120cdd8c3c2966b52e83cc69b935505080f1837b2eba1ae9aeda7319cebb3c9.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS libtheora
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=libogg $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/50-libtheora.sh" STAGENAME="50-libtheora"
RUN --mount=src=scripts.d/50-libtheora.sh,dst=/stage.sh --mount=src=.cache/downloads/50-libtheora_90adf22ee83c074158258c81916474f8fff82001538a4e7d3c413a58c4fd3850.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS libvorbis
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=libogg $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/45-libvorbis.sh" STAGENAME="45-libvorbis"
RUN --mount=src=scripts.d/45-libvorbis.sh,dst=/stage.sh --mount=src=.cache/downloads/45-libvorbis_f1f7893135cfd63e8e9f50e85bd4421c016bd34f661469ca5f6cf35585dd832a.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS libxml2
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=libiconv $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/25-libxml2.sh" STAGENAME="25-libxml2"
RUN --mount=src=scripts.d/25-libxml2.sh,dst=/stage.sh --mount=src=.cache/downloads/25-libxml2_8c279ea3d228ce8853d78b5a81fca390e5cdc9268e9e05e961cd922c002b390a.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS openssl
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=zlib $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/25-openssl.sh" STAGENAME="25-openssl"
RUN --mount=src=scripts.d/25-openssl.sh,dst=/stage.sh --mount=src=.cache/downloads/25-openssl_7fb7ae9a81b11e5e24413a2eedf93fc9bbff6b2a42a0f73a86f29f9b8fe497eb.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS rubberband
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=fftw3 $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=libsamplerate $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/50-rubberband.sh" STAGENAME="50-rubberband"
RUN --mount=src=scripts.d/50-rubberband.sh,dst=/stage.sh --mount=src=.cache/downloads/50-rubberband_5d3ca7b4a1f4c07ead3f23ba9c7a3736384a9394a34e41bf70a78075e0ed9593.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS sdl
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=libiconv $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=libsamplerate $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/50-sdl.sh" STAGENAME="50-sdl"
RUN --mount=src=scripts.d/50-sdl.sh,dst=/stage.sh --mount=src=.cache/downloads/50-sdl_b476b2a308a215a02e4ec0d7627932e2da82b338f6833e8e80b81be43c6aefae.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS xz
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=libiconv $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/25-xz.sh" STAGENAME="25-xz"
RUN --mount=src=scripts.d/25-xz.sh,dst=/stage.sh --mount=src=.cache/downloads/25-xz_a1300e2650cfab3e27037157687985995decec7a1eeded4ed4f559d7d9729d5e.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS zvbi
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=libiconv $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/50-zvbi.sh" STAGENAME="50-zvbi"
RUN --mount=src=scripts.d/50-zvbi.sh,dst=/stage.sh --mount=src=.cache/downloads/50-zvbi_836a67d315400474f3bf721865cd87501cacff448c48a92705a8db4d95ec04d8.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS fonts
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=libiconv $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=libxml2 $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/45-fonts/25-freetype.sh" STAGENAME="25-freetype"
RUN --mount=src=scripts.d/45-fonts/25-freetype.sh,dst=/stage.sh --mount=src=.cache/downloads/25-freetype_d757adb9d52f86007413a7b66a826a49532c13bb1a2f4d0df848c5dca0e9beb6.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
ENV SELF="scripts.d/45-fonts/35-fontconfig.sh" STAGENAME="35-fontconfig"
RUN --mount=src=scripts.d/45-fonts/35-fontconfig.sh,dst=/stage.sh --mount=src=.cache/downloads/35-fontconfig_8603868198f3d9c2b1a88cbf2ff89108d7d36147950d38a8fcb9762b4170ace2.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
ENV SELF="scripts.d/45-fonts/45-harfbuzz.sh" STAGENAME="45-harfbuzz"
RUN --mount=src=scripts.d/45-fonts/45-harfbuzz.sh,dst=/stage.sh --mount=src=.cache/downloads/45-harfbuzz_ab466c718d7bebf1d190ad05f5ece57cb72cb58702714812225a638412223668.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
ENV SELF="scripts.d/45-fonts/50-freetype.sh" STAGENAME="50-freetype"
RUN --mount=src=scripts.d/45-fonts/50-freetype.sh,dst=/stage.sh --mount=src=.cache/downloads/50-freetype_d757adb9d52f86007413a7b66a826a49532c13bb1a2f4d0df848c5dca0e9beb6.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS libssh
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=zlib $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=openssl $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/50-libssh.sh" STAGENAME="50-libssh"
RUN --mount=src=scripts.d/50-libssh.sh,dst=/stage.sh --mount=src=.cache/downloads/50-libssh_c394504b106fb7979570de2fbbfdb5b669df3244681d3ff8ca6b102083cd40e0.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS openmpt
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=libogg $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=zlib $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=libvorbis $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/50-openmpt.sh" STAGENAME="50-openmpt"
RUN --mount=src=scripts.d/50-openmpt.sh,dst=/stage.sh --mount=src=.cache/downloads/50-openmpt_abe1828dc13713b1f6507e376ca72b7a237c7d1db6a4bacfdd371e75a17b2a49.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS srt
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=zlib $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=openssl $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/50-srt.sh" STAGENAME="50-srt"
RUN --mount=src=scripts.d/50-srt.sh,dst=/stage.sh --mount=src=.cache/downloads/50-srt_944d00d2384f363deca15d47bc93821b6a41c67eae38581f30042a2ccc2a6ab6.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS libaribcaption
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=libiconv $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=libxml2 $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=fonts $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/50-libaribcaption.sh" STAGENAME="50-libaribcaption"
RUN --mount=src=scripts.d/50-libaribcaption.sh,dst=/stage.sh --mount=src=.cache/downloads/50-libaribcaption_83701bb2006489dd3619f6e7f730ff6dd4699dd40f4b3d95241062cb6256c217.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS libass
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=libiconv $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=libxml2 $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=fonts $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=fribidi $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/50-libass.sh" STAGENAME="50-libass"
RUN --mount=src=scripts.d/50-libass.sh,dst=/stage.sh --mount=src=.cache/downloads/50-libass_c113cd00177c1612c4a0db13a05efae357f077437bd333f55d63c899669b385a.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS libbluray
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=libiconv $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=libxml2 $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=fonts $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=libudfread $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
ENV SELF="scripts.d/50-libbluray.sh" STAGENAME="50-libbluray"
RUN --mount=src=scripts.d/50-libbluray.sh,dst=/stage.sh --mount=src=.cache/downloads/50-libbluray_15d45e44567ea2c66df0b5763b7621b0937b8285263b6c4341577ba1557989ac.tar.xz,dst=/cache.tar.xz run_stage /stage.sh
FROM base-layer AS combine-layer
COPY --link --from=mingw /opt/mingw/. /
COPY --link --from=mingw /opt/mingw/. /opt/mingw
COPY --link --from=mingw-std-threads $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=libiconv $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=zlib $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=libxml2 $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=libogg $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=vmaf $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=fftw3 $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=fonts $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=fribidi $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=libudfread $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=vulkan $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=vulkan /opt/glslc /usr/bin/glslc
COPY --link --from=openssl $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=libvorbis $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=libsamplerate $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=gmp $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=xz $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=opencl $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=amf $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=aom $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=aribb24 $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=avisynth $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=chromaprint $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=dav1d $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=davs2 $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=dvd $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=fdk-aac $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=ffnvcodec $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=frei0r $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=gme $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=kvazaar $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=libaribcaption $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=libass $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=libbluray $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=libjxl $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=libmp3lame $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=libopus $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=libplacebo $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=librist $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=libssh $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=libtheora $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=libvpx $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=libwebp $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=libzmq $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=lilv $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=onevpl $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=openal $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=opencore-amr $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=openh264 $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=openjpeg $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=openmpt $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=rav1e $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=rubberband $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=sdl $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=snappy $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=soxr $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=srt $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=svtav1 $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=twolame $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=uavs3d $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=vaapi $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=vidstab $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=vvenc $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=x264 $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=x265 $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=xavs2 $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=xvid $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=zimg $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
COPY --link --from=zvbi $FFBUILD_DESTPREFIX/. $FFBUILD_PREFIX
FROM base-layer
COPY --link --from=combine-layer $FFBUILD_PREFIX/. $FFBUILD_PREFIX
COPY --link --from=combine-layer /opt/mingw/. /
ENV \
    FF_CONFIGURE="--enable-nonfree --enable-gpl --enable-version3 --disable-debug --disable-w32threads --enable-pthreads --enable-iconv --enable-zlib --enable-libxml2 --enable-libvmaf --enable-fontconfig --enable-libharfbuzz --enable-libfreetype --enable-libfribidi --enable-vulkan --enable-libshaderc --enable-libvorbis --disable-libxcb --disable-xlib --disable-libpulse --enable-gmp --enable-lzma --enable-opencl --enable-amf --enable-libaom --enable-libaribb24 --enable-avisynth --enable-chromaprint --enable-libdav1d --enable-libdavs2 --enable-libdvdread --enable-libdvdnav --enable-libfdk-aac --enable-ffnvcodec --enable-cuda-llvm --enable-frei0r --enable-libgme --enable-libkvazaar --enable-libaribcaption --enable-libass --enable-libbluray --enable-libjxl --enable-libmp3lame --enable-libopus --enable-libplacebo --enable-librist --enable-libssh --enable-libtheora --enable-libvpx --enable-libwebp --enable-libzmq --enable-lv2 --enable-libvpl --enable-openal --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libopenh264 --enable-libopenjpeg --enable-libopenmpt --enable-librav1e --enable-librubberband --enable-schannel --enable-sdl2 --enable-libsnappy --enable-libsoxr --enable-libsrt --enable-libsvtav1 --enable-libtwolame --enable-libuavs3d --disable-libdrm --enable-vaapi --enable-libvidstab --enable-libvvenc --enable-libx264 --enable-libx265 --enable-libxavs2 --enable-libxvid --enable-libzimg --enable-libzvbi" \
    FF_CFLAGS="-DLIBTWOLAME_STATIC" \
    FF_CXXFLAGS="" \
    FF_LDFLAGS="-pthread" \
    FF_LDEXEFLAGS="" \
    FF_LIBS="-lgomp"
