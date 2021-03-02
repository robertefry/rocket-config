
################################################################################
## ENVIRONMENT VARIABLES
################################################################################

## Default editors
export EDITOR=/usr/bin/nano
export VISUAL=/usr/bin/gedit

## Use MangoHUD (Vulcan Only)
export MANGOHUD=1


################################################################################
## ALIASES & FUNCTIONS
################################################################################

## Confirm before overwriting something
alias cp="cp -i"

## Show total progress in rsync
alias rsync="rsync --info=progress2"

## Use 'less' in place of 'more'
alias more=less

## Use 'vscodium' inplaceof 'code' if available
command -v vscodium &> /dev/null && alias code=vscodium

## Listing commands
alias ls="ls --color --group-directories-first --indicator-style=slash"
alias l="ls -lh"
alias ll="ls -lAh"
alias la="ls -lah"
function ldot() {( cd $1 && ls --group-directories-first -lAhd .* )}

## Make a directory and cd into it
function mkcd()
{
    mkdir $1 && cd $1
}

## Suppress and count 'Permission denied' errors when using 'find'
## Don't search in ".snapshots" directories
function find()
{
    TMPFILE=$(mktemp)
    if [[ $? -ne 0 ]]; then
        echo "'\e[31m'Failed to allocate tempfile for error suppression"
        exit -1
    fi

    /usr/bin/find -not -path "*.snapshots*" "$@" 2> $TMPFILE

    COUNT=$(cat $TMPFILE | grep "Permission denied" | wc -l)
    if [[ $COUNT -ne 0 ]]; then
        echo -e '\e[31m'Suppressed $(cat $TMPFILE | grep "Permission denied" | wc -l) permission errors
    fi
    rm $TMPFILE
}

## Extract an archive
function extract()
{
    if [[ -f $1 ]]; then
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
function colours()
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

