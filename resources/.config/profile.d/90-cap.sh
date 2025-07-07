
# Capture the output of a command
cap() {
    tee "/tmp/capture-$(id -u)-${1:-0}.out"
}

# Return the last captured output
ret() {
    touch "/tmp/capture-$(id -u)-${1:-0}.out"
    cat "/tmp/capture-$(id -u)-${1:-0}.out"
}

# Remove the capture file
rmcap() {
    rm "/tmp/capture-$(id -u)-${1:-0}.out"
}
