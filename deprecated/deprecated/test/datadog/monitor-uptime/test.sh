#!/bin/sh

debug(){
    local __msg="$1"
    echo "\n [DEBUG] `date` ... $__msg\n"
}

info(){
    local __msg="$1"
    echo "\n [INFO]  `date` ->>> $__msg\n"
}

warn(){
    local __msg="$1"
    echo "\n [WARN]  `date` *** $__msg\n"
}

err(){
    local __msg="$1"
    echo "\n [ERR]   `date` !!! $__msg\n"
}

this_folder="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
if [ -z "$this_folder" ]; then
  this_folder=$(dirname $(readlink -f $0))
fi
parent_folder=$(dirname "$this_folder")
test_folder=$(dirname "$parent_folder")

MODULES_DIR=modules
MODULES_URL=https://github.com/jtviegas/terraform-modules/trunk/modules

if [ -f "$test_folder/secrets.inc" ]; then
    debug "we have an 'secrets.inc' file"
    . "$test_folder/secrets.inc"
fi

info "starting [ $0 $1 ] ..."
_pwd=$(pwd)

usage()
{
  cat <<EOM
  usages:
  $(basename $0) [on|off]
EOM
  exit 1
}

testOn()
{
  info "[testOn|in]"
  cd "$this_folder"
  svn export "$MODULES_URL" "$this_folder/$MODULES_DIR"
  terraform init
  terraform plan
  terraform apply -auto-approve -lock=true -lock-timeout=10m
  terraform output
  rm -rf "$this_folder/$MODULES_DIR"
  cd "$_pwd"
  info "[testOn|out]"
}

testOff()
{
  info "[testOff|in]"
  cd "$this_folder"
  svn export "$MODULES_URL" "$this_folder/$MODULES_DIR"
  terraform init
  terraform destroy -auto-approve -lock=true -lock-timeout=10m
  rm -rf "$this_folder/$MODULES_DIR"
  cd "$_pwd"
  info "[testOff|out]"
}


[ -z $1 ] && { usage; }

case "$1" in
      on)
        testOn
        ;;
      off)
        testOff
        ;;
      *)
        usage
esac


info "...[ $0 $1 ] done."