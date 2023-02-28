
################################################################################
## ENVIRONMENT VARIABLES
################################################################################

## DBUS Session
export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-"/run/user/$UID"}
export DBUS_SESSION_BUS_ADDRESS=${DBUS_SESSION_BUS_ADDRESS:-"unix:path=$XDG_RUNTIME_DIR/bus"}

## Default editors
[ -x /usr/bin/nano  ] && export EDITOR=/usr/bin/nano
[ -x /usr/bin/gedit ] && export VISUAL=/usr/bin/gedit

# Add $HOME/.local/bin to the path
[ -r "$HOME/.local/bin/path.sh" ] && PATH="$(cat $HOME/.local/bin/path.sh):$PATH"
[ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH"

## Libvirt
export LIBVIRT_DEFAULT_URI="qemu:///user"

## Disable vcpkg telemetry
export VCPKG_DISABLE_METRICS=1

# Use the fcitx input method framework
if command -v fcitx $> /dev/null || command -v fcitx5 $> /dev/null
then
    export GTK_IM_MODULE=fcitx
    export QT_IM_MODULE=fcitx
    export SDL_IM_MODULE=fcitx
    export XMODIFIERS='@im=fcitx'
fi

## OpenGL Variables
export __GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1

################################################################################
## XDG DIRECTORY STRUCTURE
################################################################################

# XDG home directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# gnupg
export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"

# ICEauthority
export ICEAUTHORITY="$XDG_CACHE_HOME/ICEauthority"

# less
export LESSHISTFILE="$XDG_CONFIG_HOME/less/history"
export LESSKEY="$XDG_CONFIG_HOME/less/keys"

# mplayer
export MPLAYER_HOME="$XDG_CONFIG_HOME/mplayer"

################################################################################
## TERMINAL PROMPT
################################################################################

PS1_FMT0="\e[0m"
[ $EUID = 0 ] && PS1_FMT1="\e[0;1;31m"    || PS1_FMT1="\e[0;1;36m"
[ $EUID = 0 ] && PS1_FMT2="\e[0;1;3;31m"  || PS1_FMT2="\e[0;1;3;36m"
[ $EUID = 0 ] && PS1_FMT3="\e[0;1;33m"    || PS1_FMT3="\e[0;1;34m"
[ $EUID = 0 ] && PS1_ERR="\e[0;1;3;33m"   || PS1_ERR="\e[0;1;3;31m"

PS1_prompt_command()
{
    printf -v EXIT '%02x' $?    # 2-digit hex

    PS1="\[$PS1_FMT1\][\[$PS1_FMT2\]\u\[$PS1_FMT1\]@\H \[$PS1_FMT0\]\W\[$PS1_FMT1\]]"

    ## Append Git information
    if command -v git &>/dev/null && [ -n "$(git rev-parse --git-dir 2>/dev/null)" ]
    then
        local branch=$(git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
        PS1="$PS1 \[$PS1_FMT1\](\[$PS1_FMT3\]$branch\[$PS1_FMT1\])"
    fi

    ## Prepend return value (if nonzero)
    if [ $EXIT != "00" ]
    then
        PS1="\[$PS1_ERR\]$EXIT $PS1"
    fi

    export PS1="$PS1\[$PS1_FMT1\]\\$ \[\$(tput sgr0)\]"
}
export PROMPT_COMMAND=PS1_prompt_command

################################################################################
## ALIASES & FUNCTIONS
################################################################################

## Quit the terminal
alias q="exit"

## Confirm before overwriting something
alias cp="cp --interactive --recursive"
alias mv="mv --interactive"
alias rm="rm"

## Listing commands
alias ls="ls --color=auto --group-directories-first --indicator-style=slash"
alias l="ls -lh"
alias ll="ls -lAh"
alias la="ls -lah"
ldot() {( cd $1 && ls --group-directories-first -lAhd .* )}

## Make parent directories with `mkdir`
alias mkdir="mkdir -p"

## Make a directory and cd into it
mkcd()
{
    mkdir $1 && cd $1
}

## Drop into a temp environment
mktmp()
{(
    TMPDIR=$(mktemp -d)
    cd $TMPDIR
    $SHELL
    rm -drf $TMPDIR
)}

## Automatically logout of a docker session
dockerhub()
{(
    docker login
    $SHELL
    docker logout
)}

## Grep
alias grep="grep --color=auto"

## Suppress and count 'Permission denied' errors when using 'find'
## Don't search in ".snapshots" directories
find()
{
    TMPFILE=$(mktemp)
    if [ $? -ne 0 ]; then
        echo "'\e[31m'Failed to allocate tempfile for error suppression"
        exit -1
    fi

    /usr/bin/find "$@" -not -path "*.snapshots*" 2> $TMPFILE

    COUNT=$(cat $TMPFILE | grep "Permission denied" | wc -l)
    if [ $COUNT -ne 0 ]; then
        echo -e '\e[31m'Suppressed $(cat $TMPFILE | grep "Permission denied" | wc -l) permission errors >&2
    fi
    rm $TMPFILE
}

## Use 'less' inplaceof 'more'
alias more=less

## Capture the output of a command
cap() { tee /tmp/capture-$UID.out; }
ret() { touch /tmp/capture-$UID.out; cat /tmp/capture-$UID.out; }
rmcap() { rm /tmp/capture-$UID.out; }

## Change default `lsblk` columns
lsblk()
{
    if echo "$*" | grep -Eq "(\s|^)-";
    then
        "$(which lsblk)" $@
    else
        "$(which lsblk)" $@ -o NAME,RM,RO,SIZE,FSUSE%,FSTYPE,PTTYPE,TYPE,OWNER,GROUP,MODE,FSROOTS,MOUNTPOINTS
    fi
}

## Extract an archive
extract()
{
    if [ -f $1 ]; then
        case $1 in
            *.tar)              tar xf $@       ;;
            *.tar.bz2|*.tbz2)   tar xjf $@      ;;
            *.tar.gz|*.tgz)     tar xzf $@      ;;
            *.tar.xz|*.txz)     tar xf $@       ;;

            *.bz2)              bunzip2 $@      ;;
            *.gz)               gunzip $@       ;;
            *.xz)               unxz $@         ;;

            *.rar)              unrar x $@      ;;
            *.Z)                uncompress $@   ;;
            *.zip)              unzip $@        ;;
            *.jar)              unzip $@        ;;
            *.7z)               7z x $@         ;;
            *.deb)              ar x $@         ;;

            *)  echo "'$1' has an unknown file extension";;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}
alias ex=extract

## Show total progress in rsync
alias rsync="rsync --info=progress2"

## Random password
rnpw()
{
    strings /dev/urandom | grep -o '[[:alnum:]]' | head -n ${1:-32} | tr -d '\n' ; echo
}

## Print my public IP address
ippub()
{
    echo $(curl ifconfig.me 2> /dev/null)
}

## Stamp the time and date
stamp()
{
    echo $(date +"%y%m%d-%H%M%S")
}

## Print colours
colours()
{
    for j in {4,10};
    do
        for c in ${j}{0..7};
        do
            echo -ne "\e[${c}m   \e[m"
        done
        echo
    done
}
