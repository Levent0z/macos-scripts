alias pdloz='pushd ~/git/loz'
alias pdsoma='pushd ~/git'

alias pdgater='cd ~/git/loz/sfdc-bazel/projects/services/gater'
alias pdgater2='cd ~/git/loz/sfdc-bazel/projects/libs/servicelibs/gater/gater'

alias pdgates='pushd ~/git/loz/gate-definitions/gate-definitions/gates'
alias pdgatest='pushd ~/git/loz/gate-definitions/test-gate-definitions/gates'

alias pdhtc='pushg ~/git/loz/hightower-client'
alias pdhts='pushd ~/git/loz/sfdc-bazel/bazel-bin/projects/services/instrumentation/hightower-service'

# Use different SSH to push ~/git/tok-lp-robot/gate-definitions
alias tokpush='GIT_SSH_COMMAND="ssh -i ~/.ssh/tok_lp_robot_rsa" git push'

# Kubernetes
if [[ -f "$HOME/git/loz/hightower-client/kubeutils.sh" ]]; then
    # Activating Kube Utils for instrumentation
    export KNAMESPACE=instrumentation
    source $HOME/git/loz/hightower-client/kubeutils.sh >/dev/null
fi
