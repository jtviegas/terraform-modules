#!/usr/bin/env bash

# ===> COMMON SECTION START  ===>
# http://bash.cumulonim.biz/NullGlob.html
shopt -s nullglob

if [ -z "$this_folder" ]; then
  this_folder="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
  if [ -z "$this_folder" ]; then
    this_folder=$(dirname $(readlink -f $0))
  fi
fi
parent_folder=$(dirname "$this_folder")


debug(){
    local __msg="$@"
    echo " [DEBUG] `date` ... $__msg "
}

info(){
    local __msg="$@"
    echo " [INFO]  `date` ->>> $__msg "
}

warn(){
    local __msg="$@"
    echo " [WARN]  `date` *** $__msg "
}

err(){
    local __msg="$@"
    echo " [ERR]   `date` !!! $__msg "
}

if [ -f "${this_folder}/.variables" ]; then
    debug "we have a '.variables' file"
    . "${this_folder}/.variables"
else
    warn "creating '.variables' file"
    touch "${this_folder}/.variables"
fi

if [ -f "${this_folder}/.secrets" ]; then
    debug "we have a '.secrets' file"
    . "${this_folder}/.secrets"
else
    warn "creating '.secrets' file"
    touch "${this_folder}/.secrets"
fi



#git clone https://github.com/jtviegas/terraform-modules.git


sys_reqs(){
  info "[sys_reqs] ..."

  which terraform 1>/dev/null
  if [ ! "$?" -eq "0" ] ; then
    info "[sys_reqs] installing terraform"
    apt-get update && apt-get install -y gnupg software-properties-common curl
    curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
    apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
    apt-get update
    apt-get -y install git terraform
  else
    info "[sys_reqs] terraform is already installed"
  fi

  info "[sys_reqs] ...done."
}

az_reqs(){
  info "[az_reqs] ..."

  which az 1>/dev/null
  if [ ! "$?" -eq "0" ] ; then
    info "[az_reqs] installing azure-cli"
    apt-get -y update
    apt-get -y install ca-certificates curl apt-transport-https lsb-release gnupg
    curl -sL https://packages.microsoft.com/keys/microsoft.asc |
      gpg --dearmor |
      tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
    AZ_REPO=$(lsb_release -cs)
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" |
      tee /etc/apt/sources.list.d/azure-cli.list
    apt-get -y update
    apt-get -y install azure-cli
  else
    info "[az_reqs] azure-cli is already installed"
  fi

  info "[az_reqs] ...done."
}

check_env_vars(){
  info "[check_env_vars] ..."
  for arg in "$@"
  do
      debug "[check_env_vars] ... checking $arg"
      which "$arg" 1>/dev/null
      env | grep $arg
      if [ ! "$?" -eq "0" ] ; then err "[check_env_vars] please define env var $arg" && return 1; fi
  done
  info "[check_env_vars] ...done."
}


az_login_check()
{
  info "[az_login_check|in]"
  az vm list-sizes --location westus
  info "[az_login_check|out]"
}

az_login()
{
  info "[az_login|in]"
  check_env_vars ARM_CLIENT_ID ARM_CLIENT_SECRET ARM_TENANT_ID
  [ ! "$?" -eq "0" ] && return 1
  az login --service-principal -u "${ARM_CLIENT_ID}" -p "${ARM_CLIENT_SECRET}" --tenant "${ARM_TENANT_ID}"
  info "[az_login|out]"
}

usage()
{
  cat <<EOM
  usages:
    system features:
    $(basename $0) sys {reqs}
                          reqs   install required packages

    azure platform features:
    $(basename $0) az {login|check|reqs}
                          reqs    installs azure related dependencies
                          login   logs in using the service principal credentials defined in environment
                                    (check '.variables' and '.secrets' files)
                          check   checks if logged in correctly listing VM's sizes
    aws platform features:
    $(basename $0) aws {login|check|reqs}
                          reqs    installs aws related dependencies
EOM
  exit 1
}


info "starting [ $0 $1 $2 ] ..."
_pwd=$(pwd)

case "$1" in
      az)
        case "$2" in
              reqs)
                az_reqs
                ;;
              login)
                az_login
                ;;
              check)
                az_login_check
                ;;
              *)
                usage
                ;;
        esac
        ;;
      sys)
        case "$2" in
              reqs)
                sys_reqs
                ;;
              *)
                usage
                ;;
        esac
        ;;
      *)
        usage
esac
info "...[ $0 $1 $2 ] done."