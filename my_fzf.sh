# This file depends on fzf (https://github.com/junegunn/fzf), do `brew install fzf` to install.

alias fz='fzf -q'     # Requires an argument
alias fze='fzf -e +i' # Fuzzy find exact, case-sensitive
alias h='history | cut -c 8- | fzf --tac'
alias h2='fc -lrn | fzf' # mostly the same thing as above

export BAT_PAGER="less -R" # for BAT, do `brew install bat` to install
export EDITOR="code -w"

#export FZF_DEFAULT_OPTS="--no-mouse --height 50% -1 --reverse --multi --inline-info --preview='[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style=numbers --color=always {} || cat {}) 2> /dev/null | head -300' --preview-window='right:hidden:wrap' --bind='f3:execute(bat --style=numbers {} || less -f {}),f2:toggle-preview,ctrl-d:half-page-down,ctrl-u:half-page-up,ctrl-a:select-all+accept,ctrl-y:execute-silent(echo {+} | pbcopy)'"
export FZF_DEFAULT_OPTS="--height 50% -1 --reverse --multi --inline-info --preview='[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style=numbers --color=always {} || cat {}) 2> /dev/null | head -300' --preview-window='right:hidden:wrap' --bind='f3:execute(bat --style=numbers {} || less -f {}),f2:toggle-preview,ctrl-d:half-page-down,ctrl-u:half-page-up,ctrl-a:select-all+accept,ctrl-y:execute-silent(echo {+} | pbcopy)'"
#FD_OPTIONS="--follow --exclude .git --exclude node_modules"
## Use git-ls-files inside git repo, otherwise fd
#export FZF_DEFAULT_COMMAND="git ls-files --cached --others --exclude-standard | fd --type f --type l $FD_OPTIONS"
#export FZF_CTRL_T_COMMAND="fd $FD_OPTIONS"
#export FZF_ALT_C_COMMAND="fs --type d $FD_OPTIONS"

function fullpath() {
    f1=$(fzf -q$1 | xargs)
    f2=$(pwd)/${f1}
    echo $(dirname ${f2})
}

## DEPRECATED alias pd='pushd `fzf | xargs dirname`'
# "pushd"
function pd() {
    if [ -z "$1" ]; then
        SELECTION=$(fzf)
    else
        SELECTION=$(fzf -q "$1")
    fi

    if [ $? -eq "0" ]; then
        pushd $(dirname "$SELECTION")
    else
        echo Aborted.
    fi
}
