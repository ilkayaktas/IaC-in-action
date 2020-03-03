#!/bin/sh -eux

sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=sudo' /etc/sudoers;

# Set up password-less sudo for the iaktas user
echo 'iaktas ALL=(ALL) NOPASSWD:ALL' >/etc/sudoers.d/99_iaktas;
chmod 440 /etc/sudoers.d/99_iaktas;

mkdir /etc/iaktas1
sudo mkdir /etc/iaktas2
echo iaktas | sudo -S -E mkdir /etc/iaktas3