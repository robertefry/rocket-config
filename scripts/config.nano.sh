#!/bin/bash

source "$(dirname "$0")/../tools/tools.editors.sh"

# configuration
tools.editors.comments "/etc/nanorc" -U "fill" && sed -i "/etc/nanorc" -e '/^set fill/s/-8/80/'
tools.editors.comments "/etc/nanorc" -U "linenumbers"
tools.editors.comments "/etc/nanorc" -U "locking"
tools.editors.comments "/etc/nanorc" -U "matchbrackets"
tools.editors.comments "/etc/nanorc" -U "punct"
tools.editors.comments "/etc/nanorc" -U "regex"
tools.editors.comments "/etc/nanorc" -U "softwrap"
tools.editors.comments "/etc/nanorc" -U "tabsize" && sed -i "/etc/nanorc" -e '/^set tabsize/s/8/4/'
tools.editors.comments "/etc/nanorc" -U "tabstospaces"
tools.editors.comments "/etc/nanorc" -U "trimblanks"
tools.editors.comments "/etc/nanorc" -U "wordchars"

# colours
tools.editors.comments "/etc/nanorc" -U "titlecolor"
tools.editors.comments "/etc/nanorc" -U "promptcolor"
tools.editors.comments "/etc/nanorc" -U "statuscolor"
tools.editors.comments "/etc/nanorc" -U "errorcolor"
tools.editors.comments "/etc/nanorc" -U "spotlightcolor"
tools.editors.comments "/etc/nanorc" -U "selectedcolor"
tools.editors.comments "/etc/nanorc" -U "stripecolor"
tools.editors.comments "/etc/nanorc" -U "scrollercolor"
tools.editors.comments "/etc/nanorc" -U "numbercolor"
tools.editors.comments "/etc/nanorc" -U "keycolor"
tools.editors.comments "/etc/nanorc" -U "functioncolor"

# syntax highlighting
tools.editors.comments "/etc/nanorc" -U 'include "/usr/share/nano/*.nanorc"'
