#!/bin/bash

## CD into the directory of this script, henceforth the current working directory
cd "$(dirname "$0")" || exit

STAMP=$(date +"%y%m%d%H%M%S")

__install()
{
    _arg_pem="$1"
    _arg_src="$2"/"$4"
    _arg_dst="$3"/"$4"

    printf " -> installing %s... " "$_arg_dst"
    (
        ## if in drymode, do nothing
        if [ "${_arg_dryrun:-on}" = "on" ]
        then
            printf "(drymode) "
            exit
        fi

        ## backup if necessary
        if [ "${_arg_backup:-on}" = "on" ]
        then
            printf "(backup) "
            [ -f "$_arg_dst" ] && mv "$_arg_dst" "$_arg_dst.$STAMP~"
        fi

        ## install
        install -Dm "$_arg_pem" "$_arg_src" "$_arg_dst"
    )
    printf "Done!\n"
}

__append()
{
    _arg_src="$1"
    _arg_dst="$2"
    _arg_num="${3:-+1}"

    printf " -> appending %s... " "$_arg_dst"
    (
        ## if in drymode, do nothing
        if [ "${_arg_dryrun:-on}" = "on" ]
        then
            printf "(drymode) "
            exit
        fi

        ## append
        tail "$_arg_num" "$_arg_src" >> "$_arg_dst"
    )
    printf "Done!\n"
}

__append_heredoc()
{
    _arg_dst="$1"
    _arg_doc="$2"

    printf " -> appending %s... " "$_arg_dst"
    (
        ## if in drymode, do nothing
        if [ "${_arg_dryrun:-on}" = "on" ]
        then
            printf "(drymode) "
            exit
        fi

        ## append
        echo "$_arg_doc" >> "$_arg_dst"
    )
    printf "Done!\n"
}

################################################################################
## SYSTEM COMPONENTS
################################################################################

# note: moved to scripts directory

# todo: system_archlinux
# todo: system_grub
# todo: system_skel = user_shells

################################################################################
## USER COMPONENTS
################################################################################

install_user_shells()
{
    printf "Installing user shells...\n"

    __install 644 "resources/home-user/" "$HOME/" ".config/rocket-config/profile.sh"
    __install 644 "resources/home-user/" "$HOME/" ".bash_login"
    __install 644 "resources/home-user/" "$HOME/" ".bash_logout"
    __install 644 "resources/home-user/" "$HOME/" ".bash_profile"
    __install 644 "resources/home-user/" "$HOME/" ".bashrc"
}

install_user_tools()
{
    printf "Installing user shell tools...\n"

    __install 644 "scripts/" "$HOME/.config/rocket-config/" "tools.system.sh"
    __install 644 "scripts/" "$HOME/.config/rocket-config/" "tools.editors.sh"
    __install 644 "scripts/" "$HOME/.config/rocket-config/" "tools.ffmpeg.sh"

    __append_heredoc "$HOME/.bashrc" "\

#
# home-user tools
#
[ -r "$HOME/.config/rocket-config/tools.system.sh" ] && . "$HOME/.config/rocket-config/tools.system.sh"
[ -r "$HOME/.config/rocket-config/tools.editors.sh" ] && . "$HOME/.config/rocket-config/tools.editors.sh"
[ -r "$HOME/.config/rocket-config/tools.ffmpeg.sh" ] && . "$HOME/.config/rocket-config/tools.ffmpeg.sh"
"
}

install_user()
{
    install_user_shells
    install_user_tools
}

################################################################################
## HOME COMPONENTS
################################################################################

install_home_shells()
{
    install_user_shells # home_shells requires user_shells
    install_user_tools  # home_shells requires user_tools

    printf "Installing home shells...\n"

    __append      "resources/home-home/" "$HOME/" ".bashrc"
    __install 644 "resources/home-home/" "$HOME/" ".config/rocket-config/profile-home.sh"
    __install 644 "resources/home-home/" "$HOME/" ".pythonrc"
    __install 644 "resources/home-home/" "$HOME/" ".gitconfig"
    __install 644 "resources/home-home/" "$HOME/" ".gitignore"
}

