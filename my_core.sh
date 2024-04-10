export DEFAULTCORE="$HOME/cog/main/core"
export PD=$(which pd >/dev/null && echo 'pd' || echo 'pushd')

# Build inside a module
alias buildMod='corecli mvn:mvn -- -pl module process-classes'

# Get latest changelist
alias cl='cat "$CORE/workspace-user.xml" | grep -C0 revision | sed -E  "s/^.*<revision>(.+)<.revision>/\1/"'

# Core start/stop
alias cs='corecli core:start --no-honu-log'
alias cx='corecli core:stop'
alias ci='corecli ide:intellij'
alias cv='corecli ide:vscode'

# Core-on-Git
alias cog='git sfdc'
alias cogd='GITSFDC_TRACE=1 git sfdc' # debug
function setcog() {
    if [[ -n "$PROJECT_PATH" ]]; then
        export CORE="$PROJECT_PATH"
    elif [[ -n "$CORE_PROJECT_PATH" ]]; then
        export CORE="$CORE_PROJECT_PATH"
    elif [[ "$USER" == 'sfwork' ]]; then
        export CORE='/opt/workspace/core-public/core'
    else
        export CORE="$DEFAULTCORE"
    fi
}

alias setblt="export CORE='$HOME/blt/app/main/core'"

# Aura
alias ax='node ./aura-util/src/test/tools/xUnit/xUnit.js.Console.js /dependency:./aura-util/src/test/tools/xUnit/dependencies ./aura-impl/src/test/javascript' #run this from the root aura folder:
alias amod='chmod 666 ~/git/loz/aura/aura-resources/target/classes/aura/javascript/*; ll ~/git/loz/aura/aura-resources/target/classes/aura/javascript/*'

#Bazel
alias bqpackages='bazel query "kind(package_info, deps(//tools/build/bazel/packages:core_packages))" --output=package' # run this under core

# Docker
alias dra='docker run -it --rm ops0-artifactrepo1-0-prd.data.sfdc.net'

# Init JAVA_HOME and M2_HOME based on what CoreCli uses
alias initj='$PD "${CORE:-$DEFAULTCORE}" >/dev/null && for LINE in `corecli show-env | grep -e "^JAVA_HOME="`; do export $LINE; done && popd >/dev/null && echo JAVA_HOME=$JAVA_HOME'
alias initm='$PD "${CORE:-$DEFAULTCORE}" >/dev/null && for LINE in `corecli show-env | grep -e "^M2_HOME="`; do export $LINE; done && popd >/dev/null && echo M2_HOME=$M2_HOME'

# Java
alias ejhc='corecli env | grep -e ^JAVA_HOME'
alias ejhx='CJH=`corecli env | grep -e ^JAVA_HOME` && echo "CORECLI $CJH"; echo "ENV     JAVA_HOME=$JAVA_HOME"'
alias jh1_292='export JAVA_HOME=/Library/Java/JavaVirtualMachines/sfdc-openjdk1.8.0.292_8.54.0.22.jdk/Contents/Home/'
alias jh1_308='export JAVA_HOME=/Library/Java/JavaVirtualMachines/sfdc-openjdk1.8.0.302_8.56.0.22.jdk/Contents/Home/'
alias jhzulu8='export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-8.jdk/Contents/Home/'
alias jh11='export JAVA_HOME=/Library/Java/JavaVirtualMachines/sfdc-openjdk_11.0.9.1_11.43.62.jdk/Contents/Home/'
alias jhl='export JAVA_HOME=/Library/Java/JavaVirtualMachines/sfdc-openjdk_11.0.9.1_11.43.62.jdk/Contents/Home/' # latest
alias jd='jdb -attach7 localhost:$(cat "${CORE:-~/core-public/core}/build/dev.properties" | grep "jdwp_debug_port" | cut -d" " -f3)'

