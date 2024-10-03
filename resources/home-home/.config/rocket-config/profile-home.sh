
################################################################################
## XDG DIRECTORY STRUCTURE
################################################################################

# DBUS session
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
export DBUS_SESSION_BUS_ADDRESS="${DBUS_SESSION_BUS_ADDRESS:-unix:path=$XDG_RUNTIME_DIR/bus}"

# XDG home directories
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# bash
export HISTFILE="$XDG_STATE_HOME"/bash/history
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
## ENVIRONMENT VARIABLES
################################################################################

# Libvirt
export LIBVIRT_DEFAULT_URI="qemu:///session"

# OpenGL variables
export __GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1

# Disable vcpkg telemetry
export VCPKG_DISABLE_METRICS=1

# Use the fcitx input method framework
if command -v fcitx $> /dev/null || command -v fcitx5 $> /dev/null
then
    export INPUT_METHOD=fcitx
    export GTK_IM_MODULE=fcitx
    export QT_IM_MODULE=fcitx
    export SDL_IM_MODULE=fcitx
    export XMODIFIERS=@im=fcitx
fi
