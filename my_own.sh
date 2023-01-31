# This file contains values hardcoded for my own use.
ID=$(whoami)
if [[ "$ID" != "loz" ]] && [[ "$ID" != "leventoz" ]]; then
    echo "Do not use this script without modifications"
    return 1
fi

FULLNAME='Levent Oz'
DEVEMAIL='leventoz.dev@gmail.com'
RSANAME='l0z_id_rsa'

alias redoAsMe="git commit --amend --author='$FULLNAME <$DEVEMAIL>'"

function gitAsMe() {
    git config --local user.name $FULLNAME
    git config --local user.email $DEVEMAIL
    export GIT_SSH_COMMAND="ssh -i $HOME/.ssh/$RSANAME"
}

function scpmy() {
    [[ -z $MYREMOTEIP ]] && echo 'Please set MYREMOTEIP by running ipv on the remote machine' && return 1
    scp -i /Users/loz/.ssh/id_rsa_ltm -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=QUIET "$MYREMOTEIP:$1" "$2"
}

function mountOznas() {
    cd ~/oznas/node-server
    mount -t smbfs //leventoz@OZNAS/node-server .
}

function sshOznas() {
    [[ `hostname` == 'OZNAS' ]] && echo 'Already on oznas.' && exit 1
    ssh oznas -p 220
}

gitNoPager
