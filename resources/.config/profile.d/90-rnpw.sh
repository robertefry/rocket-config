
# Generate a random password
if command -v strings >/dev/null 2>&1
then
    rnpw() {
        strings /dev/urandom | grep -o '[[:alnum:]]' | head -n "${1:-32}" | tr -d '\n' ; echo
    }
fi
