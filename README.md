# vinted-dns

### Introduction
This tool allows to provision DNS records to Cloudflare and local Bind instance from a single configuration file, in this case - a JSON file.

## How to run
### Setup

You will need the following data to begin: **Cloudflare account ID**, **Cloudflare API access token**, **DNS rndc key name**, **key alorithm** and **secret**. Put this sensitive data as environment variables in a **.source** file as shown below:

    #!/bin/bash
    
    export TF_VAR_cloudflare_api_token='sample_token'
    export TF_VAR_cloudflare_account_id='sample_id'
    
    export TF_VAR_dns_key_name='sample_rndc_key_name.'
    export TF_VAR_dns_key_algorithm='sample_key_algorithm' // hmac-md5
    export TF_VAR_dns_key_secret='sample_key_secret'

Secure file permissions:

    $ chmod 0600 .secret

Start a local BIND server instance locally: 

    docker pull sameersbn/bind:9.11.3-20200507
    
Run docker instance:

    docker run --name bind -d --restart=always --publish 53:53/tcp --publish 53:53/udp --publish 10000:10000/tcp --publish 953:953/tcp --volume /srv/docker/bind:/data   sameersbn/bind:9.11.3-20200507

 Port 10000 is for the webmin admin tool. Access it via https://localhost:1000 using with *root*/*password*, create your zone and setup rndc key. Make sure to include the following policy for your zone:

     update-policy {
        grant rndc-key zonesub any;
     };
so terraform is able to update your records. More details: [Using rndc](https://www-uxsup.csx.cam.ac.uk/pub/doc/redhat/redhat7.3/rhl-rg-en-7.3/s1-bind-rndc.html)  and [sameersbn/bind](https://github.com/sameersbn/docker-bind)

Install php-cli:

    $ sudo yum install php-cli -y

### Usage
Modify hosts file hosts.json to edit your DNS records. File format is self-explanatory, variable names ending with *_cloudflare* (*ex. ip_cloudflare*) will be applied to Cloudflare while those ending with *_bind* (ex. *cname_bind*) will be applied to Bind instance.

Convert hosts.json file to terraform configuration files:

    php convert.php
    
Set your terraform environment variables:

    $ . .secrets

Run tests to validate generated terraform configuration:

    $ ./test.sh

Initialize terraform:

    $ terraform init

Review terraform plan:

    $ terraform plan

Apply terraform configuration:

    $ terraform apply

Verify your global and local DNS records:

    $ dig a a1.example.com. 
    ;; ANSWER SECTION:
    a1.example.com. 1 IN A 104.27.190.62 <- global
    
    $ dig a a1.example.com. @localhost
    ;; ANSWER SECTION:
    a1.example.com.      1       IN      A       127.0.0.1 <- local

