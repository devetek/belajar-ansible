#!/bin/bash

source ./includes/constants.sh

# Development
go run *.go \
    -i /ansible/inventory/ansible-inventory.ini \
    -p /ansible/playbooks/module-emqx.yml \
    -u root \
    -k /executor/id_rsa_fake \
    -t all
# Production
# go run *.go -i /ansible/inventory/ansible-inventory-prod.ini -p /ansible/playbooks/module-emqx.yml -u root -k /executor/id_rsa_prod -t all