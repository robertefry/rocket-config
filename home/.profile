
## Source rocket
ROCKET_CONFIG=~/.config/rocket-config
[ -r ${ROCKET_CONFIG}/profile.sh ] && . ${ROCKET_CONFIG}/profile.sh
[ -r ${ROCKET_CONFIG}/fftools.sh ] && . ${ROCKET_CONFIG}/fftools.sh

## JRE Runtime Options
export JDK_JAVA_OPTIONS='-Dsun.java2d.opengl=true -Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'

## Use MangoHUD (Vulcan/OpenGL)
export MANGOHUD=1
export MANGOHUD_DLSYM=1
export ENABLE_VKBASALT=1

# re-source my shell profile
function reprofile
{
    source ~/.profile
}

## Python
if command -v python &> /dev/null
then
    alias py=python
    export PYTHONSTARTUP=~/.pythonrc
fi

## VSCodium
if command -v flatpak &> /dev/null \
    && [ "$(flatpak list | grep com.vscodium.codium)" != "" ]
then
    alias vscodium='flatpak run com.vscodium.codium'
fi
if command -v vscodium &> /dev/null
then
    alias code=vscodium
fi

## Youtube Downloader
if command -v yt-dlp &> /dev/null; then
    alias ytdl=yt-dlp
elif command -v youtube-dl &> /dev/null; then
    alias ytdl=youtube-dl
fi

## List Steam Games and IDs
steamapps()
{
    find $1 -maxdepth 1 -type f -name '*.acf' -exec awk -F '"' '/"appid|name/{ printf $4 "|" } END { print "" }' {} \; | column -t -s '|' | sort -k 2
}
