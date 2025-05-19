#!/usr/bin/bash

go run main.go -i /ansible/inventory/ansible-inventory.ini -p /ansible/playbooks/hello-world.yml -u root -k /executor/id_rsa_fake