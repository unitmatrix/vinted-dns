provider "cloudflare" {
  account_id = var.cloudflare_account_id
  api_token = var.cloudflare_api_token
}

# Add a record to the domain
resource "cloudflare_record" "terraform" {
  zone_id = var.cloudflare_zone_id_teamvinted_com
  name    = "terraform"
  value   = "104.17.26.194"
  type    = "A"
  ttl     = 1
  proxied = true
}

