#!/bin/bash

# ipvsadm -A -t 192.168.1.129:443 -s rr
# ipvsadm -a -t 192.168.1.129:443 -r 192.168.1.61:6443 -m
# ipvsadm -a -t 192.168.1.129:443 -r 192.168.1.62:6443 -m
# ipvsadm -a -t 192.168.1.129:443 -r 192.168.1.63:6443 -m

ipvsadm -A -t 192.168.0.1:443 -s rr
ipvsadm -a -t 192.168.0.1:443 -r 192.168.1.61:6443 -m
ipvsadm -a -t 192.168.0.1:443 -r 192.168.1.62:6443 -m
ipvsadm -a -t 192.168.0.1:443 -r 192.168.1.63:6443 -m