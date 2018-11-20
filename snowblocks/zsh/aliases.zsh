# ------------------------------
# Aliases
# ------------------------------
# use aliases with sudo
alias sudo='sudo '

# use neovim instead of vim
if (( $+commands[nvim] )); then
    alias vim='nvim'
fi

# use color with ls
if [[ "$OSTYPE" == darwin* ]]; then
    if (( $+commands[gls] )); then
        alias ls="gls --color=auto"
    else
        alias ls="ls -G"
    fi
else
    alias ls="ls --color=auto"
fi

# alternate ls alias with nice formatting
alias ll="${aliases[ls]:-ls} -lA"

# format diff nicely and use color if possible
if (( $+commands[colordiff] )); then
    alias diff='colordiff -u'
else
    alias diff='diff -u'
fi

# use color with grep
alias grep="grep --color=auto"

# always prompt when removing or overwriting files
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"
alias ln="ln -i"

# automatically create parent directories with mkdir
alias mkdir="mkdir -p"
