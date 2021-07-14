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

usage()
{
  cat <<EOM
  usages:
  $(basename $0) [on|off]
EOM
  exit 1
}


userOn()
{
  info "[userOn|in]"
  "$this_folder"/test.sh aws/ops-group on
  "$this_folder"/test.sh aws/ops-user on
  info "[userOn|out]"
}

userOff()
{
  info "[userOff|in]"
  "$this_folder"/test.sh aws/ops-user off
  "$this_folder"/test.sh aws/ops-group off
  info "[userOff|out]"
}


info "starting [ $0 $1 ] ..."
_pwd=$(pwd)

case "$1" in
      on)
        userOn
        ;;
      off)
        userOff
        ;;
      *)
        usage
esac


info "...[ $0 $1 ] done."