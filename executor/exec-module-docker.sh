#!/bin/bash

# Not working seamlessly on RHEL, refer to origin roles:
# - https://github.com/githubixx/ansible-role-docker (No Support For RHEL Family)
# It will take after I contribute to the origin repository: https://github.com/devetek/ansible-role-docker

source ./includes/constants.sh

go run *.go \
    -i /ansible/inventory/ansible-inventory.ini \
    -p /ansible/playbooks/module-docker.yml \
    -u root \
    -k /executor/id_rsa_fake \
    -t all \
    -e @/executor/variables/module-docker.json