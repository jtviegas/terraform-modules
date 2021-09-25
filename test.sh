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

# ---------- CONSTANTS ----------
MODULES_URL=https://github.com/jtviegas/terraform-modules/branches/zero_thirteen/modules
MODULES_DIR="${this_folder}/modules"
MODE=LOCAL # LOCAL or REMOTE
# -------------------------------

. "${this_folder}/scripts/include.sh"

if [ -f "${this_folder}/.variables" ]; then
    debug "we have a '.variables' file"
    . "${this_folder}/.variables"
fi

if [ -f "${this_folder}/.secrets" ]; then
    debug "we have a '.secrets' file"
    . "${this_folder}/.secrets"
fi

usage()
{
  cat <<EOM
  usages:
  $(basename $0) {module-test-folder} [on|off]
EOM
  exit 1
}

fetchModules()
{
  info "[fetchModules|in] (MODE: $MODE)"
  if [ "$MODE" == "REMOTE" ];then
    svn export "$MODULES_URL" "modules"
  else
    cp -R "$MODULES_DIR" "modules"
  fi
  info "[fetchModules|out]"
}

testOn()
{
  info "[testOn|in]"
  cd "$test_dir"
  fetchModules
  terraform init
  terraform plan -var-file="main.tfvars"
  terraform apply -auto-approve -lock=true -lock-timeout=5m -var-file="main.tfvars"
  terraform output
  rm -rf "modules"
  cd "$_pwd"
  info "[testOn|out]"
}

testOff()
{
  info "[testOff|in]"
  cd "$test_dir"
  fetchModules
  terraform init
  terraform destroy -lock=true -lock-timeout=5m -auto-approve -var-file="main.tfvars"
  rm -rf "modules"
  cd "$_pwd"
  info "[testOff|out]"
}

config_provider()
{
  info "[config_provider|in] ($1, $2)"
  provider="$1"
  module="$2"
  if [ "$provider" == "aws" ];then
    if [ "$module" == "ops-group" ] ||  [ "$module" == "ops-user" ] ; then
      export AWS_PROFILE=$AWS_MAIN_PROFILE
    else
      export AWS_PROFILE=$AWS_USER_PROFILE
    fi
    info "...this the configuration being used for aws:"
    aws configure list
  fi
  info "[config_provider|out]"
}

[ -z "$2" ] && { usage; }

module_dir="$1"
test_dir="${this_folder}/test/$1"

if [ ! -d "$test_dir" ]; then
  err "not a test folder: $test_dir"
  exit 1
fi

module_name=$(echo $module_dir | cut -f2 -d/)
module_provider=$(echo $module_dir | cut -f1 -d/)
config_provider "$module_provider" "$module_name"

info "starting [ $0 $1 $2 ] ..."
_pwd=$(pwd)

case "$2" in
      on)
        testOn
        ;;
      off)
        testOff
        ;;
      *)
        usage
esac


info "...[ $0 $1 $2 ] done."