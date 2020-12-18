resource "aws_acm_certificate" "frontend" {
  provider          = aws.ue1
  domain_name       = local.domain
  validation_method = "DNS"

  tags = {
    appname = var.appname
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "certvalidation" {
  for_each = {
    for dvo in aws_acm_certificate.frontend.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.root_domain.zone_id
}

resource "aws_acm_certificate_validation" "example" {
  provider                = aws.ue1
  certificate_arn         = aws_acm_certificate.frontend.arn
  validation_record_fqdns = [for record in aws_route53_record.certvalidation : record.fqdn]
}