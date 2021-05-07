#!/bin/sh -eux

# Update repository
sudo apt update

# Change keyboard layout
sudo sed -i "s/us/tr/g" /etc/default/keyboard

# Install pip
echo 'y' | sudo apt install python-pip

sudo pip2 install jinja2 --upgrade

sudo pip2 install ansible==2.7.8

sudo apt install htop

echo 'y' | sudo apt install glances

echo 'y' | sudo apt upgrade git

sudo apt install sshpass