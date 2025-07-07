
if command -v python >/dev/null 2>&1
then
    alias py=python
    export PYTHONSTARTUP="$HOME"/.pythonrc
fi

## Python Virtual Environment
#if command -v pip3 >/dev/null 2>&1
#then
#    if [ ! -r "$XDG_DATA_HOME/rocket-config/venv/bin/activate" ]
#    then
#        python3 -m venv --system-site-packages "$XDG_DATA_HOME/rocket-config/venv"
#    fi
#
#    . "$XDG_DATA_HOME/rocket-config/venv/bin/activate"
#fi
