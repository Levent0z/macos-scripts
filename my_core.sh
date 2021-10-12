# Get latest changelist
alias cl='cat ~/blt/app/main/core/workspace-user.xml | grep -C0 revision | sed -E  "s/^.*<revision>(.+)<.revision>/\1/"'

alias codepom='code ~/blt/app/main/core/pom.xml'
alias codews='code ~/blt/app/main/core/workspace-user.xml'

# Aura
alias ax='node ./aura-util/src/test/tools/xUnit/xUnit.js.Console.js /dependency:./aura-util/src/test/tools/xUnit/dependencies ./aura-impl/src/test/javascript' #run this from the root aura folder:
alias amod='chmod 666 ~/git/loz/aura/aura-resources/target/classes/aura/javascript/*; ll ~/git/loz/aura/aura-resources/target/classes/aura/javascript/*'

# Docker
alias dra='docker run -it --rm ops0-artifactrepo1-0-prd.data.sfdc.net'

# Java
alias ejhc='corecli env | grep -e ^JAVA_HOME'
alias ejhx='CJH=`corecli env | grep -e ^JAVA_HOME` && echo "CORECLI $CJH"; echo "ENV     JAVA_HOME=$JAVA_HOME"'
alias jh1_292='export JAVA_HOME=/Library/Java/JavaVirtualMachines/sfdc-openjdk1.8.0.292_8.54.0.22.jdk/Contents/Home/'
alias jh1_308='export JAVA_HOME=/Library/Java/JavaVirtualMachines/sfdc-openjdk1.8.0.302_8.56.0.22.jdk/Contents/Home/'
alias jhzulu8='export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-8.jdk/Contents/Home/'
alias jh11='export JAVA_HOME=/Library/Java/JavaVirtualMachines/sfdc-openjdk_11.0.9.1_11.43.62.jdk/Contents/Home/'
alias jhlatest='export JAVA_HOME=/Library/Java/JavaVirtualMachines/sfdc-openjdk_11.0.9.1_11.43.62.jdk/Contents/Home/'

# Pushd
alias pdbuild='pushd ~/blt/app/main/core/build'
alias pdcore='pushd ~/blt/app/main/core'
alias pdlogs='pushd ~/blt/app/main/core/sfdc/logs/sfdc'

alias pdgatesd='pushd ~/blt/app/main/core/sfdc/config/gater/dev/gates'

alias pduic='pushd ~/blt/app/main/core/ui-instrumentation-components'
alias pduia='pushd ~/blt/app/main/core/ui-instrumentation-api/java/src/ui/instrumentation/api'
alias pduii='pushd ~/blt/app/main/core/ui-instrumentation-impl/java/src/ui/instrumentation/impl'

function appready() {
    tail -f ~/blt/app/main/core/sfdc/logs/sfdc/output.log | grep "A P P    R E A D Y"
}

function appchanged() {
    tail -f ~/blt/app/main/core/sfdc/logs/sfdc/output.log | grep "changed due to: CHANGE"
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
