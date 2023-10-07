alias ghAuthors="gh pr list --limit 1000 --state all --json author --jq '.[].author.login' | sort | uniq"
alias ghPrs="gh pr list | grep -v 'nucleus/upstream_project'"

# alias ghPr='set -i && GHPR=$(gh pr list | fzf | xargs echo | cut -d" " -f1)'
function ghPr() {
    set -i
    GHPR=$(gh pr list | fzf | xargs echo | cut -d" " -f1)
}

alias ghView='ghPr && gh pr view "$GHPR"'

# gh pr view 474 --json comments | jq '.comments[-1].body' | awk -F'\\' '{print $1}' | sed 's/^"#*\s*//'
function ghLc() {
    ghPr
    gh pr view "$GHPR" --json comments | jq ".comments[-1].body" | awk -F'\\' '{print $1}' | sed 's/^"#*\s*//'
}

function nucDeploy() {
    set -i
    ghPr
    gh pr comment "$GHPR" --body '/nucleus deploy'
}
