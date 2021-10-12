# Android
alias and='open "/Applications/Android Studio.app"'
alias emu='~/Library/Android/sdk/tools/emulator'
alias etch='~/hostsfix.sh && adb root && adb remount && adb push /etc/hosts /etc/hosts'
alias studio='open /Applications/Android\ Studio.app/Contents/MacOS/studio'
alias wemu='emu -avd Pixel3XLAPI28_3 -writable-system'

# heroku autocomplete setup
#HEROKU_AC_BASH_SETUP_PATH=$HOME/Library/Caches/heroku/autocomplete/bash_setup && test -f $HEROKU_AC_BASH_SETUP_PATH && source $HEROKU_AC_BASH_SETUP_PATH;

# IDEA
alias ideace='open "/Applications/IntelliJ IDEA CE.app"'
alias ideareset='rm -rf .idea && rm -rf .ijwb'

# Java
alias ejh='echo $JAVA_HOME'
alias jhclear='unset JAVA_HOME'

# Maven
alias em2='echo $M2_HOME'
alias m2clear='unset M2_HOME'
alias m2354="export M2_HOME='$HOME/sdk/apache-maven-3.5.4'"
alias m2360="export M2_HOME='$HOME/sdk/apache-maven-3.6.0'"
alias m2362="export M2_HOME='$HOME/sdk/apache-maven-3.6.2'"
alias mvnp='mvn clean package'
alias mvni='mvn install -DskipUnitTests=true -DskipJsDoc'

# NPM
alias npmg='npm list -g --depth 0' # List globally installed packages

function buildLoop() {
    # Watch src folder, build on changes
    fswatch src | while read; do npm run build:development; done
}

function npmrun() {
    echo OPTIONS
    cat package.json | jq .scripts | tail +2 | sed '$d'
    echo "SELECT TO RUN:"
    list=$(cat package.json | jq '.scripts | keys | .[]' | sed 's/"//g' | tr -s "\n" " ")
    COLUMNS=1
    select sel in $list; do
        npm run $sel
        break
    done
}

# Self
alias dox='pushd ~/github/levent0z/docsify'

# Volta
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
