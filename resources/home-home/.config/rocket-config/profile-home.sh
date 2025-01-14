
################################################################################
## XDG DIRECTORY STRUCTURE
################################################################################

## DBUS session
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
export DBUS_SESSION_BUS_ADDRESS="${DBUS_SESSION_BUS_ADDRESS:-unix:path=$XDG_RUNTIME_DIR/bus}"

## XDG home directories
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_DATA_DIRS="$XDG_DATA_DIRS:/var/lib/flatpak/exports/share"

# bash
export HISTFILE="$XDG_STATE_HOME"/bash/history
# rust
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export CARGO_HOME="$XDG_DATA_HOME"/cargo
# python
export PYTHONSTARTUP="$HOME"/.pythonrc
# gnupg
export GNUPGHOME="$XDG_CONFIG_HOME"/gnupg
# gtk
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
# nvidia
export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv
# android
export ANDROID_HOME="$XDG_DATA_HOME"/android

check_xdg()
{
# bash
    [ -f "$HOME/.bash_history" ] && printf "%s\n" \
        "mkdir -p \"$XDG_STATE_HOME/bash\" && mv \"$HOME/.bash_history\" \"$XDG_STATE_HOME/bash/history\""
# gnupg
    [ -d "$HOME/.gnupg" ] && printf "%s\n" \
        "mv \"HOME/.gnupg\" \"$XDG_CONFIG_HOME/gnupg\""
}

################################################################################
## ENVIRONMENT
################################################################################

# libvirt
export LIBVIRT_DEFAULT_URI="qemu:///session"
# opengl
export __GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1
# vcpkg
export VCPKG_DISABLE_METRICS=1

## Use the fcitx input method framework
if command -v fcitx $> /dev/null || command -v fcitx5 $> /dev/null
then
    export INPUT_METHOD=fcitx
    export GTK_IM_MODULE=fcitx
    export QT_IM_MODULE=fcitx
    export SDL_IM_MODULE=fcitx
    export XMODIFIERS=@im=fcitx
fi

## Use MangoHUD (Vulcan/OpenGL)
export MANGOHUD=1
export MANGOHUD_DLSYM=1
export ENABLE_VKBASALT=1

################################################################################
## RUNTIME
################################################################################

## Python
if command -v python >/dev/null 2>&1
then
    alias py=python
    export PYTHONSTARTUP=~/.pythonrc
fi

## Python Virtual Environment
if command -v pip3 >/dev/null 2>&1
then
    if [ ! -r "$XDG_DATA_HOME/rocket-config/venv/bin/activate" ]
    then
        python3 -m venv --system-site-packages "$XDG_DATA_HOME/rocket-config/venv"
    fi

    . "$XDG_DATA_HOME/rocket-config/venv/bin/activate"
fi

## VSCodium
if command -v flatpak >/dev/null 2>&1 \
    && [ "$(flatpak list | grep com.vscodium.codium)" != "" ]
then
    alias vscodium='flatpak run com.vscodium.codium'
fi
if command -v vscodium >/dev/null 2>&1
then
    alias code=vscodium
fi

## JRE Runtime Options
export JDK_JAVA_OPTIONS='-Dsun.java2d.opengl=true -Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'

## Youtube Downloader
if command -v youtube-dl >/dev/null 2>&1; then
    alias ytdl=youtube-dl
fi
if command -v yt-dlp >/dev/null 2>&1; then
    alias ytdl=yt-dlp
fi

## List Steam Games and IDs
steamapps()
{
    find "$1" -maxdepth 1 -type f -name '*.acf' -exec awk -F '"' '/"appid|name/{ printf $4 "|" } END { print "" }' {} \; | column -t -s '|' | sort -k 2
}
