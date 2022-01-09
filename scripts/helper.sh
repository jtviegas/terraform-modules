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

. "${this_folder}/include.sh"

if [ -f "${parent_folder}/.variables" ]; then
    debug "we have a '.variables' file"
    . "${parent_folder}/.variables"
fi

if [ -f "${parent_folder}/.secrets" ]; then
    debug "we have a '.secrets' file"
    . "${parent_folder}/.secrets"
fi

add_entry_to_secrets()
{
  info "[add_entry_to_secrets|in] ($1, $2)"
  [ -z "$1" ] && err "no parameters provided" && return 1

  if [ -f "${parent_folder}/.secrets" ]; then
    sed -i '' "/export $1/d" "${parent_folder}/.secrets"

    if [ ! -z "$2" ]; then
      echo "export $1=$2" | tee -a "${parent_folder}/.secrets" > /dev/null
    fi
  fi
  info "[add_entry_to_secrets|out]"
}

add_entry_to_variables()
{
  info "[add_entry_to_variables|in] ($1, $2)"
  [ -z "$1" ] && err "no parameters provided" && return 1

  if [ -f "${parent_folder}/.variables" ]; then
    sed -i '' "/export $1/d" "${parent_folder}/.variables"

    if [ ! -z "$2" ]; then
      echo "export $1=$2" | tee -a "${parent_folder}/.variables" > /dev/null
    fi
  fi
  info "[add_entry_to_variables|out]"
}


az_sp_commands()
{
cat <<EOM
  azure handy commands:
    list all sp's:        az ad sp list --all --query "[].{displayName:displayName, objectId:objectId}" --output tsv
    get details of sp:    az ad sp list --display-name "{displayName}"
    list roles:           az role definition list --query "[].{name:name, roleType:roleType, roleName:roleName}" --output tsv
    get details of role:  az role definition list --name "{roleName}"
    get resource groups:  az group list --query "[].{name:name}" --output tsv
EOM
}

az_create_sp()
{
  info "[az_create_sp|in]"
  out=$(az ad sp create-for-rbac --name="$AZURE_SP_NAME" --skip-assignment --scopes="/subscriptions/${ARM_SUBSCRIPTION_ID}" -o tsv)
  if [ "$?" -eq "0" ] ; then
    app_id=$(echo "$out" | awk '{print $1}')
    secret=$(echo "$out" | awk '{print $4}')
    add_entry_to_secrets "ARM_CLIENT_SECRET" "$secret"
    add_entry_to_variables "ARM_CLIENT_ID" "$app_id"
  fi
  info "[az_create_sp|out]"
}

az_delete_sp()
{
  info "[az_delete_sp|in]"
  az ad sp delete --id "${ARM_CLIENT_ID}"
  if [ "$?" -eq "0" ] ; then
    add_entry_to_secrets "ARM_CLIENT_SECRET"
    add_entry_to_variables "ARM_CLIENT_ID"
  fi
  info "[az_delete_sp|out]"
}

az_set_sp_role()
{
  info "[az_set_sp_role|in] ($1, $2, $3)"

  [ -z "$1" ] && err "no role provided" && return 1
  [ -z "$2" ] && err "no sp app display name provided" && return 1
  [ -z "$3" ] && err "no resource group provided" && return 1

  role="$1"
  sp_app_name="$2"
  rg="$3"

  objId=$(az ad sp list --display-name "$sp_app_name" -o tsv | awk '{print $18}')
  if [ "$?" -eq "0" ] ; then
    info "[az_set_sp_role] found objId: $objId"
    roleId=$(az role definition list --name "$role" --query "[0].name" | tr -d '"')
    info "[az_set_sp_role] found roleId: $roleId"
    if [ "$?" -eq "0" ] ; then
      az role assignment create --assignee-principal-type "ServicePrincipal" --assignee-object-id "${objId}" --role "${roleId}" # --resource-group "${rg}"
    else
      err "[az_set_sp_role] something wrong in finding the roleId for $role"
    fi

  else
    err "[az_set_sp_role] something wrong in finding the objId for the sp app: $sp_app_name"
  fi

  info "[az_set_sp_role|out]"
}

az_sp_login()
{
  info "[az_sp_login|in]"
  az login --service-principal -u "${ARM_CLIENT_ID}" -p "${ARM_CLIENT_SECRET}" --tenant "${ARM_TENANT_ID}"
  info "[az_sp_login|out]"
}

az_login_check()
{
  info "[az_login_check|in]"
  az vm list-sizes --location westus
  info "[az_login_check|out]"
}

az_logout()
{
  info "[az_logout|in]"
  az logout
  info "[az_logout|out]"
}

az_list_sp_roles()
{
  info "[az_list_sp_roles|in] ($1)"

  [ -z "$1" ] && err "no sp app display name provided" && return 1
  sp_app_name="$1"
  az role assignment list --all --assignee "${sp_app_name}" --output json --query '[].{principalName:principalName, roleDefinitionName:roleDefinitionName, scope:scope}'

  info "[az_list_sp_roles|out]"
}

usage()
{
  cat <<EOM
  usages:
  $(basename $0) {az} [sp_create|sp_set_owner|sp_login|login_check|logout|sp_delete|commands]
                          sp_create     creates azure service principal in an app named 'terraform' with no roles
                          sp_set_owner  adds Owner role to the service principal defined in ARM_CLIENT_ID
                          sp_login      logs in using the service principal defined in ARM_CLIENT_ID
                          login_check   checks if logged in correctly listing VM's sizes
                          logout        logs out from current azure cli session
                          sp_delete     deletes the service principal defined in ARM_CLIENT_ID
                          commands      lists handy azure cli commands
                          sp_roles      lists roles assigned to the service principal defined in ARM_CLIENT_ID
EOM
  exit 1
}

info "starting [ $0 $1 $2 ] ..."
_pwd=$(pwd)

case "$1" in
      az)
        case "$2" in
              sp_create)
                az_create_sp
                ;;
              sp_set_owner)
                az_set_sp_role "$AZURE_OWNER_ROLE" "$AZURE_SP_NAME" "$RESOURCE_GROUP"
                az_set_sp_role "Application Administrator" "$AZURE_SP_NAME" "$RESOURCE_GROUP"
                ;;
              sp_login)
                az_sp_login
                ;;
              login_check)
                az_login_check
                ;;
              logout)
                az_logout
                ;;
              sp_delete)
                az_delete_sp
                ;;
              commands)
                az_sp_commands
                ;;
              sp_roles)
                az_list_sp_roles "$ARM_CLIENT_ID"
                ;;
              *)
                usage
                ;;
        esac
        ;;
      *)
        usage
esac
info "...[ $0 $1 $2 ] done."






