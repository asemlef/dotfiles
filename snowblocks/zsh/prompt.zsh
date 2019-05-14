# ------------------------------
# Helper Functions
# ------------------------------
function +vi-git-stashes() {
    stashes=$(command git stash list 2> /dev/null | wc -l)
    if [[ stashes -gt 0 ]]; then
        hook_com[misc]+="%F{240}  ${stashes// /}%f"
    fi
}

function +vi-git-untracked() {
    if [[ -n $(command git status --porcelain 2> /dev/null | grep -E '^\?\?' 2> /dev/null) ]]; then
        hook_com[unstaged]+="%F{yellow} %f"
    fi
}

function +vi-git-aheadbehind() {
    ahead=$(command git rev-list --count HEAD@{upstream}..HEAD 2> /dev/null)
    if [[ ahead -ge 1 ]]; then
        hook_com[misc]+="%F{red}  ${ahead}%f"
    fi

    behind=$(command git rev-list --count HEAD..HEAD@{upstream} 2> /dev/null)
    if [[ behind -ge 1 ]]; then
        hook_com[misc]+="%F{red}  ${behind}%f"
    fi
}

function get_background_jobs() {
    jobcount=$(jobs -l | wc -l)

    echo "$jobcount"
}

# ------------------------------
# VCS Info
# ------------------------------
setopt prompt_subst		# allow functions in prompt
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
# custom icons
zstyle ':vcs_info:*' stagedstr '%F{yellow} %f'
zstyle ':vcs_info:*' unstagedstr '%F{yellow} %f'
# hooks
zstyle ':vcs_info:git*+set-message:*' hooks git-stashes git-untracked git-aheadbehind
# prompt format
zstyle ':vcs_info:*' formats '| %F{green} %b%f%c%u%m'
zstyle ':vcs_info:*' actionformats '| %F{green} %b%f%F{red}|%a%f%c%u%m'

precmd() {
    vcs_info
}

# ------------------------------
# Prompt Layout
# ------------------------------
if [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" ]]; then
    host_icon="@"
    host_color="$(hostname | sum | awk '{print 1 + ($1 % 255)}')"
else
    host_icon="^"
    host_color="white"
fi

PROMPT=$'
%(?.%F{$host_color}$host_icon%f.%F{red}%?%f):%F{blue}%~%f ${vcs_info_msg_0_}
%(!.#.$) '
RPROMPT=$'%F{cyan}%(1j. %j.)%f'