# Maven
alias codemvnlogs='code ~/.corecli.logs/mvn:mvn'
alias codepom='code "${CORE:-$DEFAULTCORE}/pom.xml"'
alias codews='code "${CORE:-$DEFAULTCORE}/workspace-user.xml"'
alias coremvn='corecli mvn:mvn -- ' # specify additional args directly to maven
alias coremvni='corecli mvn:mvn -- com.sfdc.maven.plugins:intellij-maven-plugin:LATEST:import -Dintellij.root.project="${CORE:-$DEFAULTCORE}/.idea'
alias mvnciij='mvn clean install com.sfdc.maven.plugins:intellij-maven-plugin:LATEST:import -Dintellij.root.project="${CORE:-$DEFAULTCORE}/.idea'
alias mvnenv='source "${CORE:-$DEFAULTCORE}/build/maven-env.sh"'
alias m2core='export M2_HOME="${CORE:-$DEFAULTCORE}/build/apache-maven"'

# Perforce
alias p4s='echo "DEFAULT CHANGELIST:" && p4 opened -c default; echo "CHANGELISTS:" && p4 changes -c loz-ltmmhp9' # similar to gs for git status

# Testing

# $PD
alias pdbuild='$PD "${CORE:-$DEFAULTCORE}/build" >/dev/null'
alias pdcore='$PD "${CORE:-$DEFAULTCORE}" >/dev/null'
alias pdcog='$PD "${CORE:-$DEFAULTCORE}/.." >/dev/null'
alias pdlogs='$PD "${CORE:-$DEFAULTCORE}/sfdc/logs/sfdc" >/dev/null'
alias pdext='$PD "${CORE:-$DEFAULTCORE}/ext" >/dev/null'
alias pdgatesd='$PD "${CORE:-$DEFAULTCORE}/sfdc/config/gater/dev/gates" >/dev/null'
alias pdm2='$PD ~/.m2/repository/com/salesforce/services/instrumentation >/dev/null'
alias pduic='$PD "${CORE:-$DEFAULTCORE}/ui-instrumentation-components" >/dev/null'
alias pduia='$PD "${CORE:-$DEFAULTCORE}/ui-instrumentation-api/java/src/ui/instrumentation/api" >/dev/null'
alias pduii='$PD "${CORE:-$DEFAULTCORE}/ui-instrumentation-impl/java/src/ui/instrumentation/impl" >/dev/null'
alias pdwr='$PD ~/.m2/repository/sfdc/ui/webruntime-framework >/dev/null'

alias tailins='tail -f --follow=name "${CORE:-$DEFAULTCORE}/sfdc/logs/sfdc/output.log" | grep -E "^(uxlog|uxact|uxerr|uxevt|uxnvt|uxrst|3pcml|ailtn|aiuim)"'
alias tailo11y='tail -f --follow=name "${CORE:-$DEFAULTCORE}/sfdc/logs/sfdc/output.log" | grep -E "^(uxlog|uxact|uxerr|uxevt|uxnvt|uxrst|3pcml)"'
alias tailo11yx='tail -f --follow=name "${CORE:-$DEFAULTCORE}/sfdc/logs/sfdc/output.log" | grep -E "^(uxlog|uxact|uxerr|uxevt|uxnvt|uxrst|3pcml)|ui-telemetry|o11y"'

LOC=$(dirname "$0")

function myShelved() {
    WHOAMI="$(whoami)" && p4 changelists -u "$WHOAMI" -s shelved
}

function appready() {
    tail -f --follow=name "${CORE:-$DEFAULTCORE}/sfdc/logs/sfdc/output.log" | grep "A P P    R E A D Y"
}

function appchanged() {
    tail -f --follow=name "${CORE:-$DEFAULTCORE}/sfdc/logs/sfdc/output.log" | grep "changed due to: CHANGE"
}

function corelogs() {
    tail -f --follow=name "${CORE:-$DEFAULTCORE}/sfdc/logs/sfdc/output.log" | grcat "$LOC/config/conf.sfcore"
}

function coreCiStatus {
    WHOAMI="$(whoami)" && open "https://portal.prod.ci.sfdc.net/?autobuilds=&users=$WHOAMI"
}

