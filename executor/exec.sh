#!/usr/bin/bash

export SLACK_WEBHOOK_URL="https://hooks.slack.com/services/fake-app/fake-group/fake-id"
export SLACK_CHANNEL="#dpanel-resource"
export SLACK_USERNAME="dPanel-Creator"

go run main.go -i /ansible/inventory/ansible-inventory.ini -p /ansible/playbooks/bundle-wordpress.yml -u root -k /executor/id_rsa_fake -t all -e @/executor/variables/bundle-wordpress.json