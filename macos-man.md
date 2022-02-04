# macOS 配置集群

## 准备虚拟机

### 准备工作

#### 安装`multipass`

```bash
$ brew install --cask multipass
$ multipass version
multipass   1.8.1+mac
multipassd  1.8.1+mac
```

#### 配置`cloud-init`

```bash
$ ssh-keygen -t ed25519 -C "zizhizhan@gmail.com"
$ ssh -T git@github.com
$ cat <<YAML >> /opt/etc/cloud-init/multipass.yaml
users:
  - name: ubuntu
    groups: [adm]
    sudo: ["ALL = (ALL) NOPASSWD: ALL"]
    shell: /bin/bash
    ssh-authorized-keys:
      - ssh-ed25519 AAAAC3EXAMPLE... zizhizhan@gmail.com
YAML
```

### 安装虚拟机

```bash
$ multipass find
$ multipass launch --name=k8s-master01 --cloud-init=/opt/etc/cloud-init/multipass.yaml focal
$ multipass launch --name=k8s-master02 --cloud-init=/opt/etc/cloud-init/multipass.yaml focal
$ multipass launch --name=k8s-master03 --cloud-init=/opt/etc/cloud-init/multipass.yaml focal
$ multipass list

$ ssh ubuntu@`multipass list | grep master01 | awk '{print $3}'`
$ ssh ubuntu@`multipass list | grep master02 | awk '{print $3}'`
$ ssh ubuntu@`multipass list | grep master03 | awk '{print $3}'`
```

## 安装`k8s`

## 初始化必要设置

```bash
$ ./macos setup 192.168.64.7 ubuntu

```

### 安装`etcd`

```bash
$ brew install cfssl
$ cfssl version

$ gem install sshkit
$ gem install sshkit-sudo
$ gem install ed25519
$ gem install bcrypt_pbkdf

$ ./macos etcd 192.168.64.7 ubuntu --name=etcd01 --clusterips=192.168.64.7,192.168.64.8,192.168.64.9 --binaries-url=http://192.168.1.6:8888//binaries/etcd/etcd-v3.5.1-linux-arm64.tar.gz
$ ./macos etcd 192.168.64.8 ubuntu --name=etcd02 --clusterips=192.168.64.7,192.168.64.8,192.168.64.9 --binaries-url=http://192.168.1.6:8888//binaries/etcd/etcd-v3.5.1-linux-arm64.tar.gz
$ ./macos etcd 192.168.64.9 ubuntu --name=etcd03 --clusterips=192.168.64.7,192.168.64.8,192.168.64.9 --binaries-url=http://192.168.1.6:8888//binaries/etcd/etcd-v3.5.1-linux-arm64.tar.gz
```

### `etcd`服务测试

```bash
$ ETCDCTL_API=3 etcdctl --write-out=table \
  --cacert=/opt/etc/cfssl/etcd/ca.pem \
  --cert=/opt/etc/cfssl/etcd/etcd.pem \
  --key=/opt/etc/cfssl/etcd/etcd-key.pem \
  --endpoints=https://192.168.64.7:2379,https://192.168.64.8:2379,https://192.168.64.9:2379 endpoint health

$ ETCDCTL_API=3 etcdctl --write-out=table \
  --cacert=/opt/etc/cfssl/etcd/ca.pem \
  --cert=/opt/etc/cfssl/etcd/etcd.pem \
  --key=/opt/etc/cfssl/etcd/etcd-key.pem \
  --endpoints=https://192.168.64.7:2379,https://192.168.64.8:2379,https://192.168.64.9:2379 endpoint status

$ ETCDCTL_API=3 etcdctl --write-out=table \
  --cacert=/opt/etc/cfssl/etcd/ca.pem \
  --cert=/opt/etc/cfssl/etcd/etcd.pem \
  --key=/opt/etc/cfssl/etcd/etcd-key.pem \
  --endpoints=https://192.168.64.7:2379,https://192.168.64.8:2379,https://192.168.64.9:2379 member list

$ ETCDCTL_API=3 etcdctl --write-out=json \
  --cacert=/opt/etc/cfssl/etcd/ca.pem \
  --cert=/opt/etc/cfssl/etcd/etcd.pem \
  --key=/opt/etc/cfssl/etcd/etcd-key.pem \
  --endpoints=https://192.168.64.7:2379,https://192.168.64.8:2379,https://192.168.64.9:2379 auth status

$ ETCDCTL_API=3 etcdctl --write-out=json \
  --cacert=/opt/etc/cfssl/etcd/ca.pem \
  --cert=/opt/etc/cfssl/etcd/etcd.pem \
  --key=/opt/etc/cfssl/etcd/etcd-key.pem \
  --endpoints=https://192.168.64.7:2379,https://192.168.64.8:2379,https://192.168.64.9:2379 \
  get '' --prefix | jq .

$ curl -i --cacert /opt/etc/cfssl/etcd/ca.pem --cert /opt/etc/cfssl/etcd/etcd.pem --key /opt/etc/cfssl/etcd/etcd-key.pem https://192.168.64.8:2379/version
$ curl -i --cacert /opt/etc/cfssl/etcd/ca.pem --cert /opt/etc/cfssl/etcd/etcd.pem --key /opt/etc/cfssl/etcd/etcd-key.pem https://192.168.64.8:2379/health

$ curl -v --cacert /etc/etcd/ssl/ca.pem --cert /etc/etcd/ssl/etcd.pem --key /etc/etcd/ssl/etcd-key.pem https://192.168.1.61:2379/health
```


