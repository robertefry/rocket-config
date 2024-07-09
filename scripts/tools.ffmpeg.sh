#!/bin/bash

tools.ffmpeg.duration()
{
    ffprobe -v error -select_streams v:0 -show_entries stream=duration -of default=noprint_wrappers=1:nokey=1 "$1"
}

tools.ffmpeg.two_pass()
{
    src="$1";shift
    dst="$1";shift

    # confirm overwrite destination if already exists
    if [ -f "$dst" ]
    then
        read -p "The destination file, $dst, already exists. Overwrite? [y/N] " -n 1 -r
        echo # move to a new line
        if [ "$REPLY" != "y" ] && [ "$REPLY" != "Y" ]
        then
            printf "%s\n" "Aborting!"
            return 255
        fi
    fi

    ffmpeg -hide_banner -loglevel warning -stats -i "$src" "$@" -pass 1 -y /dev/null
    ffmpeg -hide_banner -loglevel warning -stats -i "$src" "$@" -pass 2 -y "$dst"
}
