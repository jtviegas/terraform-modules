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

. "${this_folder}/include.sh"

if [ -f "${parent_folder}/.variables" ]; then
    debug "we have a '.variables' file"
    . "${parent_folder}/.variables"
fi

if [ -f "${parent_folder}/.secrets" ]; then
    debug "we have a '.secrets' file"
    . "${parent_folder}/.secrets"
fi

usage()
{
  cat <<EOM
  usages:
  $(basename $0) {az_sp} [on|off|login|check]
                          on      creates azure service principal with the current account subscription
                          off     deletes the one with id defined in ARM_CLIENT_ID
                          login   logs in using the service principal credentials defined in environment
                          check   checks if logged in correctly listing VM's sizes
EOM
  exit 1
}

az_sp_on()
{
  info "[az_sp_on|in]"
  az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/${ARM_SUBSCRIPTION_ID}" -o table
  info "[az_sp_on] please add the following output to '.secrets' file:     password(ARM_CLIENT_SECRET) "
  info "[az_sp_on] please add the following output to '.variables' file:   app_id(ARM_CLIENT_ID), tenant(ARM_TENANT_ID)"
  info "[az_sp_on|out]"
}

az_sp_off()
{
  info "[az_sp_off|in]"
  az ad sp delete --id "${ARM_CLIENT_ID}"
  info "[az_sp_off|out]"
}

az_sp_login()
{
  info "[az_sp_login|in]"
  az login --service-principal -u "${ARM_CLIENT_ID}" -p "${ARM_CLIENT_SECRET}" --tenant "${ARM_TENANT_ID}"
  info "[az_sp_login|out]"
}

az_sp_check()
{
  info "[az_sp_check|in]"
  az vm list-sizes --location westus
  info "[az_sp_check|out]"
}

info "starting [ $0 $1 $2 ] ..."
_pwd=$(pwd)

case "$1" in
      az_sp)
        case "$2" in
              on)
                az_sp_on
                ;;
              off)
                az_sp_off
                ;;
              login)
                az_sp_login
                ;;
              check)
                az_sp_check
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