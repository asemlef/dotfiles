# ------------------------------
# Functions
# ------------------------------
# cd to root directory of git repo
function cdg () {
    # check if inside git repo and do nothing if not
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) != 'true' ]]; then
        return 1
    fi

    # get root path of git repo
    local root_path=$(git rev-parse --show-toplevel)

    # ensure home directory path is correct
    if [[ $root_path == /local/home* ]]; then
        local root_path=${root_path/\/local\/home/\/home}
    fi

    # cd to the root of the git repo
    cd "$root_path"
}

# update various plugins and packages
function updateall () {
    # vim-plug
    if [[ -s $HOME/.local/share/nvim/site/autoload/plug.vim ]]; then
        print -P "%F{green}Updating vim:%f"
        if (( $+commands[nvim] )); then
            nvim -c "PlugUpgrade|PlugUpdate"
        else
            vim -c "PlugUpgrade|PlugUpdate"
        fi
        print "Update complete."
        print
    fi
    # zplug
    if [[ -d $HOME/.local/share/zplug ]]; then
        print -P "%F{green}Updating zsh:%f"
        zplug update
        print
    fi
    # tmux tpm
    if [[ -d $HOME/.tmux/plugins/tpm ]]; then
        print -P "%F{green}Updating tmux:%f"
        $HOME/.tmux/plugins/tpm/bin/install_plugins
        $HOME/.tmux/plugins/tpm/bin/update_plugins all
        $HOME/.tmux/plugins/tpm/bin/clean_plugins
        print
    fi
    # pyenv
    if (( $+commands[pyenv] )); then
        print -P "%F{green}Updating pyenv:%f"
        pyenv update
        ~/.local/share/pyenv/versions/3.7.0/envs/dotfiles/bin/pip install -U $(~/.local/share/pyenv/versions/3.7.0/envs/dotfiles/bin/pip freeze --disable-pip-version-check | awk '{split($0, a, "=="); print a[1]}') --quiet --disable-pip-version-check
        print
    fi
    # homebrew
    if (( $+commands[brew] )); then
        print -P "%F{green}Updating homebrew:%f"
        brew update --force
        brew upgrade --cleanup
        brew cask upgrade
        print
    fi
}
