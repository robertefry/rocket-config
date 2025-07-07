
# Print my public IP address
if command -v curl &>/dev/null
then
    ippub() {
        curl ifconfig.me 2> /dev/null
    }
fi
