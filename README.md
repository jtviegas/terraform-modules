# terraform-modules
handy terraform modules

## how to use

### 1. setup 
#### 1.1. download helper script
download the appropriate script for your system, you can find the various scripts in the scripts folder.

...if you are on Ubuntu, run:
```
wget -O helper.sh --no-check-certificate https://raw.githubusercontent.com/jtviegas/terraform-modules/master/scripts/ubuntu.sh && chmod +x helper.sh
```

...if you run the script with no options, you'll get the available features: `./helper.sh`
```
root@842b3e423955:~# ./helper.sh
 [DEBUG] Sun Nov  7 18:25:42 CET 2021 ... we have a '.variables' file
 [DEBUG] Sun Nov  7 18:25:42 CET 2021 ... we have a '.secrets' file
 [INFO]  Sun Nov  7 18:25:42 CET 2021 ->>> starting [ ./helper.sh   ] ...
  usages:
  helper.sh sys {reqs}
                          reqs   install required packages

  helper.sh az {login|check}
                          login   logs in using the service principal credentials defined in environment
                                    (check '.variables' and '.secrets' files)
                          check   checks if logged in correctly listing VM's sizes
```

#### 1.2. install system requirements

run: `./helper.sh sys reqs`
```
root@842b3e423955:~# ./helper.sh sys reqs
 [DEBUG] Sun Nov  7 18:28:16 CET 2021 ... we have a '.variables' file
 [DEBUG] Sun Nov  7 18:28:16 CET 2021 ... we have a '.secrets' file
 [INFO]  Sun Nov  7 18:28:16 CET 2021 ->>> starting [ ./helper.sh sys reqs ] ...
 [INFO]  Sun Nov  7 18:28:16 CET 2021 ->>> [sys_reqs] ...
 [INFO]  Sun Nov  7 18:28:16 CET 2021 ->>> [sys_reqs] terraform is already installed
 [INFO]  Sun Nov  7 18:28:16 CET 2021 ->>> [sys_reqs] ...done.
 [INFO]  Sun Nov  7 18:28:16 CET 2021 ->>> ...[ ./helper.sh sys reqs ] done.
```

#### 1.3. install platform requirements

##### 1.3.1. azure
run: `./helper.sh az reqs`
```
root@842b3e423955:~# ./helper.sh az reqs
 [DEBUG] Sun Nov  7 18:40:12 CET 2021 ... we have a '.variables' file
 [DEBUG] Sun Nov  7 18:40:12 CET 2021 ... we have a '.secrets' file
 [INFO]  Sun Nov  7 18:40:12 CET 2021 ->>> starting [ ./helper.sh az reqs ] ...
 [INFO]  Sun Nov  7 18:40:12 CET 2021 ->>> [az_reqs] ...
 [INFO]  Sun Nov  7 18:40:12 CET 2021 ->>> [az_reqs] installing azure-cli
Get:1 http://security.ubuntu.com/ubuntu focal-security InRelease [114 kB]
...
Unpacking azure-cli (2.30.0-1~focal) ...
Setting up azure-cli (2.30.0-1~focal) ...
 [INFO]  Sun Nov  7 18:49:33 CET 2021 ->>> [az_reqs] ...done.
 [INFO]  Sun Nov  7 18:49:33 CET 2021 ->>> ...[ ./helper.sh az reqs ] done.
```

##### 1.3.2. aws
TODO
#### 1.4. connect to platform
##### 1.4.1. azure
- login to azure with your main account: `az login`
```
root@842b3e423955:~# az login
To sign in, use a web browser to open the page https://microsoft.com/devicelogin and enter the code DY8JUMNJ9 to authenticate.
[
  {
    "cloudName": "AzureCloud",
    "homeTenantId": "d69819b1-740d-435a-8ff4-c41cdb1df926",
    "id": "6175f3e6-4d8c-4157-a15c-0a45e7e98580",
    "isDefault": true,
    "managedByTenants": [],
    "name": "tgedr",
    "state": "Enabled",
    "tenantId": "d69819b1-740d-435a-8ff4-c41cdb1df926",
    "user": {
      "name": "tmp.tgedr@gmail.com",
      "type": "user"
    }
  }
]
```
- export the following environment variables accordingly to your azure account:
  - in `.variables`:
    - ARM_SUBSCRIPTION_ID
