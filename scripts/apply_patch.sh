#!/bin/bash

PATCHES="${1:-meson64-current}"
for folder in "../armbian-build/patch/kernel/$PATCHES/" "../userpatches/kernel/$PATCHES/"; do
    ERR_PATCH=""
    for i in `ls $folder`; do
        git apply --check "${folder}$i" 2>/dev/null
        if [ $? != "0" ]; then
            ERR_PATCH="$ERR_PATCH $i"
        else
            echo -e "[ \033[32m OK  \033[0m ] $i"
            git apply "${folder}$i" >/dev/null 2>&1

            TMP_ERR_PATCH="$ERR_PATCH"
            for j in $TMP_ERR_PATCH; do
                git apply --check "${folder}$j" 2>/dev/null
                if [ $? = "0" ]; then
                    echo -e "[ \033[32m OK  \033[0m ] $j"
                    git apply "${folder}$j" >/dev/null 2>&1
                    ERR_PATCH=$(echo "$ERR_PATCH" | sed 's/'" $j"'//')
                fi
            done
        fi
    done

    for i in $ERR_PATCH; do
        echo -e "[ \033[31m ERR \033[0m ] $i"
        git apply --stat "${folder}$i"
        git apply --check "${folder}$i"
    done
done

exit 0
