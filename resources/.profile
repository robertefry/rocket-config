#
# ~/.profile
#

for file in "$HOME"/.config/profile.d/*.sh; do
    [ -e "$file" ] || continue
    [ -r "$file" ] && . "$file"
done

if [ -r "$HOME"/.environment ]; then
    . "$HOME"/.environment
fi
