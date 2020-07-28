provider "cloudflare" {
  version = "~> 2.0"
  api_token = var.cloudflare_api_token
}

resource "cloudflare_zone" "default" {
  count = var.cloudflare_api_token != "" ? 1 : 0
  zone  = var.default_domain
}

resource "cloudflare_record" "default_mx_records" {
  count    = var.cloudflare_api_token != "" ? length(var.default_mx_records) : 0
  zone_id  = cloudflare_zone.default.0.id
  name     = var.default_domain
  type     = "MX"
  value    = element(var.default_mx_records, count.index).value
  priority = element(var.default_mx_records, count.index).priority
}