```bash
$ curl -L -s https://dl.k8s.io/release/stable.txt
```

> 下载不同版本的`K8S`安装文件，参考: [get-kube-binaries.sh](https://github.com/kubernetes/kubernetes/blob/master/cluster/get-kube-binaries.sh)

```bash
$ wget https://storage.googleapis.com/kubernetes-release/release/v1.23.3/kubernetes-server-linux-amd64.tar.gz
$ wget https://storage.googleapis.com/kubernetes-release/release/v1.23.3/kubernetes-server-linux-arm64.tar.gz
```

```bash
$ ./macos master 192.168.64.7 ubuntu --clusterips=192.168.64.7,192.168.64.8,192.168.64.9 --binaries-url=https://storage.googleapis.com/kubernetes-release/release/v1.23.3/kubernetes-server-linux-arm64.tar.gz
$ ./macos master 192.168.64.8 ubuntu --clusterips=192.168.64.7,192.168.64.8,192.168.64.9 --binaries-url=https://storage.googleapis.com/kubernetes-release/release/v1.23.3/kubernetes-server-linux-arm64.tar.gz
$ ./macos master 192.168.64.9 ubuntu --clusterips=192.168.64.7,192.168.64.8,192.168.64.9 --binaries-url=https://storage.googleapis.com/kubernetes-release/release/v1.23.3/kubernetes-server-linux-arm64.tar.gz

$ curl -i --cacert /opt/etc/cfssl/etcd/ca.pem --cert /opt/etc/cfssl/master/admin.pem --key /opt/etc/cfssl/master/admin-key.pem https://192.168.64.7:6443/version
$ curl -i --cacert /opt/etc/cfssl/etcd/ca.pem --cert /opt/etc/cfssl/master/admin.pem --key /opt/etc/cfssl/master/admin-key.pem https://192.168.64.8:6443/version
$ curl -i --cacert /opt/etc/cfssl/etcd/ca.pem --cert /opt/etc/cfssl/master/admin.pem --key /opt/etc/cfssl/master/admin-key.pem https://192.168.64.9:6443/version
```

```bash
$ ./macos ha 192.168.64.7 ubuntu --virtual-ip=192.168.64.100 --keepalived-state=MASTER --keepalived-priority=200 --link-interface=enp0s1 --clusterips=192.168.64.7,192.168.64.8,192.168.64.9 --clusternames=k8s-master01,k8s-master02,k8s-master03

$ curl -i http://192.168.64.7:33305/monitor
$ curl -i --cacert /opt/etc/cfssl/etcd/ca.pem --cert /opt/etc/cfssl/master/admin.pem --key /opt/etc/cfssl/master/admin-key.pem https://192.168.64.7:8443/version

$ ./macos ha 192.168.64.8 ubuntu --virtual-ip=192.168.64.100 --keepalived-state=BACKUP --keepalived-priority=150
$ curl -i http://192.168.64.8:33305/monitor
$ curl -i --cacert /opt/etc/cfssl/etcd/ca.pem --cert /opt/etc/cfssl/master/admin.pem --key /opt/etc/cfssl/master/admin-key.pem https://192.168.64.8:8443/version

$ ./macos ha 192.168.64.9 ubuntu --virtual-ip=192.168.64.100 --keepalived-state=BACKUP --keepalived-priority=100
$ curl -i http://192.168.64.7:33305/monitor
$ curl -i --cacert /opt/etc/cfssl/etcd/ca.pem --cert /opt/etc/cfssl/master/admin.pem --key /opt/etc/cfssl/master/admin-key.pem https://192.168.64.7:8443/version

$ curl -i --cacert /opt/etc/cfssl/etcd/ca.pem --cert /opt/etc/cfssl/master/admin.pem --key /opt/etc/cfssl/master/admin-key.pem https://192.168.64.100:8443/version
```