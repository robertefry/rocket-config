
if command -v python >/dev/null 2>&1
then
    export PYTHONSTARTUP="$HOME"/.pythonrc
fi

function py()
{
    local VENV_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/venv/"
    local VENV_PYTHON="$VENV_DIR/bin/python3"

    if [ ! -r "$VENV_PYTHON" ]
    then
        printf "%s\n" "Creating a new python virtual environment in $VENV_DIR..."
        python3 -m venv "$VENV_DIR"
    fi

    "$VENV_PYTHON" "$@"
}
