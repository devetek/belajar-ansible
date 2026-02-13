#!/bin/bash

export KOLLA_CONFIG_PATH="ansible/inventory/group_vars/kolla" 

kolla-ansible destroy -i ansible/inventory/kolla/all-in-one

rm -rf /etc/kolla /var/lib/kolla

docker system prune -af