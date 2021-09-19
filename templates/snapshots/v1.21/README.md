#### 检查系统服务

```bash
$ systemctl list-units --type=service --state=failed
$ systemctl list-units --type=service --state=exited

$ systemctl list-units --type=service --state=running
  UNIT                        LOAD   ACTIVE SUB     DESCRIPTION
  accounts-daemon.service     loaded active running Accounts Service
  containerd.service          loaded active running containerd container runtime
  cron.service                loaded active running Regular background program processing daemon
  dbus.service                loaded active running D-Bus System Message Bus
  docker.service              loaded active running Docker Application Container Engine
  getty@tty1.service          loaded active running Getty on tty1
  irqbalance.service          loaded active running irqbalance daemon
  kubelet.service             loaded active running kubelet: The Kubernetes Node Agent
  networkd-dispatcher.service loaded active running Dispatcher daemon for systemd-networkd
  rpcbind.service             loaded active running RPC bind portmap service
  rsyslog.service             loaded active running System Logging Service
  ssh.service                 loaded active running OpenBSD Secure Shell server
  systemd-journald.service    loaded active running Journal Service
  systemd-logind.service      loaded active running Login Service
  systemd-networkd.service    loaded active running Network Service
  systemd-resolved.service    loaded active running Network Name Resolution
  systemd-timesyncd.service   loaded active running Network Time Synchronization
  systemd-udevd.service       loaded active running udev Kernel Device Manager
  user@1000.service           loaded active running User Manager for UID 1000
```


#### 检查K8S资源

```bash
$ pstree -p
systemd─┬─accounts-daemon───2*[{accounts-daemon}]
        ├─containerd───9*[{containerd}]
        ├─3*[containerd-shim─┬─pause]
        │                    └─10*[{containerd-shim}]]
        ├─4*[containerd-shim─┬─pause]
        │                    └─11*[{containerd-shim}]]
        ├─containerd-shim─┬─kube-controller───6*[{kube-controller}]
        │                 └─11*[{containerd-shim}]
        ├─containerd-shim─┬─etcd───12*[{etcd}]
        │                 └─11*[{containerd-shim}]
        ├─containerd-shim─┬─kube-apiserver───10*[{kube-apiserver}]
        │                 └─11*[{containerd-shim}]
        ├─containerd-shim─┬─kube-scheduler───9*[{kube-scheduler}]
        │                 └─11*[{containerd-shim}]
        ├─containerd-shim─┬─kube-proxy───7*[{kube-proxy}]
        │                 └─11*[{containerd-shim}]
        ├─containerd-shim─┬─flanneld───8*[{flanneld}]
        │                 └─10*[{containerd-shim}]
        ├─containerd-shim─┬─promtail───21*[{promtail}]
        │                 └─11*[{containerd-shim}]
        ├─dockerd───33*[{dockerd}]
        └─kubelet───14*[{kubelet}]
        
$ ps -fp 3323 | grep ''
```

```bash
$ ps aux | grep kube
```

