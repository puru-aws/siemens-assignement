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
sudo echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDBeYcBNvUNSYrWIs23iL4UN5lUCa56D0sw31LvEu6YMhYzR4OquHEYlOQTFhPxWIBRODzf5NbuySqw6JlM7Xc0RJHzXq3PgPfvWKnTcLs4qj/r3itoxK7Iyb/5aczFofN7qlpb98K4RU2PTASEjMBPkwLQ/nRofpkI+oriUehT3rSuT4NOxRkN10T3qtmK097f90bL5Ot0Kc1ChIKDn49iZl6nD4vVh2QU+aYwPI+kjzjU2IifnMDUSzukZp1IRWDu9pjpyBo92HG3poUAXHOtOXdDjfT5MfsbHOHiVHNpkGevVc+M28LunMM7n9QuWHqtvj4LXRRAxmGF+jixGqLRomJGd76+3oLll7LxW2WNdV1EdfeQtIDBF+bRLJztWuwAgT/BPo3lD3N4OYucWr/RHRwaNXExVr/Yc9Nb9i3WG6mZvjMxV8+BM+ruV4kH8QZQ4FAlHQZ6CMVlOuY8DwoSL5p8gAPl7NFAUZ/y3a0sqgL4LRUoXEhIxZfVTGJ6UJs= ansible@ip-10-0-25-75" >> /home/siemenstester/.ssh/authorized_keys
sudo chmod 600 /home/siemenstester/.ssh/authorized_keys
sudo chown -R siemenstester:siemens /home/siemenstester/.ssh
sudo usermod --shell /bin/bash siemenstester

aws s3 sync s3://siemens-123546231/ /home/siemenstester/
sudo chown -R siemenstester /home/siemenstester/
sudo chmod 666 /var/run/docker.sock
