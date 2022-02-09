
## Source the system profile
[ -f /etc/profile ] && . /etc/profile

## Use MangoHUD (Vulcan/OpenGL)
export MANGOHUD=1
export MANGOHUD_DLSYM=1
export ENABLE_VKBASALT=1

## VSCodium
if command -v vscodium &> /dev/null
then
    alias code=vscodium
    export VISUAL=$(which vscodium)
fi

## Youtube Downloader
if command -v yt-dlp &> /dev/null; then
    alias ytdl=yt-dlp
elif command -v youtube-dl &> /dev/null; then
    alias ytdl=youtube-dl
fi
