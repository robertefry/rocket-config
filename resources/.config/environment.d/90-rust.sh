
if [ -r "$HOME"/.local/share/cargo/env ]; then
    . "$HOME"/.local/share/cargo/env
fi

export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export CARGO_HOME="$XDG_DATA_HOME"/cargo
