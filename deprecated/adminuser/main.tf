

provider "aws" {
  version = "~> 2.43"
  region = "us-east-1"
}

module "adminuser" {
  source = "./modules/admin"
  admin-public-key = "keybase:jtviegas"
}
