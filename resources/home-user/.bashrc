#
# ~/.bashrc
#

# Use full globbing
shopt -s dotglob
shopt -s globstar

# script-installed non-interactive go here

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# If running windowed, keep track of the window size
[ -n "$DISPLAY" ] && shopt -s checkwinsize

# Use bash-completion (if available)
[ -r "/usr/share/bash-completion/bash_completion" ] && . "/usr/share/bash-completion/bash_completion"

#
# home-user
#
[ -r "$HOME/.config/rocket-config/profile.sh" ] && . "$HOME/.config/rocket-config/profile.sh"

# re-source my shell profile
reprofile()
{
    . "$HOME/.bashrc"
}

# Don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth
# Set the history length - See HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000
