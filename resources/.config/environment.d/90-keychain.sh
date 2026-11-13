
if command -v keychain >/dev/null 2>&1
then
    eval "$(keychain --absolute --dir "$XDG_RUNTIME_DIR/keychain" --eval --quiet --timeout 60)"
fi
