# This file contains values hardcoded for my own use.
ID=$(whoami)
if [[ "$ID" != "loz" ]] && [[ "$ID" != "leventoz" ]] && [[ "$USER_NAME" != "loz" ]] && [[ "$SSO_USERNAME" != "loz" ]]; then
    echo "Do not use this script without modifications"
    return 1
fi

alias dox='pushd ~/github/levent0z/docsify'

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
    [[ $(hostname) == 'OZNAS' ]] && echo 'Already on oznas.' && exit 1
    ssh oznas -p 220
}

gitNoPager

alias ozl='yarn --cwd "$HOME/github/levent0z/ozl" node --loader ts-node/esm index.ts'
#setcog

alias pdmy='pushd "$HOME/bitbucket/loz"'

psz

function renamePdfs() {
    echo -n "This will rename all PDF files in the current directory. Do you want to continue? (y/n) "
    read -r REPLY
            
    echo    # move to a new line
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Operation cancelled."
        return 1
    fi

    # get count of PDF files
    pdf_count=$(ls -1 *.pdf 2>/dev/null | wc -l | tr -d ' ')
    
    # Iterate through all PDF files in the current directory
    for file in *.pdf; do
        if [[ -f "$file" ]]; then
            echo "Processing: $file ($((pdf_count--)) remaining...)"
            /Users/leventoz/github/levent0z/rename-pdf/rename-pdf.mjs "$file"
        else
            echo "No PDF files found in the current directory."
        fi
    done    
}