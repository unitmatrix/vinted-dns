
resource cloudflare_record "a1-teamvinted-com" {
    zone_id = "b0da52d77c310d5a747b05da9c9b9515"
    name = "a1"
    value = "104.17.26.195"
    type = "A"
    ttl = 1
    proxied = true
}

resource cloudflare_record "a2-teamvinted-com" {
    zone_id = "b0da52d77c310d5a747b05da9c9b9515"
    name = "a2"
    value = "104.17.26.196"
    type = "A"
    ttl = 1
    proxied = true
}

resource cloudflare_record "cname1-teamvinted-com" {
    zone_id = "b0da52d77c310d5a747b05da9c9b9515"
    name = "cname1"
    type = "CNAME"
    value = "other1.example.com"
    ttl = 1
    proxied = true
}

resource cloudflare_record "cname2-teamvinted-com" {
    zone_id = "b0da52d77c310d5a747b05da9c9b9515"
    name = "cname2"
    type = "CNAME"
    value = "other1.example.com"
    ttl = 1
    proxied = true
}

resource cloudflare_record "mx-1-teamvinted-com" {
    zone_id = "b0da52d77c310d5a747b05da9c9b9515"
    name = "teamvinted.com"
    value = "alt4.aspmx.l.google.com"
    type = "MX"
    ttl = 1
    priority = 10
}

resource cloudflare_record "mx-2-teamvinted-com" {
    zone_id = "b0da52d77c310d5a747b05da9c9b9515"
    name = "teamvinted.com"
    value = "alt3.aspmx.l.google.com"
    type = "MX"
    ttl = 1
    priority = 10
}

resource cloudflare_record "mx-3-teamvinted-com" {
    zone_id = "b0da52d77c310d5a747b05da9c9b9515"
    name = "teamvinted.com"
    value = "t4ps3zx7dkai6lyuayrgbj5wvq3bhjg74ottnoxdai3yc2pwvena.mx-verification.google.com"
    type = "MX"
    ttl = 1
    priority = 15
}

resource cloudflare_record "mx-4-teamvinted-com" {
    zone_id = "b0da52d77c310d5a747b05da9c9b9515"
    name = "teamvinted.com"
    value = "alt2.aspmx.l.google.com"
    type = "MX"
    ttl = 1
    priority = 5
}

resource cloudflare_record "mx-5-teamvinted-com" {
    zone_id = "b0da52d77c310d5a747b05da9c9b9515"
    name = "teamvinted.com"
    value = "alt1.aspmx.l.google.com"
    type = "MX"
    ttl = 1
    priority = 5
}

resource cloudflare_record "mx-6-teamvinted-com" {
    zone_id = "b0da52d77c310d5a747b05da9c9b9515"
    name = "teamvinted.com"
    value = "aspmx.l.google.com"
    type = "MX"
    ttl = 1
    priority = 1
}

resource dns_a_record_set "a1-teamvinted-com" {
    zone = "teamvinted.com."
    name = "a1"
    addresses = [ "127.0.0.1" ]
    ttl = 1
}

resource dns_a_record_set "a2-teamvinted-com" {
    zone = "teamvinted.com."
    name = "a2"
    addresses = [ "127.0.0.2" ]
    ttl = 1
}

resource dns_cname_record "cname1-teamvinted-com" {
    zone = "teamvinted.com."
    name = "cname1"
    cname = "other1.teamvinted.com."
    ttl = 1
}

resource dns_cname_record "cname2-teamvinted-com" {
    zone = "teamvinted.com."
    name = "cname2"
    cname = "other1.teamvinted.com."
    ttl = 1
}

resource dns_mx_record_set "mx-teamvinted-com" {
    zone = "teamvinted.com."
    
    ttl = 1
    
    mx {
        exchange = "alt4.aspmx.l.google.com."
        preference = 10
    }

    mx {
        exchange = "alt3.aspmx.l.google.com."
        preference = 10
    }

    mx {
        exchange = "t4ps3zx7dkai6lyuayrgbj5wvq3bhjg74ottnoxdai3yc2pwvena.mx-verification.google.com."
        preference = 15
    }

    mx {
        exchange = "alt2.aspmx.l.google.com."
        preference = 5
    }

    mx {
        exchange = "alt1.aspmx.l.google.com."
        preference = 5
    }

    mx {
        exchange = "aspmx.l.google.com."
        preference = 1
    }

}
