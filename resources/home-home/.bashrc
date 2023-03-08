#
# home-home
#
[[ -r ~/.config/rocket-config/profile-home.sh ]] && . ~/.config/rocket-config/profile-home.sh

# Don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth
# Set the history length - See HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

## JRE Runtime Options
export JDK_JAVA_OPTIONS='-Dsun.java2d.opengl=true -Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'

## Use MangoHUD (Vulcan/OpenGL)
export MANGOHUD=1
export MANGOHUD_DLSYM=1
export ENABLE_VKBASALT=1

# re-source my shell profile
reprofile()
{
    source ~/.bash_profile
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
else
    echo ytdl: backend missing, consider installing yt-dlp or youtube-dl
fi

## List Steam Games and IDs
steamapps()
{
    find $1 -maxdepth 1 -type f -name '*.acf' -exec awk -F '"' '/"appid|name/{ printf $4 "|" } END { print "" }' {} \; | column -t -s '|' | sort -k 2
}
