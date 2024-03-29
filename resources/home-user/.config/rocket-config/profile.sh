
################################################################################
## TERMINAL PROMPT
################################################################################

# Enter a subshell, keeping track of the shell depth
subshell()
{(
    export PS1_shell_depth=$(($PS1_shell_depth+1))
    $SHELL
)}

PS1_prompt_command()
{
    printf -v EXIT '%02x' $?    # 2-digit hex exit code

    PS1_FMT0="\e[0m"
    [ $(id -u) = 0 ] && PS1_FMT1="\e[0;1;31m"   || PS1_FMT1="\e[0;1;36m"
    [ $(id -u) = 0 ] && PS1_FMT2="\e[0;1;3;31m" || PS1_FMT2="\e[0;1;3;36m"
    [ $(id -u) = 0 ] && PS1_FMT3="\e[0;1;33m"   || PS1_FMT3="\e[0;1;34m"
    [ $(id -u) = 0 ] && PS1_FMTE="\e[0;1;3;33m" || PS1_FMTE="\e[0;1;3;31m"

    PS1="\[$PS1_FMT1\][\[$PS1_FMT2\]\u\[$PS1_FMT1\]@\H \[$PS1_FMT0\]\W\[$PS1_FMT1\]]"

    # Prepend the shell depth
    PS1="\[$PS1_FMT3\]$PS1_shell_depth\[$PS1_FMT1\]$PS1"

    # Append Git information
    if command -v git &>/dev/null && [ -n "$(git rev-parse --git-dir 2>/dev/null)" ]
    then
        local branch=$(git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
        PS1="$PS1 \[$PS1_FMT1\](\[$PS1_FMT3\]$branch\[$PS1_FMT1\])"
    fi

    # Prepend return value (if nonzero)
    if [ "$EXIT" != "00" ]
    then
        PS1="\[$PS1_FMTE\]$EXIT $PS1"
    fi

    export PS1="$PS1\[$PS1_FMT1\]\\$ \[\$(tput sgr0)\]"
}
export PROMPT_COMMAND=PS1_prompt_command

################################################################################
## XDG DIRECTORY STRUCTURE
################################################################################

# DBUS session
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$UID}"
export DBUS_SESSION_BUS_ADDRESS="${DBUS_SESSION_BUS_ADDRESS:-unix:path=$XDG_RUNTIME_DIR/bus}"

# XDG home directories
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

################################################################################
## ENVIRONMENT VARIABLES
################################################################################

# Default editors
[ -z "$EDITOR" ] && [ -x "/usr/bin/nano"  ] && export EDITOR="/usr/bin/nano"
[ -z "$VISUAL" ] && [ -x "/usr/bin/gedit" ] && export VISUAL="/usr/bin/gedit"

# Add ~/.local/bin to the path
[ -r ~/.local/bin/path.sh ] && PATH="$(cat ~/.local/bin/path.sh):$PATH"
[ -d ~/.local/bin ] && PATH="~/.local/bin:$PATH"

# Disable vcpkg telemetry
export VCPKG_DISABLE_METRICS=1

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
alias l="ls -lh --time-style=long-iso"
alias ll="ls -lAh --time-style=long-iso"
alias la="ls -lah --time-style=long-iso"
ldot() {( cd $1 && ls --group-directories-first -lAhd --time-style=long-iso .* )}

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
    subshell
    rm -drf $TMPDIR
)}

## Follow a chain of symlinks
follow()
{
    local target="$1"
    local linked="$target"

    while [ -L "$linked" ];
    do
        target=$(readlink "$linked")
        linked="$target"
    done

    echo "$target"
}

## Automatically logout of a docker session
dockerhub()
{(
    docker login
    subshell
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
cap() { tee "/tmp/capture-$UID-${$1:-0}.out"; }
ret() { touch "/tmp/capture-$UID-${$1:-0}.out"; cat "/tmp/capture-$UID-${$1:-0}.out"; }
rmcap() { rm "/tmp/capture-$UID-${$1:-0}.out"; }

## List information about block devices
lsblk()
{
    if echo "$*" | grep -Eq "(\s|^)-"; # only change the default columns
    then
        "$(which lsblk)" $@
    else
        "$(which lsblk)" $@ -o NAME,RM,RO,LABEL,UUID,FSTYPE,FSSIZE,FSUSE%
    fi
}

## List information about mounted block devices
lsmnt()
{
    lsblk $@ -o NAME,LABEL,FSSIZE,FSUSE%,FSUSED,FSAVAIL,FSROOTS,MOUNTPOINTS
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
