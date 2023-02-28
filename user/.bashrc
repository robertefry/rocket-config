
# Use full globbing
shopt -s dotglob
shopt -s globstar

# Use job control
set -m

#
# If not running interactively, don't do anything
#
[[ $- != *i* ]] && return


## Source the shell-agnostic profile
[ -f ${HOME}/.profile ] && . ${HOME}/.profile

# Don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# Set the history length - See HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# Append to - don't overwrite - the history file
shopt -s histappend

# Keep track of window size (if running in a window)
[ -n $DISPLAY ] && shopt -s checkwinsize

# Use bash-completion (if available)
[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion
