#!/bin/bash

count=$(find /etc -name "*\.pacnew" | wc -l)

if [[ $? == 0 ]]; then
    if [[ $count != 0 ]]; then
        echo " -> Found $count pacnew file(s) in /etc/"
    fi
else
    echo "Failed to count the number of pacnew files"
fi
