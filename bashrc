
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

## Source my shell-agnostic profile
if [[ -f $HOME/.profile ]]; then
    source $HOME/.profile
fi

## Bash prompt
#PS1='[\u@\h \W]\$ '
if [[ ${EUID} == 0 ]] ; then
	PS1='\[\033[01;31m\][\h\[\033[01;36m\] \W\[\033[01;31m\]]\$\[\033[00m\] '
else
	PS1='\[\033[01;32m\][\u@\h\[\033[01;37m\] \W\[\033[01;32m\]]\$\[\033[00m\] '
fi


################################################################################
## SHELL OPTIONS
################################################################################

# Use dotfile globbing
shopt -s dotglob


################################################################################
## SHELL PLUGINS
################################################################################

# Use bash-completion (if available)
if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    source /usr/share/bash-completion/bash_completion
fi
