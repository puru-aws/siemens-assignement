#!/bin/bash

sudo apt-get update -y
sudo apt-get install awscli -y
# Setup sudo to allow no-password sudo for "siemens" group and adding "ansible" user

sudo groupadd -r siemens
sudo useradd -m -s /bin/bash ansible
sudo usermod -a -G siemens ansible
sudo cp /etc/sudoers /etc/sudoers.orig
echo "ansible  ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/ansible

sudo mkdir -p /home/ansible/.ssh
sudo chmod 700 /home/ansible/.ssh
sudo chmod 600 /home/ansible/.ssh/authorized_keys
sudo chown -R ansible /home/ansible/.ssh
sudo usermod --shell /bin/bash ansible
aws s3 sync s3://siemens-assignement/playbooks/ /home/ansible/playbooks/

#Installing Ansible
sudo apt-get install software-properties-common
sudo apt-add-repository ppa:ansible/ansible -y
sudo apt-get update -y
sudo apt-get install ansible -y
sudo chown ansible:ansible /etc/ansible/
