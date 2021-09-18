


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
$ sudo systemctl stop docker.socket
$ sudo systemctl stop docker.service
```