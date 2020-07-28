resource "aws_acm_certificate" "default" {
  domain_name       = "*.${var.default_domain}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "cloudflare_record" "default_acm_validation" {
  count    = var.cloudflare_api_token != "" ? 1 : 0
  zone_id  = cloudflare_zone.default.0.id
  type     = aws_acm_certificate.default.domain_validation_options.0.resource_record_type
  name     = trimsuffix(aws_acm_certificate.default.domain_validation_options.0.resource_record_name, ".")
  value    = trimsuffix(aws_acm_certificate.default.domain_validation_options.0.resource_record_value, ".")
}

resource "aws_acm_certificate_validation" "default" {
  count           = var.cloudflare_api_token != "" ? 1 : 0
  certificate_arn = aws_acm_certificate.default.arn
}
