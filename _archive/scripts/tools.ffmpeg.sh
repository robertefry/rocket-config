#!/bin/bash

# TODO: Wrap these with ArgBash

tools.ffmpeg.duration()
{
    ffprobe -v error -select_streams v:0 -show_entries stream=duration -of default=noprint_wrappers=1:nokey=1 "$1"
}

tools.ffmpeg.two_pass()
{
    _src="$1";shift
    _dst="$1";shift

    # confirm overwrite destination if already exists
    if [ -f "$_dst" ]
    then
        read -p "The destination file, $_dst, already exists. Overwrite? [y/N] " -n 1 -r
        echo # move to a new line
        if [ "$REPLY" != "y" ] && [ "$REPLY" != "Y" ]
        then
            printf "%s\n" "Aborting!"
            return 255
        fi
    fi

    logfile=$(mktemp /tmp/XXXXXXXX)

    ffmpeg -hide_banner -loglevel warning -stats -i "$_src" "$@" -pass 1 -passlogfile "$logfile" -y /dev/null
    ffmpeg -hide_banner -loglevel warning -stats -i "$_src" "$@" -pass 2 -passlogfile "$logfile" -y "$_dst"

    trap 'rm -f "$logfile"' EXIT
}

tools.ffmpeg.resize()
{
    _src="$1"
    _dst="$2"
    _size="$3"
    _rate_audio="$4"

    shift 4

    _bits_conversion_command='
        function to_bytes(n,b,p,s) { printf "%u\n", n*s*b^p; next }
        /^[0-9]+$/      { print $1; next }
        /(k|Kib)$/      { to_bytes($1,  2, 10, 1) };  # kibibits      (128         bytes)
        /(m|Mib)$/      { to_bytes($1,  2, 20, 1) };  # mebibits      (128*1024    bytes)
        /(g|Gib)$/      { to_bytes($1,  2, 30, 1) };  # gibibits      (128*1024^2  bytes)
        /(t|Tib)$/      { to_bytes($1,  2, 40, 1) };  # tebibits      (128*1024^3  bytes)
        /(K|KiB?)$/     { to_bytes($1,  2, 10, 8) };  # kibibytes     (1024        bytes)
        /(M|MiB?)$/     { to_bytes($1,  2, 20, 8) };  # mebibytes     (1024*1024   bytes)
        /(G|GiB?)$/     { to_bytes($1,  2, 30, 8) };  # gibibytes     (1024*1024^2 bytes)
        /(T|TiB?)$/     { to_bytes($1,  2, 40, 8) };  # tebibytes     (1024*1024^3 bytes)
        /Kb$/           { to_bytes($1, 10,  3, 1) };  # kilobits      (125         bytes)
        /Mb$/           { to_bytes($1, 10,  6, 1) };  # megabits      (125*1000    bytes)
        /Gb$/           { to_bytes($1, 10,  9, 1) };  # gigabits      (125*1000^2  bytes)
        /Tb$/           { to_bytes($1, 10, 12, 1) };  # tetrabits     (125*1000^3  bytes)
        /KB$/           { to_bytes($1, 10,  3, 8) };  # kilobytes     (1000        bytes)
        /MB$/           { to_bytes($1, 10,  6, 8) };  # megabytes     (1000*1000   bytes)
        /GB$/           { to_bytes($1, 10,  9, 8) };  # gigabytes     (1000*1000^2 bytes)
        /TB$/           { to_bytes($1, 10, 12, 8) };  # tetrabytes    (1000*1000^3 bytes)
        {
            print "Error: Unrecognized size format: " $0;
            exit 1;
        }
    '
    _bits=$(echo "$_size" | awk "$_bits_conversion_command")

    DURATION=$(tools.ffmpeg.duration "$_src")
    BITRATE=$(awk "BEGIN {print $_bits / $DURATION}")

    _bitrate_audio=$(echo "$_rate_audio" | awk "$_bits_conversion_command")
    _bitrate_video=$(awk "BEGIN {print $BITRATE - $_bitrate_audio}")

    tools.ffmpeg.two_pass "$_src" "$_dst" -b:v "$_bitrate_video" -b:a "$_bitrate_audio" "$@"
}
