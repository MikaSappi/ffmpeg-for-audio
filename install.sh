#!/bin/bash

set -e

# Script metadata
SCRIPT_VERSION="1.0.0"
SCRIPT_NAME="FFmpeg Audio Codecs Compilation"
AUTHOR="Mika Säppi - Collins Group"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Determine number of CPU cores for parallel compilation
CORES=$(nproc)
print_status "=== $SCRIPT_NAME v$SCRIPT_VERSION ==="
print_status "Author: $AUTHOR"
print_status "This script will compile FFmpeg with essential audio codecs"
print_status "Detected $CORES CPU cores - using make -j$CORES for faster compilation"
print_status "Estimated time: 15-30 minutes depending on your system"
echo ""

# Check available disk space
AVAILABLE_SPACE=$(df ~ | awk 'NR==2 {print $4}')
REQUIRED_SPACE=2000000  # 2GB in KB
if [ "$AVAILABLE_SPACE" -lt "$REQUIRED_SPACE" ]; then
    print_error "Insufficient disk space. Required: ~2GB, Available: $(($AVAILABLE_SPACE/1024/1024))GB"
    exit 1
fi

# Setup directories
print_status "Setting up directories..."
cd ~/ &&
mkdir -p ~/ffmpeg_sources ~/bin &&

# Install dependencies
print_status "Installing dependencies..."
sudo apt-get update -qq && sudo apt-get -y install \
  autoconf \
  automake \
  build-essential \
  cmake \
  git-core \
  libass-dev \
  libfreetype6-dev \
  libgnutls28-dev \
  libmp3lame-dev \
  libopencore-amrnb-dev \
  libopencore-amrwb-dev \
  libsdl2-dev \
  libspeex-dev \
  libtwolame-dev \
  libtool \
  libva-dev \
  libvdpau-dev \
  libvorbis-dev \
  libxcb1-dev \
  libxcb-shm0-dev \
  libxcb-xfixes0-dev \
  meson \
  ninja-build \
  pkg-config \
  texinfo \
  wget \
  yasm \
  zlib1g-dev \
  libssl-dev \
  libcrypto++-dev

print_success "Dependencies installed successfully!"

# Try to install SRT from package manager first
print_status "Attempting to install SRT from package manager..."
if sudo apt-get -y install libsrt-openssl-dev 2>/dev/null || sudo apt-get -y install libsrt-gnutls-dev 2>/dev/null; then
    print_success "SRT installed from package manager!"
    SKIP_SRT_BUILD=true
else
    print_warning "SRT not available from package manager, will build from source"
    SKIP_SRT_BUILD=false
fi

# NASM
print_status "Building NASM..."
cd ~/ffmpeg_sources
NASM_VERSION="2.16.03"
NASM_SHA256="bef3de159bcd61adf98bb7cc87ee9046e944644ad76b7633f18ab063edb29e57"
wget "https://www.nasm.us/pub/nasm/releasebuilds/${NASM_VERSION}/nasm-${NASM_VERSION}.tar.bz2"
echo "${NASM_SHA256}  nasm-${NASM_VERSION}.tar.bz2" | sha256sum -c || {
    print_error "NASM checksum verification failed!"
    exit 1
}
tar xjvf nasm-2.16.03.tar.bz2 && \
cd nasm-2.16.03 && \
./autogen.sh && \
./configure --prefix="/usr/local" && \
make -j$CORES && \
sudo make install
sudo ldconfig

print_success "NASM installed successfully!"

# libfdk-aac
print_status "Building libfdk-aac..."
cd ~/ffmpeg_sources && \
git -C fdk-aac pull 2> /dev/null || git clone --depth 1 https://github.com/mstorsjo/fdk-aac && \
cd fdk-aac && \
autoreconf -fiv && \
./configure --prefix="/usr/local" --enable-shared && \
make -j$CORES && \
sudo make install
sudo ldconfig

print_success "libfdk-aac installed successfully!"

# libopus
print_status "Building libopus..."
cd ~/ffmpeg_sources && \
git -C opus pull 2> /dev/null || git clone --depth 1 https://github.com/xiph/opus.git && \
cd opus && \
./autogen.sh && \
./configure --prefix="/usr/local" --enable-shared && \
make -j$CORES && \
sudo make install
sudo ldconfig

