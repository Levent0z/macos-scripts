# Build inside a module
alias buildMod='corecli mvn:mvn -- -pl module process-classes'

# Get latest changelist
alias cl='cat ~/blt/app/main/core/workspace-user.xml | grep -C0 revision | sed -E  "s/^.*<revision>(.+)<.revision>/\1/"'
alias cl242='cat ~/blt/app/242/patch/core/workspace-user.xml  | grep -C0 revision | sed -E  "s/^.*<revision>(.+)<.revision>/\1/"'

# Core start/stop
alias cs='pushd ~/blt/app/main/core >/dev/null && corecli core:start --no-honu-log; popd >/dev/null'
alias cx='pushd ~/blt/app/main/core >/dev/null && corecli core:stop; popd >/dev/null'
alias ci='pushd ~/blt/app/main/core >/dev/null && corecli ide:intellij; popd >/dev/null'
alias cv='pushd ~/blt/app/main/core >/dev/null && corecli ide:vscode; popd >/dev/null'

# Aura
alias ax='node ./aura-util/src/test/tools/xUnit/xUnit.js.Console.js /dependency:./aura-util/src/test/tools/xUnit/dependencies ./aura-impl/src/test/javascript' #run this from the root aura folder:
alias amod='chmod 666 ~/git/loz/aura/aura-resources/target/classes/aura/javascript/*; ll ~/git/loz/aura/aura-resources/target/classes/aura/javascript/*'

# Docker
alias dra='docker run -it --rm ops0-artifactrepo1-0-prd.data.sfdc.net'

# Init JAVA_HOME and M2_HOME based on what CoreCli uses
alias initj='pushd "$HOME/blt/app/main/core" >/dev/null && for LINE in `corecli show-env | grep -e "^JAVA_HOME="`; do export $LINE; done && popd >/dev/null && echo JAVA_HOME=$JAVA_HOME'
alias initm='pushd "$HOME/blt/app/main/core" >/dev/null && for LINE in `corecli show-env | grep -e "^M2_HOME="`; do export $LINE; done && popd >/dev/null && echo M2_HOME=$M2_HOME'

# Java
alias ejhc='corecli env | grep -e ^JAVA_HOME'
alias ejhx='CJH=`corecli env | grep -e ^JAVA_HOME` && echo "CORECLI $CJH"; echo "ENV     JAVA_HOME=$JAVA_HOME"'
alias jh1_292='export JAVA_HOME=/Library/Java/JavaVirtualMachines/sfdc-openjdk1.8.0.292_8.54.0.22.jdk/Contents/Home/'
alias jh1_308='export JAVA_HOME=/Library/Java/JavaVirtualMachines/sfdc-openjdk1.8.0.302_8.56.0.22.jdk/Contents/Home/'
alias jhzulu8='export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-8.jdk/Contents/Home/'
alias jh11='export JAVA_HOME=/Library/Java/JavaVirtualMachines/sfdc-openjdk_11.0.9.1_11.43.62.jdk/Contents/Home/'
alias jhl='export JAVA_HOME=/Library/Java/JavaVirtualMachines/sfdc-openjdk_11.0.9.1_11.43.62.jdk/Contents/Home/' # latest

# Maven
alias codemvnlogs='code ~/.corecli.logs/mvn:mvn'
alias codepom='code ~/blt/app/main/core/pom.xml'
alias codews='code ~/blt/app/main/core/workspace-user.xml'
alias coremvn='corecli mvn:mvn -- ' # specify additional args directly to maven
alias coremvni='corecli mvn:mvn -- com.sfdc.maven.plugins:intellij-maven-plugin:LATEST:import -Dintellij.root.project=${HOME}/blt/app/main/core/.idea'
alias mvnciij='mvn clean install com.sfdc.maven.plugins:intellij-maven-plugin:LATEST:import -Dintellij.root.project=${HOME}/blt/app/main/core/.idea' # applies to main
alias mvnenv='source ~/blt/app/main/core/build/maven-env.sh'
alias m2core='export M2_HOME=${HOME}/blt/app/main/core/build/apache-maven'

# Testing

