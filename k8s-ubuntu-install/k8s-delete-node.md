


> 删除一个节点前，先驱赶掉上面的pod

```bash
$ kubectl drain k8s-node021 --delete-emptydir-data --force --ignore-daemonsets
$ kubectl drain k8s-node022 --delete-emptydir-data --force --ignore-daemonsets

$ kubectl get nodes
NAME          STATUS                     ROLES                  AGE    VERSION
k8s-node021   Ready,SchedulingDisabled   <none>                 128d   v1.22.1
k8s-node022   Ready,SchedulingDisabled   <none>                 128d   v1.22.1
```

> 删除节点

```bash
$ kubectl delete node k8s-node021
$ kubectl delete node k8s-node022
```


#### node 节点操作

```bash
$ sudo kubeadm reset

$ sudo apt purge docker-ce docker-ce-cli containerd.io
$ sudo rm -rf /var/lib/docker
$ sudo rm -rf /var/lib/containerd

$ sudo apt -y purge kubeadm kubelet kubectl
$ sudo rm -fr /opt/containerd/
$ sudo rm /etc/apt/sources.list.d/kubernetes.list
$ sudo rm /usr/share/keyrings/kubernetes-archive-keyring.gpg

$ sudo apt -y autoremove
```

#### 移除网桥

```bash
$ sudo apt -y install net-tools bridge-utils

$ sudo ifconfig docker0 down
$ sudo brctl delbr docker0

$ sudo ifconfig cni0 down
$ sudo brctl delbr cni0

$ sudo ifconfig flannel.1 down
$ sudo ip link del flannel.1

$ ifconfig -a
```