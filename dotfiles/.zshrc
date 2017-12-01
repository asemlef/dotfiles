# use 256 colors
export TERM="xterm-256color"

# use all the fancy icons
POWERLEVEL9K_MODE='nerdfont-complete'

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# history
HISTSIZE=999999
SAVEHIST=999999
HISTFILE=~/.zhistory
setopt inc_append_history
setopt no_share_history

# tab completion
zstyle ':completion:::::' completer _complete _approximate
zstyle ':completion:*:descriptions' format "- %d -"
zstyle ':completion:*:corrections' format "- %d - (errors %e})"
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections true
zstyle ':completion:*' menu select
zstyle ':completion:*' verbose yes

# source secondary config files
for f in zshrc_pl9k zshrc_functions; do
    if [[ -s ${ZDOTDIR:-$HOME}/.$f ]]; then
        source ${ZDOTDIR:-$HOME}/.$f
    fi
done

# source local config (if extant)
[[ -s ${ZDOTDIR:-$HOME}/.zshrc_local ]] && source ${ZDOTDIR:-$HOME}/.zshrc_local
