#!/usr/bin/bash

export SLACK_WEBHOOK_URL="https://hooks.slack.com/services/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"
export SLACK_CHANNEL="#dpanel-resource"
export SLACK_USERNAME="dPanel-Creator"

go run main.go -i /ansible/inventory/ansible-inventory.ini -p /ansible/playbooks/bundle-wordpress.yml -u root -k /executor/id_rsa_fake -t all