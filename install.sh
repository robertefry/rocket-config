
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
    printf "Installing system pacman configuration...\n"
    __install 644 {system,}/etc/pacman.d/hooks/count-pacnew-files.hook
    __install 755 {system,}/etc/pacman.d/scripts/count-pacnew-files.sh
    __install 644 {system,}/etc/pacman.conf
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
    __install 644 {system/home/,~/}.bash_login
    __install 644 {system/home/,~/}.bash_logout
    __install 644 {system/home/,~/}.bash_profile
    __install 644 {system/home/,~/}.bashrc
    __install 644 {system/home/,~/}.profile
    __install 644 {system/home/,~/}.gitconfig
}

function install_home_desktop
{
    printf "Installing home desktop settings...\n"
    __install 644 {system/home/,~/}.config/VSCodium/User/settings.json
    __install 644 {system/home/,~/}.local/share/konsole/Rocket.colorscheme
}

function install_home
{
    install_home_shells
    install_home_desktop
    printf "Home components installed!\n"
}

################################################################################
## HELP
################################################################################

function print_help
{
    printf "%s\n" "Install components of my config files"
    printf "%s\n" "    Usage: ./install.sh [components]"
    printf "%s\n" "[components]"
    printf "%s\n" "    system system_shells system_editors system_skel system_pacman"
    printf "%s\n" "    home home_shells home_desktop"
}

################################################################################
## MAIN
################################################################################

for name in "$@";
do
    install_$name || print_help
done
