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


stackOn()
{
  info "[stackOn|in]"
  "$this_folder"/test.sh aws/remote-state on
  "$this_folder"/test.sh aws/s3-website on
  "$this_folder"/test.sh aws/domain-certificate on
  "$this_folder"/test.sh aws/website-dns-and-certificate-distribution on
  info "[stackOn|out]"
}

stackOff()
{
  info "[stackOff|in]"
  "$this_folder"/test.sh aws/website-dns-and-certificate-distribution off
  "$this_folder"/test.sh aws/domain-certificate off
  "$this_folder"/test.sh aws/s3-website off
  "$this_folder"/test.sh aws/remote-state off
  info "[stackOff|out]"
}


info "starting [ $0 $1 ] ..."
_pwd=$(pwd)

case "$1" in
      on)
        stackOn
        ;;
      off)
        stackOff
        ;;
      *)
        usage
esac


info "...[ $0 $1 ] done."