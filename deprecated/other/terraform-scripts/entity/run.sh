#!/bin/sh

LOG_TRACE=TRUE
STATE_LOCK_TIMEOUT=5m
MODULES_DIR=modules
MODULES_URL=https://github.com/jtviegas/terraform-modules/trunk/modules
DEPLOYMENTS_DIR=deployments
VARIABLES_SPEC=variables.tf
REMOTE_STATE_DIR=tf-remote-state
REMOTE_STATE_SPEC=tf-remote-state.tf
LOADER_DIR=entity-loader
LOADER_SPEC=entity-loader.tf
LOADER_ZIP_URL=https://github.com/jtviegas/entity-loader/raw/master/artifacts/entity-loader.zip
LOADER_ZIP=entity-loader.zip
API_DIR=entity-api
API_SPEC=entity-api.tf
API_ZIP_URL=https://github.com/jtviegas/entity-api/raw/master/artifacts/entity-api.zip
API_ZIP=entity-api.zip
TABLES_DIR=tables
TABLES_SPEC=tables.tf

this_folder=$(dirname $(readlink -f $0))
if [ -z "$this_folder" ]; then
  this_folder="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
fi
echo "this_folder: $this_folder"

variables_src="$this_folder/$VARIABLES_SPEC"
remote_state_src="$this_folder/$REMOTE_STATE_SPEC"
loader_src="$this_folder/$LOADER_SPEC"
api_src="$this_folder/$API_SPEC"
tables_src="$this_folder/$TABLES_SPEC"

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

goin(){
    if [ ! -z $LOG_TRACE ]; then
        local __msg="$1"
        local __params="$2"
        echo "\n [IN]    `date` ___ $__msg [$__params]\n"
    fi
}

goout(){
    if [ ! -z $LOG_TRACE ]; then
        local __msg="$1"
        local __outcome="$2"
        echo "\n [OUT]   `date` ___ $__msg [$__outcome]\n"
    fi
}

init()
{
  goin "[init]" "$1"
  local _folder="$1"

  if [ ! -d "$_folder" ]; then
    mkdir -p "$_folder"
  fi

  svn export -q "$MODULES_URL" "$_folder/$MODULES_DIR"

  goout "[init]"
}

cleanupKeepState()
{
  goin "[cleanupKeepState]" "$1"
  local _folder="$1"

  rm -rf "$_folder/$MODULES_DIR"

  goout "[cleanupKeepState]"
}

cleanup()
{
  goin "[cleanup]"
  local _folder="$1"

  rm -rf "$_folder"

  goout "[cleanup]"
}

deployState()
{
  goin "[deployState]" "$1"
  local _env="$1"
  local _deploy_dir="$this_folder/$DEPLOYMENTS_DIR/$REMOTE_STATE_DIR/$_env"

  init "$_deploy_dir"
  _pwd=`pwd`
  cd "$_deploy_dir"

  _variables_target="$_deploy_dir/$VARIABLES_SPEC"
  _spec_target="$_deploy_dir/$REMOTE_STATE_SPEC"

  ln -s "$variables_src" "$_variables_target"
  ln -s "$remote_state_src" "$_spec_target"

  local _r=0
  terraform init
  _r=$?

  if [ "$_r" -eq "0" ]; then
    terraform plan
    _r=$?
  fi
  if [ "$_r" -eq "0" ]; then
    terraform apply -lock=true -lock-timeout=$STATE_LOCK_TIMEOUT
    _r=$?
  fi

  rm -f "$_variables_target" "$_spec_target"
  cd "$_pwd"
  cleanupKeepState "$_deploy_dir"
  goout "[deployState]" "$_r"
}

undeployState()
{
  goin "[undeployState]" "$1"
  local _env="$1"
  local _deploy_dir="$this_folder/$DEPLOYMENTS_DIR/$REMOTE_STATE_DIR/$_env"

  init "$_deploy_dir"
  _pwd=`pwd`
  cd "$_deploy_dir"

  _variables_target="$_deploy_dir/$VARIABLES_SPEC"
  _spec_target="$_deploy_dir/$REMOTE_STATE_SPEC"

  ln -s "$variables_src" "$_variables_target"
  ln -s "$remote_state_src" "$_spec_target"

  local _r=0
  terraform destroy -lock=true -lock-timeout=5m
  _r=$?

  rm -f "$_variables_target" "$_spec_target"
  cd "$_pwd"
  cleanup "$_deploy_dir"
  goout "[undeployState]" "$_r"
}

