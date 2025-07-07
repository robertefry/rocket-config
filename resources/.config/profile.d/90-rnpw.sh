
# Generate a random password
if command -v strings &>/dev/null
then
    rnpw() {
        strings /dev/urandom | grep -o '[[:alnum:]]' | head -n "${1:-32}" | tr -d '\n' ; echo
    }
fi
