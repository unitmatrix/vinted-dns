# vinted-dns

### Introduction
This is an example Terraform setup to provision DNS records to Cloudflare and local Bind instance providers from a single configuration file in JSON format, with the ability to configure specific values for each provider.

## How to run
### Setup

Clone git repo:

    $ git clone -b v1 https://github.com/unitmatrix/vinted-dns.git && cd vinted-dns

You will need the following data to begin: **Cloudflare account ID**, **Cloudflare API access token**, **DNS rndc key name**, **key alorithm** and **secret**. Put this sensitive data as environment variables in a **secret.tfvars** file as shown below:

    cloudflare_api_token="sample_token"
    cloudflare_account_id="sample_id"
    
    dns_key_name="sample_rndc_key_name."
    dns_key_algorithm="sample_key_algorithm"
    dns_key_secret="sample_key_secret"
    
Secure file permissions:

    $ chmod 0600 secret.tfvars

Start a local BIND server instance locally: 

    docker pull sameersbn/bind:9.11.3-20200507
    
Run docker instance:

    docker run --name bind -d --restart=always \
    --publish 53:53/tcp --publish 53:53/udp \
    --publish 10000:10000/tcp --publish 953:953/tcp \
    --volume /srv/docker/bind:/data sameersbn/bind:9.11.3-20200507

 Port 10000 is for the webmin admin tool. Access it via https://localhost:1000 with *root*/*password*, create your zone and setup rndc key. Make sure to include the following policy for your zone:

     update-policy {
        grant rndc-key zonesub any;
     };

so terraform is able to update your records. More details: [Using rndc](https://www-uxsup.csx.cam.ac.uk/pub/doc/redhat/redhat7.3/rhl-rg-en-7.3/s1-bind-rndc.html)  and [sameersbn/bind](https://github.com/sameersbn/docker-bind)

Install php-cli:

    $ sudo yum install php-cli -y

### Usage
Edit your hosts file [hosts.json](https://github.com/unitmatrix/vinted-dns/blob/v1/hosts.json) to to update your DNS records. File format is self-explanatory, variable names ending with *_cloudflare* (*ex. ip_cloudflare*) will be applied to Cloudflare while those ending with *_bind* (ex. *cname_bind*) will be applied to Bind instance.

Convert hosts.json file to Terraform configuration files:

    php convert.php
    
Run tests to validate generated Terraform configuration:

    $ ./test.sh

Initialize Terraform:

    $ terraform init

Review Terraform plan:

    $ terraform plan -var-file=secret.tfvars

Apply Terraform configuration:

    $ terraform apply -var-file=secret.tfvars

Verify your global and local DNS records have updated successfully:

    $ dig a a1.example.com. 
    ;; ANSWER SECTION:
    a1.example.com. 1 IN A **104.27.190.62** <- global
    
    $ dig a a1.example.com. @localhost
    ;; ANSWER SECTION:
    a1.example.com.      1       IN      A       **127.0.0.1** <- local
