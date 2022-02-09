#!/bin/bash

declare -a found_files

for file in "$(find /{etc,usr}/ -iname '*.pacnew' 2>/dev/null)"
do
    if [ -n "$file" ];
    then
        found_files+=( "$file" )
    fi
done

if [ "${#found_files[@]}" -gt 0 ]
then
    printf "\e[0;33mwarning:\e[0m found %s pacnew file(s) in '/{etc,usr}/'\n" "${#found_files[@]}"

    for file in ${found_files[@]}
    do
        printf " -> %s \n" "$file"
    done
fi
