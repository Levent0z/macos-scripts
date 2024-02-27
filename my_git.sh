alias gb='git branch --show-current'
alias gs='git status'
alias nogpg='git config commit.gpgsign false'
alias pdgithub='pushd ~/github'

## Use "gh prs" to show open PRs using GitHub CLI
which gh >/dev/null && ! (gh alias list | grep -E '^prs:' >/dev/null) && gh alias set prs "api -X GET search/issues  -f q='is:open, author:$(whoami), is:pr' --jq '.items[].html_url'" >/dev/null

function gl() {
    local LINES=10
    [[ -z $1 ]] || LINES=$1
    git log --pretty=format:"%h%x09%an%x09%ad%x09%s" --date=iso -n$LINES
}

function glo() {
    local LINES=10
    [[ -z $1 ]] || LINES=$1
    git log --oneline -n$LINES
}

## Git Fetch Upstream
function gfu() {
    git checkout master && git fetch upstream && git rebase upstream/master
}

## Git Fetch Origin
function gfo() {
    git checkout master && git fetch origin && git rebase origin/master
}

## Git Remote Add
function gra() {
    # Git remote add upstream, assuming fetch and push URLs are the same for "origin"
    if [ -z $1 ]; then
        echo 'Please provide the upstream repo org name'
        return 1
    fi

    local ORIGIN=$(git remote -v | grep -e "^origin" | head -1 | cut -c 8- | cut -d' ' -f1)
    local LEFT=$(echo $ORIGIN | cut -d':' -f1)
    local RIGHT=$(echo $ORIGIN | cut -d'/' -f2)
    local UPSTREAM="$LEFT:$1/$RIGHT"
    git remote add upstream $UPSTREAM
    git remote -v | grep -e "^upstream"
}

# Returns 1 if git branch has changes
function gd() {
    if [[ $(git status 2>/dev/null | tail -n1) != *"working tree clean"* ]]; then
        return 1
    else
        return 0
    fi
}

function parse_git_dirty() {
    [[ $(git status 2>/dev/null | tail -n1) != *"working tree clean"* ]] && echo "*"
}

function parse_git_branch() {
    git branch --no-color 2>/dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1/"
}

function parse_git_branch_dirty() {
    git branch --no-color 2>/dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}

function git_branch_text() {
    #outputs a text to use in export PS1 statement
    local gb=$(parse_git_branch)
    [[ -n "$gb" ]] && echo "$gb$(parse_git_dirty)"
}

# Use a specific SSH file when pushing to git
function gitSsh() {
    if [ -z $1 ]; then
        echo "Please specify the name of the private SSH file under $HOME/.ssh"
        return 1
    fi
    export GIT_SSH_COMMAND="ssh -i $HOME/.ssh/$1"
}

function gitWho() {
    echo "user.name: $(git config --get user.name)"
    echo "user.email: $(git config --get user.email)"
    echo "GIT_SSH_COMMAND=$GIT_SSH_COMMAND"
    [[ -z "$GIT_SSH_COMMAND" ]] && echo 'Use "gitSsh filename" to set GIT_SSH_COMMAND env variable'
    return 0
}

function gitPoke() {
    # Use this function to push an empty commit to retrigger CI
    if [[ $(git status -s) == '' ]]; then
        git commit -m "chore: retrigger checks" --allow-empty && git push
    else
        echo 'You have uncommitted changes'
        return 1
    fi
}

function gitNoPager() {
    # Prevents git log and git branch from opening theit outputs in less
    git config --global pager.branch false
    git config --global pager.log false
}

function gitTheirs() {
    local CONFLICTING=$(git diff --name-only --diff-filter=U)
    echo "$CONFLICTING"
    echo -n 'This will "accept theirs" and git add the above files. Are you sure? (y/N) '
    read RESP
    [[ "$RESP" != 'y' ]] && [[ "$RESP" != 'Y' ]] && echo 'Nothing done.' && return
    echo "$CONFLICTING" | xargs git checkout --theirs
    echo "$CONFLICTING" | xargs git add
    echo -n 'Continue with rebase? (Y/n) '
    read RESP
    [[ "$RESP" == 'n' ]] || [[ "$RESP" == 'N' ]] && echo 'Skipped.' && return
    git rebase --continue
}

function gitPr() {
    if [ -z "$1" ]; then
        echo 'Please specify the PR number'
        return 1
    fi
    git fetch upstream "pull/$1/head:PR$1" && git checkout PR$1
}

function gitHistory() {
    # Hack
    local MY_PATH="$HOME/github/levent0z/macos-scripts"
    "$MY_PATH/git_history.sh" "$1"
}

function gcb() {
    [[ -z $1 ]] && echo 'Please specify a suffix to the branch' && return 1
    git checkout -b $(date "+%y%m%d")-$1
}

function gpo() {
    git push -u origin $(git branch | grep '*' | cut -d ' ' -f2)
}

function gro() {
    echo -n 'This will git restore all files in the current status (including untracked files). Are you sure? (y/N) '
    read RESP
    [[ "$RESP" != 'y' ]] && [[ "$RESP" != 'Y' ]] && echo 'Nothing done.' && return
    git status --porcelain | awk -F' ' '{ print $2 }' | xargs git restore
}
