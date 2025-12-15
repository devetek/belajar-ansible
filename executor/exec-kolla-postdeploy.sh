#!/bin/bash

export KOLLA_CONFIG_PATH="ansible/inventory/group_vars/kolla" 

kolla-ansible post-deploy -i ansible/inventory/kolla/all-in-one