```bash
$ /usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock
$ /usr/bin/kubelet --bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf --config=/var/lib/kubelet/config.yaml --network-plugin=cni --pod-infra-container-image=k8s.gcr.io/pause:3.4.1

$ /usr/bin/containerd-shim-runc-v2 -namespace moby -id 050c93aab7b5eebf1c016709a90fa7b245573db22c48ff387368e60a2a384ddc -address /run/containerd/containerd.sock
$ etcd --advertise-client-urls=https://192.168.1.161:2379 --cert-file=/etc/kubernetes/pki/etcd/server.crt --client-cert-auth=true --data-dir=/var/lib/etcd --initial-advertise-peer-urls=https://192.168.1.161:2380 --initial-cluster=k8s-node001=https://192.168.1.161:2380 --key-file=/etc/kubernetes/pki/etcd/server.key --listen-client-urls=https://127.0.0.1:2379,https://192.168.1.161:2379 --listen-metrics-urls=http://127.0.0.1:2381 --listen-peer-urls=https://192.168.1.161:2380 --name=k8s-node001 --peer-cert-file=/etc/kubernetes/pki/etcd/peer.crt --peer-client-cert-auth=true --peer-key-file=/etc/kubernetes/pki/etcd/peer.key --peer-trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt --snapshot-count=10000 --trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt

$ /usr/bin/containerd-shim-runc-v2 -namespace moby -id 14684285361ba7f399d89b0c422d720002269b84ba136e929c187407e51efd8d -address /run/containerd/containerd.sock
$ kube-apiserver --advertise-address=192.168.1.161 --allow-privileged=true --authorization-mode=Node,RBAC --client-ca-file=/etc/kubernetes/pki/ca.crt --enable-admission-plugins=NodeRestriction --enable-bootstrap-token-auth=true --etcd-cafile=/etc/kubernetes/pki/etcd/ca.crt --etcd-certfile=/etc/kubernetes/pki/apiserver-etcd-client.crt --etcd-keyfile=/etc/kubernetes/pki/apiserver-etcd-client.key --etcd-servers=https://127.0.0.1:2379 --insecure-port=0 --kubelet-client-certificate=/etc/kubernetes/pki/apiserver-kubelet-client.crt --kubelet-client-key=/etc/kubernetes/pki/apiserver-kubelet-client.key --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname --proxy-client-cert-file=/etc/kubernetes/pki/front-proxy-client.crt --proxy-client-key-file=/etc/kubernetes/pki/front-proxy-client.key --requestheader-allowed-names=front-proxy-client --requestheader-client-ca-file=/etc/kubernetes/pki/front-proxy-ca.crt --requestheader-extra-headers-prefix=X-Remote-Extra- --requestheader-group-headers=X-Remote-Group --requestheader-username-headers=X-Remote-User --secure-port=6443 --service-account-issuer=https://kubernetes.default.svc.cluster.local --service-account-key-file=/etc/kubernetes/pki/sa.pub --service-account-signing-key-file=/etc/kubernetes/pki/sa.key --service-cluster-ip-range=10.96.0.0/12 --tls-cert-file=/etc/kubernetes/pki/apiserver.crt --tls-private-key-file=/etc/kubernetes/pki/apiserver.key

$ /usr/bin/containerd-shim-runc-v2 -namespace moby -id 180f3b2635ef9823ce2f832519dbd7c3d53c4e93a7acafd71d02cb8e1537f726 -address /run/containerd/containerd.sock
$ kube-controller-manager --allocate-node-cidrs=true --authentication-kubeconfig=/etc/kubernetes/controller-manager.conf --authorization-kubeconfig=/etc/kubernetes/controller-manager.conf --bind-address=127.0.0.1 --client-ca-file=/etc/kubernetes/pki/ca.crt --cluster-cidr=10.244.0.0/16 --cluster-name=kubernetes --cluster-signing-cert-file=/etc/kubernetes/pki/ca.crt --cluster-signing-key-file=/etc/kubernetes/pki/ca.key --controllers=*,bootstrapsigner,tokencleaner --kubeconfig=/etc/kubernetes/controller-manager.conf --leader-elect=true --port=0 --requestheader-client-ca-file=/etc/kubernetes/pki/front-proxy-ca.crt --root-ca-file=/etc/kubernetes/pki/ca.crt --service-account-private-key-file=/etc/kubernetes/pki/sa.key --service-cluster-ip-range=10.96.0.0/12 --use-service-account-credentials=true

$ /usr/bin/containerd-shim-runc-v2 -namespace moby -id c4e3265fd290629ba87d01b5c547368fd590adcd81119416fe227d053f84e4c7 -address /run/containerd/containerd.sock
$ kube-scheduler --authentication-kubeconfig=/etc/kubernetes/scheduler.conf --authorization-kubeconfig=/etc/kubernetes/scheduler.conf --bind-address=127.0.0.1 --kubeconfig=/etc/kubernetes/scheduler.conf --leader-elect=true --port=0

$ /usr/bin/containerd-shim-runc-v2 -namespace moby -id b5748726a6bf4295525fc8048410644dd7243b3e53e3f1b2fe4269182ef2bf56 -address /run/containerd/containerd.sock
$ /usr/local/bin/kube-proxy --config=/var/lib/kube-proxy/config.conf --hostname-override=k8s-node001

$ /usr/bin/containerd-shim-runc-v2 -namespace moby -id e7d677fc7a68508c5634daf9c34f23339076076cf6bd37da3c6b5a3383e596de -address /run/containerd/containerd.sock
$ /opt/bin/flanneld --ip-masq --kube-subnet-mgr
```

