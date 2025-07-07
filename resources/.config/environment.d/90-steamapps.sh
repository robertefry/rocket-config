
steamapps()
{
    find "$1" -maxdepth 1 -type f -name '*.acf' -exec awk -F '"' '/"appid|name/{ printf $4 "|" } END { print "" }' {} \; | column -t -s '|' | sort -k 2
}