install_home()
{
    install_home_shells
}

#
# home-extra
#

install_home_extra_code()
{
    printf "Installing home-extra code...\n"

    __install 644 "resources/home-home" "$HOME/" ".config/VSCodium/User/settings.json"
    __install 644 "resources/home-home" "$HOME/" ".clang-tidy"
}

install_home_extra()
{
    install_home_extra_code
}

#
# home-desktop
#

install_home_desktop_gtk()
{
    printf "Installing home-desktop GTK...\n"

    __install 644 "resources/home-home/" "$HOME/" ".config/gtk-3.0/gtk.css"
    __install 644 "resources/home-home/" "$HOME/" ".config/gtk-4.0/gtk.css"
}

install_home_desktop_kde()
{
    printf "Installing home-extra KDE...\n"
    __install 644 "resources/home-home/" "$HOME/" ".local/share/konsole/Rocket.colorscheme"
}

install_home_desktop()
{
    install_home_desktop_gtk
    install_home_desktop_kde
}

################################################################################
## HELP
################################################################################

print_help()
{
    printf "%s\n" "\
Install components of my config files
    Usage: ./install.sh [args] [components]

[args]
    -d, --dryrun:       Only print what would be done           (off by default)
    -B, --no-backup:    Don't make a backup of current files    (off by default)
    -h, --help:         Print this help message

[components]
    user: ............. shells tools
    home: ............. shells
    home_extra: ....... code
    home_desktop: ..... gtk kde

Optionally install an entire component category.

For example; to install the entire 'home' category, and only 'kde' from the 'home_desktop' category
'$ ./install.sh home home_desktop_kde'
    "
}

################################################################################
## ARGUMENT PARSER
################################################################################

# THE DEFAULTS INITIALIZATION - POSITIONALS
_arg_components=""

# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_dryrun="off"
_arg_backup="on"

parse_commandline()
{
    die()
    {
        _ret="${2:-1}"
        printf "%s\n\n" "$1"
        print_help
        exit "${_ret}"
    }

    if [ $# -le 0 ]
    then
        die "No components given, printing the help message instead." 0
    fi

    begins_with_short_option()
    {
        _all_short_options='dh'
        _first_option=$(echo "$1" | cut -c1)

        case "$_all_short_options" in
            (*"$_first_option"*) return 0 ;;
            (*) return 1 ;;
        esac
    }

    die_if_bad_short_option_chain()
    {
        _key="$1"
        _next="$2"

        _short=$(echo "$_key" | cut -c1-2)
        begins_with_short_option "$_next" || die "The short option '$_key' cannot be decomposed to '$_short' and '-$_next', because '$_short' doesn't accept a value and '-$_next' doesn't correspond to a short option."
    }

    _arg_components=""

	while test $# -gt 0
	do
		_key="$1"
		case "$_key" in
			-d|--dryrun)
				_arg_dryrun="on"
				;;
			-d*)
				_arg_dryrun="on"
				_next="${_key##-d}"
				if test -n "$_next" -a "$_next" != "$_key"
				then
                    shift && set -- "-d" "-${_next}" "$@" && die_if_bad_short_option_chain "$_key" "$_next"
				fi
				;;
            -B|--no-backup)
				_arg_backup="off"
				;;
			-B*)
				_arg_backup="off"
				_next="${_key##-B}"
				if test -n "$_next" -a "$_next" != "$_key"
				then
                    shift && set -- "-B" "-${_next}" "$@" && die_if_bad_short_option_chain "$_key" "$_next"
				fi
				;;
			-h|--help)
				print_help
				exit 0
				;;
			-h*)
				print_help
				exit 0
				;;
			-*)
                die "The key '$_key' doesn't correspond to a short or long option."
				;;
			*)
				_arg_components="$_arg_components $1"
				;;
		esac
		shift
	done

    for component in $_arg_components
    do
        command -v "install_$component" >/dev/null || die "The component '$component' is not recognised."
    done
}
parse_commandline "$@"

################################################################################
## MAIN
################################################################################

for component in $_arg_components
do
    install_"$component"
done
