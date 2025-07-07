
# Stamp the time and date
if command -v date &>/dev/null
then
    stamp() {
        date +"%y%m%d-%H%M%S"
    }
fi
