
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

## Source the shell-agnostic profile
[ -f $HOME/.profile ] && . $HOME/.profile
