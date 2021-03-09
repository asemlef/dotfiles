#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# function for subscripts to create symlinks with
function copy_file {
    # variables
    local opath="$RDIR/$1"
    local spath="${2/#\~/$HOME}"
    # check if file already exists and prompt
    if [[ -f $spath ]] && [[ ! -h $spath ]] && ! $FORCE; then
        echo -ne "\e[31m"
        read -p "File '$2' already exists! Overwrite? (y/N) "
        echo -ne "\e[0m"
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo_color "Skipping symlink '$2'" "YELLOW"
            return
        fi
    fi
    # copy the file
    echo_color "Creating symlink '$2'" "BLUE"
    mkdir -p $(dirname $spath)
    ln -sf $opath $spath
}

# function for echoing in color
function echo_color {
    # get ANSI color from case
    local colorstr
    case $2 in
        RED)
            colorstr='\e[31m';;
        GREEN)
            colorstr='\e[32m';;
        YELLOW)
            colorstr='\e[33m';;
        BLUE)
            colorstr='\e[94m';;
        *)
            colorstr='\e[39m';;
    esac

    # echo the string
    echo -e "$colorstr$1\e[0m"

}

# get optional argument
if [[ ${1:-""} == "--force" ]]; then
    FORCE=true
else
    FORCE=false
fi

# run install script for each directory
for dir in $(dirname $0)/files/*; do
    if [[ -d $dir ]]; then
        # print fancy header first
        RDIR=$(realpath -s $dir)
        echo_color "* $(basename $dir)" "GREEN"

        # run the actual script
        source $dir/install.sh

        # end with newline
        echo ""
    fi
done
