# ------------------------------
# Aliases
# ------------------------------
# use coreutils for macOS
if [[ "$OSTYPE" == darwin* ]]; then
    alias ls='gls'
    alias base64='gbase64'
    alias du='gdu'
    alias date='gdate'
fi

# use aliases with sudo
alias sudo='sudo '

# use neovim instead of vim
if (( $+commands[nvim] )); then
    alias vim='nvim'
fi

# use pretty color output where possible
alias ls="${aliases[ls]:-ls} --color=auto"
alias grep="${aliases[grep]:-grep} --color=auto"
if (( $+commands[colordiff] )); then
    alias diff='colordiff'
fi

# always prompt when removing or overwriting files
alias rm="${aliases[rm]:-rm} -i"
alias cp="${aliases[cp]:-cp} -i"
alias mv="${aliases[mv]:-mv} -i"
alias ln="${aliases[ln]:-ln} -i"

# format diff nicely
alias diff="${aliases[diff]:-diff} -u"

# automatically create parent directories with mkdir
alias mkdir="${aliases[mkdir]:-mkdir} -p"
