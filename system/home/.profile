
## Source the global profile.d/rocket.sh to update any changes
[ -f /etc/profile.d/rocket.sh ] && . /etc/profile.d/rocket.sh

## Use MangoHUD (Vulcan/OpenGL)
export MANGOHUD=1
export MANGOHUD_DLSYM=1
export ENABLE_VKBASALT=1

## VSCodium
if command -v vscodium &> /dev/null
then
    alias code=vscodium
    export VISUAL=$(which vscodium)
fi