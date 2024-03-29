alias bp='code ~/.bash_profile'
alias cd..='cd ..'
alias cd1='pushd .. >/dev/null'
alias cd2='pushd ../.. >/dev/null'
alias cd3='pushd ../../.. >/dev/null'
alias cd4='pushd ../../../.. >/dev/null'
alias cd5='pushd ../../../../.. >/dev/null'
alias clearb='echo -n -e "\e[2J\e[3J\e[1;1H"' # clear screen and scroll buffer
alias cpuspeed='pmset -g therm | grep CPU_Speed_Limit | cut -d" " -f3'
alias codez='code ~/.zshrc'
alias dateiso='date -u +"%Y-%m-%dT%H:%M:%SZ"'
alias dusage='du -sh *' # disk usage
alias ll='ls -hpGoAtr'  # -h: use units for sizes; -p: /-suffix for folders; -G: colorized; -o: list, but group ID omitted; -A: all entries except . and ..; -t: sort on time; -r: reverse sort
#Also see lsx function below
alias lx='script -q /dev/null ls -pGA1 | sort -bf' # maintain colors, use 1 column, sort case-insensitively (colors needed to sort inside groups: executables, folders, links, files)
alias ps0=$PS1
alias ps1='PS1="\n\[\e[1;37m\]\t \[\e[1;33m\]\h \[\e[1;36m\]\w \[\e[1;31m\]\$(git_branch_text)\n\[\e[1;36m\]o>\[\e[0;37m\]"'
alias ps2='PS1="\n\[\e[0;33m\]\t \[\e[1;33m\]\h \[\e[1;36m\]\w \[\e[1;31m\]$(git_branch_text)\n\[\e[1;36m\]o>\[\e[0;0m\]"'
alias sbp='source ~/.bash_profile'
alias therm='pmset -g thermlog'
alias wrapoff='tput rmam' #word-wrap disable
alias wrapon='tput smam'  #word-wrap enable

# Not needed in zsh
# export PS1="\n\[\e[1;37m\]\t \[\e[1;33m\]\h \[\e[1;36m\]\w \[\e[1;31m\]\$(git_branch_text)\n\[\e[1;36m\]o>\[\e[0;37m\]"

# These foreground colors are based on standard color modes
# https://en.wikipedia.org/wiki/ANSI_escape_code
export NOCOLOR='\033[0m'
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export ORANGE='\033[0;33m'
export BLUE='\033[0;34m'
export PURPLE='\033[0;35m'
export CYAN='\033[0;36m'
export LIGHTGRAY='\033[0;37m'
export DARKGRAY='\033[1;30m'
export LIGHTRED='\033[1;31m'
export LIGHTGREEN='\033[1;32m'
export YELLOW='\033[1;33m'
export LIGHTBLUE='\033[1;34m'
export LIGHTPURPLE='\033[1;35m'
export LIGHTCYAN='\033[1;36m'
export WHITE='\033[1;37m'

# These are from the ANSI-defined 256-color lookup table
function colorBg256() {
    printf '\033[48;5;%dm' $1
}
function colorBgRgb() {
    printf '\033[48;2;%d;%d;%dm' $1 $2 $3
}
function colorFg256() {
    printf '\033[38;5;%dm' $1
}
function colorFgRgb() {
    printf '\033[38;2;%d;%d;%dm' $1 $2 $3
}
function colorReset() {
    printf "$NOCOLOR"
}

function echoColor() {
    # Specify first argument as the color, second argument as the line
    echo "$1${@:2}$NOCOLOR"
}

function exists() {
    which "$1" >/dev/null # returns 1 if not found
}

function exitIfFailed() {
    RETVAL=$?
    if [[ "$RETVAL" != "0" ]]; then
        echo 'Failed.'
        exit $RETVAL
    fi
}

function findstr() {
    grep -r "$1" .
}

function findstrf() {
    if [ -z $1 ]; then
        echo 'Please provide glob filter as your first argument (e.g. *.js)'
        return 1
    fi
    if [ -z $2 ]; then
        echo 'Please provide a keyword expression as your second argument'
    fi
    find . -type f -name "$1" | xargs -P4 grep $2
}

# Returns 0 is the first argument ends with /
function isFolder() {
    echo "$*" | grep -E '/$' >/dev/null
}

# Get the path of a given process via its ID
function getProcPath() {
    if [ -z $1 ]; then
        echo Please provide a Process ID
    else
        ps -p $1 -o args=
    fi
}

function lsx() {
    RESULT=$(ls -pA1 $1 | sort -bf)
    while read LINE; do
        isFolder "$LINE" && echoColor $LIGHTBLUE "$LINE"
    done <<<$RESULT

    while read LINE; do
        isFolder "$LINE" || echo "$LINE"
    done <<<$RESULT
    return 0
}

function md() {
    mkdir -p "$1" && pushd "$1"
}

function of() {
    # Show processes with top open files
    lsof | awk '{print $1}' | sort | uniq -c | sort -rn | head
}

function sd() {
    # Switch directory with ability to go back to previous one if history and no argument
    local PREVDIR
    if [[ -z "$1" ]]; then
        if [[ -z "$MY_SD_PATH" ]]; then
            echo "No previous folder to switch back to"
            return 1
        else
            # Go back to the previous one
            PREVDIR="$PWD"
            pushd "$MY_SD_PATH" >/dev/null
        fi
    else
        # Save current as previous, and switch to specified one
        PREVDIR="$PWD"
        pushd "$1" >/dev/null
    fi

    [[ $? == 0 ]] && export MY_SD_PATH="$PREVDIR" && echo "OLD PATH: $PREVDIR" && echo "NEW PATH: $PWD"
}

function pd() {
    if [[ -z "$1" ]]; then
        sd
    else
        local DIR
        if [[ -d "$1" ]]; then
            DIR="$1"
        elif [[ -f "$1" ]]; then
            DIR=$(dirname "$1")
        else
            echo 'Invalid path to file or folder'
            return 1
        fi
        echo "$DIR" | grep -e '^/' >/dev/null
        if [[ $? != 0 ]]; then
            DIR="$PWD/$DIR"
        fi
        sd "$DIR" >/dev/null
    fi
}

function flatSize() {
    # Returns the total size of the immediate folders
    for A in $(ls -1p | grep -e "/$"); do
        pushd "$A" >/dev/null
        find . -type f -print0 | xargs -0 stat -f %z | awk '{t+=$1}END{print ENVIRON["PWD"],t}'
        popd >/dev/null
    done
}

function whichSh() {
    local CMD=$(ps -p $$ -o command | tail -1)
    local CMDP=$(echo $CMD | cut -f 1 -d ' ')

    if [[ "$CMDP" =~ ^- ]]; then
        # For Linux running on NAS
        CMDP=$(echo $CMD | cut -f 2 -d '-')
    fi

    which "$CMDP" | xargs ls -l
}

function scriptFolder() {
    # Returns the folder of the script
    local script_dir="$(cd "$(dirname "$0")" && pwd)"
    echo "$script_dir"
}

function dir() {
    local DIR="$1"
    [[ -z "$DIR" ]] && DIR="$PWD"
    cat <(ls -hpoal "$DIR" | grep -e '^d' | sort -f -k 8) <(ls -hpoal "$DIR" | grep -v '^d' | sort -f -k 8) | grep -v '^total'
}
