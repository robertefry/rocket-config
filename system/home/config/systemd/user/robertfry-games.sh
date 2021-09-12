#!/bin/sh

# !! THIS SCRIPT MUST BE CONTROLLED BY THE SYSTEMD SERVICE !! #
# !!     this is to avoid multiple overwriting mounts     !! #

HOME=$1
command=$2

file="/media/titan.saturn.local/games/robertfry-games.iso"
cache_device="$HOME/.cache/robertfry-games.device"

function device_setup
{
    local result=$(udisksctl loop-setup -f $file)
    echo $result | sed 's/\(^.*as \|\.$\)//g' > $cache_device
    echo "Mapped file $file at $(cat $cache_device)"
}

function device_delete
{
    udisksctl loop-delete -b $(cat $cache_device)
    echo "Unmapped file $file at $(cat $cache_device)"
    rm $cache_device
}

function device_mount
{
    udisksctl mount -b $(cat $cache_device)
}

function device_umount
{
    udisksctl unmount -b $(cat $cache_device)
}


case "$command" in
    "mount")  device_setup && device_mount ;;
    "umount") device_umount && device_delete ;;
esac
