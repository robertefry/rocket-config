#!/bin/bash

function __install
{
    printf " -> installing %s... " "$3"
    [ "${_arg_backup:-on}" == "off" ] && _backup="" || _backup="-b"
    [ "${_arg_dryrun:-on}" == "off" ] && install -D ${_backup} -m $1 $2 $3
    printf "Done!\n"
}

################################################################################
## ROCKET COMPONENTS
################################################################################

function install_rocket_system
{
    printf "Installing rocket system...\n"
    __install 644 {rocket,/etc/rocket-config}/profile.sh
    __install 644 {rocket,/etc/rocket-config}/fftools.sh
}

function install_rocket_user
{
    printf "Installing rocket user...\n"
    __install 644 {rocket,~/.config/rocket-config}/profile.sh
    __install 644 {rocket,~/.config/rocket-config}/fftools.sh
}

################################################################################
## SYSTEM COMPONENTS
################################################################################

function install_system_shells
{
    install_rocket_system # system_shells requires rocket_config

    printf "Installing system shells...\n"
    __install 644 {system,}/etc/bash.bashrc
    __install 644 {system,}/etc/profile.d/rocket-config.sh
}

function install_system_skel
{
    printf "Installing system skel...\n"
    __install 644 {system,}/etc/skel/.bash_login
    __install 644 {system,}/etc/skel/.bash_logout
    __install 644 {system,}/etc/skel/.bash_profile
    __install 644 {system,}/etc/skel/.bashrc
    __install 644 {system,}/etc/skel/.profile
}

function install_system
{
    install_system_shells
    install_system_skel
}

#
# system-extra
#

function install_system-extra_editors
{
    printf "Installing system-extra editors...\n"
    __install 644 {system,}/etc/nanorc
}

function install_system-extra_pacman
{
    printf "Installing system-extra pacman...\n"
    __install 644 {system,}/etc/pacman.conf
    __install 644 {system,}/etc/pacman.d/hooks/count-pacnew-files.hook
    __install 755 {system,}/etc/pacman.d/scripts/count-pacnew-files.sh
}

function install_system-extra
{
    install_system-extra_editors
    install_system-extra_pacman
}

################################################################################
## USER COMPONENTS
################################################################################

function install_user_shells
{
    install_rocket_user # user_shells requries rocket_user

    printf "Installing user shells...\n"
    __install 644 {user,~}/.bash_login
    __install 644 {user,~}/.bash_logout
    __install 644 {user,~}/.bash_profile
    __install 644 {user,~}/.bashrc
    __install 644 {user,~}/.profile
    __install 644 {user,~}/.pythonrc
    __install 644 {user,~}/.gitconfig
    __install 644 {user,~}/.gitignore
}

function install_user
{
    install_user_shells
}

#
# user-extra
#

function install_user-extra_code
{
    printf "Installing user-extra code...\n"
    __install 644 {user,~}/.config/VSCodium/User/settings.json
    __install 644 {user,~}/.clang-tidy
}

function install_user-extra
{
    install_user-extra_code
}

#
# user-desktop
#

function install_user-desktop_kde
{
    printf "Installing user-desktop KDE...\n"
    __install 644 {user/,~/}.local/share/konsole/Rocket.colorscheme
}

function install_user-desktop
{
    install_user-desktop_kde
}

################################################################################
## HELP
################################################################################

function print_help
{
    printf "%s\n" "\
Install components of my config files
    Usage: ./install.sh [args] [components]

[args]
    -d, --dryrun:       Only print what would be done           (off by default)
    -B, --no-backup:    Don't make a backup of current files    (off by default)
    -h, --help:         Print this help message

[components]
    rocket: ........... system user
    system: ........... shells skel
    system-extra: ..... editors pacman
    user: ............. shells
    user-extra: ....... code
    user-desktop: ..... kde

Optionally install an entire component category.

For example; to install the entire 'user' category, and only 'code' from the 'user-extra' category
'$ ./install.sh user user-extra_code'
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

function parse_commandline
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
        [ "$(type -t install_$component)" == "function" ] || die "The component '$component' is not recognised."
    done
}
parse_commandline "$@"

################################################################################
## MAIN
################################################################################

for component in "${_arg_components[@]}"
do
    install_$component
done
