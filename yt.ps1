# ═══════════════════════════════════════════════════════════════════
#  YouTube to MP3 Downloader
#  Auto-install dependencies | Beautiful CLI | Silent operation
# ═══════════════════════════════════════════════════════════════════

$ErrorActionPreference = "SilentlyContinue"
Clear-Host

$baseDir = $PSScriptRoot
$binDir = "$baseDir\bin"
$mp3Dir = "$baseDir\mp3"
$ytDlp = "$binDir\yt-dlp.exe"
$ffmpeg = "$binDir\ffmpeg.exe"

function Show-Banner {
    Write-Host ""
    Write-Host "  ╔════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "  ║                                            ║" -ForegroundColor Cyan
    Write-Host "  ║  " -NoNewline -ForegroundColor Cyan
    Write-Host "       YouTube to MP3 Downloader        " -NoNewline -ForegroundColor Yellow
    Write-Host "  ║" -ForegroundColor Cyan
    Write-Host "  ║                                            ║" -ForegroundColor Cyan
    Write-Host "  ╚════════════════════════════════════════════╝" -ForegroundColor Cyan
}

function Show-Status($message, $type = "info") {
    $icon = switch ($type) {
        "info"     { "ℹ" }
        "success"  { "✓" }
        "download" { "⬇" }
        "process"  { "⚙" }
    }
    $color = switch ($type) {
        "info"     { "Cyan" }
        "success"  { "Green" }
        "download" { "Yellow" }
        "process"  { "Magenta" }
    }
    Write-Host "  $icon " -NoNewline -ForegroundColor $color
    Write-Host $message -ForegroundColor White
}

function Show-Divider {
    Write-Host "  ──────────────────────────────────────────────" -ForegroundColor DarkGray
}

Show-Banner
New-Item -ItemType Directory -Force -Path $binDir, $mp3Dir | Out-Null

if (-not (Test-Path $ytDlp)) {
    Show-Status "Installing yt-dlp..." "download"
    Invoke-WebRequest -Uri "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe" `
        -OutFile $ytDlp -UseBasicParsing -ErrorAction Stop | Out-Null
    Show-Status "yt-dlp installed successfully" "success"
} else {
    Show-Status "yt-dlp ready" "success"
}

if (-not (Test-Path $ffmpeg)) {
    Show-Status "Installing ffmpeg..." "download"
    $zip = "$binDir\ffmpeg.zip"
    Invoke-WebRequest -Uri "https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip" `
        -OutFile $zip -UseBasicParsing -ErrorAction Stop | Out-Null
    Expand-Archive $zip -DestinationPath $binDir -Force | Out-Null
    Remove-Item $zip -Force
    $ffmpegExe = Get-ChildItem $binDir -Recurse -Filter ffmpeg.exe | Select-Object -First 1
    Copy-Item $ffmpegExe.FullName $ffmpeg -Force
    Get-ChildItem $binDir -Directory | Remove-Item -Recurse -Force
    Show-Status "ffmpeg installed successfully" "success"
} else {
    Show-Status "ffmpeg ready" "success"
}

Show-Divider
Write-Host "  " -NoNewline
Write-Host "Type 'exit' to quit" -ForegroundColor DarkGray

$downloadCount = 0
while ($true) {
    Write-Host "  " -NoNewline
    $url = Read-Host "Paste YouTube URL"
    
    if ($url -match '^(exit|quit|q)$') {
        Clear-Host
        Show-Banner
        Show-Status "Thanks for using! Downloaded $downloadCount file(s)" "success"
        Start-Sleep -Seconds 2
        exit
    }
    
    if ([string]::IsNullOrWhiteSpace($url)) {
        continue
    }

    Show-Divider
    
    $isPlaylist = $url -match '([?&]list=|/playlist\?)'
    if ($isPlaylist) {
        Show-Status "Detected playlist! Downloading all videos..." "process"
    } else {
        Show-Status "Starting download..." "process"
    }
    
    $downloadSuccess = $false
    
    try {
        $result = & $ytDlp `
            -x `
            --audio-format mp3 `
            --audio-quality 0 `
            --yes-playlist `
            --no-warnings `
            --no-progress `
            --quiet `
            --ffmpeg-location $binDir `
            -o "$mp3Dir\%(title)s.%(ext)s" `
            $url 2>&1
        
        $downloadSuccess = $LASTEXITCODE -eq 0
    }
    catch {
        $downloadSuccess = $false
    }
    
    Clear-Host
    Show-Banner
    Show-Divider
    Write-Host "  " -NoNewline
    Write-Host "Type 'exit' to quit" -ForegroundColor DarkGray
    Show-Divider
    
    if ($downloadSuccess) {
        $downloadCount++
        Show-Status "Download complete! [$downloadCount total]" "success"
        Show-Status "Saved to: $mp3Dir" "info"
    }
    
    Show-Divider
}
