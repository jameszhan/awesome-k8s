#!/bin/bash

sudo apt -y purge docker-ce docker-ce-cli containerd.io
sudo rm -vrf /var/lib/docker
sudo rm -vrf /var/lib/containerd