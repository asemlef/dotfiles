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
    if [[ -s $HOME/.vim/autoload/plug.vim ]]; then
        print -P "%F{green}Updating vim:%f"
        command vim -c "PlugUpgrade|PlugUpdate"
        print "Update complete."
    fi
    # neovim vim-plug
    if [[ -s $HOME/.local/share/nvim/site/autoload/plug.vim ]]; then
        print -P "%F{green}Updating neovim:%f"
        command nvim -c "PlugUpgrade|PlugUpdate"
        print "Update complete."
    fi
    # zplug
    if [[ -d $HOME/.zplug ]]; then
        print -P "%F{green}Updating zsh:%f"
        zplug update
    fi
    # tmux tpm
    if [[ -d $HOME/.tmux/plugins/tpm ]]; then
        print -P "%F{green}Updating tmux:%f"
        $HOME/.tmux/plugins/tpm/bin/install_plugins
        $HOME/.tmux/plugins/tpm/bin/update_plugins all
        $HOME/.tmux/plugins/tpm/bin/clean_plugins

    fi
    # homebrew
    if (( $+commands[brew] )); then
        print -P "%F{green}Updating homebrew:%f"
        brew upgrade --cleanup
    fi
}
