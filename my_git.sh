alias glo='git log --oneline -n20'
alias gs='git status'
alias nogpg='git config commit.gpgsign false'
alias pdgithub='pushd ~/github'

## Use "gh prs" to show open PRs using GitHub CLI
which gh >/dev/null && gh alias set prs "api -X GET search/issues  -f q='is:open, author:$(whoami), is:pr' --jq '.items[].html_url'" >/dev/null

## Git log with optional args
function gl() {
  if [ -z $1 ]; then
    ARG=
  else
    ARG=-n$1
  fi
  git log --pretty=format:"%h%x09%an%x09%ad%x09%s" --date=iso $ARG
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
    echo "user.name: `git config --get user.name`"
    echo "user.email: `git config --get user.email`"
    echo "GIT_SSH_COMMAND=$GIT_SSH_COMMAND"
    [[ -z "$GIT_SSH_COMMAND" ]] && echo 'Use "gitSsh filename" to set GIT_SSH_COMMAND env variable'
    return 0
}
