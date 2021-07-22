terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

resource "aws_acm_certificate" "domain_certificate" {
  domain_name       = var.domain
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
  subject_alternative_names = var.sub_domains
}

data "aws_route53_zone" "domain_zone" {
  name         = var.domain
  private_zone = false
}

data "aws_route53_zone" "sub_domain_zone" {
  for_each = var.sub_domains

  name         = each.value
  private_zone = false
}

resource "aws_route53_record" "cname_record" {
  for_each = {
    for dvo in aws_acm_certificate.domain_certificate.domain_validation_options : dvo.domain_name => {
      name    = dvo.resource_record_name
      record  = dvo.resource_record_value
      type    = dvo.resource_record_type
      zone_id = dvo.domain_name == var.domain ? data.aws_route53_zone.domain_zone.zone_id: data.aws_route53_zone.sub_domain_zone[dvo.domain_name].zone_id
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = each.value.zone_id
}

resource "aws_acm_certificate_validation" "example" {
  certificate_arn         = aws_acm_certificate.domain_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.cname_record : record.fqdn]
}


