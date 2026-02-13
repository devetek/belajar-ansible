#!/usr/bin/bash

export SLACK_WEBHOOK_URL="https://hooks.slack.com/services/fake-app/fake-group/fake-id"

go run main.go -i /ansible/inventory/ansible-inventory.ini -p /ansible/playbooks/module-blackbox_exporter.yml -u root -k /executor/id_rsa_fake -t all -e @/executor/variables/module-blackbox_exporter.json
