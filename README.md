# YouTube to MP3 Downloader

## Features

- **Zero Configuration** - Automatically downloads and installs dependencies (yt-dlp & ffmpeg)
- **Beautiful CLI** - Clean, modern interface with minimal output
- **Continuous Mode** - Download multiple songs without restarting
- **Playlist Support** - Download entire playlists or single videos
- **Silent Operation** - No cluttered logs, only essential feedback
- **High Quality** - Downloads audio at highest quality available
- **Organized** - All MP3 files saved to dedicated folder

## Requirements

- Windows 10/11
- PowerShell 5.1 or later
- Internet connection

## Quick Start

1. Download the script:
   ```powershell
   # Clone or download yt.ps1 to any folder
   ```

2. Open terminal and run the script:
   ```powershell
   .\yt.ps1
   ```

3. Paste YouTube URLs when prompted
4. Type `exit` to quit

That's it! Dependencies are installed automatically on first run.

## Usage

### Basic Usage

```powershell
.\yt.ps1
```

The script will:
1. Show a welcome banner
2. Auto-install yt-dlp and ffmpeg (first run only)
3. Prompt for YouTube URLs
4. Download and convert to MP3
5. Save files to `mp3/` folder

### Commands

- **Paste any YouTube video URL** - Downloads single video as MP3
- **Paste any YouTube playlist URL** - Downloads entire playlist as MP3 files
- **`exit`** / **`quit`** / **`q`** - Exit the program

## File Structure

```
your-folder/
├── yt.ps1          # Main script
├── bin/            # Auto-created, contains yt-dlp.exe & ffmpeg.exe
└── mp3/            # Auto-created, your downloaded MP3 files
```

## How It Works

1. **Dependencies Check** - On first run, downloads:
   - [yt-dlp](https://github.com/yt-dlp/yt-dlp) - YouTube downloader
   - [ffmpeg](https://ffmpeg.org/) - Audio converter

2. **Download** - Fetches highest quality audio from YouTube

3. **Convert** - Converts to MP3 format using ffmpeg

4. **Save** - Stores in `mp3/` folder with original video title

## Advanced

### MP3 Quality

The script downloads audio at highest quality (`--audio-quality 0`). To change quality, edit line ~112:

```powershell
--audio-quality 0  # 0 = best, 9 = worst
```

### Output Location

To change output folder, edit line 11:

```powershell
$mp3Dir = "$baseDir\mp3"  # Change "mp3" to your preferred folder
```

### Playlists

Paste any YouTube playlist URL and the script will automatically download all videos as MP3 files. Works with:
- Public playlists
- Your own playlists (if public)
- Mix playlists
- Channel playlists

Example playlist URLs:
```
https://www.youtube.com/playlist?list=PLxxxxxxxxxxxxxxxxxx
https://www.youtube.com/watch?v=xxxxx&list=PLxxxxxxxxxxxxxxxxxx
```

## Credits

- [yt-dlp](https://github.com/yt-dlp/yt-dlp) - Video/audio downloader
- [ffmpeg](https://ffmpeg.org/) - Media processing

---

**Enjoy your music!**
# ytb_mp3_downloader_script
