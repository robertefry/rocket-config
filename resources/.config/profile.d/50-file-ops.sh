
# Confirm before overwriting something
alias cp="cp --interactive --recursive"
alias mv="mv --interactive"
alias rm="rm"

# Make sure `gls` exists: real one if coreutils is installed, else plain ls (GNU on Linux)
command -v gls &>/dev/null || alias gls='command ls'

# Listing commands
alias ls="gls --color=auto --group-directories-first --indicator-style=slash --time-style=long-iso"
alias l="ls -lh"
alias ll="ls -lAh"
alias la="ls -lah"
ldot() {( cd "$1" && ls -lAhd .* )}

# Make parent directories with `mkdir`
alias mkdir="mkdir -p"

# Make a directory and cd into it
mkcd()
{
    mkdir "$1" && cd "$1" || return 255
}

# Drop into a temp environment
mktmp()
{(
    TMPDIR="$(mktemp -d)"
    cd "$TMPDIR" || return 255
    $SHELL
    trap 'rm -drf "$TMPDIR"' EXIT
)}

# Follow a chain of symlinks
follow()
{
    _target="$1"
    _linked="$_target"

    while [ -L "$_linked" ];
    do
        _target=$(readlink "$_linked")
        _linked="$_target"
    done

    echo "$_target"
}
