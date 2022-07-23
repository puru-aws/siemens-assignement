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
#sudo cat "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC+czNGW/qwCPng3w4Lsq1rW9417MGSBbozuIAJwftp2EBrBKAHGfmGx8UdfQ5Gjusj6u2HYa08TJK8n3n0h+x0vJ/vOC91CbRvZYVdo9TYklS5lGYHTAYrt29pzOWjLpM2o7bozDzU9YYr1+uAfPYmsmMlGrKFHDJp8A+8Zz4gpAR1NRCdMVnuNKlfUlQwry41itW8SDOfcWeOETIirnQ8XW9SsQvliN1uIeWdtDQeldRX8x3Jvlxm1TUBKi07DoL943Gp0I3/pyDT0wcDFajhAkVWQyXBkxKDpsSnrT2bPxkUcDIXAlXPpi6/u4w8/xKh2SkWdy7umQ0esqFk7ZoRDHYtfSl05TkvHCtvpQdB347T2RqhXQ/0upR9s/fufbmNYadcNlzqpKnIzcJ/0SPritKdZALDzqHWTe+DBvLuo3cwgiJa4j7uEVD/T4eX51iHtdIAqvv4Dh8WtW7P7ABu+bV0c6ofS+OpEeVe87IW9Ip8hjnqsTi7ILh5pjWZRyM= prushok@88665a1fd6b2.ant.amazon.com" > /home/siemenstester/.ssh/authorized_keys
sudo chmod 600 /home/siemenstester/.ssh/authorized_keys
sudo chown -R siemenstester /home/siemenstester/.ssh
sudo usermod --shell /bin/bash siemenstester

aws s3 sync s3://siemens-assignement/ /home/siemenstester/