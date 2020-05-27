#!/bin/bash

echo "Rebooting Kubernetes machines"

ssh iaktas@192.168.56.101 -t sudo poweroff
ssh iaktas@192.168.56.102 -t sudo poweroff
ssh iaktas@192.168.56.103 -t sudo poweroff

