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
FILE_VARIABLES=${FILE_VARIABLES:-".variables"}
FILE_SECRETS=${FILE_SECRETS:-".secrets"}
MODULES_URL=https://github.com/jtviegas/terraform-modules/branches/zero_thirteen/modules
MODULES_DIR="${this_folder}/modules"
MODE=LOCAL # LOCAL or REMOTE
# -------------------------------

. "${this_folder}/scripts/include.sh"

if [ -f "${this_folder}/${FILE_VARIABLES}" ]; then
    debug "we have a '${FILE_VARIABLES}' file"
    . "${this_folder}/${FILE_VARIABLES}"
fi

if [ -f "${this_folder}/${FILE_SECRETS}" ]; then
    debug "we have a '${FILE_SECRETS}' file"
    . "${this_folder}/${FILE_SECRETS}"
fi

usage()
{
  cat <<EOM
  usages:
  $(basename $0) {module-test-folder} [on|off]
EOM
  exit 1
}

# ------------------------------------------
# -------    azure auth section      -------
sp_login()
{
  info "[sp_login|in]"
  export ARM_CLIENT_ID="$IAC_SP_ID"
  export ARM_CLIENT_SECRET="$IAC_SP_PSWD"
  az login --service-principal -u "${ARM_CLIENT_ID}" -p "${ARM_CLIENT_SECRET}" --tenant "${ARM_TENANT_ID}"
  result=$?
  info "[sp_login|out]"
  return $result
}

sp_logout()
{
  info "[sp_logout|in]"
  az logout --username "${ARM_CLIENT_ID}"
  unset ARM_CLIENT_ID
  unset ARM_CLIENT_SECRET
  info "[sp_logout|out]"
}

add_entry_to_variables()
{
  info "[add_entry_to_variables|in] ($1, $2)"
  [ -z "$1" ] && err "no parameters provided" && return 1

  variables_file="${this_folder}/${FILE_VARIABLES}"

  if [ -f "$variables_file" ]; then
    sed -i '' "/export $1/d" "$variables_file"

    if [ ! -z "$2" ]; then
      echo "export $1=$2" | tee -a "$variables_file" > /dev/null
    fi
  fi
  info "[add_entry_to_variables|out]"
}

add_entry_to_secrets()
{
  info "[add_entry_to_secrets|in] ($1, ${2:0:7})"
  [ -z "$1" ] && err "no parameters provided" && return 1

  secrets_file="${this_folder}/${FILE_SECRETS}"

  if [ -f "$secrets_file" ]; then
    sed -i '' "/export $1/d" "$secrets_file"

    if [ ! -z "$2" ]; then
      echo "export $1=$2" | tee -a "$secrets_file" > /dev/null
    fi
  fi
  info "[add_entry_to_secrets|out]"
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

post_base(){
  info "[post_base|in] ($1)"
    if [ "on" == "$1" ]; then
      add_entry_to_secrets "ARM_ACCESS_KEY" $(terraform output config_storage_account_access_key)
      add_entry_to_secrets "IAC_SP_PSWD" $(terraform output sp_pswd)
      add_entry_to_variables "IAC_SP_ID" $(terraform output sp_app_id)
      add_entry_to_secrets "TF_VAR_sp_eventhubs_object_id" $(terraform output sp_eventhubs_object_id)
    else
      add_entry_to_secrets "ARM_ACCESS_KEY"
      add_entry_to_secrets "IAC_SP_PSWD"
      add_entry_to_variables "IAC_SP_ID"
      add_entry_to_secrets "TF_VAR_sp_eventhubs_object_id"
    fi
  info "[post_base|out]"
}

post_scaffolding()
{
  info "[post_scaffolding|in] ($1)"

#  if [ "on" == "$1" ]; then
#  else
#  fi

  info "[post_scaffolding|out]"
}

init_terraform(){
  info "[init_terraform|in] ($1)"
  if [ "solution_base" != "$1" ]; then
    terraform init -backend-config="resource_group_name=${TF_VAR_resource_group}" \
      -backend-config="storage_account_name=${TF_VAR_configuration_store_account}" \
      -backend-config="container_name=${TF_VAR_tfstate_storage_container}"
  else
    terraform init
  fi
  info "[init_terraform|out]"
}

testOn()
{
  info "[testOn|in] ($1)"
  cd "$test_dir"
  fetchModules
  [ "solution_base" != "$1" ] && sp_login

  init_terraform "$1"
  terraform plan #-var-file="main.tfvars"
  terraform apply -auto-approve -lock=true -lock-timeout=5m #-var-file="main.tfvars"
  terraform output

  [ "solution_base" == "$1" ] && post_base "on"
  [ "solution_scaffolding" == "$1" ] && post_scaffolding "on"

  [ "solution_base" != "$1" ] && sp_logout
  rm -rf "modules"
  rm -rf .terraform.lock*
  cd "$_pwd"
  info "[testOn|out]"
}

testOff()
{
  info "[testOff|in]"
  cd "$test_dir"
  fetchModules
  [ "solution_base" != "$1" ] && sp_login

  init_terraform "$1"
  terraform destroy -lock=true -lock-timeout=5m -auto-approve #-var-file="main.tfvars"

  [ "solution_base" == "$1" ] && post_base "off"
  [ "solution_scaffolding" == "$1" ] && post_scaffolding "off"

  [ "solution_base" != "$1" ] && sp_logout
  rm -rf "modules"
  rm -rf .terraform.lock*
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
        testOn "$module_name"
        ;;
      off)
        testOff "$module_name"
        ;;
      *)
        usage
esac


info "...[ $0 $1 $2 ] done."