
extract()
{
    if [ -f "$1" ]; then
        case "$1" in
            *.tar)              tar xf "$@"     ;;
            *.tar.bz2|*.tbz2)   tar xjf "$@"    ;;
            *.tar.gz|*.tgz)     tar xzf "$@"    ;;
            *.tar.xz|*.txz)     tar xf "$@"     ;;

            *.bz2)              bunzip2 "$@"    ;;
            *.gz)               gunzip "$@"     ;;
            *.xz)               unxz "$@"       ;;

            *.rar)              unrar x "$@"    ;;
            *.Z)                uncompress "$@" ;;
            *.zip)              unzip "$@"      ;;
            *.jar)              unzip "$@"      ;;
            *.7z)               7z x "$@"       ;;
            *.deb)              ar x "$@"       ;;

            *)  echo "'$1' has an unknown file extension";;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

alias ex=extract
