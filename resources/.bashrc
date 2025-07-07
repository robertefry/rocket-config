#
# ~/.bashrc
#

for file in "$HOME"/.config/profile.bash.d/*.sh; do
    [ -e "$file" ] || continue
    [ -r "$file" ] && . "$file"
done

if [ -r "$HOME"/.profile ]; then
    . "$HOME"/.profile
fi
