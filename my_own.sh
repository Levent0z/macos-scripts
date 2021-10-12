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
