
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

## OpenGL Variables
__GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1

## List Steam Games and IDs
function steamapps
{
    find $1 -maxdepth 1 -type f -name '*.acf' -exec awk -F '"' '/"appid|name/{ printf $4 "|" } END { print "" }' {} \; | column -t -s '|' | sort -k 2
}

## JRE Runtime Options
export JDK_JAVA_OPTIONS='-Dsun.java2d.opengl=true -Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
