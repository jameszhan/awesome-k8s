#!/bin/bash

systemctl stop docker
systemctl stop docker.socket
systemctl stop containerd
systemctl daemon-reload

rm -v /usr/lib/systemd/system/{docker.service,docker.socket,containerd.service}
rm -vrf /run/{docker,containerd}
rm -vrf /etc/docker
rm -vrf /var/lib/{docker,dockershim,containerd}
rm -vrf /tmp/docker
rm -vrf /usr/local/bin/{containerd,containerd-shim,containerd-shim-runc-v2,ctr,docker,docker-init,docker-proxy,dockerd,runc}
rm -vf /etc/systemd/system/multi-user.target.wants/docker.service
rm -vf /etc/systemd/system/sockets.target.wants/docker.socket