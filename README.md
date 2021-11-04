# terraform-modules
handy terraform modules

## pre-requirements

- [create a service principal and its access token](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/guides/service_principal_client_secret)
- [associate a service principal to AD permissions](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/guides/service_principal_configuration#azure-active-directory-permissions)
- export variables to environment, use the `.variables` file (version managed):
  - AWS_MAIN_PROFILE
  - AWS_USER_PROFILE
  - ARM_SUBSCRIPTION_ID
  - ARM_TENANT_ID
  - ARM_USER
  - ARM_CLIENT_ID
- export secret variables to environment using `.secrets` file (not version managed, you'll have to create it in your folder):
  - ARM_CLIENT_SECRET
  - AWS_*
- login with service principal:
  - azure
    - `./scripts/helper.sh az_sp login `
  - aws
    - TODO

## usage
- `test` folder contains examples on how to use modules
- try and test any module in the `test/*` folder using the `test.sh` script
- you can copy and adapt this script, `test.sh`, into your projects, check its function `fetchModules` where you can define whether the modules are downloaded from the internet or loaded locally

### aws
- add aws main profile in `.variables` (manual step)
- create `IAM` _group_ and _user_ to manage resources in aws:
  - `./test.sh aws/ops-group on`
  - `./test.sh aws/ops-user on`
- in aws IAM create keys for the user just created (manual step)
- create aws user profile:
  - ex: `aws configure --profile tgedr`
  - ...and add it to `.variables` (manual step)
- `./test.sh aws/remote-state on` - creates the bucket to save terraform remote state and the dynamoDb table to hold the lock
- `./test.sh aws/3-apps-deployment on` - deploys a solution comprising the creation of:
  - 2 subdomains additionally to the required domain
  - ssl certificates for the domain and subdomains
  - 3 SPA index.html's in a bucket each, configured as websites
  - distribution and linking of the 3 SPA's with domain and subdomains and its certificates through _cloudfront_
- in the end we should see  all 3 websites navigating to the domain and subdomains using a browser
- in the end to undeploy all:
  - `./test.sh aws/3-apps-deployment off`
  - `./test.sh aws/remote-state off`
  - 
### azure
- deploy base infrastructure - terraform remote state persistence
  - `./test.sh azure/base on`
- deploy data lake storage with fs and 4 folder(bronze,silver,gold,tmp)
  - `./test.sh azure/data_lake on`
- undeploy
  - `./test.sh azure/data_lake off`
  - `./test.sh azure/base off`
  
## modules

### aws

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

### azure

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
  


