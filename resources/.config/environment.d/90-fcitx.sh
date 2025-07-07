
if command -v fcitx $> /dev/null || command -v fcitx5 $> /dev/null
then
    export INPUT_METHOD=fcitx
    export GTK_IM_MODULE=fcitx
    export QT_IM_MODULE=fcitx
    export SDL_IM_MODULE=fcitx
    export XMODIFIERS=@im=fcitx
fi
