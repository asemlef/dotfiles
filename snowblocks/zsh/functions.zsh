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

# ssh and automatically create/attach tmux session
function ssht() {
    ssh -t $@ "tmux attach -t 0 || tmux new -s 0"
}

# print time remaining for kerberos ticket
function kcheck() {
    # define variables as local
    local datecmd
    local kprintstr
    local kdate
    local ktimeleft
    local ktimestr

    # use homebrew coreutils date on macos
    if [[ "$OSTYPE" == darwin* ]]; then
        datecmd='gdate'
    else
        datecmd='date'
    fi

    # check kerberos ticket
    if (( $+commands[klist] )); then
        if ! klist -s ; then
            kprintstr="%B%F{red}00:00:00%f%b"
        else
            kdate="$(klist | grep 'krbtgt' | awk 'BEGIN { FS="  " } ; { print $2 }')"
            ktimeleft=$(($($datecmd -d "$kdate" +%s) - $($datecmd +%s)))
            ktimestr=$($datecmd -u -d @${ktimeleft} +%T)
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
        ~/.local/share/pyenv/versions/dotfiles/bin/pip install -U $(~/.local/share/pyenv/versions/dotfiles/bin/pip freeze --disable-pip-version-check | awk '{split($0, a, "=="); print a[1]}') --quiet --disable-pip-version-check
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
