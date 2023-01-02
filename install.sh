#!/bin/bash

function __install
{
    printf " -> installing %s... " "$3"
    install -Dbm $1 $2 $3
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
    printf "System components installed!\n"
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
    printf "Home components installed!\n"
}

################################################################################
## HOME EXTRA COMPONENTS
################################################################################

function install_home-extra_code
{
    printf "Installing home code...\n"
    __install 644 {system/home,~}/.config/VSCodium/User/settings.json
    __install 644 {system/home,~}/.clang-tidy
}

function install_home-extra
{
    install_home-extra_code
    printf "Home (Extra) components installed!\n"
}

################################################################################
## HOME DESKTOP COMPONENTS
################################################################################

function install_home-desktop_kde
{
    printf "Installing home desktop KDE...\n"
    __install 644 {system/home/,~/}.local/share/konsole/Rocket.colorscheme
    printf "Home (Desktop KDE) components installed!\n"
}

function install_home-desktop
{
    install_home-desktop_kde
    printf "Home (Desktop) components installed!\n"
}

################################################################################
## HELP
################################################################################

function print_help
{
    printf "%s\n" "Install components of my config files"
    printf "%s\n" "    Usage: ./install.sh [components]"
    printf "%s\n" "[components]"
    printf "%s\n" "    system: ........ shells skel"
    printf "%s\n" "    system-extra: .. editors pacman"
    printf "%s\n" "    home: .......... shells"
    printf "%s\n" "    home-extra: .... code"
    printf "%s\n" "    home-desktop: .. kde"
    printf "%s\n" "Optionally install an entire component category."
}

################################################################################
## MAIN
################################################################################

if [ $# -le 0 ]
then
    printf "No arguments supplied, printing the help message.\n"
    print_help
    exit 0
fi

for name in "$@";
do
    install_$name || print_help
done
