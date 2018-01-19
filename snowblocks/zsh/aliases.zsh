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

# use neovim instead of vim
if (( $+commands[nvim] )); then
    alias vim='nvim'
fi

# always prompt when removing or overwriting files
alias rm="${aliases[rm]:-rm} -i"
alias cp="${aliases[cp]:-cp} -i"
alias mv="${aliases[mv]:-mv} -i"
alias ln="${aliases[ln]:-ln} -i"

# use color diff output
alias diff="${aliases[diff]:-diff} --old-line-format=$'\e[0;31m%L\e[0m' --new-line-format=$'\e[0;32m%L\e[0m'"

# misc useful
alias mkdir="${aliases[mkdir]:-mkdir} -p"
alias ls="${aliases[ls]:-ls} --color=auto"
