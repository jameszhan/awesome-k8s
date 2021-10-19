### 安装组件

#### Calico

```bash
$ kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
```

#### Flannel

```bash
$ kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

#### CoreDNS

```bash
$ helm repo add coredns https://coredns.github.io/helm
$ helm -n kube-system install coredns coredns/coredns
```

#### Metrics Server

```bash
$ kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml 
```

#### CSI NFS driver

```bash
$ git clone https://github.com/kubernetes-csi/csi-driver-nfs.git
$ cd csi-driver-nfs/deploy

$ kubectl apply -f rbac-csi-nfs-controller.yaml
$ kubectl apply -f csi-nfs-driverinfo.yaml
$ kubectl apply -f csi-nfs-controller.yaml
$ kubectl apply -f csi-nfs-node.yaml
```

#### NFS Subdirectory External Provisioner

```bash
$ helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
$ helm install -n kube-system nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner
```

#### Kubernetes Dashboard

```bash
$ kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.3.1/aio/deploy/recommended.yaml
```

#### Ingress Nginx

```bash
$ helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
$ helm template -n ingress-nginx --debug ingress-nginx ingress-nginx/ingress-nginx
```

### 参考

- [Calico](https://docs.projectcalico.org/)
- [CoreDNS](https://coredns.io/)
- [Kubernetes Metrics Server](https://github.com/kubernetes-sigs/metrics-server)
- [Kubernetes Dashboard](https://github.com/kubernetes/dashboard)
- [CSI NFS driver](https://github.com/kubernetes-csi/csi-driver-nfs)
- [Kubernetes Dashboard](https://github.com/kubernetes/dashboard)
- [Ingress Nginx](https://kubernetes.github.io/ingress-nginx/)