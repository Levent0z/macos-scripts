#! /bin/env/bash

alias bb='cd ~/bitbucket'
alias scm='cd ~/scm'
alias oda='cd ~/bitbucket/oda'
alias soda='cd ~/scm/oda'
alias ohai='cd ~/scm/ohai_clinical'
alias omo='cd ~/scm/omo'
alias dev='cd ~/dev/ohai_clinical'

alias oci-login-iad="oci session authenticate --region us-ashburn-1 --profile-name default --tenancy-name bmc_operator_access"
alias oci-login-phx="oci session authenticate --region us-phoenix-1 --profile-name default --tenancy-name bmc_operator_access"

alias oci-login-iad-oc1="oci session authenticate --region us-ashburn-1 --profile-name oc1 --tenancy-name bmc_operator_access"
alias oci-login-phx-oc1="oci session authenticate --region us-phoenix-1 --profile-name oc1 --tenancy-name bmc_operator_access"

# Use this for devops-ui-service development
alias oci-refresh-iad="oci session refresh --profile default || oci-login-iad"
alias oci-refresh-phx="oci session refresh --profile default || oci-login-phx"
alias oci-refresh-iad-oc1="oci session refresh --profile oc1 || oci-login-iad-oc1"
alias oci-refresh-phx-oc1="oci session refresh --profile oc1 || oci-login-phx-oc1"

alias oci-int="oci -i --config-file '~/.oci/config' --profile default --auth security_token"

alias oci-token="ssh operator-access-token.svc.ad1.r2 'generate --mode jwt'"
alias oci-token-copy="ssh operator-access-token.svc.ad1.r2 'generate --mode jwt' | pbcopy"

## Bastion URL format "bastion-{ad}.rb.{region}.{oci_iaas_domain_name}"

# shellcheck disable=SC2139
alias oci-ssh-r1="ssh -o PKCS11Provider=none $USER@bastion-ad1.rb.r1.oci.oracleiaas.com"
# shellcheck disable=SC2139
alias oci-get-tls-ca-bundle-r1="scp -o PKCS11Provider=none $USER@bastion-ad1.rb.r1.oci.oracleiaas.com:/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem ."
# shellcheck disable=SC2139
alias oci-get-tls-ca-bundle-phx="scp -o PKCS11Provider=none $USER@bastion-ad1.rb.us-phoenix-1.oci.oracleiaas.com:/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem ."

alias oci-ls="alias | grep -E '^oci'"
alias oci-which="alias | grep -E '^oci'"

## Add omni-curl (download zip from https://artifactory.oci.oraclecorp.com/libs-release/oracle/cloud/bots/omni-curl)
export PATH=/Users/loz/tools/omni-curl-97-d18ea0c6c12/bin:$PATH

## This is for the playground/packages/backup script
export BACKUP_DESTINATION=/Users/loz/Documents/backup

source "$HOME/tools/secret-service-cli/shellconfig"

# https://confluence.oraclecorp.com/confluence/display/RBMC/Oracle+DB+setup+In+Local
alias odb-start='colima start --memory 8 --arch x86_64'

alias bastion-r1='ssh bastion-ad1.rb.r1.oci.oracleiaas.com'

function oci-get() {
    local PROFILE='DEFAULT'
    local URI=$1
    oci raw-request --target-uri "$URI" --http-method GET --profile "$PROFILE" --auth security_token | jq
}

function oci-post() {
    local PROFILE='DEFAULT'
    local URI=$1
    local JSON=$2
    if [[ -z "$JSON" ]]; then
        echo JSON must be specified "$JSON".
        return
    fi
    oci raw-request --target-uri "$URI" --http-method POST --profile "$PROFILE" --auth security_token --request-body "$JSON" | jq
}

function oci-post-file() {
    local PROFILE='DEFAULT'
    local URI=$1
    local JSON_PATH=$2
    oci raw-request --target-uri "$URI" --http-method POST --profile "$PROFILE" --auth security_token --request-body "file://$JSON_PATH" | jq
}

# temporary values, don't depend on them
export tmpRBCS1='https://rbcentral-staging.oci.oraclecorp.com/20211201/rbc/tasks/count'
export tmpRBCS2='https://rbcentral-staging.oci.oraclecorp.com/20211201/rbc/subscription/teamView'


alias dope-run='oci-refresh && pushd "$HOME/bitbucket/dope/devops-ui-service/devops-ui-service" && ./run.sh config/user.conf --debug; popd'


get_kiab() {
    if (which kiab > /dev/null) && [[ "$1" != '--force' ]]; then
        echo 'kiab is already in path - skipping.'
        return 0
    fi

    local pkgroot
    pkgroot="$(pwd)"
    local kiab_cli_version=0.1.31    
    local kiab_local_dir="${pkgroot}/kiab"
    local kiab_cli_bin="${pkgroot}/kiab/bin/kiab"
    local kiab_cli_filename="kiab-cli-${kiab_cli_version}.tgz"

    if [[ ! -f "$kiab_cli_bin" ]] || [[ "$1" == '--force' ]]; 
    then    
        echo "This will download kiab version $kiab_cli_version to $kiab_local_dir and extract it to $kiab_cli_bin, and add it to the PATH."
        echo -n 'Continue? (Y/n) '
        read RESP
        [[ "$RESP" == 'n' ]] || [[ "$RESP" == 'N' ]] && echo 'Skipped.' && return 0

        # Check if the kiab-cli is present
        if [ ! -f "$kiab_cli_bin" ]; then
            mkdir -p "${kiab_local_dir}"
            echo 'Downloading...'
            curl -# https://artifactory.oci.oraclecorp.com/kiev-generic-local/com/oracle/pic/kiev/kiab-cli/${kiab_cli_version}/${kiab_cli_filename} -o "${kiab_local_dir}"/${kiab_cli_filename}
            echo 'Extracting...'
            tar --strip-components=1 -C "${kiab_local_dir}" -xzf  "${kiab_local_dir}"/${kiab_cli_filename}
        fi
    fi

    echo 'Adding to the PATH...'
    export PATH=${PATH}:"${kiab_local_dir}/bin"
    echo 'Done.'
    return 0
}


## Git Fetch Upstream
function sgfu() {
    scm-git checkout master && scm-git fetch upstream && scm-git rebase upstream/master
}

## Git Fetch Origin
function sgfo() {
    scm-git checkout master && scm-git fetch origin && scm-git rebase origin/master
}


function srepos() {
    # Assumes the following has been run
    # oci session authenticate --region us-phoenix-1 --profile-name DEFAULT --tenancy-name bmc_operator_accesss

    local CONFIG_FILE="$HOME/.oci/config"
    local PROFILE='DEFAULT'
    local OHAI_CLINICAL_PROJECT_ID='ocid1.devopsproject.oc1.phx.amaaaaaaw4vcxbyajigjxw7wlnhgturi5657fi6yi2m3u44s3gvxwyy7zpfa' 
    local PROJECT_ID="$OHAI_CLINICAL_PROJECT_ID"
    oci devops repository list --project-id "$PROJECT_ID" --config-file "$CONFIG_FILE" --profile "$PROFILE" --auth security_token --output json --all | jq '.data.items[].name' | sort
}

