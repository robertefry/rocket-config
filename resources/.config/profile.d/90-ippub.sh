
# Print my public IP address
if command -v curl >/dev/null 2>&1
then
    ippub() {
        curl ifconfig.me 2> /dev/null
    }
fi
