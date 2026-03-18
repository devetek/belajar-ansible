#!/bin/bash

python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt --force-reinstall
ansible-galaxy install -r requirements.yml -f