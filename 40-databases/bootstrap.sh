#!/bin/bash

# dnf install ansible -y
# ansible-pull -U https://github.com/gurunani/ansible-roboshop-roles-.git -i localhost,  -e component=mongodb main.yaml
component=$1
dnf install ansible -y
ansible-pull -U https://github.com/gurunani/ansible-roboshop-roles-.git -e component=$1 -e env=$2 main.yaml