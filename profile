
################################################################################
## ENVIRONMENT VARIABLES
################################################################################

## Default editors
export EDITOR=/usr/bin/nano
export VISUAL=/usr/bin/gedit


################################################################################
## ALIASES & FUNCTIONS
################################################################################

## Confirm before overwriting something
alias cp="cp -i"

## Use 'less' in place of 'more'
alias more=less

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

## Suppress 'Permission denied' errors when using 'find'
function find()
{
    /usr/bin/find "$@" 2>&1 | grep -v "Permission denied"
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

