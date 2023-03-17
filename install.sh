#!/bin/bash

## CD into the directory of this script, henceforth the current-working directory
cd "$(dirname "$0")"

STAMP=$(date +"%y%m%d%H%M%S")

__install()
{
    _arg_pem="$1"
    _arg_src="$2"
    _arg_dst="$3"

    printf " -> installing %s... " "$_arg_dst"
    (
        ## if in drymode, do nothing
        if [ "${_arg_dryrun:-on}" == "on" ]
        then
            printf "(drymode) "
            exit
        fi

        ## backup if necessary
        if [ "${_arg_backup:-on}" == "on" ]
        then
            printf "(backup) "
            [ -f "$_arg_dst" ] && mv "$_arg_dst"{,.$STAMP~}
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
        if [ "${_arg_dryrun:-on}" == "on" ]
        then
            printf "(drymode) "
            exit
        fi

        ## append
        tail "$_arg_num" "$_arg_src" >> "$_arg_dst"
    )
    printf "Done!\n"
}

__append-heredoc()
{
    _arg_dst="$1"
    _arg_doc="$2"

    printf " -> appending %s... " "$_arg_dst"
    (
        ## if in drymode, do nothing
        if [ "${_arg_dryrun:-on}" == "on" ]
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

# todo: system-archlinux
# todo: system-grub
# todo: system-skel = user-shells

################################################################################
## USER COMPONENTS
################################################################################

install-user-shells()
{
    printf "Installing user shells...\n"

    __install 644 {resources/home-user/,~}/.config/rocket-config/profile.sh
    __install 644 {resources/home-user/,~}/.bash_login
    __install 644 {resources/home-user/,~}/.bash_logout
    __install 644 {resources/home-user/,~}/.bash_profile
    __install 644 {resources/home-user/,~}/.bashrc
}

install-user-tools()
{
    printf "Installing user shell tools...\n"

    __install 644 {scripts/,~/.config/rocket-config/}/tools.editors.sh
    __install 644 {scripts/,~/.config/rocket-config/}/tools.ffmpeg.sh

    __append-heredoc ~/.bashrc "\

#
# home-user tools
#
[[ -r ~/.config/rocket-config/tools.editors.sh ]] && . ~/.config/rocket-config/tools.editors.sh
[[ -r ~/.config/rocket-config/tools.ffmpeg.sh ]] && . ~/.config/rocket-config/tools.ffmpeg.sh
"
}

install-user()
{
    install-user-shells
    install-user-tools
}

################################################################################
## HOME COMPONENTS
################################################################################

install-home-shells()
{
    install-user-shells # home_shells requires user_shells
    install-user-tools  # home_shells requires user_tools

    printf "Installing home shells...\n"

    __append {resources/home-home/,~}/.bashrc
    __install 644 {resources/home-home/,~}/.config/rocket-config/profile-home.sh
    __install 644 {resources/home-home/,~}/.pythonrc
    __install 644 {resources/home-home/,~}/.gitconfig
    __install 644 {resources/home-home/,~}/.gitignore
}

install-home()
{
    install-home-shells
}

#
# home-extra
#

install-home_extra-code()
{
    printf "Installing home-extra code...\n"

    __install 644 {resources/home-home,~}/.config/VSCodium/User/settings.json
    __install 644 {resources/home-home,~}/.clang-tidy
}

install-home_extra()
{
    install-home_extra-code
}

#
# home-desktop 
#

install-home_desktop-gtk()
{
    printf "Installing home-desktop GTK...\n"

    __install 644 {resources/home-home/,~}/.config/gtk-3.0/gtk.css
    __install 644 {resources/home-home/,~}/.config/gtk-4.0/gtk.css
}

install-home_desktop-kde()
{
    printf "Installing home-extra KDE...\n"
    __install 644 {resources/home-home/,~}/.local/share/konsole/Rocket.colorscheme
}

install-home_desktop()
{
    install-home_desktop-gtk
    install-home_desktop-kde
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
'$ ./install.sh home home_desktop-kde'
    "
}

################################################################################
## ARGUMENT PARSER
################################################################################

# THE DEFAULTS INITIALIZATION - POSITIONALS
_arg_components=()

# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_dryrun="off"
_arg_backup="on"

parse_commandline()
{
    die()
    {
        local _ret="${2:-1}"
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
        local first_option all_short_options='dh'
        first_option="${1:0:1}"
        test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
    }

    local _positionals=()

	while test $# -gt 0
	do
		local _key="$1"
		case "$_key" in
			-d|--dryrun)
				_arg_dryrun="on"
				;;
			-d*)
				_arg_dryrun="on"
				_next="${_key##-d}"
				if test -n "$_next" -a "$_next" != "$_key"
				then
					{ begins_with_short_option "$_next" && shift && set -- "-d" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept a value and '-${_key:2:1}' doesn't correspond to a short option."
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
					{ begins_with_short_option "$_next" && shift && set -- "-B" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept a value and '-${_key:2:1}' doesn't correspond to a short option."
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
				_positionals+=("$1")
				;;
		esac
		shift
	done

    assign_positional_args()
    {
        local _positional_name _shift_for=$1
        _positional_names=""
        _our_args=$((${#_positionals[@]} - 0))
        for ((ii = 0; ii < _our_args; ii++))
        do
            _positional_names="$_positional_names _arg_components[$((ii + 0))]"
        done

        shift "$_shift_for"
        for _positional_name in ${_positional_names}
        do
            test $# -gt 0 || break
            eval "$_positional_name=\${1}" || die "Error during argument parsing, possibly an Argbash bug." 1
            shift
        done
    }
    assign_positional_args 1 "${_positionals[@]}"

    for component in "${_arg_components[@]}"
    do
        [ "$(type -t install-$component)" == "function" ] || die "The component '$component' is not recognised."
    done
}
parse_commandline "$@"

################################################################################
## MAIN
################################################################################

for component in "${_arg_components[@]}"
do
    install-$component
done
