# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions

# If this is a login shell, switch to zsh
if shopt -q login_shell && [[ -e /bin/zsh ]]; then
    SHELL=/bin/zsh
    exec /bin/zsh --login
fi
