
# Suppress and count permission denied errors when using find
# Don't search in .snapshots directories
find()
{
    TMPFILE=$(mktemp)
    if [ $? -ne 0 ]; then
        printf "\e[31m%s\n" "Failed to allocate tempfile for error suppression" >&2
        return 255
    fi

    $(which find) "$@" -not -path "*/.snapshots/*" 2> "$TMPFILE"

    COUNT=$(grep -c "Permission denied" "$TMPFILE")
    if [ "$COUNT" -gt 0 ]; then
        printf "\e[31m%s\n" "Suppressed $COUNT permission errors" >&2
    fi

    ERRORS=$(grep -v "Permission denied" "$TMPFILE" | awk 'NF')
    if [ -n "$ERRORS" ]; then
        printf "\e[31m%s\n" "$ERRORS" >&2
    fi

    trap 'rm -f "$TMPFILE"' EXIT
}
