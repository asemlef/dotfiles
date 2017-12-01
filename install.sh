#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# parse the directory in which the script resides
sourcedir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# ensure that the submodules are present and up to date
git -C $sourcedir submodule update --init --recursive

# create symlinks to dotfiles
for f in $(ls -A1 $sourcedir/dotfiles); do
    # if file already exists and is not a symlink, back it up first
    if [[ ! -L $HOME/$f && -e $HOME/$f ]]; then
        echo "$f already exists, backing up to $HOME/$f.bak"
        mv $HOME/$f $HOME/$f.bak
    # if file already exists and IS a symlink, remove it
    elif [[ -L $HOME/$f && -e $HOME/$f ]]; then
        rm -f "$HOME/$f"
    fi
    ln -s $sourcedir/dotfiles/$f $HOME/$f
done
