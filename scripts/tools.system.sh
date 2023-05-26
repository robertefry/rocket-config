#!/bin/bash

tools.system.update()
{
    if command -v apt &>/dev/null
    then
        apt update && apt upgrade -y
    fi

    if command -v pacman &>/dev/null
    then
        pacman -Syyu
    fi

    if command -v paru &>/dev/null
    then
        paru -Syyu
    fi

    if command -v flatpak &>/dev/null
    then
        flatpak update
    fi
}
