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

MODULES_DIR=modules
MODULES_URL=https://github.com/jtviegas/terraform-modules/trunk/modules
STATE_MODULE_TARGET=module.tf-remote-state
SOLVER_SUCCESS_MONITOR_TARGET=datadog_monitor.solver-successrate
API_SUCCESS_MONITOR_TARGET=datadog_monitor.api-successrate
SOLVER_UPTIME_MONITOR_TARGET=datadog_monitor.solver-uptime
API_UPTIME_MONITOR_TARGET=datadog_monitor.api-uptime


this_folder="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
if [ -z "$this_folder" ]; then
  this_folder=$(dirname $(readlink -f $0))
fi

STATE_DIR="$this_folder"/remote-state
MONITORS_DIR="$this_folder"/monitors

if [ -f "$this_folder/include.secret" ]; then
    debug "we have an 'include.secret' file"
    . "$this_folder/include.secret"
fi

info "starting [ $0 $1 $2 ] ..."
_pwd=$(pwd)

usage()
{
  cat <<EOM
  usages:
  $(basename $0) [state|monitor] [on|off]
EOM
  exit 1
}

stateOn()
{
  info "[stateOn|in]"
  cd "$STATE_DIR"
  svn export "$MODULES_URL" "$STATE_DIR/$MODULES_DIR"
  ln -s "$this_folder"/variables.tf "$STATE_DIR"/variables.tf
  terraform init
  terraform plan
  terraform apply -auto-approve -lock=true -lock-timeout=10m
  terraform output storage-account-access-key

  #rm -rf "$STATE_DIR/$MODULES_DIR"
  #rm "$STATE_DIR"/variables.tf
  cd "$this_folder"
  info "[stateOn|out]"
}

stateOff()
{
  info "[stateOff|in]"
  cd "$STATE_DIR"
  svn export "$MODULES_URL" "$STATE_DIR/$MODULES_DIR"
  ln -s "$this_folder"/variables.tf "$STATE_DIR"/variables.tf
  terraform init
  terraform destroy -auto-approve -lock=true -lock-timeout=10m
  rm -rf "$STATE_DIR/$MODULES_DIR"
  rm "$STATE_DIR"/variables.tf
  cd "$this_folder"
  info "[stateOff|out]"
}

monitorOn()
{
  info "[monitorOn|in]"
  cd "$STATE_DIR"
  export ARM_ACCESS_KEY=`terraform output storage-account-access-key`
  cd "$MONITORS_DIR"
  svn export "$MODULES_URL" "$MONITORS_DIR/$MODULES_DIR"
  ln -s "$this_folder"/variables.tf "$MONITORS_DIR"/variables.tf
  terraform init
  terraform plan
  terraform apply -auto-approve -lock=true -lock-timeout=10m
  rm -rf "$MONITORS_DIR/$MODULES_DIR"
  rm "$MONITORS_DIR"/variables.tf
  cd "$this_folder"
  info "[monitorOn|out]"
}

monitorOff()
{
  info "[monitorOff|in]"
  cd "$STATE_DIR"
  export ARM_ACCESS_KEY=`terraform output storage-account-access-key`
  cd "$MONITORS_DIR"
  svn export "$MODULES_URL" "$MONITORS_DIR/$MODULES_DIR"
  ln -s "$this_folder"/variables.tf "$MONITORS_DIR"/variables.tf
  terraform init
  terraform destroy -auto-approve -lock=true -lock-timeout=10m
  rm -rf "$MONITORS_DIR/$MODULES_DIR"
  rm "$MONITORS_DIR"/variables.tf
  cd "$this_folder"
  info "[monitorOff|out]"
}


[ -z $2 ] && { usage; }

case "$1" in
        state)
          case "$2" in
            on)
              stateOn
              ;;
            off)
              stateOff
              ;;
            *)
              usage
          esac
          ;;
        monitor)
          case "$2" in
            on)
              monitorOn
              ;;
            off)
              monitorOff
              ;;
            *)
              usage
          esac
          ;;
        *)
          usage
esac


cd "$_pwd"
info "...[ $0 $1 $2 ] done."