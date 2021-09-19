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