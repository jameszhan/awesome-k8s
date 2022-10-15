## Master Setup

### Install Etcd

#### On macOS

```bash
$ ./k8s etcd 192.168.1.62 deploy --name=etcd-02 --initial-state=existing \
  --clusterips=192.168.1.61,192.168.1.62,192.168.1.63 \
  --binaries-url=https://github.com/etcd-io/etcd/releases/download/v3.5.5/etcd-v3.5.5-linux-amd64.tar.gz

$ ssh k8s-master02 -t /usr/local/bin/etcdctl version
$ ssh k8s-master02 -t systemctl status etcd

$ ETCDCTL_API=3 etcdctl --write-out=table \
  --cacert=/opt/etc/k8s/cfssl/etcd/ca.pem \
  --cert=/opt/etc/k8s/cfssl/etcd/etcd.pem \
  --key=/opt/etc/k8s/cfssl/etcd/etcd-key.pem \
  --endpoints=https://192.168.1.61:2379,https://192.168.1.62:2379,https://192.168.1.63:2379 endpoint health
 
$ ETCDCTL_API=3 etcdctl --write-out=table \
  --cacert=/opt/etc/k8s/cfssl/etcd/ca.pem \
  --cert=/opt/etc/k8s/cfssl/etcd/etcd.pem \
  --key=/opt/etc/k8s/cfssl/etcd/etcd-key.pem \
  --endpoints=https://192.168.1.61:2379,https://192.168.1.62:2379,https://192.168.1.63:2379 endpoint status

$ ETCDCTL_API=3 etcdctl --write-out=table \
  --cacert=/opt/etc/k8s/cfssl/etcd/ca.pem \
  --cert=/opt/etc/k8s/cfssl/etcd/etcd.pem \
  --key=/opt/etc/k8s/cfssl/etcd/etcd-key.pem \
  --endpoints=https://192.168.1.61:2379,https://192.168.1.62:2379,https://192.168.1.63:2379 member list

$ ETCDCTL_API=3 etcdctl --write-out=json \
  --cacert=/opt/etc/k8s/cfssl/etcd/ca.pem \
  --cert=/opt/etc/k8s/cfssl/etcd/etcd.pem \
  --key=/opt/etc/k8s/cfssl/etcd/etcd-key.pem \
  --endpoints=https://192.168.1.61:2379,https://192.168.1.62:2379,https://192.168.1.63:2379 get '' --prefix | jq .

$ curl -i --cacert /opt/etc/k8s/cfssl/etcd/ca.pem --cert /opt/etc/k8s/cfssl/etcd/etcd.pem --key /opt/etc/k8s/cfssl/etcd/etcd-key.pem https://192.168.1.61:2379/version
$ curl -i --cacert /opt/etc/k8s/cfssl/etcd/ca.pem --cert /opt/etc/k8s/cfssl/etcd/etcd.pem --key /opt/etc/k8s/cfssl/etcd/etcd-key.pem https://192.168.1.61:2379/health
```

#### On k8s-master02

```bash
$ ETCDCTL_API=3 etcdctl --write-out=table \
  --cacert=/etc/etcd/ssl/ca.pem \
  --cert=/etc/etcd/ssl/etcd.pem \
  --key=/etc/etcd/ssl/etcd-key.pem \
  --endpoints=https://192.168.1.61:2379,https://192.168.1.62:2379,https://192.168.1.63:2379 endpoint status
$ curl -i --cacert /etc/etcd/ssl/ca.pem --cert /etc/etcd/ssl/etcd.pem --key /etc/etcd/ssl/etcd-key.pem https://192.168.1.61:2379/version
$ curl -i --cacert /etc/etcd/ssl/ca.pem --cert /etc/etcd/ssl/etcd.pem --key /etc/etcd/ssl/etcd-key.pem https://192.168.1.61:2379/health
```

### Install k8s server components

```bash
$ ./k8s master 192.168.1.62 deploy \
  --clusterips=192.168.1.61,192.168.1.62,192.168.1.63 \
  --service-cluster-ip-range=192.168.1.128/25 \
  --cluster_cidr=10.244.0.0/16 \
  --binaries-url=https://storage.googleapis.com/kubernetes-release/release/v1.23.12/kubernetes-server-linux-amd64.tar.gz

$ curl -i --cacert /opt/etc/k8s/cfssl/etcd/ca.pem \
  --cert /opt/etc/k8s/cfssl/master/admin.pem \
  --key /opt/etc/k8s/cfssl/master/admin-key.pem https://192.168.1.62:6443/version
  
$ ssh k8s-master02 -t systemctl status kube-apiserver
$ ssh k8s-master02 -t systemctl status kube-controller-manager
$ ssh k8s-master02 -t systemctl status kube-scheduler
```

### 配置HA

```bash
$ ./k8s ha 192.168.1.62 deploy \
  --virtual-ip=192.168.1.100 \
  --keepalived-state=MASTER \
  --keepalived-priority=200 \
  --link-interface=enp1s0 \
  --clusterips=192.168.1.61,192.168.1.62,192.168.1.63 \
  --clusternames=k8s-master01,k8s-master02,k8s-master03
  
$ ssh k8s-master02 -t sudo systemctl status keepalived
$ ssh k8s-master02 -t sudo systemctl status haproxy

$ curl -i http://192.168.1.62:33305/monitor
$ curl -i --cacert /opt/etc/k8s/cfssl/etcd/ca.pem --cert /opt/etc/k8s/cfssl/master/admin.pem \
  --key /opt/etc/k8s/cfssl/master/admin-key.pem https://192.168.1.62:8443/version
```
