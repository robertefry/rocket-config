#!/bin/bash

## CD into the directory of this script, henceforth the current working directory
cd "$(dirname "$0")" || exit

STAMP=$(date +"%y%m%d%H%M%S")

__test_and_set()
{
    local var="$1"

    if [ -z "${!var+x}" ]; then
        printf -v "$var" 1
        return 0
    else
        return 1
    fi
}

__install()
{
    local _arg_pem="$1"
    local _arg_src="$2"/"$4"
    local _arg_dst="$3"/"$4"

    # Avoid installing a file more than once
    local _safe_src=$(echo "$_arg_src" | sed 's/[^a-zA-Z0-9_]/_/g')
    __test_and_set "_INSTALLED_${_safe_src}" || return 0

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

################################################################################
## USER
################################################################################

install_user_profile()
{
    printf "Installing shell profile...\n"

    __install 644 "resources/" "$HOME/" ".profile"
    __install 644 "resources/" "$HOME/" ".environment"
    __install 644 "resources/" "$HOME/" ".config/profile.d/10-ps1.sh"
    __install 644 "resources/" "$HOME/" ".config/profile.d/20-local-bin.sh"
    __install 644 "resources/" "$HOME/" ".config/profile.d/50-file-ops.sh"
    __install 644 "resources/" "$HOME/" ".config/profile.d/60-alias-editors.sh"
    __install 644 "resources/" "$HOME/" ".config/profile.d/60-alias-exit.sh"
    __install 644 "resources/" "$HOME/" ".config/profile.d/90-block-tools.sh"
    __install 644 "resources/" "$HOME/" ".config/profile.d/90-cap.sh"
    __install 644 "resources/" "$HOME/" ".config/profile.d/90-extract.sh"
    __install 644 "resources/" "$HOME/" ".config/profile.d/90-find.sh"
    __install 644 "resources/" "$HOME/" ".config/profile.d/90-grep.sh"
    __install 644 "resources/" "$HOME/" ".config/profile.d/90-ippub.sh"
    __install 644 "resources/" "$HOME/" ".config/profile.d/90-reprofile.sh"
    __install 644 "resources/" "$HOME/" ".config/profile.d/90-rnpw.sh"
    __install 644 "resources/" "$HOME/" ".config/profile.d/90-rsync.sh"
    __install 644 "resources/" "$HOME/" ".config/profile.d/90-stamp.sh"
}

install_user_bash()
{
    install_user_profile

    printf "Installing bash shell...\n"

    __install 644 "resources/" "$HOME/" ".bash_profile"
    __install 644 "resources/" "$HOME/" ".bash_login"
    __install 644 "resources/" "$HOME/" ".bash_logout"
    __install 644 "resources/" "$HOME/" ".bashrc"
    __install 644 "resources/" "$HOME/" ".config/profile.bash.d/10-system.sh"
    __install 644 "resources/" "$HOME/" ".config/profile.bash.d/30-display.sh"
    __install 644 "resources/" "$HOME/" ".config/profile.bash.d/30-globbing.sh"
    __install 644 "resources/" "$HOME/" ".config/profile.bash.d/50-completion.sh"
    __install 644 "resources/" "$HOME/" ".config/profile.bash.d/50-history.sh"
    __install 644 "resources/" "$HOME/" ".config/profile.bash.d/90-reprofile.sh"
}

install_user()
{
    install_user_profile
    install_user_bash
}

################################################################################
## HOME
################################################################################

install_home_environment()
{
    printf "Installing home environments...\n"

    __install 644 "resources/" "$HOME/" ".config/environment.d/30-xdg.sh"
    __install 644 "resources/" "$HOME/" ".config/environment.d/50-jre.sh"
    __install 644 "resources/" "$HOME/" ".config/environment.d/80-bash.sh"
    __install 644 "resources/" "$HOME/" ".config/environment.d/90-android.sh"
    __install 644 "resources/" "$HOME/" ".config/environment.d/90-code.sh"
    __install 644 "resources/" "$HOME/" ".config/environment.d/90-fcitx.sh"
    __install 644 "resources/" "$HOME/" ".config/environment.d/90-gnupg.sh"
    __install 644 "resources/" "$HOME/" ".config/environment.d/90-gtk.sh"
    __install 644 "resources/" "$HOME/" ".config/environment.d/90-keychain.sh"
    __install 644 "resources/" "$HOME/" ".config/environment.d/90-libvirt.sh"
    __install 644 "resources/" "$HOME/" ".config/environment.d/90-mangohud.sh"
    __install 644 "resources/" "$HOME/" ".config/environment.d/90-nvidia.sh"
    __install 644 "resources/" "$HOME/" ".config/environment.d/90-opengl.sh"
    __install 644 "resources/" "$HOME/" ".config/environment.d/90-python.sh"
    __install 644 "resources/" "$HOME/" ".config/environment.d/90-rust.sh"
    __install 644 "resources/" "$HOME/" ".config/environment.d/90-steamapps.sh"
    __install 644 "resources/" "$HOME/" ".config/environment.d/90-vcpkg.sh"
    __install 644 "resources/" "$HOME/" ".config/environment.d/90-ytdl.sh"
}

install_home_extras()
{
    printf "Installing home extras...\n"

    __install 644 "resources/" "$HOME/" ".gitconfig"
    __install 644 "resources/" "$HOME/" ".gitignore"

    __install 644 "resources/" "$HOME/" ".pythonrc"

    __install 644 "resources/" "$HOME/" ".clang-tidy"
    __install 644 "resources/" "$HOME/" ".config/clangd/config.yaml"

    __install 644 "resources/" "$HOME/" ".config/VSCodium/product.json"
    __install 644 "resources/" "$HOME/" ".config/VSCodium/User/settings.json"
    __install 644 "resources/" "$HOME/" ".config/VSCodium/User/keybindings.json"
}

install_home()
{
    install_user
    install_home_environment
    install_home_extras
}

################################################################################
## EDITORS
################################################################################

install_editors_nano()
{
    __install 644 "resources/" "$HOME/" ".nanorc"
}

install_editors()
{
    install_editors_nano
}

################################################################################
## DESKTOP
################################################################################

install_desktop_gtk()
{
    printf "Installing desktop GTK...\n"

    __install 644 "resources/" "$HOME/" ".config/gtk-3.0/gtk.css"
    __install 644 "resources/" "$HOME/" ".config/gtk-4.0/gtk.css"
}

install_desktop_kde()
{
    printf "Installing desktop KDE...\n"

    __install 644 "resources/" "$HOME/" ".local/share/konsole/Rocket.colorscheme"
}

install_home_desktop()
{
    install_desktop_gtk
    install_desktop_kde
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
    user: ............. profile bash
    home: ............. environment extras
    editors: .......... nano
    desktop: .......... gtk kde

Optionally install an entire component category.

For example; to install the entire 'user' component, and only 'kde' from the 'desktop' component
'$ ./install.sh user desktop_kde'
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
