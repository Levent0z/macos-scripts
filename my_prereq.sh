# This script will attempt to install brew and a number of CLI tools via brew.
echo 'This script will attempt to install CLI tools.'

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
    read -p 'Install Brew (macos package loader)? (y/n) ' RESP
    [[ "$RESP" != 'y' ]] && return
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    exitIfFailed
}

function installNotify() {
    read -p 'Install notify: a simple script to do notifications? (y/n) ' RESP
    [[ "$RESP" != 'y' ]] && return

    LOC=$(dirname "$0")
    cp "$LOC/notify" /usr/local/bin/
    exitIfFailed
}

function Brew() {
    NAME=$1
    LABEL=$2
    [[ "$LABEL" == "" ]] && LABEL=$NAME
    read -p "Install $LABEL? (y/n) " RESP
    [[ "$RESP" != 'y' ]] && return
    brew install "$NAME"
    exitIfFailed
}

exists notify || installNotify
exists brew || installBrew
exists bat || Brew 'bat' 'bat: a cat clone with syntax highlighting'
exists fzf || Brew 'fzf' 'fzf: Fuzzy finder'

echo "Done!"
exists notify && notify "Done!" "my_prereq.sh"
