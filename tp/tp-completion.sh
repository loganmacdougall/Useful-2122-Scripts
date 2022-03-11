#usr/bin/env bash

# Author: Logan MacDougall
# Filename: tp-completion.sh

# This is used along side the tp script so clicking
# the tab key will provide auto-completion

# These variables must be set same as they are in the tp file
USERNAME="macdougall"
LABSFOLDER="/users/cs/$USERNAME/Courses/CSCI2122/Labs"

_tp_completions() {
    if [ ${#COMP_WORDS[@]} == 2 ]; then
        COMPREPLY+=($(compgen -W "lab lib" "${COMP_WORDS[1]}"))
        return 0
    else
        case ${COMP_WORDS[1]} in
            "lab")
                if [ ${#COMP_WORDS[@]} == 3 ]; then
                    COMPREPLY=($(compgen -W "$(ls ${LABSFOLDER} | grep -e "^\(Lab\)" | cut -c 4- | sed -e ':a;N;$!ba;s/\n/ /g')" "${COMP_WORDS[2]}"))
                elif [ ${#COMP_WORDS[@]} == 4 -a -d $LABSFOLDER/Lab${COMP_WORDS[2]}/$USERNAME/Lab${COMP_WORDS[2]} ]; then
                    COMPREPLY=($(compgen -W "$(find $LABSFOLDER/Lab${COMP_WORDS[2]}/$USERNAME/Lab${COMP_WORDS[2]} -maxdepth 1 -mindepth 1 -type d | rev | cut -d "/" -f 1 | rev)" "${COMP_WORDS[3]}"))
                fi
                ;;
            *)
        esac
    fi
}

complete -F _tp_completions tp