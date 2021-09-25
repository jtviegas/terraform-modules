# terraform-modules
handy terraform modules

## usage
try and test any module using the `test.sh` script.

example:

```
./test.sh aws/website on
./test.sh aws/website off
```

## modules

### aws

- ops-group
  - operations group, as an admin group, to add users afterwards
  - requires: nothing
  - provides: group and role info
- ops-user
  - operations user, as an admin user
  - requires: group, _keybase_ public key
  - provides: user
- remote-state
  - remote state to persist state files
  - requires: user and group
  - provides: remote state in bucket and state lock in dynamo db table
- s3-website
  - website deployment on s3 bucket
  - requires: 
    - user
    - group
    - remote-state
    - SPA's index.html
  - provides: SPA deployment in an s3 bucket
- subdomain
  - subdomain entry under a predefined domain zone
  - requires: domain name zone created in route53
  - provides: a subdomain that can later be linked to a certificate and a bucket website, for instance
- domain-certificate
  - certificate to use with an existing route53 domain name and related sub-domains
  - requires: domain name and sub domain zones created in route53
  - provides: a certificate to use with domain and subdomains
- web-distribution
  - link dns records(domains or subdomains), certificates and bucket websites
  - requires:
    - domain or subdomain created in route53
    - domain or subdomain certificate
    - s3 bucket website
  - provides: web presence with https

### azure

- base
  - resource group and remote state
  - requires: nothing
  - provides: remote state in storage account and an overarching resource group


#### suggested usage - with `./test.sh` using test folders (note: requires an existing domain in route53)

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


