#!/bin/sh -eux


# Change keyboard layout
sudo sed -i "s/us/tr/g" /etc/default/keyboard
