#!/bin/bash

rm -f /tmp/kubelet.k8s-*.root.log.*

systemctl stop kubelet
systemctl disable kubelet
systemctl daemon-reload

rm -v /usr/lib/systemd/system/kubelet.service
rm -vf /etc/systemd/system/multi-user.target.wants/kubelet.service

rm -vrf /etc/kubernetes
rm -vrf /var/lib/kubelet
rm -vrf /usr/libexec/kubernetes
rm -vrf /usr/local/bin/{kubelet,kube-proxy}


