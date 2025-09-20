#!/bin/bash

set -e

# Determine number of CPU cores for parallel compilation
CORES=$(nproc)
echo "=== FFmpeg Audio Codecs Compilation Script ==="
echo "This script will compile FFmpeg with essential audio codecs"
echo "Detected $CORES CPU cores - using make -j$CORES for faster compilation"
echo "Estimated time: 15-30 minutes depending on your system"
echo ""

# Setup directories
echo "Setting up directories..."
cd ~/ &&
mkdir -p ~/ffmpeg_sources ~/bin &&

# Install dependencies
echo "Installing dependencies..."
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

echo "Dependencies installed successfully!"

# Try to install SRT from package manager first
echo "Attempting to install SRT from package manager..."
if sudo apt-get -y install libsrt-openssl-dev 2>/dev/null || sudo apt-get -y install libsrt-gnutls-dev 2>/dev/null; then
    echo "SRT installed from package manager!"
    SKIP_SRT_BUILD=true
else
    echo "SRT not available from package manager, will build from source"
    SKIP_SRT_BUILD=false
fi

# NASM
echo "Building NASM..."
cd ~/ffmpeg_sources
NASM_VERSION="2.16.03"
NASM_SHA256="bef3de159bcd61adf98bb7cc87ee9046e944644ad76b7633f18ab063edb29e57"
wget "https://www.nasm.us/pub/nasm/releasebuilds/${NASM_VERSION}/nasm-${NASM_VERSION}.tar.bz2"
echo "${NASM_SHA256}  nasm-${NASM_VERSION}.tar.bz2" | sha256sum -c || {
    echo "NASM checksum verification failed!"
    exit 1
}
tar xjvf nasm-2.16.03.tar.bz2 && \
cd nasm-2.16.03 && \
./autogen.sh && \
./configure --prefix="/usr/local" && \
make -j$CORES && \
sudo make install
sudo ldconfig

echo "NASM installed successfully!"

# libfdk-aac
echo "Building libfdk-aac..."
cd ~/ffmpeg_sources && \
git -C fdk-aac pull 2> /dev/null || git clone --depth 1 https://github.com/mstorsjo/fdk-aac && \
cd fdk-aac && \
autoreconf -fiv && \
./configure --prefix="/usr/local" --enable-shared && \
make -j$CORES && \
sudo make install
sudo ldconfig

echo "libfdk-aac installed successfully!"

# libopus
echo "Building libopus..."
cd ~/ffmpeg_sources && \
git -C opus pull 2> /dev/null || git clone --depth 1 https://github.com/xiph/opus.git && \
cd opus && \
./autogen.sh && \
./configure --prefix="/usr/local" --enable-shared && \
make -j$CORES && \
sudo make install
sudo ldconfig

echo "libopus installed successfully!"

# SRT (only build if not available from package manager)
if [ "$SKIP_SRT_BUILD" = false ]; then
    echo "Building SRT from source..."
    cd ~/ffmpeg_sources && \
    git -C srt pull 2> /dev/null || git clone --depth 1 https://github.com/Haivision/srt.git && \
    cd srt && \
    mkdir -p build && cd build && \
    cmake -DCMAKE_INSTALL_PREFIX="/usr/local" -DENABLE_SHARED=ON -DENABLE_STATIC=OFF -DUSE_OPENSSL_PC=OFF .. && \
    make -j$CORES && \
    sudo make install && \
    sudo ldconfig
    echo "SRT built and installed successfully!"
else
    echo "Using SRT from package manager"
fi

# FFmpeg compilation
echo "Building FFmpeg with audio codecs..."
cd ~/ffmpeg_sources 
git -C ffmpeg pull 2> /dev/null || git clone https://git.ffmpeg.org/ffmpeg.git 
cd ffmpeg 

# Version selection
echo ""
echo "=== FFmpeg Version Selection ==="
echo "Fetching available versions..."
git fetch --tags > /dev/null 2>&1

# Get list of stable versions
STABLE_VERSIONS=$(git tag | grep "^n[0-9]" | grep -v -E "(dev|rc|alpha|beta)" | sort -V)
LATEST_STABLE=$(echo "$STABLE_VERSIONS" | tail -1)

echo "Latest stable version: $LATEST_STABLE"
echo ""
echo "Available recent stable versions:"
echo "$STABLE_VERSIONS" | tail -10
echo ""
echo "Enter version to install (e.g., n7.0.2, n6.1.1)"
echo "Or press Enter for latest stable ($LATEST_STABLE):"
read -r VERSION_INPUT

if [ -z "$VERSION_INPUT" ]; then
    SELECTED_VERSION="$LATEST_STABLE"
    echo "Using latest stable version: $SELECTED_VERSION"
else
    # Validate the input version exists
    if echo "$STABLE_VERSIONS" | grep -q "^${VERSION_INPUT}$"; then
        SELECTED_VERSION="$VERSION_INPUT"
        echo "Using specified version: $SELECTED_VERSION"
    else
        echo "Warning: Version '$VERSION_INPUT' not found in stable releases."
        echo "Available versions that match your input:"
        echo "$STABLE_VERSIONS" | grep "$VERSION_INPUT" || echo "No matches found."
        echo ""
        echo "Continue with latest stable ($LATEST_STABLE)? (y/N):"
        read -r CONTINUE_CHOICE
        if [[ "$CONTINUE_CHOICE" =~ ^[Yy]$ ]]; then
            SELECTED_VERSION="$LATEST_STABLE"
            echo "Using latest stable version: $SELECTED_VERSION"
        else
            echo "Installation cancelled."
            exit 1
        fi
    fi
fi

echo "Checking out FFmpeg version: $SELECTED_VERSION"
git checkout "$SELECTED_VERSION"

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
echo "Making PATH changes permanent..."
if ! grep -q 'export PATH="/usr/local/bin:$PATH"' ~/.bashrc; then
    echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bashrc
    echo "Added /usr/local/bin to PATH in ~/.bashrc"
fi

# Create convenience script for system FFmpeg if needed
if [ -f "/usr/bin/ffmpeg.backup" ]; then
    echo "Creating 'ffmpeg-system' command for accessing original FFmpeg..."
    sudo ln -sf /usr/bin/ffmpeg.backup /usr/local/bin/ffmpeg-system
fi

echo ""
echo "=== Compilation Complete! ==="
echo "FFmpeg version $SELECTED_VERSION has been successfully compiled with the following audio codecs:"
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
echo "Compilation used $CORES CPU cores for faster build times."
echo "You can verify the installation by running:"
echo "  ffmpeg -version"
echo "  ffmpeg -codecs | grep -E '(fdk_aac|mp3lame|opus|vorbis|speex|twolame|amr)'"
echo ""
echo "FFmpeg binary location: /usr/local/bin/ffmpeg"
echo ""
echo "Note: Using all CPU cores during compilation may have made your system"
echo "temporarily slow or unresponsive. This is normal and should now be resolved."
echo ""
echo "=== FFmpeg Version Information ==="
ffmpeg -version