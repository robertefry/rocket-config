
if command -v flatpak >/dev/null 2>&1 \
    && [ "$(flatpak list | grep com.vscodium.codium)" != "" ]
then
    alias vscodium='flatpak run com.vscodium.codium'
fi

if command -v vscodium >/dev/null 2>&1
then
    alias code=vscodium
fi
