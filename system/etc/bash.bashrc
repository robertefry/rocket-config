#
# /etc/bash.bashrc
#

# Use full globbing
shopt -s dotglob
shopt -s globstar

#
# If not interactive, return now
#
[[ $- != *i* ]] && return


# Keep track of window size (if running in a window)
[ -n $DISPLAY ] && shopt -s checkwinsize

# Use bash-completion (if available)
[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion
