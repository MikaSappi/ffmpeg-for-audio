#!/bin/bash

set -e

echo ""
echo "This script will compile FFmpeg with essential audio codecs"
echo ""
echo "You will be prompted for your password once in the process, after you've selected ffmpeg version."

# Check for Homebrew
if ! command -v brew &> /dev/null; then
	echo "Error: Homebrew is required but not installed."
	echo "Install it from: https://brew.sh"
	exit 1
fi

# Version selection
echo "=== FFmpeg Version Selection ==="
echo ""
echo "Fetching available FFmpeg versions..."
STABLE_VERSIONS=$(git ls-remote --tags https://git.ffmpeg.org/ffmpeg.git | \
	grep -o 'refs/tags/n[0-9].*' | \
	sed 's|refs/tags/||' | \
	grep -v '\^{}' | \
	grep -v -E "(dev|rc|alpha|beta)" | \
	sort -V)
LATEST_STABLE=$(echo "$STABLE_VERSIONS" | tail -1)

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
CORES=$(sysctl -n hw.ncpu)
echo "Detected $CORES CPU cores - using make -j$CORES"
echo "This process will take about two minutes on an M4 Pro"
echo ""

# Ask for sudo
echo "This script requires sudo privileges for installation."
echo "Please enter your password now to avoid interruptions during compilation:"
sudo -v

# Keep sudo alive in background
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Install dependencies via Homebrew
echo "Installing dependencies via Homebrew..."
brew install \
  autoconf \
  automake \
  cmake \
  git \
  libtool \
  pkg-config \
  nasm \
  yasm \
  lame \
  opus \
  libvorbis \
  speex \
  twolame \
  opencore-amr \
  libass \
  freetype \
  sdl2

echo "Dependencies installed successfully!"

# Try to install SRT from Homebrew
echo "Attempting to install SRT from Homebrew..."
if brew install srt 2>/dev/null; then
	echo "SRT installed from Homebrew!"
	SKIP_SRT_BUILD=true
else
	echo "SRT not available from Homebrew, will build from source"
	SKIP_SRT_BUILD=false
fi

# libfdk-aac
echo "Building libfdk-aac..."
cd ~/ffmpeg_sources
git -C fdk-aac pull 2> /dev/null || git clone --depth 1 https://github.com/mstorsjo/fdk-aac
cd fdk-aac
autoreconf -fiv
./configure --prefix="/usr/local" --enable-shared
make -j$CORES
sudo make install

echo "libfdk-aac installed successfully!"

# SRT (if not available from Homebrew)
if [ "$SKIP_SRT_BUILD" = false ]; then
	echo "Building SRT from source..."
	cd ~/ffmpeg_sources
	git -C srt pull 2> /dev/null || git clone --depth 1 https://github.com/Haivision/srt.git
	cd srt
	mkdir -p build && cd build
	cmake -DCMAKE_INSTALL_PREFIX="/usr/local" -DENABLE_SHARED=ON -DENABLE_STATIC=OFF ..
	make -j$CORES
	sudo make install
	echo "SRT built and installed successfully!"
else
	echo "Using SRT from Homebrew"
fi

# FFmpeg compilation
echo "Building FFmpeg with audio codecs..."
cd ~/ffmpeg_sources/ffmpeg

echo "Checking out FFmpeg version: $SELECTED_VERSION"
git checkout "$SELECTED_VERSION"

cd ~/ffmpeg_sources/ffmpeg
./configure \
  --prefix="/usr/local" \
  --extra-cflags="-I$(brew --prefix)/include -fPIC" \
  --extra-ldflags="-L$(brew --prefix)/lib" \
  --enable-shared \
  --enable-gpl \
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
  --enable-version3
make -j$CORES
sudo make install

# Update PATH to include the new FFmpeg binary
export PATH="/usr/local/bin:$PATH"

# Make PATH change permanent for both bash and zsh
echo "Making PATH changes permanent..."
for rc_file in ~/.bashrc ~/.zshrc; do
	if [ -f "$rc_file" ]; then
		if ! grep -q 'export PATH="/usr/local/bin:$PATH"' "$rc_file"; then
			echo 'export PATH="/usr/local/bin:$PATH"' >> "$rc_file"
			echo "Added /usr/local/bin to PATH in $rc_file"
		fi
	fi
done

# Create convenience script for Homebrew FFmpeg if it exists
if command -v /opt/homebrew/bin/ffmpeg &> /dev/null || command -v /usr/local/Cellar/ffmpeg &> /dev/null; then
	echo "Creating 'ffmpeg-brew' command for accessing Homebrew FFmpeg..."
	BREW_FFMPEG=$(brew --prefix ffmpeg 2>/dev/null)/bin/ffmpeg
	if [ -f "$BREW_FFMPEG" ]; then
		sudo ln -sf "$BREW_FFMPEG" /usr/local/bin/ffmpeg-brew
	fi
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
echo "Note: You may need to restart your terminal or run 'source ~/.zshrc' (or ~/.bashrc)"
echo "for PATH changes to take effect."
echo ""
echo "=== FFmpeg Version Information ==="
ffmpeg -version