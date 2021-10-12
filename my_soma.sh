MY_GIT_ORG="$HOME~/git/loz"

alias pdmy="pushd $MY_GIT_ORG"
alias pdsoma='pushd ~/git'

alias pdgater="pushd $MY_GIT_ORG/sfdc-bazel/projects/services/gater"
alias pdgater2="pushd $MY_GIT_ORG/sfdc-bazel/projects/libs/servicelibs/gater/gater"

alias pdgates="pushd $MY_GIT_ORG/gate-definitions/gate-definitions/gates"
alias pdgatest="pushd $MY_GIT_ORG/gate-definitions/test-gate-definitions/gates"

alias pdhtc="pushd $MY_GIT_ORG/hightower-client"
alias pdhts="pushd $MY_GIT_ORG/sfdc-bazel/bazel-bin/projects/services/instrumentation/hightower-service"

# Use different SSH to push ~/git/tok-lp-robot/gate-definitions
alias tokpush='GIT_SSH_COMMAND="ssh -i ~/.ssh/tok_lp_robot_rsa" git push'

# Kubernetes
if [[ -f "$MY_GIT_ORG/hightower-client/kubeutils.sh" ]]; then
    # Activating Kube Utils for instrumentation
    export KNAMESPACE=instrumentation
    source $MY_GIT_ORG/hightower-client/kubeutils.sh >/dev/null
fi
