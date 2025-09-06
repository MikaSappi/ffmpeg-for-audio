# FFmpeg Custom Audio Codecs Compilation

Builds FFmpeg from source with essential audio codecs on Debian/Ubuntu systems, including Raspberry Pi. This was built to make our life easier, and I hope it works for you as well.

**Author** Mika Säppi
**Organization** Collins Group

## Security Notice

This script downloads and compiles software from multiple sources:

- Uses NASM from nasm.us with SHA-256 verification
- Clones source code from GitHub repositories
- Requires sudo privileges for system installation

**Before running:**

- Review the script contents
- Ensure you're on a trusted network
- Verify you trust the source repositories

While this script follows standard build practices and includes security measures,
compiling from source inherently carries more risk than using package managers.

## Included Codecs

- **libfdk-aac** - High-quality AAC encoding
- **libmp3lame** - MP3 encoding
- **libopus** - Modern low-latency codec
- **libvorbis** - Ogg Vorbis
- **libspeex** - Speech codec
- **libtwolame** - MP2 encoding
- **libopencore-amr** - AMR-NB/WB for mobile
- **libsrt** - Secure Reliable Transport (conditional)

## Installation

```bash
bash install.sh
```

**Time:** 15-30 minutes depending on system
**Space:** ~2GB in `~/ffmpeg_sources`

## System FFmpeg Handling

The script detects existing FFmpeg installations (common on Pi OS due to Hailo TAPPAS dependencies) and:

- Creates backup at `/usr/bin/ffmpeg.backup`
- Installs custom build to `/usr/local/bin/ffmpeg`
- Updates PATH to prioritize custom build
- Creates `ffmpeg-system` command for accessing original

## Usage

After installation:

```bash
ffmpeg -version                    # Custom build with audio codecs
ffmpeg-system -version             # Original system build (if existed)
```

## Verification

Check available encoders:

```bash
ffmpeg -encoders | grep -E "(fdk|opus|vorbis|speex|twolame|amr)"
```

## Requirements

- Debian/Ubuntu based system
- ~2GB free space
- Internet connection
- sudo privileges

## Troubleshooting

**Missing codec after build:**

```bash
which ffmpeg                       # Should show /usr/local/bin/ffmpeg
export PATH="/usr/local/bin:$PATH" # If not in PATH
```

**SRT support unavailable:**
Normal on some ARM systems. Script continues without SRT if build fails.

**System dependencies:**
The script preserves system FFmpeg to maintain compatibility with installed packages.

## Files Created

- `~/ffmpeg_sources/` - Source code and builds
- `/usr/local/bin/ffmpeg` - Custom FFmpeg binary
- `/usr/local/lib/libfdk-aac*` - FDK-AAC libraries
- `/usr/local/bin/ffmpeg-system` - Link to original (if existed)

## Removal

To revert to system FFmpeg:

```bash
sudo rm /usr/local/bin/ffmpeg
sudo mv /usr/bin/ffmpeg.backup /usr/bin/ffmpeg  # If backup exists
```

## Should it fail

If the installation fails for some reason, please remove `~/ffmpeg_sources` before trying again.

# FFmpeg Compilation Troubleshooting

## Build Failures

### "Package 'openssl', required by 'virtual:world', not found"

**Cause:** Missing OpenSSL development libraries
**Fix:**

```bash
sudo apt-get install libssl-dev libcrypto++-dev
```

### "srt >= 1.3.0 not found using pkg-config"

**Cause:** SRT library unavailable on ARM/older systems
**Fix:** Script continues without SRT. To force SRT:

```bash
sudo apt-get install libsrt-openssl-dev || sudo apt-get install libsrt-gnutls-dev
```

### "autoreconf: command not found"

**Cause:** Missing autotools
**Fix:**

```bash
sudo apt-get install autoconf automake libtool
```

### "configure: error: C compiler cannot create executables"

**Cause:** Missing build essentials
**Fix:**

```bash
sudo apt-get install build-essential gcc g++
```

### "make: command not found"

**Cause:** Missing make utility
**Fix:**

```bash
sudo apt-get install make
```

## Runtime Issues

### Custom FFmpeg not found after build

**Cause:** PATH not updated
**Fix:**

```bash
export PATH="/usr/local/bin:$PATH"
echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### "libfdk_aac not found" after successful build

**Cause:** Using system FFmpeg instead of custom build
**Check:**

```bash
which ffmpeg                    # Should show /usr/local/bin/ffmpeg
ffmpeg -version | grep fdk      # Should show libfdk-aac in config
```

**Fix:**

```bash
/usr/local/bin/ffmpeg -version  # Use full path
```

### "error while loading shared libraries"

**Cause:** Library paths not updated
**Fix:**

```bash
sudo ldconfig
export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
```

## Space and Performance Issues

### "No space left on device"

**Cause:** Insufficient disk space (needs ~2GB)
**Fix:**

```bash
df -h                          # Check available space
sudo apt-get clean             # Clear package cache
rm -rf ~/ffmpeg_sources        # Remove if partial build
```

### Extremely slow compilation

**Cause:** Using single core compilation
**Fix:** Script automatically uses all cores. To manually adjust:

```bash
make -j$(nproc)               # Use all cores
make -j2                      # Use 2 cores
```

### System becomes unresponsive during build

**Cause:** Too many parallel jobs on low-RAM systems
**Fix:** Edit script, reduce cores:

```bash
CORES=$(($(nproc) / 2))       # Use half available cores
```

## Network and Download Issues

### "wget: unable to resolve host address"

**Cause:** DNS/network issues
**Fix:**

```bash
ping google.com               # Test connectivity
sudo systemctl restart systemd-resolved
```

### Git clone failures

**Cause:** Network timeouts or repository issues
**Fix:**

```bash
git config --global http.postBuffer 1048576000
git config --global http.maxRequestBuffer 100M
```

## Permission Issues

### "Permission denied" during installation

**Cause:** Insufficient privileges for system directories
**Fix:**

```bash
sudo make install             # Use sudo for installation steps
sudo ldconfig                # Update library cache
```

### Cannot write to /usr/local

**Cause:** Directory permissions
**Fix:**

```bash
sudo chown -R $(whoami) /usr/local/src
# Or use sudo for the entire script
```

## Recovery Commands

### Clean rebuild

```bash
rm -rf ~/ffmpeg_sources
sudo rm -f /usr/local/bin/ffmpeg
sudo rm -f /usr/local/lib/libfdk-aac*
./install.sh
```

### Revert to system FFmpeg

```bash
sudo mv /usr/bin/ffmpeg.backup /usr/bin/ffmpeg
sudo rm /usr/local/bin/ffmpeg
# Remove custom PATH from ~/.bashrc
```

### Check what went wrong

```bash
# Check last build logs
cd ~/ffmpeg_sources/ffmpeg
tail -50 config.log

# Check library installation
pkg-config --list-all | grep -E "(fdk|opus|srt)"
ls -la /usr/local/lib/lib*
```
