
################################################################################
## ENVIRONMENT VARIABLES
################################################################################

## DBUS Session
export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-"/run/user/$UID"}
export DBUS_SESSION_BUS_ADDRESS=${DBUS_SESSION_BUS_ADDRESS:-"unix:path=$XDG_RUNTIME_DIR/bus"}

## Default editors
export EDITOR=/usr/bin/nano
export VISUAL=/usr/bin/gedit

## Disable vcpkg telemetry
export VCPKG_DISABLE_METRICS=1

# Add $HOME/.local/bin to the path
[ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH"

# Use the fcitx input method framework
if command -v fcitx $> /dev/null
then
    export SDL_IM_MODULE=fcitx
    export GTK_IM_MODULE=fcitx
    export QT_IM_MODULE=fcitx
    export XMODIFIERS='@im=fcitx'
fi


################################################################################
## TERMINAL PROMPT
################################################################################

PS1_FMT0="\e[0m"
[ ${EUID} = 0 ] && PS1_FMT1="\e[0;1;31m"   || PS1_FMT1="\e[0;1;36m"
[ ${EUID} = 0 ] && PS1_FMT2="\e[0;1;3;31m" || PS1_FMT2="\e[0;1;3;36m"
[ ${EUID} = 0 ] && PS1_FMT3="\e[0;1;33m"   || PS1_FMT3="\e[0;1;34m"

function PS1_git_info
{
    if command -v git &>/dev/null && [ -n "$(git rev-parse --git-dir 2>/dev/null)" ]
    then
        local _BRANCH="$(git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')"
        echo -en " ${PS1_FMT1}(${PS1_FMT3}${_BRANCH}${PS1_FMT1})"
    fi
}

PS1="\[${PS1_FMT1}\][\[${PS1_FMT2}\]\u\[${PS1_FMT1}\]@\H \[${PS1_FMT0}\]\W\[${PS1_FMT1}\]]\$(PS1_git_info)\\$ \[$(tput sgr0)\]"


################################################################################
## XDG DIRECTORY STRUCTURE
################################################################################

# XDG home directories
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

# gnupg
export GNUPGHOME=$XDG_CONFIG_HOME/gnupg

# ICEauthority
export ICEAUTHORITY=$XDG_CACHE_HOME/ICEauthority

# less
export LESSHISTFILE="${XDG_CONFIG_HOME}/less/history"
export LESSKEY="${XDG_CONFIG_HOME}/less/keys"

# mplayer
export MPLAYER_HOME=$XDG_CONFIG_HOME/mplayer


################################################################################
## ALIASES & FUNCTIONS
################################################################################

## Quit the terminal
alias q="exit"

## Confirm before overwriting something
alias cp="cp -i"
alias mv="mv -i"
# alias rm="rm -i"

## Make parent directories with `mkdir`
alias mkdir="mkdir -p"

## Show total progress in rsync
alias rsync="rsync --info=progress2"

## Show total progress with dd
#alias dd="dd status=progress"

## Use 'less' in place of 'more'
alias more=less

## Listing commands
alias ls="ls --color --group-directories-first --indicator-style=slash"
alias l="ls -lh"
alias ll="ls -lAh"
alias la="ls -lah"
function ldot {( cd $1 && ls --group-directories-first -lAhd .* )}

## Capture the output of a command
function cap { tee /tmp/capture-$UID.out; }
function ret { touch /tmp/capture-$UID.out; cat /tmp/capture-$UID.out; }
function clearcap { rm /tmp/capture-$UID.out; }

## Make a directory and cd into it
function mkcd
{
    mkdir $1 && cd $1
}

## Change default `lsblk` columns
function lsblk
{
    if echo "$*" | grep -Eq "(\s|^)-";
    then
        "$(which lsblk)" $@
    else
        "$(which lsblk)" $@ -o NAME,RM,RO,SIZE,FSUSE%,FSTYPE,PTTYPE,TYPE,OWNER,GROUP,MODE,FSROOTS,MOUNTPOINTS
    fi
}

## Suppress and count 'Permission denied' errors when using 'find'
## Don't search in ".snapshots" directories
function find
{
    TMPFILE=$(mktemp)
    if [ $? -ne 0 ]; then
        echo "'\e[31m'Failed to allocate tempfile for error suppression"
        exit -1
    fi

    /usr/bin/find "$@" -not -path "*.snapshots*" 2> $TMPFILE

    COUNT=$(cat $TMPFILE | grep "Permission denied" | wc -l)
    if [ $COUNT -ne 0 ]; then
        echo -e '\e[31m'Suppressed $(cat $TMPFILE | grep "Permission denied" | wc -l) permission errors
    fi
    rm $TMPFILE
}

## Extract an archive
function extract
{
    if [ -f $1 ]; then
        case $1 in
            *.tar.bz2)  tar xjf $@      ;;
            *.tar.gz)   tar xzf $@      ;;
            *.bz2)      bunzip2 $@      ;;
            *.gz)       gunzip $@       ;;
            *.rar)      unrar x $@      ;;
            *.tar)      tar xf $@       ;;
            *.tbz2)     tar xjf $@      ;;
            *.tgz)      tar xzf $@      ;;
            *.xz)       unxz $@         ;;
            *.Z)        uncompress $@   ;;
            *.zip)      unzip $@        ;;
            *.7z)       7z x $@         ;;
            *)      echo "'$1' has an unknown file extension";;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}
alias ex=extract

## Print colours
function colours
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

## Print my public IP address
function ippub
{
    echo $(curl ifconfig.me 2> /dev/null)
}
