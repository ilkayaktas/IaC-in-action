#!/bin/sh -eux

cd ~
mkdir iaktas 
cd iaktas
echo "Sana selam olsun başkan!" > iaktas+"$(date +'%s')".txt

sudo sed -i "s/us/tr/g" /etc/default/keyboard

mkdir /etc/iaktas4
echo iaktas | sudo -S -E mkdir /etc/iaktas5
