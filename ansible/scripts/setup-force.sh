#!/bin/bash

pip install -r requirements.txt --force-reinstall
ansible-galaxy install -r requirements.yml -f