- create a service principal, run: `./helper az create_sp`
```
root@842b3e423955:~# ./helper.sh az create_sp
 [DEBUG] Sun Nov  7 19:19:33 CET 2021 ... we have a '.variables' file
 [DEBUG] Sun Nov  7 19:19:33 CET 2021 ... we have a '.secrets' file
 [INFO]  Sun Nov  7 19:19:33 CET 2021 ->>> starting [ ./helper.sh az create_sp ] ...
 [INFO]  Sun Nov  7 19:19:33 CET 2021 ->>> [az_create_sp|in]
Creating 'Contributor' role assignment under scope '/subscriptions/6175f3e6-4d8c-4157-a15c-0a45e7e98580'
The output includes credentials that you must protect. Be sure that you do not include these credentials in your code or check the credentials into your source control. For more information, see https://aka.ms/azadsp-cli
'name' property in the output is deprecated and will be removed in the future. Use 'appId' instead.
AppId                                 DisplayName                    Name                                  Password                            Tenant
------------------------------------  -----------------------------  ------------------------------------  ----------------------------------  ------------------------------------
5c88b533-5949-4ea7-998d-d2757fc5162e  azure-cli-2021-11-07-18-19-35  5c88b533-5949-4ea7-998d-d2757fc5162e  ....                                d69819b1-740d-435a-8ff4-c41cdb1df926
 [INFO]  Sun Nov  7 19:19:44 CET 2021 ->>> [az_create_sp] please add the following output to '.secrets' file:     password(ARM_CLIENT_SECRET)
 [INFO]  Sun Nov  7 19:19:44 CET 2021 ->>> [az_create_sp] please add the following output to '.variables' file:   app_id(ARM_CLIENT_ID), tenant(ARM_TENANT_ID)
 [INFO]  Sun Nov  7 19:19:44 CET 2021 ->>> [az_create_sp|out]
 [INFO]  Sun Nov  7 19:19:44 CET 2021 ->>> ...[ ./helper.sh az create_sp ] done.
```
- export the following environment variables accordingly to the previous command output:
  - in `.variables`:
    - ARM_CLIENT_ID
    - ARM_TENANT_ID
  - in `.secrets`:
    - ARM_CLIENT_SECRET
- test azure login with the service principal, run: `./helper.sh az login`
```
root@842b3e423955:~# ./helper.sh az login
 [DEBUG] Sun Nov  7 18:59:43 CET 2021 ... we have a '.variables' file
 [DEBUG] Sun Nov  7 18:59:43 CET 2021 ... we have a '.secrets' file
 [INFO]  Sun Nov  7 18:59:43 CET 2021 ->>> starting [ ./helper.sh az login ] ...
 [INFO]  Sun Nov  7 18:59:43 CET 2021 ->>> [az_login|in]
 [INFO]  Sun Nov  7 18:59:43 CET 2021 ->>> [check_env_vars] ...
 ...
 [INFO]  Sun Nov  7 18:59:43 CET 2021 ->>> [check_env_vars] ...done.
[
  {
    "cloudName": "AzureCloud",
    "homeTenantId": "d69819b1-740d-435a-8ff4-c41cdb1df926",
    "id": "6175f3e6-4d8c-4157-a15c-0a45e7e98580",
    "isDefault": true,
    "managedByTenants": [],
    "name": "tgedr",
    "state": "Enabled",
    "tenantId": "d69819b1-740d-435a-8ff4-c41cdb1df926",
    "user": {
      "name": "5c88b533-5949-4ea7-998d-d2757fc5162e",
      "type": "servicePrincipal"
    }
  }
]
 [INFO]  Sun Nov  7 18:59:52 CET 2021 ->>> [az_login|out]
 [INFO]  Sun Nov  7 18:59:52 CET 2021 ->>> ...[ ./helper.sh az login ] done.
```
- verify azure account access, run: `./helper.sh az check`
```
root@842b3e423955:~# ./helper.sh az check
 [DEBUG] Sun Nov  7 19:03:20 CET 2021 ... we have a '.variables' file
 [DEBUG] Sun Nov  7 19:03:20 CET 2021 ... we have a '.secrets' file
 [INFO]  Sun Nov  7 19:03:20 CET 2021 ->>> starting [ ./helper.sh az check ] ...
 [INFO]  Sun Nov  7 19:03:20 CET 2021 ->>> [az_login_check|in]
 ...
    {
      "maxDataDiskCount": 64,
      "memoryInMb": 688128,
      "name": "Standard_E104i_v5",
      "numberOfCores": 104,
      "osDiskSizeInMb": 1047552,
      "resourceDiskSizeInMb": 0
    }
  ]
 [INFO]  Sun Nov  7 19:04:09 CET 2021 ->>> [az_login_check|out]
 [INFO]  Sun Nov  7 19:04:09 CET 2021 ->>> ...[ ./helper.sh az check ] done.
```

##### 1.4.2. aws

