#!/bin/bash

# It works but still using fork version, issue open: https://github.com/trfore/ansible-role-mongodb-install/issues/112
# Later will move to origin dependency

source ./includes/constants.sh

go run *.go \
    -i /ansible/inventory/ansible-inventory.ini \
    -p /ansible/playbooks/module-mongodb.yml \
    -u root \
    -k /executor/id_rsa_fake \
    -t all \
    -v \
    -e @/executor/variables/module-mongodb.json