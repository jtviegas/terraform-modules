#!/bin/sh

MODULES_DIR=modules
MODULES_URL=https://github.com/jtviegas/terraform-modules/trunk/modules
this_folder="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

usage()
{
  cat <<EOM
  usage:
  $(basename $0) [deploy|undeploy]
EOM
  exit 1
}

[ -z $1 ] && { usage; }
[ ! "$1" == "deploy" ] && [ ! "$1" == "undeploy" ] && { usage; }

echo "starting [ $0 $1 ]..."
_pwd=$(pwd)

svn export "$MODULES_URL" "$this_folder/$MODULES_DIR"

if [ "$1" == "deploy" ]; then
      terraform init
      terraform plan
      terraform apply -auto-approve -lock=true -lock-timeout=10m
else
    terraform destroy -auto-approve -lock=true -lock-timeout=10m
fi

rm -rf "$this_folder/$MODULES_DIR"
cd "$_pwd"
echo "...[ $0 $1 ] done."