#!/bin/sh -eux

# Init master node
kubeadm init

# KUBECONFIG is required for kubectl usage
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
export KUBECONFIG=$HOME/.kube/config

#Test kubectl
kubectl get po -n kube-system

# After you see controllers pods, its time to join worker nodes to master node.
# When you init master node, last line contains a command like below:
# kubeadm join 192.168.1.101:6443 --token 02w8iq.54tub8cmanfhkq0s --discovery-token-ca-cert-hash sha256:9fc8069822aeaea9ca6ef75588adb7a46c8cde06b9b933855a1685636f5a29c3
# Run this command on worker nodes.

# kubectl describe node node1
# KubeletNotReady              runtime network not ready: NetworkReady=false reason:NetworkPlugin NotReady message:docker: network plugin is not ready: cni config uninitialized

kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
watch kubectl get pods --all-namespaces

