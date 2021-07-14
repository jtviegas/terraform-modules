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
- domain-certificate
  - certificate to use with an existing route53 domain name
  - requires: domain name created in route53
  - provides: a certificate to use with domain name
- website-dns-and-certificate-distribution
  - link dns record to certificate and bucket website
  - requires:
    - domain name created in route53
    - domain certificate
    - s3 bucket website
  - provides: access to website with ssh and dns domain
  


#### suggested usage

- add aws main profile in `.variables`
- `./aws-user.sh on`
- in aws IAM create keys for the user just created 
- create aws user profile:
  - ex: `aws configure --profile tgedr`
  - ...and add it to `.variables`
- `./aws-stack.sh on`


