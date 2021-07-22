terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

data "aws_route53_zone" "domain_zone" {
  name         = var.domain
  private_zone = false
}

resource "aws_route53_zone" "subdomain_zone" {
  name = var.sub_domain
}

resource "aws_route53_record" "subdomain_ns" {
  zone_id = data.aws_route53_zone.domain_zone.zone_id
  name    = var.sub_domain
  type    = "NS"
  ttl     = 300
  records = aws_route53_zone.subdomain_zone.name_servers
}
