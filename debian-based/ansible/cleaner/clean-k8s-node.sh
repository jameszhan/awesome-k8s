#!/bin/bash

sudo kubeadm reset --force
sudo apt-mark unhold kubectl kubeadm kubelet
sudo apt -y purge kubectl kubeadm kubelet
sudo apt -y autoremove

if [ -d /etc/kubernetes ]; then
    sudo rm -vrf /etc/kubernetes
fi

if [ -d ~/.kube ]; then
    sudo rm -vrf ~/.kube
fi