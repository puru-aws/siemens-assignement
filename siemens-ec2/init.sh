#!/bin/bash

sudo apt-get update -y
sudo apt-get install awscli -y

# Setup sudo to allow no-password sudo for "siemens" group and adding "siemenstester" user
sudo groupadd -r siemens
sudo useradd -m -s /bin/bash siemenstester
sudo usermod -a -G siemens siemenstester
sudo cp /etc/sudoers /etc/sudoers.orig
echo "siemenstester  ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/siemenstester

# Installing SSH key
sudo mkdir -p /home/siemenstester/.ssh
sudo chmod 700 /home/siemenstester/.ssh
sudo touch /home/siemenstester/.ssh/authorized_keys
sudo cat "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDTDh6N3H9v/dHb3I1ue7K7f+P6IIQhl5t12uaZcCJ77p5o/qe+za7MKzyh86s2ciGaKUa92M7KAhyRxa93HgdFfC9oY5NiFixxClsc+SCyyhw7o/NHs6iL+RP2bpAhHtcicY8F+6sBPb0NmmM5tn14hPEwUtXHGlG4SwiGe3hfPFKY+0top42XHXZcrdc1xQCRyI52XVE7vlZ2JFAku7DNQ+S+jzbhiC1HqfXCDCqlpn4iWQtHkutPWMwNpoBDRFXRzXhpm+e28kq4y+KqvouK9vzoTJWXRxiOWoYQMZL/QUviokIHL9CsLXuMTNZeDgVdCu+HHGblprFKfnWA6JmHZqC4vc+4bI70go59zNwG0kEh9cOw7Re8lfQ4uD+vY7jim8G58udyvh+3VltM6ce0vn8DmgejHxexRD+I6XfaANhJu9GfogHiqMbZPFNBwKE9aru9I+U2E7+aBfHXg/fawyk5DaQOuU5vcfABvfS7nEBJP/Ba9tot0ZESLSjYAQc= ansible@ip-10-0-1-233" >> /home/siemenstester/.ssh/authorized_keys
sudo chmod 600 /home/siemenstester/.ssh/authorized_keys
sudo chown -R siemenstester /home/siemenstester/.ssh
sudo usermod --shell /bin/bash siemenstester

aws s3 sync s3://siemens-assignement/ /home/siemenstester/
sudo chown -R siemenstester /home/siemenstester/
