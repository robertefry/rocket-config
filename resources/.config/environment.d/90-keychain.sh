
if command -v keychain >/dev/null 2>&1
then
    alias keychain="keychain --absolute --dir "$XDG_RUNTIME_DIR"/keychain"
    eval $(keychain --eval --quiet --timeout 5 ~/.ssh/*.key)
fi
