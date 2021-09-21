#!/bin/bash

systemctl stop etcd
systemctl disable etcd
systemctl daemon-reload

rm -v /usr/lib/systemd/system/etcd.service
rm -vf /etc/systemd/system/multi-user.target.wants/etcd.service

rm -vfr /etc/etcd
rm -vfr /var/lib/etcd
rm -vfr /usr/local/bin/etcd*
rm -fr /tmp/etcd*