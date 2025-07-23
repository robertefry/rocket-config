
# Toggle 'sudo' at the beginning of the current command.
#
# Activated by pressing the escape key twice (Esc Esc).
#

__toggle_sudo()
{
    local line="${READLINE_LINE}"

    if [[ "$line" =~ ^[[:space:]]*sudo[[:space:]]+ ]]; then
        READLINE_LINE="$(printf '%s' "$line" | sed -E 's/^[[:space:]]*sudo[[:space:]]+//')"
    else
        READLINE_LINE="sudo $line"
    fi
    READLINE_POINT=${#READLINE_LINE}
}

if [[ $- == *i* ]]; then
    bind -x '"\e\e":__toggle_sudo'
fi
