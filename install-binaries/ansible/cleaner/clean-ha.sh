#!/bin/bash

apt -y purge haproxy keepalived
apt -y autoremove

if [ -d /etc/haproxy ]; then
    rm -vfr /etc/haproxy
fi

if [ -d /etc/keepalived ]; then
    rm -vfr /etc/keepalived
fi
