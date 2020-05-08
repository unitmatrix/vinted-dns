#!/bin/sh

# Initialize a working directory for validation without 
# accessing any configured remote backend
terraform init -backend=false

# Validate the configuration files in a directory, 
# referring only to the configuration and not accessing any 
# remote services such as remote state, provider APIs, etc.
terraform validate
