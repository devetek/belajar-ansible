#!/usr/bin/bash

export SLACK_WEBHOOK_URL="https://hooks.slack.com/services/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"
export SLACK_CHANNEL="#dpanel-resource"
export SLACK_USERNAME="dPanel-Creator"

go run main.go -i /ansible/inventory/ansible-inventory.ini -p /ansible/playbooks/hello-world.yml -u root -k /executor/id_rsa_fake -e @/ansible/variables/task-1.json