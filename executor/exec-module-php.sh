#!/bin/bash

# Not working seamlessly on RHEL, requires additional roles:
# - geerlingguy.repo-epel
# - geerlingguy.repo-remi
# It will take after get a generic playbook working with both OS family

source ./includes/constants.sh

go run *.go \
    -i /ansible/inventory/ansible-inventory.ini \
    -p /ansible/playbooks/module-php.yml \
    -u root \
    -k /executor/id_rsa_fake \
    -t all \
    -v \
    -e @/executor/variables/module-php.json