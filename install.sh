
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

function list_system_manual_install
{
    printf "System components that require manuall installation are...\n"
    printf " -> %s\n" "/etc/default/grub"
}

function install_system
{
    install_system_shells
    install_system_editors
    install_system_skel
    install_system_pacman
    list_system_manual_install
    printf "System components installed!\n"
}

################################################################################
## HOME COMPONENTS
################################################################################

function install_home_shells
{
    printf "Installing home shells...\n"
    __install 644 {system/home/,~/}.profile
}

function install_home_skel
{
    printf "Installing home skel...\n"
    __install 644 {system/etc/skel/,~/}.bash_login
    __install 644 {system/etc/skel/,~/}.bash_logout
    __install 644 {system/etc/skel/,~/}.bash_profile
    __install 644 {system/etc/skel/,~/}.bashrc
    __install 644 {system/etc/skel/,~/}.profile
}

function install_home_git
{
    printf "Installing home git...\n"
    __install 644 {system/home/,~/}.gitconfig
}

function install_home_tex
{
    printf "Installing home tex_common...\n"
    __install 644 {system/home/,~/}.tex_common
}

function install_home_code
{
    printf "Installing home code settings...\n"
    __install 644 {system/home/,~/.}config/VSCodium/User/settings.json
}

function install_home_konsole
{
    printf "Installing home konsole configurations...\n"
    __install 644 {system/home/,~/.}local/share/konsole/Rocket.colorscheme
}

function list_home_manual_install
{
    printf "Home components that require manuall installation are...\n"
    printf " -> %s\n" ".config/systemd/user/robertfry-games.service"
    printf " -> %s\n" ".config/systemd/user/robertfry-games.sh"
    printf " -> %s\n" ".config/systemd/user/scc-daemon.service"
}

function install_home
{
    install_home_shells
    install_home_skel
    install_home_git
    install_home_tex
    install_home_code
    install_home_konsole
    list_home_manual_install
    printf "Home components installed!\n"
}

################################################################################
## HELP
################################################################################

function print_help
{
    printf "%s\n" "Install each component of my config files..."
    printf "\t%s\n" "sudo ./install.sh system(_shells|_editors|_skel|_pacman)?"
    printf "\t%s\n" "./install.sh home(_shells|_git|_tex|_code|_konsole)?"
}

################################################################################
## MAIN
################################################################################

for name in "$@";
do
    install_$name 2>/dev/null || print_help
done
