#!/bin/sh -eux

# Update repository
sudo apt update

# Change keyboard layout
sudo sed -i "s/us/tr/g" /etc/default/keyboard

# Install pip
echo 'y' | sudo apt install python3-pip

sudo pip3 install jinja2==2.11.1 --upgrade

sudo pip3 install ansible==2.9.6

sudo apt install htop

echo 'y' | sudo apt install glances

echo 'y' | sudo apt upgrade git

sudo apt install sshpass