#!/bin/sh 

cd ~
mkdir iaktas 
cd iaktas
echo "Sana selam olsun başkan!" > iaktas+"$(date +'%s')".txt

sudo sed -i "s/us/tr/g" /etc/default/keyboard

rm -rf /etc/X11/xkb