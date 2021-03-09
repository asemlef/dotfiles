#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# VARIABLES
pyver="3.8.5"
ldir=$(dirname $0)

# check if git is available
if ! command -v git > /dev/null; then
    echo "git missing!"
    exit 1
fi

# install pyenv and plugins from git
if [[ ! -d ~/.local/share/pyenv ]]; then
    git clone https://github.com/pyenv/pyenv.git ~/.local/share/pyenv
fi
repos="pyenv-virtualenv
pyenv-update"
for repo in $repos; do
    if [[ ! -d ~/.local/share/pyenv/plugins/$repo ]]; then
        git clone https://github.com/pyenv/$repo.git ~/.local/share/pyenv/plugins/$repo
    fi
done

# set env variables
export PYENV_ROOT="$HOME/.local/share/pyenv"

# install correct python version in pyenv
~/.local/share/pyenv/bin/pyenv install $pyver --skip-existing

# if missing, create virtualenv and install packages in it
if [[ ! -d ~/.local/share/pyenv/versions/dotfiles ]]; then
    ~/.local/share/pyenv/bin/pyenv virtualenv $pyver dotfiles
# if present, check that it's using the correct python version and recreate if not
else
    venv_ver=$(awk '/^version/{print $3}' ~/.local/share/pyenv/versions/dotfiles/pyvenv.cfg)
    if [[ $venv_ver != $pyver ]]; then
        ~/.local/share/pyenv/bin/pyenv uninstall --force dotfiles
        ~/.local/share/pyenv/bin/pyenv virtualenv $pyver dotfiles
    fi
fi
~/.local/share/pyenv/versions/dotfiles/bin/pip install --requirement $ldir/pip-pkgs.txt --quiet --disable-pip-version-check

# symlink pylint
if [[ ! -d ~/.local/bin ]]; then
    mkdir ~/.local/bin
fi
if [[ ! -L ~/.local/bin/pylint ]]; then
    ln -s ~/.local/share/pyenv/versions/dotfiles/bin/pylint ~/.local/bin/pylint
fi