function coreeslint() {
    [[ -z $1 ]] && echo 'Please specify the module name, e.g. ui-instrumentation-components' && return 1
    corecli mvn:mvn -- tools:eslint-lwc -pl "$1"
}

function bzeslint() {
    set -i

    if [[ ! -f "BUILD.bazel" ]]; then
        echo 'This command must be run from a Bazel module folder (missing BUILD.bazel).'
        return 1
    fi

    local MODULE_NAME
    MODULE_NAME=$(grep BUILD.bazel -e "^sfdc_core_module" -C1 | grep name | awk '{print $3}' | awk -F'"' '{print $2}')

    local COMMAND="bazel test //${MODULE_NAME}:eslint_lwc --test_output=all"
    echo -n "About to run '$COMMAND', Continue? (Y/n) "
    read -r RESP
    if [[ "$RESP" == 'n' ]] || [[ "$RESP" == 'N' ]]; then
        echo 'Skipped.'
        return 2
    fi
    eval "$COMMAND"
}

function coreeslintQuick() {
    # Note: this is using a hard-coded version of eslint-tool, need to run the non-quick way to update it
    [[ -z $1 ]] && echo 'Please specify the module name, e.g. ui-instrumentation-components' && return 1

    pushd $HOME/tools/eslint-tool/2.0.5 >/dev/null
    $HOME/tools/eslint-tool/2.0.5/node/node-v14.15.1-darwin-x64/bin/node ./node_modules/eslint/bin/eslint.js \
        --no-color --max-warnings 0 \
        "${CORE:-$DEFAULTCORE}/$1/modules"
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

function clwrTest() {
    corecli --monitor direct core:ant utest-surefire -Dutest.modules=:communities-webruntime-sites-impl-test-unit,:communities-webruntime-sfdc-impl-test-unit
}

function coreXunitCl() {
    [[ -z $1 ]] && echo 'Please specify a changelist' && return 1
    pushd "$HOME/cog/main/core/build"
    ./ant utest-precheckin -Dchangelist=$1
    popd
}

function ccli() {
    ALLARGS=$*
    pushd "$HOME/cog/main/core"
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
    # https://confluence.internal.salesforce.com/display/COREBUILD/Work+With+Bazel+Packages
    [[ -z "$1" ]] && echo 'Please provide a variable name as your first argument. e.g. _WEBRUNTIME_FRAMEWORK_VERSION' && return 1
    [[ -z "$2" ]] && echo 'Please provide a value as your second argument. e.g. 242.40' && return 1
    corecli graph:update-version-variable -n "$1" --version "$2"
    echo 'You can use coreRestoreVar to undo this.'
}

function coreRestoreVar() {
    [[ ! -f "workspace.xml" ]] && [[ ! -d "core" ]] && echo "Please run this command from Core folder" && return 1
    echo 'Checking for modified .bzl files...'
    local FILES=$(git status -s | grep -e "\.bzl$" | cut -d ' ' -f 3)
    if [[ -z "$FILES" ]]; then
        echo 'No modified .bzl files found.'
        return 0
    fi
    echo 'The following files will be restored:'
    echo "$FILES"
    echo 'To diff them first, enter "d"'
    while true; do
        echo -n 'Continue? (Y/n/d) '
        read RESP
        [[ "$RESP" == 'n' ]] || [[ "$RESP" == 'N' ]] && echo "Canceled." && return 1
        if [[ "$RESP" == 'd' ]] || [[ "$RESP" == 'D' ]]; then
            echo "$FILES" | xargs git diff --
            continue
        fi
        break
    done
    echo "$FILES" | xargs git restore
    echo 'Done.'
}

function logrt() {
    if [ -z $1 ]; then
        echo 'Please provide logRecordType to filter as your first argument (e.g. ailtn)'
        return 1
    fi

    tail -f --follow=name ~/cog/main/core/sfdc/logs/sfdc/output.log | grep -E "^$1"
}

# Reminder: `System.out.println` doesn't go onto output.log

function logwatch() {
    if [ -z $1 ]; then
        echo 'Please provide your keyword to filter as your first argument (escape spaces)'
        return 1
    fi
    tail -f --follow=name ~/cog/main/core/sfdc/logs/sfdc/output.log | grep -E "$1"
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
    node "$SCRIPT_PATH" "$HOME/cog/main/core/$1" -- --json --forceExit "--outputFile=$TEMP_DIR/$1.json" --no-cache
    popd >/dev/null
}

function precheck() {
    [[ -z "$1" ]] && echo 'Please specify checkin number' && return 1

    # More: file:///Users/loz/.honu/cache/pcx.html#pc:validate
    pcx pc:validate -c "$1" --autobuild main_precheckin --timeout 300
}

function clFiles() {
    [[ -z "$1" ]] && echo 'Please specify changelist ID' && return 1
    p4 describe "$1" | grep -e '^\.\.\.' | cut -d ' ' -f 2
}

function cogUpdate() {
    # https://git.soma.salesforce.com/pages/gimlet/gimlet-docs/software-updates
    brew update && brew upgrade git-sfdc-v2
}

function cogu() {
    [[ -z "$1" ]] && echo 'Please specify changelist ID' && return 1
    git sfdc p4-unshelve $1
}

function fixNull() {
    # This fixes the NullPointerException that happens during component-compile of org.auraframework:aura-maven-plugin
    # Run it under core
    find . -name .registries -delete
    find . -name .lwr_registries -delete
}

function cogClone() {
    [[ -z "$1" ]] && echo "Please specify the name of the repo to clone (e.g p4/main or p4/244-patch)" && return 1
    local NAME=$(echo $1 | cut -d'/' -f2)

    if [[ -z "$2" ]]; then
        echo -n "Using $NAME for the name of the folder to clone into. Continue? (Y/n) "
        read RESP
        [[ "$RESP" != 'y' ]] && [[ "$RESP" != 'Y' ]] && return 1
    fi

    git sfdc clone -b $1 -n $2
}

function sfwConnect() {
    [[ -z "$1" ]] && echo 'Please specify the workspace ID' && return 1
    echo 'Reminder to view logs: cat /var/log/user-data.log'
    sfworkctl connect --document "" -w $1

}

function fixGraphExecutionServiceClientStatisticsIssue() {
    # https://salesforce.stackenterprise.co/questions/27078
    sudo chmod +r /etc/pki_service/sfdc/client/keys
}

function echoGitBranchesOnSfw() {
    echo 'Run the following after connecting to SFW using sfwConnect:'
    echo 'find /opt/workspace/core-public/.git/refs/heads -type f | cut -d"/" -f8-'
}

function bazelXUnit() {
    [[ -z "$1" ]] && echo 'Please specify the module name, e.g. ui-instrumentation-components' && return 1
    bazel test "//$1:xunit_test" --test_output=all
}

function bazelJest() {
    [[ -z "$1" ]] && echo 'Please specify the module name, e.g. ui-instrumentation-components' && return 1
    bazel test "//$1:jest_test --test_output=all"
}

function bazelJunit() {
    [[ -z "$1" ]] && echo 'Please specify the module name, e.g. ui-instrumentation-components' && return 1
    bazel test "//$1/test/unit:junit_manual"
}

function bazelEslint() {
    [[ -z "$1" ]] && echo 'Please specify the module name, e.g. ui-instrumentation-components' && return 1
    bazel test "//$1:eslint_lwc --test_output=all"
}

function highlightFirstToken() {
    awk -F'`' '{if (NF > 1 && length($1) <= 5) printf "\033[37;41m%s\033[0m", $1; else printf "%s", $1; for(i=2; i<=NF; i++) printf " %s", $i; print ""}'
}

function gitSfdcUpdate() {
    git sfdc upgrade
    ## You can also run the following to enable automatic update:  git sfdc setup-automaint
}