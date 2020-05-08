# cloudflare
variable "cloudflare_account_id" {
  type = string
}

variable "cloudflare_api_token" {
  type = string
}

# dns rndc
variable "dns_key_name" {
  type = string
}

variable "dns_key_algorithm" {
  type = string
}

variable "dns_key_secret" {
  type = string
}

variable "cloudflare_zone_id_teamvinted_com" {
  type = string
  default = "b0da52d77c310d5a747b05da9c9b9515"
}



