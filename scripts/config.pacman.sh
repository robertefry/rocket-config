#!/bin/bash

source "$(dirname "$0")/../tools/tools.editors.sh"

tools.editors.comments -i "/etc/pacman.conf" -u "Color"
tools.editors.comments -i "/etc/pacman.conf" -c "NoProgressBar"
tools.editors.comments -i "/etc/pacman.conf" -u "CheckSpace"

# enable parallel downloads
tools.editors.comments -i "/etc/pacman.conf" -u "ParallelDownloads"
sed -i "/etc/pacman.conf" -e '/^ParallelDownloads/s/\s*=?\s*\d*/ = 5/g'
