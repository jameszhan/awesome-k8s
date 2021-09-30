#!/bin/bash

apt -y update
apt -y purge ipvsadm ipset chrony
apt -y autoremove

if [ -f /etc/apt/sources.list_bak ]; then
    mv -v /etc/apt/sources.list_bak /etc/apt/sources.list
fi

if [ -f /etc/modules-load.d/k8s.conf ]; then
    rm -vfr /etc/modules-load.d/k8s.conf
fi

if [ -f /etc/modules-load.d/ipvs.conf ]; then
    rm -vfr /etc/modules-load.d/ipvs.conf
fi

if [ -f /etc/sysctl.d/k8s.conf ]; then
    rm -vfr /etc/sysctl.d/k8s.conf
fi