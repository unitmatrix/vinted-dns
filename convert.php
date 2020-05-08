<?php

// Enable verbose errors
ini_set('display_errors', 1);
error_reporting(E_ALL);

// DNS hosts input file
$hosts_file = 'hosts.json';

// terraform resource output file
$out_file = 'main.tf';

// Define dns record templates

// cloudflare dns A record template for terraform
$cf_a_r_t = '
resource cloudflare_record "%s" {
    zone_id = "%s"
    name = "%s"
    value = "%s"
    type = "A"
    ttl = %d
    proxied = %s
}
';

// cloudflare dns MX record template for terraform
$cf_mx_r_t = '
resource cloudflare_record "%s" {
    zone_id = "%s"
    name = "%s"
    value = "%s"
    type = "MX"
    ttl = %d
    priority = %d
}
';

// cloudflare dns CNAME record template for terraform
$cf_cname_r_t = '
resource cloudflare_record "%s" {
    zone_id = "%s"
    name = "%s"
    type = "CNAME"
    value = "%s"
    ttl = %d
    proxied = %s
}
';

// Bind dns resource templates

// BIND dns A record template for terraform
$b_a_r_t = '
resource dns_a_record_set "%s" {
    zone = "%s"
    name = "%s"
    addresses = [ "%s" ]
    ttl = %d
}
';

// BIND dns MX record template for terraform
$b_mx_r_t = '
resource dns_mx_record_set "%s" {
    zone = "%s"
    %s
    ttl = %d
    %s
}
';

// BIND dns MX record sub-template for terraform
$mx_t = '
    mx {
        exchange = "%s"
        preference = %d
    }
';

// BIND dns CNAME record template for terraform
$b_cname_r_t = '
resource dns_cname_record "%s" {
    zone = "%s"
    name = "%s"
    cname = "%s"
    ttl = %d
}
';

// Define global variables
$cf_out = $b_out = $mxs = '';


// main

// Import hosts data from json to an array
$hosts_array = json_decode(file_get_contents($hosts_file)) or die("ERROR importing json from $hosts_file: " . json_last_error() . PHP_EOL);

// Walk through the array, pick up needed records and convert to the target format with templates
foreach($hosts_array as $d)
{
    // Convert Cloudflare records
    foreach ($d as $t => $data)
    {
        if ($t == 'origin') // example.com.
        {
            $origin = $data;
        }
        else if ($t == 'a')
        {
            // Cloudflare A records
            foreach($data as $record)
            {
                $out = sprintf($cf_a_r_t,
                    // generate unique terraform resource name
                    strtolower(str_replace('.', '-', $record->name . '.' . rtrim($origin, '.'))), // name-example-com
                    $record->cloudflare_zone_id,
                    $record->name,
                    $record->ip_cloudflare,
                    $record->ttl,
                    $record->proxied ? 'true' : 'false'
                );
                $cf_out .= $out;
            }
        }
        else if ($t == 'mx')
        {
            // Cloudflare MX records
            $i = 0;
            foreach($data as $record)
            {
                $out = sprintf($cf_mx_r_t, 
                    // generate unique terraform resource name
                    strtolower(str_replace('.', '-', 'mx-'. ++$i . '.' . rtrim($origin, '.'))), // mx-0-example-com
                    $record->cloudflare_zone_id,
                    $record->name_cloudflare,
                    $record->host_cloudflare,
                    $record->ttl,
                    $record->preference
                );
                $cf_out .= $out;
            }
        }
        else if ($t == 'cname')
        {
            // Cloudflare CNAME records
            foreach($data as $record)
            {
                $out = sprintf($cf_cname_r_t,
                    // generate unique terraform resource name
                    strtolower(str_replace('.', '-', $record->name . '.' . rtrim($origin, '.'))), // cname-example-com
                    $record->cloudflare_zone_id,
                    $record->name,
                    $record->cname_cloudflare,
                    $record->ttl,
                    $record->proxied ? 'true' : 'false'
                );
                $cf_out .= $out;
            }
        }
    }
    
    // Convert BIND records
    foreach ($d as $t => $data)
    {
        if ($t == 'origin')
        {
            $origin = $data; // example.com.
        }
        else if ($t == 'a')
        {
            // BIND A records
            foreach($data as $record)
            {
                $out = sprintf($b_a_r_t,
                    // generate unique terraform resource name
                    strtolower(str_replace('.', '-', $record->name . '.' . rtrim($origin, '.'))), // name-example-com
                    $record->zone,
                    $record->name,
                    $record->ip_bind,
                    $record->ttl
                );
                $b_out .= $out;
            }
        }
        else if ($t == 'mx')
        {
            // BIND MX records
            $mxs = '';
            foreach($data as $record)
            {
                $mxs .= sprintf($mx_t, 
                    $record->host_bind,
                    $record->preference
                );
            }
            
            $out = sprintf($b_mx_r_t,
                // generate unique terraform resource name
                strtolower(str_replace('.', '-', 'mx' . '.' . rtrim($origin, '.'))), // mx-0-example-com
                $record->zone,
                $record->name_bind ? sprintf('name = "%s"', $record->name_bind) : '', // only add if not empty
                $record->ttl,
                $mxs
            );
            $b_out .= $out;
        }
        else if ($t == 'cname')
        {
            // BIND CNAME records
            foreach($data as $record)
            {
              $out = sprintf($b_cname_r_t,
                  // generate unique terraform resource name
                  strtolower(str_replace('.', '-', $record->name . '.' . rtrim($origin, '.'))), // cname-example-com
                  $record->zone,
                  $record->name,
                  $record->cname_bind,
                  $record->ttl
              );
              $b_out .= $out;
            }
        }
    }
}

// print result to stdout
echo $cf_out.$b_out;

// Write result to file
file_put_contents($out_file, $cf_out.$b_out) or die("ERROR writing to file: " . $out_file . PHP_EOL);
