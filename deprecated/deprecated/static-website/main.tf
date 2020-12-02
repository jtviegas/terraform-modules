

provider "aws" {
  version = "~> 2.43"
  region = "eu-west-1"
}

module "website" {
  source = "./modules/admin"
  admin-public-key = "keybase:jtviegas"
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = "${aws_acm_certificate.cert.arn}"
  validation_record_fqdns = ["${aws_route53_record.cert_validation.fqdn}"]
}
