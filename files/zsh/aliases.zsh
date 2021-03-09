# ------------------------------
# Aliases
# ------------------------------
# use aliases with sudo
alias sudo='sudo '

# use color with ls
alias ls="ls --color=auto"

# alternate ls alias with nice formatting
alias ll="ls -lA"

# format diff nicely (color requires diff 3.6+)
alias diff='diff -u --color'

# use color with grep
alias grep="grep --color=auto"

# always prompt when removing or overwriting files
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"
alias ln="ln -i"

# automatically create parent directories with mkdir
alias mkdir="mkdir -p"

# attach to tmux session if extant, else create one
alias t="tmux attach || tmux new-session"