# Pushd
alias pdbuild='pushd ~/blt/app/main/core/build >/dev/null'
alias pdcore='pushd ~/blt/app/main/core >/dev/null'
alias pdlogs='pushd ~/blt/app/main/core/sfdc/logs/sfdc >/dev/null'
alias pdext='pushd ~/blt/app/main/core/ext >/dev/null'
alias pdgatesd='pushd ~/blt/app/main/core/sfdc/config/gater/dev/gates >/dev/null'
alias pdm2='pushd ~/.m2/repository/com/salesforce/services/instrumentation >/dev/null'
alias pduic='pushd ~/blt/app/main/core/ui-instrumentation-components >/dev/null'
alias pduia='pushd ~/blt/app/main/core/ui-instrumentation-api/java/src/ui/instrumentation/api >/dev/null'
alias pduii='pushd ~/blt/app/main/core/ui-instrumentation-impl/java/src/ui/instrumentation/impl >/dev/null'

alias tailins='tail -f ~/blt/app/main/core/sfdc/logs/sfdc/output.log | grep -E "^(uxlog|uxact|uxerr|uxevt|3pcml|ailtn|aiuim|cptsk)"'
alias tailo11y='tail -f ~/blt/app/main/core/sfdc/logs/sfdc/output.log | grep -E "^(uxlog|uxact|uxerr|uxevt|3pcml)|ui-telemetry|o11y"'
alias tailo11y242='tail -f ~/blt/app/242/patch/core/sfdc/logs/sfdc/output.log | grep -E "^(uxlog|uxact|uxerr|uxevt|3pcml)|ui-telemetry|o11y"'

LOC=$(dirname "$0")

function myShelved() {
    WHOAMI="$(whoami)" && p4 changelists -u "$WHOAMI" -s shelved
}

function appready() {
    tail -f ~/blt/app/main/core/sfdc/logs/sfdc/output.log | grep "A P P    R E A D Y"
}

function appchanged() {
    tail -f ~/blt/app/main/core/sfdc/logs/sfdc/output.log | grep "changed due to: CHANGE"
}

function corelogs() {
    tail -f ~/blt/app/main/core/sfdc/logs/sfdc/output.log | grcat "$LOC/config/conf.sfcore"
}

function coreCiStatus {
    WHOAMI="$(whoami)" && open "https://portal.prod.ci.sfdc.net/?autobuilds=&users=$WHOAMI"
}

function coreeslint() {
    [[ -z $1 ]] && echo 'Please specify the module name, e.g. ui-instrumentation-components' && return 1
    corecli mvn:mvn -- tools:eslint-lwc -pl "$1"
}

function coreeslintQuick() {
    # Note: this is using a hard-coded version of eslint-tool, need to run the non-quick way to update it
    [[ -z $1 ]] && echo 'Please specify the module name, e.g. ui-instrumentation-components' && return 1

    pushd $HOME/tools/eslint-tool/2.0.5 >/dev/null
    $HOME/tools/eslint-tool/2.0.5/node/node-v14.15.1-darwin-x64/bin/node ./node_modules/eslint/bin/eslint.js \
        --no-color --max-warnings 0 \
        "$HOME/blt/app/main/core/$1/modules"
    # --ignore-pattern **/modules/force/adsBridge/adsBridge.js \
    # --ignore-pattern **/modules/native/ldsEngineMobile/ldsEngineMobile.js \
    # --ignore-pattern **/modules/native/ldsWorkerApi/ldsWorkerApi.js \
    # --ignore-pattern **/modules/force/lds*/** \
    # --ignore-pattern **/modules/visualEditor/jQuery/jQueryLib.js \
    # --ignore-pattern **/modules/visualEditor/jQuery/jQueryUILib.js
    popd >/dev/null
}

function coreJest() {
    [[ -z $1 ]] && echo 'Please specify a module, e.g. ui-instrumentation-components' && return 1
    coremvn tools:jest-raptor -Drpl=$1
}

function coreStatus() {
    WHOAMI="$(whoami)" && pcx status --user="$WHOAMI"
}

function coreSubmitTest() {
    # Submits to Code Review Stage Testing (CRST) (doesn't actually submit)
    [[ -z $1 ]] && echo 'Please specify the changelist name (check Pending in p4v)' && return 1
    corecli crst:submit -c $1
}

function coreJunitMod() {
    [[ -z $1 ]] && echo 'Please specify CSV list of module references to test, e.g. :appanalytics-connect-api-test-unit,:communities-webruntime-sfdc-impl-test-unit,:ui-uisdk-connect-impl-test-unit' && return 1
    corecli core:ant utest-surefire -Dutest.modules=$1
}

