
################################################################################
## ENVIRONMENT VARIABLES
################################################################################

## Default editors
export EDITOR=/usr/bin/nano
export VISUAL=/usr/bin/gedit

## Disable vcpkg telemetry
export VCPKG_DISABLE_METRICS=1

# Add $HOME/.local/bin to the path
[ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH"


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

## Confirm before overwriting something
alias cp="cp -i"
alias mv="mv -i"

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
function ldot ( cd $1 && ls --group-directories-first -lAhd .* )

## Make a directory and cd into it
function mkcd
{
    mkdir $1 && cd $1
}

## Change default `lsblk` columns
function lsblk
{
    if [ $# -ne 0 ]; then
        "$(which lsblk)" $@
    else
        "$(which lsblk)" -o NAME,RM,RO,SIZE,FSUSE%,FSTYPE,PTTYPE,TYPE,OWNER,GROUP,MODE,FSROOTS,MOUNTPOINTS
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
            *.tar.bz2)  tar xjf $1      ;;
            *.tar.gz)   tar xzf $1      ;;
            *.bz2)      bunzip2 $1      ;;
            *.rar)      unrar x $1      ;;
            *.gz)       gunzip $1       ;;
            *.tar)      tar xf $1       ;;
            *.tbz2)     tar xjf $1      ;;
            *.tgz)      tar xzf $1      ;;
            *.zip)      unzip $1        ;;
            *.Z)        uncompress $1   ;;
            *.7z)       7z x $1         ;;
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
