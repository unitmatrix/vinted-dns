provider "cloudflare" {
  version = "~> 2.6"
  account_id = var.cloudflare_account_id
  api_token = var.cloudflare_api_token
}

provider "dns" {
  version = "~> 2.2"
  update {
    server        = "127.0.0.1"
    key_name      = var.dns_key_name
    key_algorithm = var.dns_key_algorithm
    key_secret    = var.dns_key_secret
  }
}