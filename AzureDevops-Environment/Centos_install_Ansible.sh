#!/bin/bash

# Steps taken from https://learn.microsoft.com/en-us/azure/developer/ansible/install-on-linux-vm?tabs=azure-cli

sudo yum install -y python3-pip && \
sudo pip3 install --upgrade pip && \
pip3 install "ansible==2.9.17" && \
pip3 install ansible[azure]