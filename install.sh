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

function install_system_editors
{
    printf "Installing system editors...\n"
    __install 644 {system,}/etc/nanorc
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

function install_system_pacman
{
    printf "Installing system pacman...\n"
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

system/home/.local/share/konsole/Rocket.colorscheme

function install_home_shells
{
    printf "Installing home shells...\n"
    __install 644 {system/home,~}/.bash_login
    __install 644 {system/home,~}/.bash_logout
    __install 644 {system/home,~}/.bash_profile
    __install 644 {system/home,~}/.bashrc
    __install 644 {system/home,~}/.profile
}

function install_home_git
{
    printf "Installing home git...\n"
    __install 644 {system/home,~}/.gitconfig
}

function install_home
{
    install_home_shells
    install_home_git
    printf "Home components installed!\n"
}

################################################################################
## HOME EXTRA COMPONENTS
################################################################################

function install_home_code
{
    printf "Installing home code...\n"
    __install 644 {system/home,~}/.config/VSCodium/User/settings.json
}

function install_home_game
{
    printf "Installing home game...\n"
    __install 644 {system/home,~}/.config/systemd/user/scc-daemon.service
}

function install_home_extra
{
    install_home_code
    install_home_game
    printf "Home (Extra) components installed!\n"
}

################################################################################
## HOME DESKTOP COMPONENTS
################################################################################

function install_home_desktop_kde
{
    printf "Installing home desktop KDE...\n"
    __install 644 {system/home/,~/}.local/share/konsole/Rocket.colorscheme
    printf "Home (Desktop KDE) components installed!\n"
}

################################################################################
## HELP
################################################################################

function print_help
{
    printf "%s\n" "Install components of my config files"
    printf "%s\n" "    Usage: ./install.sh [components]"
    printf "%s\n" "[components]"
    printf "%s\n" "    system: ........ shells editors skel pacman"
    printf "%s\n" "    home: .......... shells git"
    printf "%s\n" "    home_extra: .... code game"
    printf "%s\n" "    home_desktop: .. kde"
    printf "%s\n" "Optionally install an entire component category."
}

################################################################################
## MAIN
################################################################################

for name in "$@";
do
    install_$name || print_help
done
