#!/bin/sh -eux

cd ~
mkdir iaktas 
cd iaktas
echo "Sana selam olsun başkan!" > iaktas+"$(date +'%s')".txt

sudo sed -i "s/us/tr/g" /etc/default/keyboard

mkdir /etc/iaktas4
echo 'iaktas' | sudo -S -E mkdir /etc/iaktas5

sudo apt-get update

# du command
sudo apt install ncdu

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

# Install Kubernetes
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
echo 'y' | sudo apt install kubeadm
sudo systemctl enable kubelet 
sudo systemctl start kubelet

# something disables the bridge-nf-call-iptables kernel parameter, which is required for Kubernetes services to operate properly. 
sudo sysctl -w net.bridge.bridge-nf-call-iptables=1
sudo echo "net.bridge.bridge-nf-call-iptables=1" > /etc/sysctl.d/k8s.conf
sudo swapoff -a && sed -i '/ swap / s/^/#/' /etc/fstab

echo "192.160.1.101  master.k8s" >> /etc/hosts
echo "192.160.1.102  node1.k8s" >> /etc/hosts
echo "192.160.1.103  node2.k8s" >> /etc/hosts
