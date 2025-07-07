
# Use nano as our default console editor
if [ -z "$EDITOR" ]; then
    command -v nano &>/dev/null && export EDITOR="$(which nano)"
fi

# Use gedit as our default graphical editor
if [ -z "$VISUAL" ]; then
    command -v gedit &>/dev/null && export VISUAL="$(which gedit)"
fi

# Use less instead of more
if command -v less &>/dev/null; then
    alias more=less
fi
