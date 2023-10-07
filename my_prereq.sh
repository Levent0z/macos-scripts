# This script will attempt to install brew and a number of CLI tools via brew.
echo 'This script will attempt to install CLI tools.'

LOC=$(dirname "$0")

function exitIfFailed() {
    RETVAL=$?
    if [[ "$RETVAL" != "0" ]]; then
        echo 'Failed.'
        exit $RETVAL
    fi
}
function exists() {
    which "$1" >/dev/null # returns 1 if not found
}

function installBrew() {
    echo -n 'Install Brew (macos package loader)? (y/n) '
    read RESP
    [[ "$RESP" != 'y' ]] && return
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    exitIfFailed
}

function installNotify() {
    echo 'Install notify: a simple script to do notifications? (y/n) '
    read RESP
    [[ "$RESP" != 'y' ]] && return

    cp "$LOC/notify" /usr/local/bin/
    exitIfFailed
}

function installTermenu() {
    echo 'Install termenu: a CLI helper to enable choices? (y/n) '
    read RESP
    [[ "$RESP" != 'y' ]] && return
    pip3 install termenu
}

function Brew() {
    NAME=$1
    LABEL=$2
    [[ "$LABEL" == "" ]] && LABEL=$NAME
    echo -n "Install $LABEL? (y/n) "
    read RESP
    [[ "$RESP" != 'y' ]] && return
    brew install "$NAME"
    exitIfFailed
}

exists notify || installNotify
exists brew || installBrew
exists bat || Brew 'bat' 'bat: a cat clone with syntax highlighting'
exists fzf || Brew 'fzf' 'fzf: Fuzzy finder'
exists grcat || Brew 'grc' 'grc/grcat: Colorizer'
exists termenu || installTermenu
exists gh || Brew 'gh' 'gh: GitHub CLI'
echo "Done!"
exists notify && notify "Done!" "my_prereq.sh"
