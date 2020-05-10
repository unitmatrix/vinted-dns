locals {
    # create a flat list of objects for Cloudflare resources from A records
    cf_a_records_list = flatten([
        for zone_key, zone_data in var.zones: [
            for record_key, record_data in zone_data.a_records: [
                for ip in record_data.provider1_addresses: {
                    zone_id: zone_data.provider1_zone_id
                    name: record_data.name
                    ttl: record_data.ttl
                    proxied: record_data.provider1_proxied
                    ip: ip
                    unique_key: join("-", [ip, record_key, trimsuffix(zone_key, ".")])
                }
            ]
        ]
    ])
    
    # resource for_each requires a map. cf_a_records_list is a list of maps, so we must 
    # now project it into a single map where each key is unique. We will use the 
    # combined zone and record keys as a single unique key per instance.
    cf_a_records_map = {
        for record_data in local.cf_a_records_list: record_data.unique_key => record_data
    }
    
    # create a flat list of objects for Cloudflare resources from MX records
    cf_mx_records_list = flatten([
        for zone_key, zone_data in var.zones: [
            for record_key, record_data in zone_data.mx_records: [
                for mx_name, mx_data in record_data.provider1_mxs: {
                    zone_id: zone_data.provider1_zone_id
                    name: record_data.provider1_name
                    ttl: record_data.ttl
                    value: mx_data.exchange
                    priority: mx_data.preference
                    unique_key: join("-", [ mx_name, record_key, trimsuffix(zone_key, ".") ])
                }
            ]
        ]
    ])
    
    # project to a map as required by for_each
    cf_mx_records_map = {
        for record_data in local.cf_mx_records_list: record_data.unique_key => record_data
    }
    
    # create a flat list of objects for Bind resources from A records
    b_a_records_set = flatten([
        for zone_key, zone_data in var.zones: [
            for record_key, record_data in zone_data.a_records: {
                zone: zone_data.provider2_zone
                name: record_data.name
                ttl: record_data.ttl
                addresses: record_data.provider2_addresses
                unique_key: join("-", [ record_key, trimsuffix(zone_key, ".") ])
            }
        ]
    ])
    
    # project to a map as required by for_each
    b_a_records_map = {
        for record_data in local.b_a_records_set: record_data.unique_key => record_data
    }
    
    # create a flat list of objects for Bind resources from MX records
    b_mx_records_set = flatten([
        for zone_key, zone_data in var.zones: [
            for record_key, record_data in zone_data.mx_records: {
                zone: zone_data.provider2_zone
                name: record_data.provider2_name
                ttl: record_data.ttl
                mxs: record_data.provider2_mxs
                unique_key: join("-", [ record_key, trimsuffix(zone_key, ".") ])
            }
        ]
    ])
    
    # project to a map as required by for_each
    b_mx_records_map = {
        for record_data in local.b_mx_records_set: record_data.unique_key => record_data
    }
}

resource cloudflare_record "a_record" {
    for_each = local.cf_a_records_map
        zone_id = each.value.zone_id
        name = each.value.name
        value = each.value.ip
        type = "A"
        ttl = each.value.ttl
        proxied = each.value.proxied
}

resource cloudflare_record "mx_record" {
    for_each = local.cf_mx_records_map
        zone_id = each.value.zone_id
        name = each.value.name
        value = each.value.value
        priority = each.value.priority
        type = "MX"
        ttl = each.value.ttl
}

resource dns_a_record_set "a_record" {
    for_each = local.b_a_records_map
        zone = each.value.zone
        name = each.value.name
        addresses = each.value.addresses
        ttl = each.value.ttl
}

resource dns_mx_record_set "mx_record" {
    for_each = local.b_mx_records_map
        zone = each.value.zone
        name = each.value.name == "" ? null : each.value.name
        ttl = each.value.ttl
        dynamic "mx" {
            for_each = each.value.mxs
                content {
                    exchange = mx.value.exchange
                    preference = mx.value.preference
                }
       }
}