```bash
$ kubectl get all
NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   138d

$ kubectl get all -n kube-system -o wide
NAME                                      READY   STATUS    RESTARTS   AGE    IP              NODE          NOMINATED NODE   READINESS GATES
pod/etcd-k8s-node001                      1/1     Running   18         138d   192.168.1.161   k8s-node001   <none>           <none>
pod/kube-apiserver-k8s-node001            1/1     Running   18         138d   192.168.1.161   k8s-node001   <none>           <none>
pod/kube-controller-manager-k8s-node001   1/1     Running   18         138d   192.168.1.161   k8s-node001   <none>           <none>
pod/kube-scheduler-k8s-node001            1/1     Running   18         138d   192.168.1.161   k8s-node001   <none>           <none>
pod/kube-flannel-ds-q9jbf                 1/1     Running   22         138d   192.168.1.161   k8s-node001   <none>           <none>
pod/kube-flannel-ds-g7w5p                 1/1     Running   19         138d   192.168.1.162   k8s-node002   <none>           <none>
pod/kube-flannel-ds-ckpt4                 1/1     Running   21         138d   192.168.1.163   k8s-node003   <none>           <none>
pod/kube-flannel-ds-xt69k                 1/1     Running   21         138d   192.168.1.165   k8s-node005   <none>           <none>
pod/kube-flannel-ds-8m6k5                 1/1     Running   20         138d   192.168.1.166   k8s-node006   <none>           <none>
pod/kube-flannel-ds-jv2mp                 1/1     Running   20         138d   192.168.1.167   k8s-node007   <none>           <none>
pod/kube-flannel-ds-g24g8                 1/1     Running   21         138d   192.168.1.168   k8s-node008   <none>           <none>
pod/kube-flannel-ds-knxm2                 1/1     Running   13         135d   192.168.1.95    k8s-node031   <none>           <none>
pod/kube-flannel-ds-x7mxm                 1/1     Running   14         135d   192.168.1.96    k8s-node032   <none>           <none>
pod/kube-flannel-ds-z8k42                 1/1     Running   15         135d   192.168.1.99    k8s-node033   <none>           <none>
pod/kube-proxy-t524r                      1/1     Running   18         138d   192.168.1.161   k8s-node001   <none>           <none>
pod/kube-proxy-zfj4j                      1/1     Running   17         138d   192.168.1.162   k8s-node002   <none>           <none>
pod/kube-proxy-smzmf                      1/1     Running   17         138d   192.168.1.163   k8s-node003   <none>           <none>
pod/kube-proxy-fws2m                      1/1     Running   17         138d   192.168.1.165   k8s-node005   <none>           <none>
pod/kube-proxy-qh79z                      1/1     Running   17         138d   192.168.1.166   k8s-node006   <none>           <none>
pod/kube-proxy-9ff6s                      1/1     Running   17         138d   192.168.1.167   k8s-node007   <none>           <none>
pod/kube-proxy-wwhh2                      1/1     Running   17         138d   192.168.1.168   k8s-node008   <none>           <none>
pod/kube-proxy-k8rp7                      1/1     Running   13         135d   192.168.1.95    k8s-node031   <none>           <none>
pod/kube-proxy-pmtkr                      1/1     Running   14         135d   192.168.1.96    k8s-node032   <none>           <none>
pod/kube-proxy-gdzps                      1/1     Running   13         135d   192.168.1.99    k8s-node033   <none>           <none>
pod/coredns-558bd4d5db-s8bb8              1/1     Running   16         138d   10.244.2.138    k8s-node002   <none>           <none>
pod/coredns-558bd4d5db-sf9qh              1/1     Running   18         138d   10.244.4.110    k8s-node003   <none>           <none>

NAME               TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)                  AGE    SELECTOR
service/kube-dns   ClusterIP   10.96.0.10   <none>        53/UDP,53/TCP,9153/TCP   138d   k8s-app=kube-dns

NAME                             DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR            AGE    CONTAINERS     IMAGES                               SELECTOR
daemonset.apps/kube-flannel-ds   11        11        10      11           10          <none>                   138d   kube-flannel   quay.io/coreos/flannel:v0.14.0-rc1   app=flannel
daemonset.apps/kube-proxy        11        11        10      11           10          kubernetes.io/os=linux   138d   kube-proxy     k8s.gcr.io/kube-proxy:v1.21.0        k8s-app=kube-proxy

NAME                      READY   UP-TO-DATE   AVAILABLE   AGE    CONTAINERS   IMAGES                              SELECTOR
deployment.apps/coredns   2/2     2            2           138d   coredns      k8s.gcr.io/coredns/coredns:v1.8.0   k8s-app=kube-dns

NAME                                 DESIRED   CURRENT   READY   AGE    CONTAINERS   IMAGES                              SELECTOR
replicaset.apps/coredns-558bd4d5db   2         2         2       138d   coredns      k8s.gcr.io/coredns/coredns:v1.8.0   k8s-app=kube-dns,pod-template-hash=558bd4d5db
```


#### 检查证书

```bash
$ cfssl certinfo -cert k8s-master/etc/kubernetes/pki/ca.crt
$ cfssl certinfo -cert k8s-master/etc/kubernetes/pki/apiserver.crt
$ cfssl certinfo -cert k8s-master/etc/kubernetes/pki/apiserver-etcd-client.crt
$ cfssl certinfo -cert k8s-master/etc/kubernetes/pki/apiserver-kubelet-client.crt
$ cfssl certinfo -cert k8s-master/etc/kubernetes/pki/front-proxy-ca.crt
$ cfssl certinfo -cert k8s-master/etc/kubernetes/pki/front-proxy-client.crt
```

```bash
$ cfssl certinfo -cert k8s-master/etc/kubernetes/pki/etcd/ca.crt
$ cfssl certinfo -cert k8s-master/etc/kubernetes/pki/etcd/healthcheck-client.crt
$ cfssl certinfo -cert k8s-master/etc/kubernetes/pki/etcd/peer.crt
$ cfssl certinfo -cert k8s-master/etc/kubernetes/pki/etcd/server.crt
```