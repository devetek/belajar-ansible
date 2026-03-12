#!/bin/bash

# Not working seamlessly on RHEL, with error details:
# Public key for postgresql17-server-17.9-1PGDG.rhel9.7.aarch64.rpm is not installed. Failing package is: postgresql17-server-17.9-1PGDG.rhel9.7.aarch64
#  GPG Keys are configured as: https://download.postgresql.org/pub/repos/yum/keys/PGDG-RPM-GPG-KEY-RHEL
# The downloaded packages were saved in cache until the next successful transaction.
# You can remove cached packages by executing 'dnf clean packages'.
# Error: GPG check FAILED

# Alternatives, we use: geerlingguy.postgresql
# Later will follow official document https://www.postgresql.org/download/linux/redhat/ to install from non official pkg manager
# It solved, based on issue: https://github.com/ANXS/postgresql/issues/612

source ./includes/constants.sh

go run *.go \
    -i /ansible/inventory/ansible-inventory.ini \
    -p /ansible/playbooks/module-postgresql.yml \
    -u root \
    -k /executor/id_rsa_fake \
    -t all \
    -e @/executor/variables/module-postgresql.json