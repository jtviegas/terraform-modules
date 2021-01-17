#!/usr/bin/env bash

# http://bash.cumulonim.biz/NullGlob.html
shopt -s nullglob

this_folder="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
if [ -z "$this_folder" ]; then
  this_folder=$(dirname $(readlink -f $0))
fi
parent_folder=$(dirname "$this_folder")

export ADDITIONAL_SECRETS="$parent_folder/secrets.inc"

# --- START include bashutils SECTION ---
_pwd=$(pwd)
cd "$this_folder"
curl -s https://api.github.com/repos/tgedr/bashutils/releases/latest \
| grep "browser_download_url.*utils\.tar\.bz2" \
| cut -d '"' -f 4 | wget -qi -
tar xjpvf utils.tar.bz2
rm utils.tar.bz2
. "$this_folder/bashutils.inc"
cd "$_pwd"
# --- END include bashutils SECTION ---

usage() {
  cat <<EOM
  usage:
  $(basename $0) { deploy | undeploy }

      - deploy: apply terraform resources
      - undeploy: destroy terraform resources
      - get_function: download the function
EOM
  exit 1
}

debug "1: $1 2: $2 3: $3 4: $4 5: $5 6: $6 7: $7 8: $8 9: $9"

case "$1" in
  deploy)
    terraform_autodeploy "$this_folder"
    ;;
  undeploy)
    terraform_autodestroy "$this_folder"
    ;;
  get_function)
    get_function_release "$FUNCTION_REPO" "$FUNCTION_ARTIFACT"
    ;;
  *)
    usage
    ;;
esac