#!/bin/bash

export KOLLA_CONFIG_PATH="ansible/inventory/group_vars/kolla" 

kolla-ansible prechecks -i ansible/inventory/kolla/all-in-one