print_success "libopus installed successfully!"

# SRT (only build if not available from package manager)
if [ "$SKIP_SRT_BUILD" = false ]; then
    print_status "Building SRT from source..."
    cd ~/ffmpeg_sources && \
    git -C srt pull 2> /dev/null || git clone --depth 1 https://github.com/Haivision/srt.git && \
    cd srt && \
    mkdir -p build && cd build && \
    cmake -DCMAKE_INSTALL_PREFIX="/usr/local" -DENABLE_SHARED=ON -DENABLE_STATIC=OFF -DUSE_OPENSSL_PC=OFF .. && \
    make -j$CORES && \
    sudo make install && \
    sudo ldconfig
    print_success "SRT built and installed successfully!"
else
    print_status "Using SRT from package manager"
fi

# FFmpeg compilation
print_status "Building FFmpeg with audio codecs..."
cd ~/ffmpeg_sources 
git -C ffmpeg pull 2> /dev/null || git clone https://git.ffmpeg.org/ffmpeg.git 
cd ffmpeg 

# Get latest stable version (7.x series)
print_status "Checking out latest stable version..."
LATEST_STABLE=$(git tag | grep "^n[0-9]" | grep -v -E "(dev|rc|alpha|beta)" | sort -V | tail -1)
print_status "Using FFmpeg stable version: $LATEST_STABLE"
git checkout "$LATEST_STABLE"

cd ~/ffmpeg_sources/ffmpeg && \
./configure \
  --prefix="/usr/local" \
  --extra-cflags="-fPIC" \
  --enable-shared \
  --enable-gpl \
  --enable-gnutls \
  --enable-libfdk-aac \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libvorbis \
  --enable-libspeex \
  --enable-libtwolame \
  --enable-libopencore-amrnb \
  --enable-libopencore-amrwb \
  $(pkg-config --exists srt && echo "--enable-libsrt" || echo "# SRT not available") \
  --enable-nonfree \
  --enable-version3 && \
make -j$CORES && \
sudo make install && \
sudo ldconfig

# Update PATH to include the new FFmpeg binary
export PATH="/usr/local/bin:$PATH"

# Make PATH change permanent
print_status "Making PATH changes permanent..."
if ! grep -q 'export PATH="/usr/local/bin:$PATH"' ~/.bashrc; then
    echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bashrc
    print_success "Added /usr/local/bin to PATH in ~/.bashrc"
fi

# Create convenience script for system FFmpeg if needed
if [ -f "/usr/bin/ffmpeg.backup" ]; then
    print_status "Creating 'ffmpeg-system' command for accessing original FFmpeg..."
    sudo ln -sf /usr/bin/ffmpeg.backup /usr/local/bin/ffmpeg-system
fi

echo ""
print_success "=== Compilation Complete! ==="
print_success "FFmpeg has been successfully compiled with the following audio codecs:"
echo "  ✓ libfdk-aac (High-quality AAC)"
echo "  ✓ libmp3lame (MP3)"
echo "  ✓ libopus (Modern codec for streaming)"
echo "  ✓ libvorbis (Ogg Vorbis)"
echo "  ✓ libspeex (Speech codec)"
echo "  ✓ libtwolame (MP2)"
echo "  ✓ libopencore-amr (AMR-NB/WB for mobile)"
if pkg-config --exists srt; then
    echo "  ✓ libsrt (Secure Reliable Transport)"
else
    echo "  ⚠ libsrt (Not available on this system)"
fi
echo ""
print_status "Compilation used $CORES CPU cores for faster build times."
print_status "You can verify the installation by running:"
echo "  ffmpeg -version"
echo "  ffmpeg -codecs | grep -E '(fdk_aac|mp3lame|opus|vorbis|speex|twolame|amr)'"
echo ""
print_status "FFmpeg binary location: /usr/local/bin/ffmpeg"
echo ""
print_warning "Note: Using all CPU cores during compilation may have made your system"
print_warning "temporarily slow or unresponsive. This is normal and should now be resolved."
echo ""
print_status "=== FFmpeg Version Information ==="
ffmpeg -version