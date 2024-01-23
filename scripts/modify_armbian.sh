#!/bin/bash

for i in `ls userpatches/*.patch 2>/dev/null`; do
    git apply --check "${i}" 2>/dev/null
    if [ $? != "0" ]; then
        echo -e "[ \033[31m ERR \033[0m ] $i"
        git apply --stat "${i}"
        git apply --check "${i}"
    else
        echo -e "[ \033[32m OK  \033[0m ] $i"
        git apply "${i}" >/dev/null 2>&1
    fi
done

exit 0