deployLoader()
{
  goin "[deployLoader]" "$1"

  local _env="$1"
  local _deploy_dir="$this_folder/$DEPLOYMENTS_DIR/$LOADER_DIR/$_env"

  init "$_deploy_dir"
  _pwd=`pwd`
  cd "$_deploy_dir"

  _variables_target="$_deploy_dir/$VARIABLES_SPEC"
  _spec_target="$_deploy_dir/$LOADER_SPEC"
  _zip="$_deploy_dir/$LOADER_ZIP"

  ln -s "$variables_src" "$_variables_target"
  sed "s/\$ENV/$TF_VAR_env/g" "$loader_src" > "$_spec_target"
  sed "s/\$APP/$TF_VAR_app/g" "$_spec_target" > "${_spec_target}_tmp"
  sed "s/\$REGION/$TF_VAR_region/g" "${_spec_target}_tmp" > "$_spec_target"
  wget $LOADER_ZIP_URL --output-document="$_zip"

  local _r=0
  terraform init
  _r=$?

  if [ "$_r" -eq "0" ]; then
    terraform plan
    _r=$?
  fi
  if [ "$_r" -eq "0" ]; then
    terraform apply -lock=true -lock-timeout=$STATE_LOCK_TIMEOUT
    _r=$?
  fi

  rm -f "$_variables_target" "$_zip" "$_spec_target" "${_spec_target}_tmp"
  cd "$_pwd"
  cleanup "$_deploy_dir"

  goout "[deployLoader]" "$_r"
}

undeployLoader()
{
  goin "[undeployLoader]" "$1"

  local _env="$1"
  local _deploy_dir="$this_folder/$DEPLOYMENTS_DIR/$LOADER_DIR/$_env"

  init "$_deploy_dir"
  _pwd=`pwd`
  cd "$_deploy_dir"

  _variables_target="$_deploy_dir/$VARIABLES_SPEC"
  _spec_target="$_deploy_dir/$LOADER_SPEC"

  ln -s "$variables_src" "$_variables_target"
  sed "s/\$ENV/$TF_VAR_env/g" "$loader_src" > "$_spec_target"
  sed "s/\$APP/$TF_VAR_app/g" "$_spec_target" > "${_spec_target}_tmp"
  sed "s/\$REGION/$TF_VAR_region/g" "${_spec_target}_tmp" > "$_spec_target"

  local _r=0
  terraform init
  _r=$?

  if [ "$_r" -eq "0" ]; then
    terraform destroy -lock=true -lock-timeout=5m
    _r=$?
  fi

  rm -f "$_variables_target" "$_spec_target" "${_spec_target}_tmp"
  cd "$_pwd"
  cleanup "$_deploy_dir"

  goout "[undeployLoader]" "$_r"
}

deployApi()
{
  goin "[deployApi]" "$1"

  local _env="$1"
  local _deploy_dir="$this_folder/$DEPLOYMENTS_DIR/$API_DIR/$_env"

  init "$_deploy_dir"
  _pwd=`pwd`
  cd "$_deploy_dir"

  _variables_target="$_deploy_dir/$VARIABLES_SPEC"
  _spec_target="$_deploy_dir/$API_SPEC"
  _zip="$_deploy_dir/$API_ZIP"

  ln -s "$variables_src" "$_variables_target"
  sed "s/\$ENV/$TF_VAR_env/g" "$api_src" > "$_spec_target"
  sed "s/\$APP/$TF_VAR_app/g" "$_spec_target" > "${_spec_target}_tmp"
  sed "s/\$REGION/$TF_VAR_region/g" "${_spec_target}_tmp" > "$_spec_target"
  wget $API_ZIP_URL --output-document="$_zip"

  local _r=0
  terraform init
  _r=$?

  if [ "$_r" -eq "0" ]; then
    terraform plan
    _r=$?
  fi
  if [ "$_r" -eq "0" ]; then
    terraform apply -lock=true -lock-timeout=$STATE_LOCK_TIMEOUT
    _r=$?
  fi

  rm -f "$_variables_target" "$_zip" "$_spec_target" "${_spec_target}_tmp"
  cd "$_pwd"
  cleanup "$_deploy_dir"


  goout "[deployApi]" "$_r"
}

