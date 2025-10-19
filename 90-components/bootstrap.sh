#!/bin/bash

component=$1
env=$2


# Explicitly set MONGODB_HOST
ansible-pull -U https://github.com/gurunani/ansible-roboshop-roles-tf.git \
  -e component=$component \
  -e env=$env \
  -e MONGODB_HOST=mongodb-${env}.gurulabs.xyz \
  main.yaml