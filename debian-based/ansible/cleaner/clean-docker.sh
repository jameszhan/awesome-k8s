#!/bin/bash

sudo apt -y purge docker-ce docker-ce-cli containerd.io

if [ -d /var/lib/docker ]; then
    sudo rm -vrf /var/lib/docker
fi

if [ -d /var/lib/containerd ]; then
    sudo rm -vrf /var/lib/containerd
fi

if [ -f /etc/apt/sources.list.d/docker.list ]; then
    sudo rm -v /etc/apt/sources.list.d/docker.list
fi

if [ -f /usr/share/keyrings/docker-archive-keyring.gpg ]; then
    sudo rm -v /usr/share/keyrings/docker-archive-keyring.gpg
fi

if [ -f /etc/docker/daemon.json ]; then
    sudo rm -v /etc/docker/daemon.json
fi

sudo gpasswd --delete deploy docker