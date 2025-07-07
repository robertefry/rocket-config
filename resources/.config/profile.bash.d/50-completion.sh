
# Enable bash completion
ENABLE_BASH_COMPLETION=1

# Enable remote cvs completion
#COMP_CVS_REMOTE=

# Enable configure arguments completion
#COMP_CONFIGURE_HINTS=

# Enable tar archive internal path completion
#COMP_TAR_INTERNAL_PATHS=

# Enable wireless uid completion
#COMP_IWCONFIG_SCAN=

# Enable zeroconf hostnames completion
#COMP_AVAHI_BROWSE=

if [ -r "/usr/share/bash-completion/bash_completion" ]; then
    . "/usr/share/bash-completion/bash_completion"
fi
