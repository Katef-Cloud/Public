#!/bin/bash

# install Terraform on Centos 7

sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install terraform
terraform -install-autocomplete