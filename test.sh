#!/usr/bin/env bash

# ===> COMMON SECTION START  ===>
# http://bash.cumulonim.biz/NullGlob.html
shopt -s nullglob

# ---------- CONSTANTS ----------
MODULES_URL=https://github.com/jtviegas/terraform-modules/branches/zero_thirteen/modules
# -------------------------------

if [ -z "$this_folder" ]; then
  this_folder="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
  if [ -z "$this_folder" ]; then
    this_folder=$(dirname $(readlink -f $0))
  fi
fi

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

if [ -f "$parent_folder/include.secret" ]; then
    debug "we have an 'include.secret' file"
    . "$parent_folder/include.secret"
fi

usage()
{
  cat <<EOM
  usages:
  $(basename $0) {module-test-folder} [on|off]
EOM
  exit 1
}

[ -z "$2" ] && { usage; }

module_dir="$1"
test_dir="${this_folder}/test/$1"
src_dir="${this_folder}/modules/$1"

if [ ! -d "$test_dir" ]; then
  err "not a test folder: $test_dir"
  exit 1
fi

if [ ! -d "$src_dir" ]; then
  err "not a module folder: $src_dir"
  exit 1
fi

info "starting [ $0 $1 $2 ] ..."
_pwd=$(pwd)

testOn()
{
  info "[testOn|in]"
  cd "$test_dir"
  svn export "$MODULES_URL" "modules"
  terraform init
  terraform plan -var-file="main.tfvars"
  terraform apply -auto-approve -lock=true -lock-timeout=10m -var-file="main.tfvars"
  terraform output
  rm -rf "modules"
  cd "$_pwd"
  info "[testOn|out]"
}

testOff()
{
  info "[testOff|in]"
  cd "$test_dir"
  svn export "$MODULES_URL" "modules"
  terraform init
  terraform destroy -auto-approve -lock=true -lock-timeout=10m -var-file="main.tfvars"
  rm -rf "modules"
  cd "$_pwd"
  info "[testOff|out]"
}

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