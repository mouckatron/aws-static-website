resource "aws_route53_record" "cloudfront" {
  zone_id = data.aws_route53_zone.root_domain.zone_id
  name    = local.domain
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.frontend.domain_name
    zone_id                = aws_cloudfront_distribution.frontend.hosted_zone_id
    evaluate_target_health = false
  }
}
