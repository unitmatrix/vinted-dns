# vinted-dns

### Introduction
This is an example Terraform setup to provision DNS records to Cloudflare and a local Bind instance providers from a single configuration file, with the ability to configure specific values for each provider. Version 2 is implemented without conversion scripts using only native Terraform v0.12.24 data structures (lists, nested maps) and resources (for_each, dynamic blocks) while [Version 1](https://github.com/unitmatrix/vinted-dns/tree/v1) utilized JSON file as a back-end store and a custom script to convert it to Terraform configuration files.

## How to run
### Setup

Install Terraform. [HashiCorp installation guide](https://learn.hashicorp.com/terraform/getting-started/install.html)

    $ terraform -v
    Terraform v0.12.24

Clone git repo:

    $ git clone https://github.com/unitmatrix/vinted-dns.git && cd vinted-dns

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
    --volume /srv/docker/bind:/data \
    sameersbn/bind:9.11.3-20200507

 Port 10000 is for the webmin admin tool. Access it via https://localhost:1000 with *root*/*password*, create your zone and setup rndc key. Make sure to include the following policy for your zone:

     update-policy {
        grant rndc-key zonesub any;
     };
     
so terraform is able to update your records. More details: [Using rndc](https://www-uxsup.csx.cam.ac.uk/pub/doc/redhat/redhat7.3/rhl-rg-en-7.3/s1-bind-rndc.html)  and [sameersbn/bind](https://github.com/sameersbn/docker-bind)

### Usage
Edit your zones file [zones.tfvars](https://github.com/unitmatrix/vinted-dns/blob/master/zones.tfvars) to update your DNS records as needed. File format is self-explanatory, variable names starting with *provider_X* (*ex. provider1_addresses*) will be applied to Cloudflare while those starting with *provider2_* (ex. *provider2_mxs*) will be applied to Bind instance only.

Example of A record for www domain name:

    record_key1 = {
	    name = "www"
	    ttl = 3600
	    provider1_addresses = ["11.11.11.1", "11.11.11.2"]
	    provider2_addresses = ["10.10.10.1", "10.10.10.2"]
	    provider1_proxied = "true"
    }

Run tests to validate Terraform configuration:

    $ ./test.sh

Initialize Terraform:

    $ terraform init

Review Terraform plan:

    $ terraform plan -var-file=secret.tfvars -var-file=zones.tfvars

Apply Terraform configuration:

    $ terraform apply -var-file=secret.tfvars -var-file=zones.tfvars

Verify your global and local DNS records have updated successfully:

    $ dig a a1.example.com. 
    ;; ANSWER SECTION:
    a1.example.com. 1 IN A **104.27.190.62** <- global
    
    $ dig a a1.example.com. @localhost
    ;; ANSWER SECTION:
    a1.example.com.      1       IN      A       **127.0.0.1** <- local

