
if command -v python >/dev/null 2>&1
then
    export PYTHONSTARTUP="$HOME"/.pythonrc
fi

function py()
{
    local VENV_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/venv/"

    if [ ! -r "$VENV_DIR/bin/activate" ]
    then
        python3 -m venv "$VENV_DIR"
    fi

    "$VENV_DIR/bin/python3" "$@"
}
