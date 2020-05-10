zones = {
    zone_key1 = {
        provider1_zone_id = "b0da52d77c310d5a747b05da9c9b9515"
        provider2_zone = "teamvinted.com."
        a_records = {
            record_key1 = {
              name = "a1"
              ttl = 1
              provider1_addresses = ["11.11.11.11", "11.11.11.12"]
              provider2_addresses = ["10.10.10.11", "10.10.10.12"]
              provider1_proxied = "true"
            }
            record_key2 = {
              name = "a2"
              ttl = 1
              provider1_addresses = ["11.11.11.13", "11.11.11.14"]
              provider2_addresses = ["10.10.10.13", "10.10.10.14"]
              provider1_proxied = "true"
            }
        }
        mx_records = {
            record_key1 = {
                provider1_name: "@"
                provider2_name: ""
                ttl: 1
                provider1_mxs = {
                    mx_key1 = {
                        exchange: "aspmx.l.google.com"
                        preference: 1
                    }
                    mx_key2 = {
                        exchange: "alt1.aspmx.l.google.com"
                        preference: 5
                    }
                    mx_key3 = {
                        exchange: "alt2.aspmx.l.google.com"
                        preference: 5
                    }
                    mx_key3 = {
                        exchange: "alt3.aspmx.l.google.com"
                        preference: 10
                    }
                    mx_key4 = {
                        exchange: "alt4.aspmx.l.google.com"
                        preference: 10
                    }
                    mx_key5 = {
                        exchange: "t4ps3zx7dkai6lyuayrgbj5wvq3bhjg74ottnoxdai3yc2pwvena.mx-verification.google.com"
                        preference: 10
                    }
               }
               provider2_mxs = {
                    mx_key1 = {
                        exchange: "mx1.local.example.com."
                        preference: 1
                    }
                    mx_key2 = {
                        exchange: "mx2.local.example.com."
                        preference: 5
                    }
                }
            }
        }
    }
}