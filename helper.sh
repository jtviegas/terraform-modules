#!/usr/bin/env bash

# ===> COMMON SECTION START  ===>

# http://bash.cumulonim.biz/NullGlob.html
shopt -s nullglob
# -------------------------------
this_folder="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
if [ -z "$this_folder" ]; then
  this_folder=$(dirname $(readlink -f $0))
fi
parent_folder=$(dirname "$this_folder")
# -------------------------------
debug(){
    local __msg="$1"
    echo " [DEBUG] `date` ... $__msg "
}

info(){
    local __msg="$1"
    echo " [INFO]  `date` ->>> $__msg "
}

warn(){
    local __msg="$1"
    echo " [WARN]  `date` *** $__msg "
}

err(){
    local __msg="$1"
    echo " [ERR]   `date` !!! $__msg "
}
# ---------- CONSTANTS ----------
export FILE_VARIABLES=${FILE_VARIABLES:-".variables"}
export FILE_LOCAL_VARIABLES=${FILE_LOCAL_VARIABLES:-".local_variables"}
export FILE_SECRETS=${FILE_SECRETS:-".secrets"}
export NAME="bashutils"
export INCLUDE_FILE=".${NAME}"
export TAR_NAME="${NAME}.tar.bz2"
# -------------------------------
if [ ! -f "$this_folder/$FILE_VARIABLES" ]; then
  warn "we DON'T have a $FILE_VARIABLES variables file - creating it"
  touch "$this_folder/$FILE_VARIABLES"
else
  . "$this_folder/$FILE_VARIABLES"
fi

if [ ! -f "$this_folder/$FILE_LOCAL_VARIABLES" ]; then
  warn "we DON'T have a $FILE_LOCAL_VARIABLES variables file - creating it"
  touch "$this_folder/$FILE_LOCAL_VARIABLES"
else
  . "$this_folder/$FILE_LOCAL_VARIABLES"
fi

if [ ! -f "$this_folder/$FILE_SECRETS" ]; then
  warn "we DON'T have a $FILE_SECRETS secrets file - creating it"
  touch "$this_folder/$FILE_SECRETS"
else
  . "$this_folder/$FILE_SECRETS"
fi
# ---------- FUNCTIONS ----------
update_bashutils(){
  echo "[update_bashutils] ..."

  tar_file="${NAME}.tar.bz2"
  _pwd=`pwd`
  cd "$this_folder"

  curl -s https://api.github.com/repos/jtviegas/bashutils/releases/latest \
  | grep "browser_download_url.*${NAME}\.tar\.bz2" \
  | cut -d '"' -f 4 | wget -qi -
  tar xjpvf $tar_file
  if [ ! "$?" -eq "0" ] ; then echo "[update_bashutils] could not untar it" && cd "$_pwd" && return 1; fi
  rm $tar_file

  cd "$_pwd"
  echo "[update_bashutils] ...done."
}
# ---------- include bashutils ----------
. ${this_folder}/${INCLUDE_FILE}
# <=== COMMON SECTION END  <===

# ===> MAIN SECTION ===>

# ---------- LOCAL CONSTANTS ----------
# MODULES_URL=https://github.com/jtviegas/terraform-modules/branches/zero_thirteen/modules
MODULES_DIR="${this_folder}/modules"
# MODE=LOCAL # LOCAL or REMOTE
TEST_DIR="$this_folder/test"
# ---------- FUNCTIONS ----------

commands()
{
  cat <<EOM
  commands:
  aws configure list    : list current AWS configuration
EOM
}




postprocess()
{
  [ "$1" != "id" ] && [ "$1" != "state" ] && err "postprocessing can only be id or state" && return 
  local postprocessing="$1"
  local operation="$2"
  if [ "$postprocessing" == "id" ]; then
    if [ "$operation" == "on" ]; then
      access_key=$(terraform output access_key)
      add_entry_to_secrets "ID_ACCESS_KEY" "${access_key}"
      access_key_id=$(terraform output access_key_id)
      add_entry_to_variables "ID_ACCESS_KEY_ID" "${access_key_id}"
    elif [ "$operation" == "off" ]; then
      add_entry_to_secrets "ID_ACCESS_KEY"
      add_entry_to_variables "ID_ACCESS_KEY_ID"
    fi
  fi

  #if [ "$postprocessing" == "state" ]; then

  #fi

}

test()
{
  info "[test|in] (provider=$1, module=$2, operation=$3)"

  local result=0
  local provider="$1"
  local module="$2"
  local operation="$3"

  [ "$operation" != "on" ] && [ "$operation" != "off" ] && usage

  local test_dir="${TEST_DIR}/${provider}/${module}"

  _pwd=`pwd`
  cd "$test_dir" && cp -R "$MODULES_DIR" "modules"

  if [ "$operation" == "on" ]; then
    terraform init
    terraform plan -var-file="main.tfvars"
    terraform apply -auto-approve -lock=true -lock-timeout=5m -var-file="main.tfvars"
  elif [ "$operation" == "off" ]; then
    terraform init
    terraform destroy -lock=true -lock-timeout=5m -auto-approve -var-file="main.tfvars"
  fi

  rm -rf "modules"
  cd "$_pwd"

  info "[test|out]"
}



# -------------------------------

usage() {
  cat <<EOM
  usage:
  $(basename $0)
      commands                                  : list handy commands
      test { provider } { module } { on|off }   : test module
      update                                    : updates the include '.bashutils' file
EOM
  exit 1
}

debug "1: $1 2: $2 3: $3 4: $4 5: $5 6: $6 7: $7 8: $8 9: $9"


case "$1" in
  test)
    ([ -z $2 ] || [ -z $3 ] || [ -z $4 ]) && usage
    test "$2" "$3" "$4"
    ;;
  update)
    update_bashutils
    ;;
  commands)
    commands
    ;;
  *)
    usage
    ;;
esac

debug "...[ $0 $1 $2 $3 $4 ] done."
# -------------------------------





