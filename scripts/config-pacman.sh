#!/bin/bash

sed -i /etc/pacman.conf -e '/Color/s/^#\s*//'
sed -i /etc/pacman.conf -e '/NoProgressBar/s/^/#/g'
sed -i /etc/pacman.conf -e '/CheckSpace/s/^#\s*//'
sed -i /etc/pacman.conf -e '/ParallelDownloads/s/^#\s*//' -e '/ParallelDownloads/s/\s*=\s*\d+/ = 5/'
