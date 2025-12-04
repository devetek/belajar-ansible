#!/bin/bash


# Define slack notification channel
export SLACK_WEBHOOK_URL="https://hooks.slack.com/services/fake-app/fake-group/fake-id"

# Define ansible roles path
export ANSIBLE_HOST_KEY_CHECKING="false"
export ANSIBLE_FORCE_COLOR="true"
export ANSIBLE_ROLES_PATH="/ansible/roles"
export ANSIBLE_STDOUT_CALLBACK="dpanel"
export ANSIBLE_SHELL_ALLOW_WORLD_READABLE_TEMP="true"
export ANSIBLE_DPANEL_PLUGINS="/ansible/plugins/utils"
export ANSIBLE_CALLBACK_PLUGINS="/ansible/plugins/callback"

# Define dPanel publisher settings
export DPANEL_PUBLISHER_URL="https://cloud-dev.terpusat.com/api/v1/ansible/callback"
export DPANEL_PUBLISHER_TOKEN="fake-token-1234567890"