undeployApi()
{
  goin "[undeployApi]" "$1"

  local _env="$1"
  local _deploy_dir="$this_folder/$DEPLOYMENTS_DIR/$API_DIR/$_env"

  init "$_deploy_dir"
  _pwd=`pwd`
  cd "$_deploy_dir"

  _variables_target="$_deploy_dir/$VARIABLES_SPEC"
  _spec_target="$_deploy_dir/$API_SPEC"

  ln -s "$variables_src" "$_variables_target"
  sed "s/\$ENV/$TF_VAR_env/g" "$api_src" > "$_spec_target"
  sed "s/\$APP/$TF_VAR_app/g" "$_spec_target" > "${_spec_target}_tmp"
  sed "s/\$REGION/$TF_VAR_region/g" "${_spec_target}_tmp" > "$_spec_target"

  local _r=0
  terraform init
  _r=$?

  if [ "$_r" -eq "0" ]; then
    terraform destroy -lock=true -lock-timeout=5m
    _r=$?
  fi

  rm -f "$_variables_target" "$_spec_target" "${_spec_target}_tmp"
  cd "$_pwd"
  cleanup "$_deploy_dir"

  goout "[undeployApi]" "$_r"
}

deployTables()
{
  goin "[deployTables]" "$1"

  local _env="$1"
  local _deploy_dir="$this_folder/$DEPLOYMENTS_DIR/$TABLES_DIR/$_env"

  init "$_deploy_dir"
  _pwd=`pwd`
  cd "$_deploy_dir"

  _variables_target="$_deploy_dir/$VARIABLES_SPEC"
  _spec_target="$_deploy_dir/$TABLES_SPEC"

  ln -s "$variables_src" "$_variables_target"
  sed "s/\$ENV/$TF_VAR_env/g" "$tables_src" > "$_spec_target"
  sed "s/\$APP/$TF_VAR_app/g" "$_spec_target" > "${_spec_target}_tmp"
  sed "s/\$REGION/$TF_VAR_region/g" "${_spec_target}_tmp" > "$_spec_target"

  local _r=0
  terraform init
  _r=$?

  if [ "$_r" -eq "0" ]; then
    terraform plan
    _r=$?
  fi
  if [ "$_r" -eq "0" ]; then
    terraform apply -lock=true -lock-timeout=$STATE_LOCK_TIMEOUT
    _r=$?
  fi

  rm -f "$_variables_target" "$_spec_target" "${_spec_target}_tmp"
  cd "$_pwd"
  cleanup "$_deploy_dir"

  goout "[deployTables]" "$_r"
}

undeployTables()
{
  goin "[undeployTables]" "$1"

  local _env="$1"
  local _deploy_dir="$this_folder/$DEPLOYMENTS_DIR/$TABLES_DIR/$_env"

  init "$_deploy_dir"
  _pwd=`pwd`
  cd "$_deploy_dir"

  _variables_target="$_deploy_dir/$VARIABLES_SPEC"
  _spec_target="$_deploy_dir/$TABLES_SPEC"

  ln -s "$variables_src" "$_variables_target"
  sed "s/\$ENV/$TF_VAR_env/g" "$tables_src" > "$_spec_target"
  sed "s/\$APP/$TF_VAR_app/g" "$_spec_target" > "${_spec_target}_tmp"
  sed "s/\$REGION/$TF_VAR_region/g" "${_spec_target}_tmp" > "$_spec_target"

  local _r=0
  terraform init
  _r=$?

  if [ "$_r" -eq "0" ]; then
    terraform destroy -lock=true -lock-timeout=5m
    _r=$?
  fi

  rm -f "$_variables_target" "$_spec_target" "${_spec_target}_tmp"
  cd "$_pwd"
  cleanup "$_deploy_dir"

  goout "[undeployTables]" "$_r"
}

usage()
{
  cat <<EOM
  usage:
  $(basename $0) {state|loader|api|tables} {deploy|undeploy} {dev|pro} {<appname>} [<region>=eu-west-1]
EOM
  exit 1
}


[ -z $4 ] && { usage; }
[ "$3" != "dev" ] && [ "$3" != "pro" ] && { usage; }

export TF_VAR_app=$4
export TF_VAR_env=$3

if [ -z "$5" ]; then
  export TF_VAR_region="eu-west-1"
else
  export TF_VAR_region="$5"
fi

case "$1" in
        state)
            case "$2" in
                    deploy)
                      deployState "$3"
                      ;;
                    undeploy)
                      undeployState "$3"
                      ;;
                    *)
                      usage
            esac
            ;;
        loader)
            case "$2" in
                    deploy)
                      deployLoader "$3"
                      ;;
                    undeploy)
                      undeployLoader "$3"
                      ;;
                    *)
                      usage
            esac
            ;;
        api)
            case "$2" in
                    deploy)
                      deployApi "$3"
                      ;;
                    undeploy)
                      undeployApi "$3"
                      ;;
                    *)
                      usage
            esac
            ;;
        tables)
            case "$2" in
                    deploy)
                      deployTables "$3"
                      ;;
                    undeploy)
                      undeployTables "$3"
                      ;;
                    *)
                      usage
            esac
            ;;
        *)
            usage
esac


