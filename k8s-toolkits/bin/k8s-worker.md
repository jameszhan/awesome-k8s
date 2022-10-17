```bash
$ ./k8s docker 192.168.1.111 deploy
$ ssh k8s-node011 -t docker version
$ ssh k8s-node011 -t systemctl status docker

$ ./k8s docker 192.168.1.112 deploy
$ ./k8s docker 192.168.1.119 deploy
```

#### 安装`kubelet`和`kube-proxy`

```bash
$ ./k8s worker 192.168.1.111 deploy \
  --hostname=k8s-node011 \
  --master-addr=192.168.1.100:8443 \
  --dns-ip=192.168.1.130 \
  --kube-proxy-mode=ipvs \
  --binaries-url=https://storage.googleapis.com/kubernetes-release/release/v1.23.13/kubernetes-server-linux-amd64.tar.gz
$ ./k8s worker 192.168.1.112 deploy \
  --hostname=k8s-node012 \
  --master-addr=192.168.1.100:8443 --dns-ip=192.168.1.130 --kube-proxy-mode=ipvs --binaries-url=https://storage.googleapis.com/kubernetes-release/release/v1.23.4/kubernetes-server-linux-amd64.tar.gz
$ ./k8s worker 192.168.1.119 deploy \
  --hostname=k8s-node019 \
  --master-addr=192.168.1.100:8443 \
  --dns-ip=192.168.1.130 \
  --kube-proxy-mode=ipvs \
  --binaries-url=https://storage.googleapis.com/kubernetes-release/release/v1.23.13/kubernetes-server-linux-amd64.tar.gz

$ ssh k8s-node011 -t systemctl status docker
$ ssh k8s-node019 -t systemctl status docker
$ ssh k8s-node011 -t systemctl status kubelet
$ ssh k8s-node019 -t systemctl status kubelet
$ ssh k8s-node011 -t systemctl status kube-proxy
$ ssh k8s-node019 -t systemctl status kube-proxy
```

#### 接受新加入节点申请

```bash
$ kubectl get csr | grep Pending | awk '{print $1}' | xargs kubectl certificate approve
$ kubectl get nodes
```