function coreXunitCl() {
    [[ -z $1 ]] && echo 'Please specify a changelist' && return 1
    pushd "$HOME/blt/app/main/core/build"
    ./ant utest-precheckin -Dchangelist=$1
    popd
}

function ccli() {
    ALLARGS=$*
    pushd "$HOME/blt/app/main/core"
    corecli $ALLARGS
    RETVAL=$?
    popd
    return $RETVAL
}

function cclog() {
    [[ -z $1 ]] && rank=1 || rank=$1
    cat ~/.corecli.logs/latest/$(ls -1 ~/.corecli.logs/latest | sort -r | tail +$rank | head -1)
}

function ccresetext() {
    local checksum='ext/.sync-ext-checksum/'
    if [[ ! -d $checksum ]]; then
        echo 'Please run this command from core'
        return
    fi
    echo -n "Delete $checksum? y/n "
    read RESP
    [[ $RESP != 'y' ]] && return
    rm -rf $checksum
    echo Deleted.
}

function ccupdate() {
    python3 <(curl https://sfdc-ansible.s3.amazonaws.com/honu-apps/installall)
}

# Reinstall certificates.
function cctls() {
    echo 'First, running hostsfix.'
    [[ -f ~/hostsfix.sh ]] && ~/hostsfix.sh || (
        echo '~/hostsfix.sh not found'
        return 1
    )
    corecli tls:create-certificates tls:install-certificates
}

function coreSubmitNoCheck() {
    [[ -z "$1" ]] && echo 'Please provide a changelist number' && return 1
    corecli core:submit --no-check -c "$1"
}

function coreUpdateVar() {
    [[ -z "$1" ]] && echo 'Please provide a variable name as your first argument. e.g. _WEBRUNTIME_FRAMEWORK_VERSION' && return 1
    [[ -z "$2" ]] && echo 'Please provide a value as your second argument. e.g. 242.40' && return 1
    corecli graph:update-version-variable -n "$1" --version "$2"
}

function logrt() {
    if [ -z $1 ]; then
        echo 'Please provide logRecordType to filter as your first argument (e.g. ailtn)'
        return 1
    fi

    tail -f ~/blt/app/main/core/sfdc/logs/sfdc/output.log | grep -E "^$1"
}

# Reminder: `System.out.println` doesn't go onto output.log

function logwatch() {
    if [ -z $1 ]; then
        echo 'Please provide your keyword to filter as your first argument (escape spaces)'
        return 1
    fi
    tail -f ~/blt/app/main/core/sfdc/logs/sfdc/output.log | grep -E "$1"
}

function redirectCore() {
    OTHERHOST=$1
    if [[ -z $OTHERHOST ]]; then
        echo 'Please specify a short hostname for the destination'
        return 1
    fi
    if [[ -z $SSHARGS ]]; then
        echo 'Warning: $SSHARGS not defined.'
    fi
    # redirects localhost ports to the specified (other) host as long as the ssh is open
    ssh $SSHARGS -L 6109:localhost:6109 -L 6101:localhost:6101 $OTHERHOST.internal.salesforce.com || echo 'Failed.'
}

function jestForMod() {
    local TEMP_DIR='/tmp/jest'
    local INSTALL_PATH="$HOME/git/lwc"
    mkdir -p "$TEMP_DIR"

    local REPO_PATH="$INSTALL_PATH/lwc-testrunner"
    local BIN_PATH="$REPO_PATH/bin"
    local SCRIPT_PATH="$BIN_PATH/lwc-test.js"

    if [[ ! -f "$SCRIPT_PATH" ]]; then
        echo "$SCRIPT_PATH not found."
        echo -n 'Clone the repo into that path and call "yarn install"? (y/n) '
        read RESP
        [[ "$RESP" != 'y' ]] && return 1

        pushd "$PWD" >/dev/null
        mkdir -p "$INSTALL_PATH" >/dev/null
        cd "$INSTALL_PATH"
        git clone git@git.soma.salesforce.com:lwc/lwc-testrunner.git
        cd "$REPO_PATH"
        yarn install
        popd >/dev/null
    fi

    [[ -z $1 ]] && echo 'Please specify a module, e.g. ui-instrumentation-components' && return 1

    pushd "$BIN_PATH" >/dev/null
    node "$SCRIPT_PATH" "$HOME/blt/app/main/core/$1" -- --json --forceExit "--outputFile=$TEMP_DIR/$1.json" --no-cache
    popd >/dev/null
}


