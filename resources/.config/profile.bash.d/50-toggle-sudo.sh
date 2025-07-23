
# Toggle 'sudo' at the beginning of the current command.
#
# Activated by pressing the escape key twice (Esc Esc).
#

__toggle_sudo()
{
    local command="${READLINE_LINE}"

    local leading_whitespace="${command%%[![:space:]]*}"
    command="${command#$leading_whitespace}"

    case "$command" in
        "")
            # TODO: Parse the previous command and toggle sudo.
            # For now, let's just prepend sudo and let bash expand the command.
            command="sudo !!"
            ;;
        sudo[[:space:]]*)
            command="$(printf '%s' "$command" | sed -E 's/^[[:space:]]*sudo[[:space:]]+//')"
            ;;
        *)
            command="sudo $command"
            ;;
    esac

    READLINE_LINE="$leading_whitespace$command"
    READLINE_POINT=${#READLINE_LINE}
}

if [[ $- == *i* ]]; then
    bind -x '"\e\e":__toggle_sudo'
fi
