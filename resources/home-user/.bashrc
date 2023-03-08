#
# ~/.bashrc
#

# Use full globbing
shopt -s dotglob
shopt -s globstar

# script-installed non-interactive go here

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#
# home-user
#
[[ -r ~/.config/rocket-config/profile.sh ]] && . ~/.config/rocket-config/profile.sh

# If running windowed, keep track of the window size
[ -n "$DISPLAY" ] && shopt -s checkwinsize

# Use bash-completion (if available)
[[ -r /usr/share/bash-completion/bash_completion ]] && . /usr/share/bash-completion/bash_completion
