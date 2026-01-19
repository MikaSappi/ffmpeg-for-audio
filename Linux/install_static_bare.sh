#!/bin/bash

set -e

echo "=== FFmpeg Static Audio Codecs Compilation Script ==="
echo "This script will compile FFmpeg with essential audio codecs (statically linked)"
echo ""

# version selection
echo "Preparing FFmpeg repository for version selection..."
cd ~/
mkdir -p ~/ffmpeg_sources_static_bare
cd ~/ffmpeg_sources_static_bare
git -C ffmpeg pull 2> /dev/null || git clone https://git.ffmpeg.org/ffmpeg.git
cd ffmpeg
git fetch --tags > /dev/null 2>&1

# Get list of stable versions
STABLE_VERSIONS=$(git tag | grep "^n[0-9]" | grep -v -E "(dev|rc|alpha|beta)" | sort -V)
LATEST_STABLE=$(echo "$STABLE_VERSIONS" | tail -1)

echo "=== FFmpeg Version Selection ==="
echo "Latest stable version: $LATEST_STABLE"
echo ""
echo "Available major versions:"
for major in $(echo "$STABLE_VERSIONS" | sed 's/^n\([0-9]\+\)\..*$/\1/' | sort -n | uniq | tail -5); do
    latest_in_major=$(echo "$STABLE_VERSIONS" | grep "^n${major}\." | tail -1)
    echo "  $major -> $latest_in_major"
done
echo ""
echo "Enter version to install:"
echo "  - Full version (e.g., n7.0.2, n6.1.1)"
echo "  - Major version number (e.g., 7 for latest n7.x.y)"
echo "  - Press Enter for latest stable ($LATEST_STABLE)"
echo ""
read -p "Version: " VERSION_INPUT

if [ -z "$VERSION_INPUT" ]; then
    SELECTED_VERSION="$LATEST_STABLE"
    echo "Using latest stable version: $SELECTED_VERSION"
elif [[ "$VERSION_INPUT" =~ ^[0-9]+$ ]]; then
    # Single number - find latest version for that major
    MAJOR_VERSION="$VERSION_INPUT"
    SELECTED_VERSION=$(echo "$STABLE_VERSIONS" | grep "^n${MAJOR_VERSION}\." | tail -1)
    if [ -z "$SELECTED_VERSION" ]; then
        echo "Error: No stable versions found for major version $MAJOR_VERSION"
        echo "Available major versions: $(echo "$STABLE_VERSIONS" | sed 's/^n\([0-9]\+\)\..*$/\1/' | sort -n | uniq | tr '\n' ' ')"
        exit 1
    fi
    echo "Using latest version for major $MAJOR_VERSION: $SELECTED_VERSION"
elif echo "$STABLE_VERSIONS" | grep -q "^${VERSION_INPUT}$"; then
    SELECTED_VERSION="$VERSION_INPUT"
    echo "Using specified version: $SELECTED_VERSION"
else
    echo "Error: Version '$VERSION_INPUT' not found in stable releases."
    echo "Available versions that contain '$VERSION_INPUT':"
    MATCHING_VERSIONS=$(echo "$STABLE_VERSIONS" | grep "$VERSION_INPUT" | head -10)
    if [ -n "$MATCHING_VERSIONS" ]; then
        echo "$MATCHING_VERSIONS"
    else
        echo "No matches found."
    fi
    echo ""
    echo "Use format like: n7.0.2, n6.1.1, or just: 7, 6"
    exit 1
fi

echo "Selected FFmpeg version: $SELECTED_VERSION"
echo ""

# Determine number of CPU cores for parallel compilation
CORES=$(nproc)
echo "Detected $CORES CPU cores - using make -j$CORES for faster compilation"
echo "Estimated time: 15-30 minutes depending on your system"
echo ""

# Setup directories
echo "Setting up directories..."
cd ~/ &&
mkdir -p ~/ffmpeg_sources_static_bare ~/bin &&

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
  libsdl2-dev \
  libtool \
  pkg-config \
  texinfo \
  wget \
  yasm \
  zlib1g-dev \
  libssl-dev

echo "Dependencies installed successfully!"

# NASM
echo "Building NASM..."
cd ~/ffmpeg_sources_static_bare
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
./configure --prefix="/usr/local/ffmpeg-static-bare" && \
make -j$CORES && \
sudo make install

echo "NASM installed successfully!"

# libfdk-aac
echo "Building libfdk-aac (static)..."
cd ~/ffmpeg_sources_static_bare && \
git -C fdk-aac pull 2> /dev/null || git clone --depth 1 https://github.com/mstorsjo/fdk-aac && \
cd fdk-aac && \
autoreconf -fiv && \
./configure --prefix="/usr/local/ffmpeg-static-bare" --disable-shared --enable-static && \
make -j$CORES && \
sudo make install

echo "libfdk-aac installed successfully!"

# libopus
echo "Building libopus (static)..."
cd ~/ffmpeg_sources_static_bare && \
git -C opus pull 2> /dev/null || git clone --depth 1 https://github.com/xiph/opus.git && \
cd opus && \
./autogen.sh && \
./configure --prefix="/usr/local/ffmpeg-static-bare" --disable-shared --enable-static && \
make -j$CORES && \
sudo make install

echo "libopus installed successfully!"

# libmp3lame
echo "Building libmp3lame (static)..."
cd ~/ffmpeg_sources_static_bare
if [ ! -f lame-3.100.tar.gz ]; then
    wget https://sourceforge.net/projects/lame/files/lame/3.100/lame-3.100.tar.gz
fi
tar xzf lame-3.100.tar.gz
cd lame-3.100
./configure --prefix="/usr/local/ffmpeg-static-bare" --disable-shared --enable-static --enable-nasm
make -j$CORES
sudo make install

echo "libmp3lame installed successfully!"

# libsoxr
echo "Building libsoxr (static)..."
cd ~/ffmpeg_sources_static_bare && \
git -C soxr pull 2> /dev/null || git clone https://github.com/chirlu/soxr.git && \
cd soxr && \
mkdir -p build && cd build && \
cmake -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX="/usr/local/ffmpeg-static-bare" \
      -DBUILD_SHARED_LIBS=OFF \
      -DWITH_OPENMP=OFF \
      .. && \
make -j$CORES && \
sudo make install

echo "libsoxr installed successfully!"

# Set PKG_CONFIG_PATH for static libraries
export PKG_CONFIG_PATH="/usr/local/ffmpeg-static-bare/lib/pkgconfig:$PKG_CONFIG_PATH"

echo "Verifying libsoxr installation..."
if pkg-config --exists soxr; then
    echo "libsoxr found via pkg-config"
    pkg-config --modversion soxr
else
    echo "Warning: libsoxr not found in pkg-config"
fi

# FFmpeg compilation (static)
echo "Building FFmpeg with audio codecs (static)..."
cd ~/ffmpeg_sources_static_bare/ffmpeg

echo "Checking out FFmpeg version: $SELECTED_VERSION"
git checkout "$SELECTED_VERSION"

cd ~/ffmpeg_sources_static_bare/ffmpeg && \
PKG_CONFIG_PATH="/usr/local/ffmpeg-static-bare/lib/pkgconfig:$PKG_CONFIG_PATH" \
./configure \
  --prefix="/usr/local/ffmpeg-static-bare" \
  --pkg-config-flags="--static" \
  --extra-ldflags="-L/usr/local/ffmpeg-static-bare/lib -static" \
  --extra-cflags="-I/usr/local/ffmpeg-static-bare/include" \
  --extra-libs="-lm" \
  --disable-ffplay \
  --disable-ffprobe \
  --disable-doc \
  --disable-htmlpages \
  --disable-manpages \
  --disable-podpages \
  --disable-txtpages \
  --disable-shared \
  --disable-libopenh264 \
  --disable-libxcb \
  --disable-sdl2 \
  --disable-vaapi \
  --disable-vdpau \
  --disable-alsa \
  --disable-sndio \
  --disable-libpulse \
  --disable-xlib \
  --disable-libdrm \
  --enable-static \
  --enable-gpl \
  --enable-libfdk-aac \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libsoxr \
  --enable-nonfree \
  --enable-version3 \
  && make -j$CORES && \
  sudo make install

# Copy the static binary to /usr/local/bin for convenience
echo "Installing FFmpeg binary to /usr/local/bin..."
sudo cp /usr/local/ffmpeg-static-bare/bin/ffmpeg /usr/local/bin/ffmpeg

# Update PATH to include the new FFmpeg binary
export PATH="/usr/local/bin:$PATH"

# Make PATH change permanent
echo "Making PATH changes permanent..."
if ! grep -q 'export PATH="/usr/local/bin:$PATH"' ~/.bashrc; then
    echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bashrc
    echo "Added /usr/local/bin to PATH in ~/.bashrc"
fi

# Create convenience script for system FFmpeg if needed
if [ -f "/usr/bin/ffmpeg" ]; then
    echo "Creating 'ffmpeg-system' command for accessing original FFmpeg..."
    sudo ln -sf /usr/bin/ffmpeg /usr/local/bin/ffmpeg-system
fi
