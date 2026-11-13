
# Stamp the time and date
if command -v date >/dev/null 2>&1
then
    stamp() {
        date +"%y%m%d-%H%M%S"
    }
fi
