
# Use nano as our default console editor
if [ -z "$EDITOR" ] && command -v nano >/dev/null 2>&1; then
    EDITOR="$(which nano)"
    export EDITOR
fi

# Use gedit as our default graphical editor
if [ -z "$VISUAL" ] && command -v gedit >/dev/null 2>&1; then
    VISUAL="$(which gedit)"
    export VISUAL
fi

# Use less instead of more
if command -v less >/dev/null 2>&1; then
    alias more=less
fi
