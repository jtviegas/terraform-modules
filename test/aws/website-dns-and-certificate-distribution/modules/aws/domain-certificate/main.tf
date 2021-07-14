terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

data "aws_route53_zone" "domain_zone" {
  name         = var.domain_name
  private_zone = false
}

resource "aws_acm_certificate" "domain_certificate" {
  domain_name       = var.domain_name
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "domain_record" {
  depends_on = [aws_acm_certificate.domain_certificate]
  name    = tolist(aws_acm_certificate.domain_certificate.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.domain_certificate.domain_validation_options)[0].resource_record_type
  zone_id = data.aws_route53_zone.domain_zone.id
  records = [ tolist(aws_acm_certificate.domain_certificate.domain_validation_options)[0].resource_record_value ]
  ttl     = 2400
}


resource "aws_acm_certificate_validation" "domain_certificate_validation" {
  depends_on = [aws_route53_record.domain_record]
  certificate_arn         = aws_acm_certificate.domain_certificate.arn
  validation_record_fqdns = [ aws_route53_record.domain_record.fqdn ]
}


