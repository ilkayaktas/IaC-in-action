#!/bin/sh -eux

cd ~
mkdir iaktas 
cd iaktas
echo "Sana selam olsun başkan!" > iaktas+"$(date +'%s')".txt

sudo sed -i "s/us/tr/g" /etc/default/keyboard

mkdir /etc/iaktas4
echo 'iaktas' | sudo -S -E mkdir /etc/iaktas5

sudo apt-get update

# Required for selinux configuration
sudo apt install selinux-utils
sudo apt install policycoreutils 
echo 'y' | sudo apt install selinux-basics
sestatus

# Disable secure linux
sudo sed -i "s/SELINUX=enforcing/SELINUX=permissive/g" /etc/default/keyboard

sestatus

# Disable firewall
echo 'iaktas' | systemctl disable firewalld && systemctl stop firewalld

# Install docker
echo 'y' | sudo apt install docker.io
sudo systemctl start docker
sudo systemctl enable docker
docker --version