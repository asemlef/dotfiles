# ------------------------------
# Aliases
# ------------------------------
# use coreutils for macOS
if [[ "$OSTYPE" == darwin* ]]; then
    alias ls='gls --color=auto'
else
    alias ls='ls --color=auto'
fi

# always prompt when removing or overwriting files
alias rm="${aliases[rm]:-rm} -i"
alias cp="${aliases[cp]:-cp} -i"
alias mv="${aliases[mv]:-mv} -i"
alias ln="${aliases[ln]:-ln} -i"

# misc useful
alias mkdir="${aliases[mkdir]:-mkdir} -p"
