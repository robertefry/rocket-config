
PS1_prompt_command()
{
    EXIT=$(printf '%02x' $?)    # 2-digit hex exit code

    PS1_FMT0="\e[0m"
    [ "$(id -u)" = 0 ] && PS1_FMT1="\e[0;1;31m"   || PS1_FMT1="\e[0;1;36m"
    [ "$(id -u)" = 0 ] && PS1_FMT2="\e[0;1;3;31m" || PS1_FMT2="\e[0;1;3;36m"
    [ "$(id -u)" = 0 ] && PS1_FMT3="\e[0;1;33m"   || PS1_FMT3="\e[0;1;34m"
    [ "$(id -u)" = 0 ] && PS1_FMTE="\e[0;1;3;33m" || PS1_FMTE="\e[0;1;3;31m"

    PS1="\[$PS1_FMT1\][\[$PS1_FMT2\]\u\[$PS1_FMT1\]@\H \[$PS1_FMT0\]\W\[$PS1_FMT1\]]"

    # Prepend the shell level if inside a subshell
    [ "$SHLVL" -gt 1 ] && PS1="\[$PS1_FMT3\]$SHLVL\[$PS1_FMT1\]$PS1"

    # Append Git information
    if command -v git >/dev/null 2>&1 && [ -n "$(git rev-parse --git-dir 2>/dev/null)" ]
    then
        _branch=$(git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
        PS1="$PS1 \[$PS1_FMT1\](\[$PS1_FMT3\]$_branch\[$PS1_FMT1\])"
    fi

    # Prepend return value (if nonzero)
    if [ "$EXIT" != "00" ]
    then
        PS1="\[$PS1_FMTE\]$EXIT $PS1"
    fi

    export PS1="$PS1\[$PS1_FMT1\]\\$ \[\$(tput sgr0)\]"
}

export PROMPT_COMMAND=PS1_prompt_command
