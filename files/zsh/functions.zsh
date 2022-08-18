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

    # cd to the root of the git repo
    cd "$root_path"
}

# print time remaining for kerberos ticket
function kcheck() {
    # define variables as local
    local kprintstr
    local kdate
    local ktimeleft
    local ktimestr

    # check kerberos ticket
    if (( $+commands[klist] )); then
        if ! klist -s ; then
            kprintstr="%B%F{red}00:00:00%f%b"
        else
            kdate="$(klist | grep 'krbtgt' | awk 'BEGIN { FS="  " } ; { print $2 }')"
            ktimeleft=$(($(date -d "$kdate" +%s) - $(date +%s)))
            ktimestr=$(date -u -d @${ktimeleft} +%T)
            if [[ $ktimeleft -le 18000 ]]; then
                kprintstr="%B%F{yellow}$ktimestr%f%b"
            elif [[ $ktimeleft -le 7200 ]]; then
                kprintstr="%B%F{red}$ktimestr%f%b"
            else
                kprintstr="$ktimestr"
            fi
        fi
        print -P "Kerberos: $kprintstr"
    else
        print -P "Kerberos: %B%F{red}klist not present%f%b"
        return 1
    fi
}

# update various plugins and packages
function updateall () {
    # vim-plug
    if [[ -s $HOME/.vim/autoload/plug.vim ]]; then
        print -P "%F{green}Updating vim:%f"
        vim -c "PlugUpgrade|PlugUpdate"
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
    if [[ -d $HOME/.local/share/tmux/plugins/tpm ]]; then
        print -P "%F{green}Updating tmux:%f"
        $HOME/.local/share/tmux/plugins/tpm/bin/install_plugins
        $HOME/.local/share/tmux/plugins/tpm/bin/update_plugins all
        $HOME/.local/share/tmux/plugins/tpm/bin/clean_plugins
        print
    fi
    # pyenv
    if (( $+commands[pyenv] )); then
        print -P "%F{green}Updating pyenv:%f"
        pyenv update
        ~/.local/share/pyenv/versions/dotfiles/bin/pip install -U $(~/.local/share/pyenv/versions/dotfiles/bin/pip freeze --disable-pip-version-check | awk '{split($0, a, "=="); print a[1]}') --quiet --disable-pip-version-check
        print
    fi
    # homebrew
    if (( $+commands[brew] )); then
        print -P "%F{green}Updating homebrew:%f"
        brew update --force
        brew upgrade
        brew cleanup
        print
    fi
}
