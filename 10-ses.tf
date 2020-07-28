resource "aws_ses_domain_identity" "default" {
  domain = var.default_domain
}

resource "cloudflare_record" "default_ses_verification" {
  count    = var.cloudflare_api_token != "" ? 1 : 0
  zone_id  = cloudflare_zone.default.0.id
  type     = "TXT"
  name     = "_amazonses"
  value    = aws_ses_domain_identity.default.verification_token
}

resource "aws_ses_domain_identity_verification" "default" {
  count      = var.cloudflare_api_token != "" ? 1 : 0
  domain     = aws_ses_domain_identity.default.domain
  depends_on = [cloudflare_record.default_ses_verification]
}

resource "aws_ses_domain_dkim" "default" {
  count  = var.cloudflare_api_token != "" ? 1 : 0
  domain = aws_ses_domain_identity_verification.default.0.domain
}

resource "cloudflare_record" "default_ses_dkim" {
  # The "count" value depends on resource attributes that cannot be determined
  # until apply, so Terraform cannot predict how many instances will be created.
  # To work around this, use the -target argument to first apply only the
  # resources that the count depends on.
  #count   = length(aws_ses_domain_dkim.default.dkim_tokens)

  count   = var.cloudflare_api_token != "" ? 3 : 0
  zone_id = cloudflare_zone.default.0.id
  type    = "CNAME"
  name    = "${element(aws_ses_domain_dkim.default.0.dkim_tokens, count.index)}._domainkey"
  value   = "${element(aws_ses_domain_dkim.default.0.dkim_tokens, count.index)}.dkim.amazonses.com"
}
