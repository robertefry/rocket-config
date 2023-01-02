#!/bin/bash

function __install
{
    printf " -> installing %s... " "$3"
    [ "${_arg_dryrun:-on}" == "off" ] && install -Dbm $1 $2 $3
    printf "Done!\n"
}

################################################################################
## SYSTEM COMPONENTS
################################################################################

function install_system_shells
{
    printf "Installing system shells...\n"
    __install 644 {system,}/etc/bash.bashrc
    __install 644 {system,}/etc/profile.d/rocket.sh
    __install 644 {system,}/etc/profile.d/fftools.sh
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

function install_system
{
    install_system_shells
    install_system_editors
    install_system_skel
    install_system_pacman
}

################################################################################
## HOME COMPONENTS
################################################################################

function install_home_shells
{
    printf "Installing home shells...\n"
    __install 644 {system/home,~}/.bash_login
    __install 644 {system/home,~}/.bash_logout
    __install 644 {system/home,~}/.bash_profile
    __install 644 {system/home,~}/.bashrc
    __install 644 {system/home,~}/.profile
    __install 644 {system/home,~}/.pythonrc
    __install 644 {system/home,~}/.gitconfig
    __install 644 {system/home,~}/.gitignore
}

function install_home
{
    install_home_shells
}

################################################################################
## HOME EXTRA COMPONENTS
################################################################################

function install_home-extra_code
{
    printf "Installing home-extra code...\n"
    __install 644 {system/home,~}/.config/VSCodium/User/settings.json
    __install 644 {system/home,~}/.clang-tidy
}

function install_home-extra
{
    install_home-extra_code
}

################################################################################
## HOME DESKTOP COMPONENTS
################################################################################

function install_home-desktop_kde
{
    printf "Installing home-desktop KDE...\n"
    __install 644 {system/home/,~/}.local/share/konsole/Rocket.colorscheme
}

function install_home-desktop
{
    install_home-desktop_kde
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
    -d, --dryrun:   Only print what would be done (off by default)
    -h, --help:     Print this help message

[components]
    system: ........... shells skel
    system-extra: ..... editors pacman
    home: ............. shells
    home-extra: ....... code
    home-desktop: ..... kde

Optionally install an entire component category.

For example; to install the entire 'home' category, and only 'code' from the 'home-extra' category
'$ ./install.sh home home-extra_code'
    "
}

################################################################################
## ARGUMENT PARSER
################################################################################

# THE DEFAULTS INITIALIZATION - POSITIONALS
_arg_components=()

# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_dryrun="off"

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

if [ "${_arg_dryrun}" == "on" ]
then
    printf "%s\n" "Running in dryrun mode, only printing what would happen"
fi

for component in "${_arg_components[@]}"
do
    install_$component
done
