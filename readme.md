# FFmpeg Custom Audio Codecs Compilation

Compiles FFmpeg from source with audio codecs on Linux (Debian/Ubuntu, including Raspberry Pi) and macOS.

**Author** Mika Säppi
**Organization** Fremen

## Security Notice

Scripts download and compile from multiple sources (nasm.us with SHA-256 verification, GitHub repos) and require sudo. Review scripts before running and ensure you're on a trusted network.

## Pre-compiled binaries for x86-64 Linux

Find [here](https://github.com/MikaSappi/ffmpeg-for-audio/releases).

---

## Linux versions

Scripts in `Linux/`. Each prompts for a version before building.

### `install.sh` — Full shared build

Shared-library FFmpeg with all codecs, FFprobe, FFplay, manpages, and hardware acceleration.

**Great for:** Desktop use, development, general-purpose media processing.

### `install_static.sh` — Full static build

Statically linked binary with reduced codec set (see table). Includes FFprobe and manpages.

**Great for:** Portable deployments without external library dependencies.

### `install-headless.sh` — Headless shared build

Shared-library build with full codec set. Disables display, audio I/O, and docs (FFplay, SDL2, ALSA, PulseAudio, VAAPI, VDPAU, XCB, X11, DRM, libopenh264, manpages). FFprobe included.

**Great for:** Servers, containers, CI/CD pipelines.

### `install_static_bare.sh` — Minimal static build

Static binary with reduced codec set and the same disables as headless. Pre-compiled x86 binary available (~26 MB, Ubuntu 24.04).

**Great for:** Embedding in applications, microservices, minimal Docker images.

### Comparison (Linux)

| | `install.sh` | `install_static.sh` | `install-headless.sh` | `install_static_bare.sh` |
|---|:---:|:---:|:---:|:---:|
| **Linking** | Shared | Static | Shared | Static |
| **FFprobe** | Yes | Yes | Yes | Yes |
| **FFplay** | Yes | Yes | No | No |
| **Manpages** | Yes | Yes | No | No |
| **Display / HW accel** | Yes | Yes | No | No |
| **Audio I/O (ALSA, Pulse)** | Yes | Yes | No | No |
| **GnuTLS** | Yes | No | Yes | No |
| **libfdk-aac** | Yes | Yes | Yes | Yes |
| **libmp3lame** | Yes | Yes | Yes | Yes |
| **libopus** | Yes | Yes | Yes | Yes |
| **libsoxr** | Yes | Yes | Yes | Yes |
| **libvorbis** | Yes | No | Yes | No |
| **libspeex** | Yes | No | Yes | No |
| **libtwolame** | Yes | No | Yes | No |
| **libopencore-amr** | Yes | No | Yes | No |
| **libsrt** | If available | No | If available | No |

---

## macOS versions

Scripts in `macOS/`. Each prompts for a version before building. Requires [Homebrew](https://brew.sh).

### `install_macos.sh` — Full shared build

Shared-library FFmpeg with all codecs, FFprobe, FFplay, and manpages. Most codecs installed via Homebrew; libfdk-aac compiled from source (licensing).

**Great for:** Desktop use, development, general-purpose media processing on macOS.

### `install_macos_static.sh` — Static build

Statically linked binary with reduced codec set. All codec libraries compiled from source. Includes FFprobe and manpages.

**Great for:** Portable deployments, distributing to other Macs, embedding in macOS applications.

### Comparison (macOS)

| | `install_macos.sh` | `install_macos_static.sh` |
|---|:---:|:---:|
| **Linking** | Shared | Static |
| **FFprobe** | Yes | Yes |
| **FFplay** | Yes | Yes |
| **Manpages** | Yes | Yes |
| **libfdk-aac** | Yes | Yes |
| **libmp3lame** | Yes | Yes |
| **libopus** | Yes | Yes |
| **libsoxr** | Yes | Yes |
| **libvorbis** | Yes | No |
| **libspeex** | Yes | No |
| **libtwolame** | Yes | No |
| **libopencore-amr** | Yes | No |
| **libsrt** | If available | If available |

---

## Included Codecs

All builds include:

- **libfdk-aac** — AAC encoding
- **libmp3lame** — MP3 encoding
- **libopus** — Low-latency codec
- **libsoxr** — Audio resampling

Full (shared) builds also include:

- **libvorbis** — Ogg Vorbis
- **libspeex** — Speech codec
- **libtwolame** — MP2 encoding
- **libopencore-amr** — AMR-NB/WB
- **libsrt** — Secure Reliable Transport (if available)

---

## Installation

```bash
bash install.sh
```

**Time:** 5-30 minutes | **Space:** ~2GB

### Version selection

Each script prompts for a version. Press Enter for the latest stable release.

```
=== FFmpeg Version Selection ===
Latest stable version: n8.0

Available major versions:
  4 -> n4.4.5
  5 -> n5.1.7
  6 -> n6.1.3
  7 -> n7.1.2
  8 -> n8.0

Version: 7
Using latest version for major 7: n7.1.2
```

## System FFmpeg Handling

On Linux, if a system FFmpeg exists (e.g., Pi OS with Hailo TAPPAS):

- Backup created at `/usr/bin/ffmpeg.backup`
- Custom build installed to `/usr/local/bin/ffmpeg`
- `ffmpeg-system` command created for the original

On macOS, if Homebrew FFmpeg exists:

- `ffmpeg-brew` command created for the Homebrew version

## Verification

```bash
ffmpeg -version
ffmpeg -encoders | grep -E "(fdk|opus|vorbis|speex|twolame|amr)"
```

## Requirements

**Linux:** Debian/Ubuntu, ~2GB free, internet, sudo
**macOS:** Homebrew, ~2GB free, internet, sudo

## Removal

Linux:
```bash
sudo rm /usr/local/bin/ffmpeg
sudo mv /usr/bin/ffmpeg.backup /usr/bin/ffmpeg  # If backup exists
```

macOS:
```bash
sudo rm /usr/local/bin/ffmpeg
```

If a build fails, remove `~/ffmpeg_sources` (or `~/ffmpeg_sources_static`, `~/ffmpeg_sources_static_bare`) and retry.

---

## Troubleshooting

### Build errors

| Error | Fix |
|---|---|
| `Package 'openssl' not found` | `sudo apt-get install libssl-dev libcrypto++-dev` |
| `srt >= 1.3.0 not found` | Script continues without SRT. To force: `sudo apt-get install libsrt-openssl-dev` |
| `autoreconf: command not found` | `sudo apt-get install autoconf automake libtool` |
| `C compiler cannot create executables` | `sudo apt-get install build-essential` |
| `No space left on device` | Need ~2GB free. Run `sudo apt-get clean` |

### Runtime errors

| Problem | Fix |
|---|---|
| Custom FFmpeg not found | `export PATH="/usr/local/bin:$PATH"` and add to `~/.bashrc` |
| `libfdk_aac not found` | Check `which ffmpeg` shows `/usr/local/bin/ffmpeg`, not system version |
| `error while loading shared libraries` | Run `sudo ldconfig` |
| System unresponsive during build | Edit script: `CORES=$(($(nproc) / 2))` |

### Clean rebuild

```bash
rm -rf ~/ffmpeg_sources
sudo rm -f /usr/local/bin/ffmpeg
./install.sh
```

### Debug a failed build

```bash
cd ~/ffmpeg_sources/ffmpeg && tail -50 config.log
pkg-config --list-all | grep -E "(fdk|opus|srt)"
```
