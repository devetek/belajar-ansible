#!/bin/bash

source ./includes/constants.sh

go run *.go \
    -i /ansible/inventory/ansible-inventory.ini \
    -p /ansible/playbooks/cloud-proxmox-lxc.yml \
    -u root \
    -k /executor/id_rsa_fake \
    -t all \
    -e @/executor/variables/cloud-proxmox-xlc.json \
    -v