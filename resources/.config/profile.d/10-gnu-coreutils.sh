
# Provide a function to find the GNU CoreUtils version of a given command

gnu_coreutils()
{
    get_path() {(
        unalias "$cmd" 2>/dev/null 1>&2
        unset -f "$cmd" 2>/dev/null 1>&2
        command -v "$cmd" 2>/dev/null
    )}

    for cmd in "g$1" "$1"; do
        path=$(get_path "$cmd")
        case $path in /*) ;; *) continue ;; esac
        case $("$path" --version 2>/dev/null) in
            *"GNU coreutils"*) echo "$path"; return 0 ;;
        esac
    done
    echo "gnu_coreutils: no GNU $1 found" >&2
    return 1
}