### 2. use the modules
- have a look into `test` folder, it contains examples on how to use modules
#### 2.1. azure example - create the base resources on which we can build after, a storage account to save remote terraform state 
- create a terraform spec file to use the base module:
```
root@842b3e423955:~# vi main.tf
root@842b3e423955:~# cat main.tf
provider "azurerm" {
  features {}
}

variable "project" {
  type    = string
}

variable "solution" {
  type    = string
}

variable "env" {
  type    = string
}

module "base" {
  source = "./modules/azure/base"
  project = var.project
  solution = var.solution
  env = var.env
}
```
- create a terraform variables file to flesh out the variable values:
```
root@842b3e423955:~# vi main.tfvars
root@842b3e423955:~# cat main.tfvars
project = "theone"
solution = "test"
env = "dev"
```
- fetch modules from latest release: run `./helper.sh mod fetch`
```
root@842b3e423955:~# ./helper.sh mod fetch
 [DEBUG] Sun Nov  7 20:44:11 CET 2021 ... we have a '.variables' file
 [DEBUG] Sun Nov  7 20:44:11 CET 2021 ... we have a '.secrets' file
 [INFO]  Sun Nov  7 20:44:11 CET 2021 ->>> starting [ ./helper.sh mod fetch ] ...
 ...
 [INFO]  Sun Nov  7 20:44:13 CET 2021 ->>> [fetch_modules|out]
 [INFO]  Sun Nov  7 20:44:13 CET 2021 ->>> ...[ ./helper.sh mod fetch ] done.
root@842b3e423955:~# ls
helper.sh  main.tf  main.tfvars  modules 
```
- to deploy, run: `./helper.sh mod deploy`
```
root@842b3e423955:~# ./helper.sh mod deploy
 [DEBUG] Sun Nov  7 20:55:23 CET 2021 ... we have a '.variables' file
 [DEBUG] Sun Nov  7 20:55:23 CET 2021 ... we have a '.secrets' file
 [INFO]  Sun Nov  7 20:55:23 CET 2021 ->>> starting [ ./helper.sh mod deploy ] ...
 [INFO]  Sun Nov  7 20:55:23 CET 2021 ->>> [testOn|in]
Initializing modules...
...
module.base.azurerm_storage_account.base: Creation complete after 24s [id=/subscriptions/6175f3e6-4d8c-4157-a15c-0a45e7e98580/resourceGroups/theone0test0dev/providers/Microsoft.Storage/storageAccounts/theone0test0dev0base]
module.base.azurerm_storage_container.state: Creating...
module.base.azurerm_storage_container.state: Creation complete after 0s [id=https://theone0test0dev0base.blob.core.windows.net/terraform-remote-state]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.
 [INFO]  Sun Nov  7 20:56:36 CET 2021 ->>> [testOn|out]
 [INFO]  Sun Nov  7 20:56:36 CET 2021 ->>> ...[ ./helper.sh mod deploy ] done.
```
- you can check now in your azure subscription 3 new resources:
  - resource group: `theone0test0dev`
  - storage account: `theone0test0dev0base`
  - storage container: `terraform-remote-state`
- to undeploy, run: `./helper.sh mod undeploy`
```
root@842b3e423955:~# ./helper.sh mod undeploy
 [DEBUG] Sun Nov  7 21:01:51 CET 2021 ... we have a '.variables' file
 [DEBUG] Sun Nov  7 21:01:51 CET 2021 ... we have a '.secrets' file
 [INFO]  Sun Nov  7 21:01:51 CET 2021 ->>> starting [ ./helper.sh mod undeploy ] ...
 [INFO]  Sun Nov  7 21:01:51 CET 2021 ->>> [testOff|in]
Initializing modules...
...
module.base.azurerm_resource_group.base_rg: Still destroying... [id=/subscriptions/6175f3e6-4d8c-4157-a15c-...7e98580/resourceGroups/theone0test0dev, 10s elapsed]
module.base.azurerm_resource_group.base_rg: Destruction complete after 17s

Destroy complete! Resources: 3 destroyed.
 [INFO]  Sun Nov  7 21:02:49 CET 2021 ->>> [testOff|out]
 [INFO]  Sun Nov  7 21:02:49 CET 2021 ->>> ...[ ./helper.sh mod undeploy ] done.
```

#### 2.2. aws example
TODO
### 3. existent modules
#### aws

- ops-group
  - provides: operations group and role info, as an admin group, to add users afterwards
  - requires: nothing
- ops-user
  - provides: operations user, as an admin user
  - requires: group, _keybase_ public key
- remote-state
  - provides: remote terraform state persistence  in bucket and state lock in dynamo db table
  - requires: user and group
- s3-website
  - provides: SPA deployment in an s3 bucket
  - requires: 
    - user
    - group
    - remote-state
    - SPA's index.html
- subdomain
  - provides: a subdomain entry that can later be linked to a certificate and a bucket website, for instance
  - requires: domain name zone created in route53
- domain-certificate
  - provides: a certificate to use with an existing route53 domain name and related sub-domains
  - requires: domain name and sub domain zones created in route53
- web-distribution
  - provides: web presence with https, links dns records(domains or subdomains), certificates and bucket websites
  - requires:
    - domain or subdomain created in route53
    - domain or subdomain certificate
    - s3 bucket website

#### azure

- base
  - resource group and remote state
  - requires: service principal account login
  - provides: remote state in storage account and an overarching resource group
- ad_users
  - provides: AD users
  - requires: service principal with azure active directory permissions
- storage_container
  - provides: a storage account and a container
  - requires: remote state and resource group
- storage_queues
  - provides: a storage account and a set of queues
  - requires: remote state and resource group
- data_lake
  - provides: a data lake file system and a set of folders
  - requires: remote state and resource group

### 4. development
TODO




  


