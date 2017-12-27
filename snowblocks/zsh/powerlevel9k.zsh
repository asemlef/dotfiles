# ------------------------------
# Powerlevel9k Configuration
# ------------------------------
# prompt layout
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(host dir dir_writable vcs newline time)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status background_jobs command_execution_time)
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

# time
if [[ $UID == 0 || $EUID == 0 ]]; then
    local clock_icon="\uF198" # 
    POWERLEVEL9K_TIME_FOREGROUND='magenta'
    POWERLEVEL9K_TIME_BACKGROUND='black'
else
    local clock_icon="\uF017" # 
    POWERLEVEL9K_TIME_FOREGROUND='011'
    POWERLEVEL9K_TIME_BACKGROUND='black'
fi
POWERLEVEL9K_TIME_FORMAT="$clock_icon %D{%H:%M:%S}"

# host
POWERLEVEL9K_HOST_ICON="\uF109" # 
POWERLEVEL9K_HOST_REMOTE_FOREGROUND="white"
POWERLEVEL9k_HOST_LOCAL_FOREGROUND="white"

# root indicator
#POWERLEVEL9K_ROOT_ICON="\uF198" # 
#POWERLEVEL9K_ROOT_INDICATOR_FOREGROUND="black"
#POWERLEVEL9K_ROOT_INDICATOR_BACKGROUND="magenta"

# execution time
POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=5
POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='245'
POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='black'

# directory path
POWERLEVEL9K_SHORTEN_DIR_LENGTH=8
POWERLEVEL9K_SHORTEN_DELIMITER="…"
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"
POWERLEVEL9K_DIR_PATH_SEPARATOR="%F{black} $(print_icon 'LEFT_SUBSEGMENT_SEPARATOR') %F{black}"
POWERLEVEL9K_HOME_FOLDER_ABBREVIATION="$(print_icon 'HOME_ICON')"
POWERLEVEL9K_DIR_OMIT_FIRST_CHARACTER=true

# misc icons
POWERLEVEL9K_HOME_SUB_ICON="$(print_icon 'HOME_ICON')"
POWERLEVEL9K_FOLDER_ICON=''
POWERLEVEL9K_VCS_GIT_ICON=''
POWERLEVEL9K_VCS_GIT_GITHUB_ICON=''
POWERLEVEL9K_VCS_GIT_BITBUCKET_ICON=''
POWERLEVEL9K_VCS_GIT_GITLAB_ICON=''

# misc settings
POWERLEVEL9K_STATUS_OK=false
