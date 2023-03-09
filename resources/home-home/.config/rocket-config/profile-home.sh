
################################################################################
## XDG DIRECTORY STRUCTURE
################################################################################

# bash
export HISTFILE="$XDG_STATE_HOME"/bash/history
# gnupg
export GNUPGHOME="$XDG_CONFIG_HOME"/gnupg
# gtk
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc

check_xdg()
{
# bash
    [ -f ~/.bash_history ] && printf "%s\n" \
        'mkdir -p "$XDG_STATE_HOME"/bash && mv ~/.bash_history "$XDG_STATE_HOME"/bash/history'
# gnupg
    [ -d ~/.gnupg ] && printf "%s\n" \
        'mv ~/.gnupg "$XDG_CONFIG_HOME"/gnupg'
}

################################################################################
## ENVIRONMENT VARIABLES
################################################################################

# Libvirt
export LIBVIRT_DEFAULT_URI="qemu:///session"

# OpenGL variables
export __GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1

# Use the fcitx input method framework
if command -v fcitx $> /dev/null || command -v fcitx5 $> /dev/null
then
    export INPUT_METHOD=fcitx
    export GTK_IM_MODULE=fcitx
    export QT_IM_MODULE=fcitx
    export SDL_IM_MODULE=fcitx
    export XMODIFIERS=@im=fcitx
fi
