#!/bin/bash

systemctl stop kube-scheduler
systemctl stop kube-controller-manager
systemctl stop kube-apiserver

systemctl disable kube-scheduler
systemctl disable kube-controller-manager
systemctl disable kube-apiserver

rm -vf /usr/lib/systemd/system/{kube-scheduler.service,kube-controller-manager.service,kube-apiserver.service}
rm -vf /etc/systemd/system/multi-user.target.wants/{kube-scheduler.service,kube-controller-manager.service,kube-apiserver.service}

rm -vfr /etc/kubernetes
rm -vfr /var/log/kubernetes
rm -vfr /tmp/kubernetes
rm -vfr /home/deploy/.kube

rm -vfr /usr/libexec/kubernetes
rm -vf /usr/local/bin/kube*
rm -vf /usr/local/bin/{apiextensions-apiserver,mounter}

rm -vf /tmp/kube-apiserver.k8s-*.root.log.*
rm -vf /tmp/kube-controller-manager.k8s-*.root.log.*
rm -vf /tmp/kube-scheduler.k8s-*.root.log.*