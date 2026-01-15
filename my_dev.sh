# Android
alias and='open "/Applications/Android Studio.app"'
alias emu='~/Library/Android/sdk/tools/emulator'
alias etch='~/hostsfix.sh && adb root && adb remount && adb push /etc/hosts /etc/hosts'
alias studio='open /Applications/Android\ Studio.app/Contents/MacOS/studio'
alias wemu='emu -avd Pixel3XLAPI28_3 -writable-system'

# Bazel
alias bzclean='bazel clean --expunge'

# heroku autocomplete setup
#HEROKU_AC_BASH_SETUP_PATH=$HOME/Library/Caches/heroku/autocomplete/bash_setup && test -f $HEROKU_AC_BASH_SETUP_PATH && source $HEROKU_AC_BASH_SETUP_PATH;

# IDEA
alias ideace='open "/Applications/IntelliJ IDEA CE.app"'
alias ideareset='rm -rf .idea && rm -rf .ijwb'

# Java
alias ejh='echo $JAVA_HOME'
alias jhclear='unset JAVA_HOME'
alias usjh='unset JAVA_HOME'
# Tip: vim can be used to view inside a JAR file

# Maven
alias em2='echo $M2_HOME'
alias m2clear='unset M2_HOME'
alias usm2='unset M2_HOME'
alias m2354="export M2_HOME='$HOME/sdk/apache-maven-3.5.4'"
alias m2360="export M2_HOME='$HOME/sdk/apache-maven-3.6.0'"
alias m2362="export M2_HOME='$HOME/sdk/apache-maven-3.6.2'"
alias mvnp='mvn clean package'
alias mvni='mvn install -DskipUnitTests=true -DskipJsDoc'
alias mvnnot='mvn install -DskipTests'              # compile the tests but skip executing them. (`-DskipTests` is recognized by the Surefire plugin.)
alias mvnskipt='mvn install -Dmaven.test.skip=true' # completely skip compiling and executing tests
# mvn clean install -DskipTests # this worked
alias mvnx='mvn install -DskipUnitTests=true -DskipJsDoc -DskipTests -Dmaven.test.skip=true' # just add all parameters whichever is used
alias mvns='mvn spotless:apply'

function mvnGet() {
    local REPO=$1       #e.g. https://phx-nexus-proxy.internal.salesforce.com
    local ARTIFACT=$2   # e.g. com.salesforce.armada:scs-client:LATEST:jar
    local TRANSITIVE=$3 # e.g. false
    local DEST=$4       #e.g. scs-client.jar
    mvn dependency:get -DrepoUrl=$REPO -Dartifact=$ARTIFACT -Dtransitive=$TRANSITIVE -Ddest=$4
}

# NPM
alias npmg='npm list -g --depth 0'                              # List globally installed packages
alias yarnlinklist='ll -R ~/.config/yarn/link'                  # List linked packages recursively
alias yarnlinked='find node_modules -type l | grep -v "/.bin/"' # Show linked folders except for those that contain .bin in the path

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

# Chrome
alias nocert-chrome="pkill -x 'Google Chrome$' && sleep 2; open -a 'Google Chrome' --args --ignore-certificate-errors"

# Volta
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# MacOS App Nap
alias noappnap='defaults write NSGlobalDomain NSAppSleepDisabled -bool YES'

# XCode
alias xi='xcode-select --install'

function runJar() {
    # Example JAR: target/o11y-processing-service.jar
    # Processes the JSON log entries in stdout, and replaces the `\n` text with actual newlines
    [[ -z $1 ]] && echo 'Usage: runJar <jarfile>' && return 1
    [[ -z "$JAVA_HOME" ]] && echo 'JAVA_HOME is not set' && return 1
    "$JAVA_HOME/bin/java" -jar "$1" | jq '.message' | sed s/\\\\n/\\n/g
}
