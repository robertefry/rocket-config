#!/bin/bash

# configuration
sed -i /etc/nanorc -e '/set fill/s/^#\s*//' -e '/set fill/s/-8/80/'
sed -i /etc/nanorc -e '/set linenumbers/s/^#\s*//'
sed -i /etc/nanorc -e '/set locking/s/^#\s*//'
sed -i /etc/nanorc -e '/set matchbrackets/s/^#\s*//'
sed -i /etc/nanorc -e '/set punct/s/^#\s*//'
sed -i /etc/nanorc -e '/set regex/s/^#\s*//'
sed -i /etc/nanorc -e '/set softwrap/s/^#\s*//'
sed -i /etc/nanorc -e '/set tabsize/s/^#\s*//' -e '/set tabsize/s/8/4/'
sed -i /etc/nanorc -e '/set tabstospaces/s/^#\s*//'
sed -i /etc/nanorc -e '/set trimblanks/s/^#\s*//'
sed -i /etc/nanorc -e '/set wordchars/s/^#\s*//'

# colours
sed -i /etc/nanorc -e '/set titlecolor/s/^#\s*//'
sed -i /etc/nanorc -e '/set promptcolor/s/^#\s*//'
sed -i /etc/nanorc -e '/set statuscolor/s/^#\s*//'
sed -i /etc/nanorc -e '/set errorcolor/s/^#\s*//'
sed -i /etc/nanorc -e '/set spotlightcolor/s/^#\s*//'
sed -i /etc/nanorc -e '/set selectedcolor/s/^#\s*//'
sed -i /etc/nanorc -e '/set stripecolor/s/^#\s*//'
sed -i /etc/nanorc -e '/set scrollercolor/s/^#\s*//'
sed -i /etc/nanorc -e '/set numbercolor/s/^#\s*//'
sed -i /etc/nanorc -e '/set keycolor/s/^#\s*//'
sed -i /etc/nanorc -e '/set functioncolor/s/^#\s*//'

# syntax highlighting
sed -i /etc/nanorc -e '/include "\/usr\/share\/nano\/*.nanorc"/s/^#\s*//'
