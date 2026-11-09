
# Compatibility layer for non-gnu systems (MacOS, BSD, etc...).

command -v gls >/dev/null 2>&1 || alias ls="gls"

# For now, we'll only replace ls with that from coreutils.
# In future, we may wish to replace more tools.
