provider "aws" {
  version = "~> 2.43"
  region = "eu-west-1"
}

data "aws_route53_zone" "zone" {
  name         = "${var.domain-name}."
  private_zone = false
}

resource "aws_acm_certificate" "website-domain-certificate" {
  domain_name       = "${var.domain-name}"
  validation_method = "DNS"


  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = "${aws_acm_certificate.cert.arn}"
  validation_record_fqdns = ["${aws_route53_record.cert_validation.fqdn}"]
}
