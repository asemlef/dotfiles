#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# check for requisite utilities
utilities=(curl grep cut tr wget)
for util in "${utilities[@]}"; do
    if ! hash $util 2> /dev/null; then
        echo "'$util' not found!"
        exit 1
    fi
done

# download latest neovim from github (requires FUSE)
curl https://api.github.com/repos/neovim/neovim/releases/latest \
    | grep "browser_download_url.*appimage\"" \
    | cut -d : -f 2,3 \
    | tr -d \" \
    | wget -qi - -O ~/.local/bin/nvim
chmod +x ~/.local/bin/nvim
