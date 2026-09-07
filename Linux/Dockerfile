# Static custom FFmpeg with audio codecs (libfdk-aac, libopus, libmp3lame,
# libsoxr). Mirrors install_static_bare.sh as a two-stage build.
#
# Runtime image is debian:bookworm-slim with /usr/local/bin/{ffmpeg,ffprobe}
# on PATH. Other services use this as their FROM:
#   FROM ghcr.io/mikasappi/ffmpeg-for-audio/linux-bare-7.1:latest
# and stop bundling their own ffmpeg.

# syntax=docker/dockerfile:1.6
ARG FFMPEG_MAJOR=7

FROM debian:bookworm-slim AS builder
ARG FFMPEG_MAJOR
ENV DEBIAN_FRONTEND=noninteractive \
    PREFIX=/usr/local/ffmpeg-static-bare \
    PKG_CONFIG_PATH=/usr/local/ffmpeg-static-bare/lib/pkgconfig

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
      autoconf automake build-essential ca-certificates cmake git \
      libssl-dev libtool pkg-config wget yasm zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src

# NASM 2.16.03 — checksum-verified to match install_static_bare.sh
RUN wget -q https://www.nasm.us/pub/nasm/releasebuilds/2.16.03/nasm-2.16.03.tar.bz2 \
    && echo "bef3de159bcd61adf98bb7cc87ee9046e944644ad76b7633f18ab063edb29e57  nasm-2.16.03.tar.bz2" | sha256sum -c - \
    && tar xjf nasm-2.16.03.tar.bz2 \
    && cd nasm-2.16.03 \
    && ./autogen.sh \
    && ./configure --prefix=$PREFIX \
    && make -j"$(nproc)" \
    && make install

# apt only ships yasm, which FFmpeg 8+ no longer accepts as a substitute for nasm.
ENV PATH="$PREFIX/bin:$PATH"

# libfdk-aac (static)
RUN git clone --depth 1 https://github.com/mstorsjo/fdk-aac \
    && cd fdk-aac \
    && autoreconf -fiv \
    && ./configure --prefix=$PREFIX --disable-shared --enable-static \
    && make -j"$(nproc)" \
    && make install

# libopus (static)
RUN git clone --depth 1 https://github.com/xiph/opus.git \
    && cd opus \
    && ./autogen.sh \
    && ./configure --prefix=$PREFIX --disable-shared --enable-static \
    && make -j"$(nproc)" \
    && make install

# libmp3lame 3.100 (static)
RUN wget -q -O lame-3.100.tar.gz \
        "https://downloads.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz" \
    && tar xzf lame-3.100.tar.gz \
    && cd lame-3.100 \
    && ./configure --prefix=$PREFIX --disable-shared --enable-static --enable-nasm \
    && make -j"$(nproc)" \
    && make install

# libsoxr (static)
RUN git clone --depth 1 https://github.com/chirlu/soxr.git \
    && cd soxr \
    && mkdir -p build \
    && cd build \
    && cmake \
         -DCMAKE_BUILD_TYPE=Release \
         -DCMAKE_INSTALL_PREFIX=$PREFIX \
         -DBUILD_SHARED_LIBS=OFF \
         -DWITH_OPENMP=OFF \
         -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
         .. \
    && make -j"$(nproc)" \
    && make install

# FFmpeg — pick latest stable of the chosen major, static-link everything.
RUN git clone https://git.ffmpeg.org/ffmpeg.git \
    && cd ffmpeg \
    && git fetch --tags \
    && VER=$(git tag | grep "^n${FFMPEG_MAJOR}\." | grep -v -E "(dev|rc|alpha|beta)" | sort -V | tail -1) \
    && test -n "$VER" || (echo "no stable tags for major $FFMPEG_MAJOR" && exit 1) \
    && echo "Building FFmpeg $VER" \
    && git checkout "$VER" \
    && ./configure \
         --prefix=$PREFIX \
         --pkg-config-flags="--static" \
         --extra-ldflags="-L$PREFIX/lib -static" \
         --extra-cflags="-I$PREFIX/include" \
         --extra-libs="-lm" \
         --disable-ffplay --disable-doc --disable-htmlpages \
         --disable-manpages --disable-podpages --disable-txtpages \
         --disable-shared --disable-libopenh264 --disable-libxcb \
         --disable-sdl2 --disable-vaapi --disable-vdpau \
         --disable-alsa --disable-sndio --disable-libpulse \
         --disable-xlib --disable-libdrm \
         --enable-static --enable-gpl \
         --enable-libfdk-aac --enable-libmp3lame --enable-libopus \
         --enable-libsoxr --enable-nonfree --enable-version3 \
    && make -j"$(nproc)" \
    && make install

FROM debian:bookworm-slim
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
      ca-certificates tzdata \
    && rm -rf /var/lib/apt/lists/*
ENV TZ=Europe/Helsinki
COPY --from=builder /usr/local/ffmpeg-static-bare/bin/ffmpeg  /usr/local/bin/ffmpeg
COPY --from=builder /usr/local/ffmpeg-static-bare/bin/ffprobe /usr/local/bin/ffprobe
