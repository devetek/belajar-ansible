#!/usr/bin/bash

export SLACK_WEBHOOK_URL="https://hooks.slack.com/services/fake-app/fake-group/fake-id"

# Development
go run main.go -i /ansible/inventory/ansible-inventory.ini -p /ansible/playbooks/module-emqx.yml -u root -k /executor/id_rsa_fake -t all
# Production
# go run main.go -i /ansible/inventory/ansible-inventory-prod.ini -p /ansible/playbooks/module-emqx.yml -u root -k /executor/id_rsa_prod -t all