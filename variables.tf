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

variable "zones" {
    type = map(object({
        provider1_zone_id = string
        provider2_zone    = string
        a_records = map(object({
            name  = string
            ttl   = number
            provider1_addresses = set(string)
            provider2_addresses = set(string)
            provider1_proxied = string
        }))
        cname_records = map(object({
            name  = string
            ttl   = number
            provider1_cname = string
            provider2_cname = string
            provider1_proxied = string
        }))
        mx_records = map(object({
            provider1_name  = string
            provider2_name  = string
            ttl             = number
            provider1_mxs = map(object({
                exchange   = string
                preference = number
            }))
            provider2_mxs = map(object({
                exchange   = string
                preference = number
            }))
        }))
    }))
}