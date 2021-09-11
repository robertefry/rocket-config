#!/bin/bash

file="/media/titan.saturn.local/games/robertfry-steam.iso"

function err
{
    case $1 in
        1) echo "ERROR: No matching block device found."   ;;
        2) echo "ERROR: Block device already defined."     ;;
    esac
    exit -1
}

function find_block_device
{
    block_device=$(losetup -a | grep $file | sed 's/: .*$//')
}

function device_setup
{
    find_block_device
    [ -z $block_device ] || err 2 && udisksctl loop-setup -f $file
}

function device_delete
{
    find_block_device
    [ -n $block_device ] || err 1 && udisksctl loop-delete -b $block_device
}

function device_mount
{
    find_block_device
    [ -n $block_device ] || err 1 && udisksctl mount -b $block_device
}

function device_umount
{
    find_block_device
    [ -n $block_device ] || err 1 && udisksctl unmount -b $block_device
}


if [ "$1" = "mount" ];
then
    device_setup; device_mount
fi

if [ "$1" = "umount" ];
then
    device_umount; device_delete
fi
