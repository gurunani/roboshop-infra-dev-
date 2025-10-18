#!/bin/bash

component=$1
env=$2

# install ansible and pip
dnf install -y ansible python3-pip
pip3 install --upgrade boto3 botocore

export ANSIBLE_PYTHON_INTERPRETER=/usr/bin/python3

# Explicitly set MONGODB_HOST
ansible-pull -U https://github.com/gurunani/ansible-roboshop-roles-.git \
  -e component=$component \
  -e env=$env \
  -e MONGODB_HOST=mongodb-${env}.gurulabs.xyz \
  main.yaml