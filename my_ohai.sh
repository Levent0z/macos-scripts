#! /bin/env/bash

alias ohai-list-dev-vm='~/bitbucket/oda/oda-dev-resources/scripts/list-dev-vm-ip.sh'

alias ohai-ssh-dev-vm='ssh devdigital.phx.dev-vm.10.190.1.93' 
alias ohai-which="alias | grep -E '^ohai'"

alias ohai-auth='~/dev/ohai_clinical/nursing-service/scripts/getAuthToken.sh'

alias standup='pushd "$HOME/bitbucket/loz/playground/packages/randomize" >/dev/null  && (cat team.txt | ./randomize.js $(date -u +"%Y%m%d")); popd >/dev/null'
