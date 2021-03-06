# Get latest changelist
alias cl='cat ~/blt/app/main/core/workspace-user.xml | grep -C0 revision | sed -E  "s/^.*<revision>(.+)<.revision>/\1/"'

# Core start/stop
alias cs='pushd ~/blt/app/main/core >/dev/null && corecli core:start --no-honu-log; popd >/dev/null'
alias cx='pushd ~/blt/app/main/core >/dev/null && corecli core:stop; popd >/dev/null'
alias ci='pushd ~/blt/app/main/core >/dev/null && corecli ide:intellij; popd >/dev/null'

# Aura
alias ax='node ./aura-util/src/test/tools/xUnit/xUnit.js.Console.js /dependency:./aura-util/src/test/tools/xUnit/dependencies ./aura-impl/src/test/javascript' #run this from the root aura folder:
alias amod='chmod 666 ~/git/loz/aura/aura-resources/target/classes/aura/javascript/*; ll ~/git/loz/aura/aura-resources/target/classes/aura/javascript/*'

# Docker
alias dra='docker run -it --rm ops0-artifactrepo1-0-prd.data.sfdc.net'

# Init JAVA_HOME and M2_HOME based on what CoreCli uses
alias initj='pushd "$HOME/blt/app/main/core" >/dev/null && for LINE in `corecli show-env | grep -e "^JAVA_HOME=" -e "^M2_HOME="`; do export $LINE; done && popd >/dev/null && echo JAVA_HOME=$JAVA_HOME && echo M2_HOME=$M2_HOME'

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

# Pushd
alias pdbuild='pushd ~/blt/app/main/core/build'
alias pdcore='pushd ~/blt/app/main/core'
alias pd236='pushd ~/blt/app/236/patch/core'
alias pdlogs='pushd ~/blt/app/main/core/sfdc/logs/sfdc'
alias pdext='pushd ~/blt/app/main/core/ext'
alias pdgatesd='pushd ~/blt/app/main/core/sfdc/config/gater/dev/gates'
alias pdm2='pushd ~/.m2/repository/com/salesforce/services/instrumentation'
alias pduic='pushd ~/blt/app/main/core/ui-instrumentation-components'
alias pduia='pushd ~/blt/app/main/core/ui-instrumentation-api/java/src/ui/instrumentation/api'
alias pduii='pushd ~/blt/app/main/core/ui-instrumentation-impl/java/src/ui/instrumentation/impl'

alias tailins='tail -f ~/blt/app/main/core/sfdc/logs/sfdc/output.log | grep -E "^(uxlog)|(uxact)|(uxerr)|(uxevt)|(3pcml)|(ailtn)|(aiuim)"'

LOC=$(dirname "$0")

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
    WHOAMI=$(whoami) && open "https://portal.prod.ci.sfdc.net/?autobuilds=&users=$WHOAMI"
}

function coreeslint() {
    [[ -z $1 ]] && echo 'Please specify the module name, e.g. ui-instrumentation-components' && return 1
    corecli mvn:mvn -- tools:eslint-lwc -pl "$1"
}

function coreeslintQuick() {
    # Note: this is using a hard-coded version of eslint-tool, need to run the non-quick way to update it
    [[ -z $1 ]] && echo 'Please specify the module name, e.g. ui-instrumentation-components' && return 1

    pushd /Users/loz/tools/eslint-tool/2.0.5 >/dev/null
    /Users/loz/tools/eslint-tool/2.0.5/node/node-v14.15.1-darwin-x64/bin/node ./node_modules/eslint/bin/eslint.js \
        --no-color --max-warnings 0 \
        "/Users/loz/blt/app/main/core/$1/modules"
    # --ignore-pattern **/modules/force/adsBridge/adsBridge.js \
    # --ignore-pattern **/modules/native/ldsEngineMobile/ldsEngineMobile.js \
    # --ignore-pattern **/modules/native/ldsWorkerApi/ldsWorkerApi.js \
    # --ignore-pattern **/modules/force/lds*/** \
    # --ignore-pattern **/modules/visualEditor/jQuery/jQueryLib.js \
    # --ignore-pattern **/modules/visualEditor/jQuery/jQueryUILib.js
    popd >/dev/null
}

function coreResubmitCodeReviewStage() {
    # Submits to Code Review Stage Testing (CRST)
    [[ -z $1 ]] && echo 'Please specify the changelist name (check Pending in p4v)' && return 1
    corecli crst:submit -c $1
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
    read -p "Delete $checksum? y/n " RESP
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

function logrt() {
    if [ -z $1 ]; then
        echo 'Please provide logRecordType to filter as your first argument (e.g. ailtn)'
        return 1
    fi

    tail -f ~/blt/app/main/core/sfdc/logs/sfdc/output.log | grep -E "^$1"
}

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
