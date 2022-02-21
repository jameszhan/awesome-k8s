# `macOS`本地部署`k8s`集群

## 环境说明

| 组件                     | 版本                  | 用途                        | 安装位置                                         |
| ----------------------- | --------------------- | -------------------------- | ----------------------------------------------- |
| macOS                   | macOS Monterey 12.1   | 宿主机操作系统                | -                                               |
| Homebrew                | 3.3.14                | 包管理工具                   | macOS                                           |
| Multipass               | 1.8.1+mac             | 快速创建`Ubuntu`虚拟机实例     | macOS                                           |
| Ubuntu Server           | Ubuntu 20.04.4 LTS    | 虚拟机操作系统                 | macOS                                           |
| Ruby                    | ruby 3.1.0p0          | 用于执行`macos`命令行工具      | macOS                                           |
| CFSSL                   | 1.6.1                 | 生成`k8s`集群相关证书          | macOS                                           |
| Helm                    | v3.8.0                | kubernetes package manager   | macOS                                           |
| etcd                    | 3.5.2                 | `k8s`集群数据管理              | k8s-node01/k8s-node02/k8s-node03                |
| kube-apiserver          | v1.23.4               | `k8s master`服务             | k8s-node01/k8s-node02/k8s-node03                |
| kube-controller-manager | v1.23.4               | `k8s master`服务             | k8s-node01/k8s-node02/k8s-node03                |
| kube-scheduler          | v1.23.4               | `k8s master`服务             | k8s-node01/k8s-node02/k8s-node03                |
| kubectl                 | v1.23.4               | `k8s`命令行工具               | macOS/k8s-node01/k8s-node02/k8s-node03          |
| HAProxy                 | 2.0.13-2ubuntu0.3     | 负载均衡服务                  | k8s-node01/k8s-node02/k8s-node03                |
| Keepalived              | v2.0.19               | 高可用服务                    | k8s-node01/k8s-node02/k8s-node03                |
| Docker                  | 20.10.12              | `CRI`服务                    | k8s-node01/k8s-node02/k8s-node03/k8s-node04/... |
| kubelet                 | v1.23.4               | `k8s worker`服务             | k8s-node01/k8s-node02/k8s-node03/k8s-node04/... |
| kube-proxy              | v1.23.4               | `k8s worker`服务             | k8s-node01/k8s-node02/k8s-node03/k8s-node04/... |
| Calico                  | v3.22.0               | `CNI vRouter`服务            | k8s-node01/k8s-node02/k8s-node03/k8s-node04/... |
| CoreDNS                 | 1.16.7                | `k8s DNS`服务                | k8s cluster                                     |


## 准备工作

### 安装相关软件

#### 安装`Homebrew`

```bash
$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

详细安装过程可以参考[Install Homebrew](https://brew.sh/)。

#### 安装`Multipass`

```bash
$ brew install --cask multipass
$ multipass version
multipass   1.8.1+mac
multipassd  1.8.1+mac
```

详细安装过程可以参考[Install Multipass](https://multipass.run/)。

#### 安装`CFSSL`

```bash
$ brew install cfssl
$ cfssl version
Version: 1.6.1
Runtime: go1.17.2
```

#### 安装`Ruby`(可选)

```bash
$ brew install ruby
$ ruby --version
ruby 3.1.0p0 (2021-12-25 revision fb4df44d16) [x86_64-darwin21]
$ gem update --system
$ gem update
$ gem --version
3.3.7
```

> `macOS`默认自带了`ruby`，不过在执行`gem`命令时候，需要使用`sudo`。

### 安装虚拟机

生成密钥文件

```bash
$ ssh-keygen -t ed25519 -C "zizhizhan@gmail.com"
```

#### k8s-node01

准备`cloud-init`文件

```bash
$ cat <<YAML >> /opt/etc/cloud-init/k8s-node01.yml
users:
  - name: ubuntu
    groups: [adm, admin, sudo, staff, users]
    sudo: ["ALL = (ALL) NOPASSWD: ALL"]
    shell: /bin/bash
    ssh-authorized-keys:
      - ssh-ed25519 AAAAC3Nz...... zizhizhan@gmail.com
fqdn: k8s-node01.local
write_files:
  - path: /etc/cloud/templates/hosts.debian.tmpl
    content: |
      192.168.64.21    k8s-node01
      192.168.64.22    k8s-node02
      192.168.64.23    k8s-node03
    append: true
YAML
```

安装虚拟机

```bash
$ multipass launch --name=k8s-node01 --cpus=2 --mem=2G --disk=32G --cloud-init=/opt/etc/cloud-init/k8s-node01.yml focal
$ ssh ubuntu@`multipass list | grep k8s-node01 | awk '{print $3}'`
```


#### k8s-node02

准备`cloud-init`文件

```bash
$ cat <<YAML >> /opt/etc/cloud-init/k8s-node02.yml
users:
  - name: ubuntu
    groups: [adm, admin, sudo, staff, users]
    sudo: ["ALL = (ALL) NOPASSWD: ALL"]
    shell: /bin/bash
    ssh-authorized-keys:
      - ssh-ed25519 AAAAC3Nz...... zizhizhan@gmail.com
fqdn: k8s-node02.local
write_files:
  - path: /etc/cloud/templates/hosts.debian.tmpl
    content: |
      192.168.64.21    k8s-node01
      192.168.64.22    k8s-node02
      192.168.64.23    k8s-node03
    append: true
YAML
```

安装虚拟机

```bash
$ multipass launch --name=k8s-node02 --cpus=2 --mem=2G --disk=32G --cloud-init=/opt/etc/cloud-init/k8s-node02.yml focal
$ ssh ubuntu@`multipass list | grep k8s-node02 | awk '{print $3}'`
```

#### k8s-node03

准备`cloud-init`文件

```bash
$ cat <<YAML >> /opt/etc/cloud-init/k8s-node03.yml
users:
  - name: ubuntu
    groups: [adm, admin, sudo, staff, users]
    sudo: ["ALL = (ALL) NOPASSWD: ALL"]
    shell: /bin/bash
    ssh-authorized-keys:
      - ssh-ed25519 AAAAC3Nz...... zizhizhan@gmail.com
fqdn: k8s-node03.local
write_files:
  - path: /etc/cloud/templates/hosts.debian.tmpl
    content: |
      192.168.64.21    k8s-node01
      192.168.64.22    k8s-node02
      192.168.64.23    k8s-node03
    append: true
YAML
```

安装虚拟机

```bash
$ multipass launch --name=k8s-node03 --cpus=2 --mem=2G --disk=32G --cloud-init=/opt/etc/cloud-init/k8s-node03.yml focal
$ ssh ubuntu@`multipass list | grep k8s-node03 | awk '{print $3}'`
```

### 安装`macos`工具

#### 安装必要工具

```bash
$ gem install thor
$ gem install sshkit
$ gem install sshkit-sudo
$ gem install ed25519
$ gem install bcrypt_pbkdf
```

> 使用系统自带的`Ruby`，记得前面加`sudo`。

#### 安装`macos`

```bash
$ curl -o macos https://raw.githubusercontent.com/jameszhan/awesome-k8s/main/k8s-on-macos/bin/macos
$ chmod +x macos
$ ./macos
```

## 安装集群

### 初始化必要设置

```bash
$ ./macos setup 192.168.64.21 ubuntu
$ ./macos setup 192.168.64.22 ubuntu
$ ./macos setup 192.168.64.23 ubuntu
```

> 进行下一步前，最好先重启虚拟机

```bash
$ multipass list | grep k8s-node | awk '{print $1}' | xargs multipass restart
```

### 安装[etcd](https://github.com/etcd-io/etcd/releases)集群

#### 执行安装脚本

```bash
$ ./macos etcd 192.168.64.21 ubuntu --name=etcd01 --clusterips=192.168.64.21,192.168.64.22,192.168.64.23 --binaries-url=http://192.168.1.6:8888/binaries/etcd/etcd-v3.5.1-linux-arm64.tar.gz
$ multipass exec k8s-node01 /usr/local/bin/etcdctl version

$ ./macos etcd 192.168.64.22 ubuntu --name=etcd02 --clusterips=192.168.64.21,192.168.64.22,192.168.64.23 --binaries-url=http://192.168.1.6:8888/binaries/etcd/etcd-v3.5.1-linux-arm64.tar.gz
$ multipass exec k8s-node02 /usr/local/bin/etcdctl version

$ ./macos etcd 192.168.64.23 ubuntu --name=etcd03 --clusterips=192.168.64.21,192.168.64.22,192.168.64.23 --binaries-url=http://192.168.1.6:8888/binaries/etcd/etcd-v3.5.1-linux-arm64.tar.gz
$ multipass exec k8s-node03 /usr/local/bin/etcdctl version
```

#### 测试`etcd`集群

```bash
$ ETCDCTL_API=3 etcdctl --write-out=table \
  --cacert=/opt/etc/cfssl/etcd/ca.pem \
  --cert=/opt/etc/cfssl/etcd/etcd.pem \
  --key=/opt/etc/cfssl/etcd/etcd-key.pem \
  --endpoints=https://192.168.64.21:2379,https://192.168.64.22:2379,https://192.168.64.23:2379 endpoint health

$ ETCDCTL_API=3 etcdctl --write-out=table \
  --cacert=/opt/etc/cfssl/etcd/ca.pem \
  --cert=/opt/etc/cfssl/etcd/etcd.pem \
  --key=/opt/etc/cfssl/etcd/etcd-key.pem \
  --endpoints=https://192.168.64.21:2379,https://192.168.64.22:2379,https://192.168.64.23:2379 endpoint status

$ ETCDCTL_API=3 etcdctl --write-out=table \
  --cacert=/opt/etc/cfssl/etcd/ca.pem \
  --cert=/opt/etc/cfssl/etcd/etcd.pem \
  --key=/opt/etc/cfssl/etcd/etcd-key.pem \
  --endpoints=https://192.168.64.21:2379,https://192.168.64.22:2379,https://192.168.64.23:2379 member list

$ ETCDCTL_API=3 etcdctl --write-out=json \
  --cacert=/opt/etc/cfssl/etcd/ca.pem \
  --cert=/opt/etc/cfssl/etcd/etcd.pem \
  --key=/opt/etc/cfssl/etcd/etcd-key.pem \
  --endpoints=https://192.168.64.21:2379,https://192.168.64.22:2379,https://192.168.64.23:2379 get '' --prefix | jq .

$ curl -i --cacert /opt/etc/cfssl/etcd/ca.pem --cert /opt/etc/cfssl/etcd/etcd.pem --key /opt/etc/cfssl/etcd/etcd-key.pem https://192.168.64.21:2379/version
$ curl -i --cacert /opt/etc/cfssl/etcd/ca.pem --cert /opt/etc/cfssl/etcd/etcd.pem --key /opt/etc/cfssl/etcd/etcd-key.pem https://192.168.64.22:2379/health
```

### 安装`k8s-master`

#### 执行安装脚本

```bash
$ ./macos master 192.168.64.21 ubuntu --clusterips=192.168.64.21,192.168.64.22,192.168.64.23 --binaries-url=http://192.168.1.6:8888/binaries/kubernetes/kubernetes-server-v1.23.3-linux-arm64.tar.gz
$ curl -i --cacert /opt/etc/cfssl/etcd/ca.pem --cert /opt/etc/cfssl/master/admin.pem --key /opt/etc/cfssl/master/admin-key.pem https://192.168.64.21:6443/version

$ ./macos master 192.168.64.22 ubuntu --clusterips=192.168.64.21,192.168.64.22,192.168.64.23 --binaries-url=http://192.168.1.6:8888/binaries/kubernetes/kubernetes-server-v1.23.3-linux-arm64.tar.gz
$ curl -i --cacert /opt/etc/cfssl/etcd/ca.pem --cert /opt/etc/cfssl/master/admin.pem --key /opt/etc/cfssl/master/admin-key.pem https://192.168.64.22:6443/version

$ ./macos master 192.168.64.23 ubuntu --clusterips=192.168.64.21,192.168.64.22,192.168.64.23 --binaries-url=http://192.168.1.6:8888/binaries/kubernetes/kubernetes-server-v1.23.3-linux-arm64.tar.gz
$ curl -i --cacert /opt/etc/cfssl/etcd/ca.pem --cert /opt/etc/cfssl/master/admin.pem --key /opt/etc/cfssl/master/admin-key.pem https://192.168.64.23:6443/version
```

#### 配置`HA`

```bash
$ ./macos ha 192.168.64.21 ubuntu --virtual-ip=192.168.64.100 --keepalived-state=MASTER --keepalived-priority=200 --link-interface=enp0s1 --clusterips=192.168.64.21,192.168.64.22,192.168.64.23 --clusternames=k8s-node01,k8s-node02,k8s-node03
$ curl -i http://192.168.64.21:33305/monitor
$ curl -i --cacert /opt/etc/cfssl/etcd/ca.pem --cert /opt/etc/cfssl/master/admin.pem --key /opt/etc/cfssl/master/admin-key.pem https://192.168.64.21:8443/version

$ ./macos ha 192.168.64.22 ubuntu --virtual-ip=192.168.64.100 --keepalived-state=BACKUP --keepalived-priority=150 --link-interface=enp0s1 --clusterips=192.168.64.21,192.168.64.22,192.168.64.23 --clusternames=k8s-node01,k8s-node02,k8s-node03
$ curl -i http://192.168.64.22:33305/monitor
$ curl -i --cacert /opt/etc/cfssl/etcd/ca.pem --cert /opt/etc/cfssl/master/admin.pem --key /opt/etc/cfssl/master/admin-key.pem https://192.168.64.22:8443/version

$ ./macos ha 192.168.64.23 ubuntu --virtual-ip=192.168.64.100 --keepalived-state=BACKUP --keepalived-priority=100 --link-interface=enp0s1 --clusterips=192.168.64.21,192.168.64.22,192.168.64.23 --clusternames=k8s-node01,k8s-node02,k8s-node03
$ curl -i http://192.168.64.23:33305/monitor
$ curl -i --cacert /opt/etc/cfssl/etcd/ca.pem --cert /opt/etc/cfssl/master/admin.pem --key /opt/etc/cfssl/master/admin-key.pem https://192.168.64.23:8443/version

$ curl -i --cacert /opt/etc/cfssl/etcd/ca.pem --cert /opt/etc/cfssl/master/admin.pem --key /opt/etc/cfssl/master/admin-key.pem https://192.168.64.100:8443/version
```

### 管理集群

### 安装`k8s worker`

```bash
$ hostnamectl status
$ sudo hostnamectl set-hostname k8s-worker01

$ ./macos setup 192.168.64.5 ubuntu
$ ./macos docker 192.168.64.5 ubuntu
# ./macos worker 192.168.64.5 ubuntu --hostname=k8s-worker01 --master-addr=192.168.64.100:8443 --dns-ip=10.96.0.2 --kube-proxy-mode=ipvs --binaries-url=https://storage.googleapis.com/kubernetes-release/release/v1.23.3/kubernetes-server-linux-arm64.tar.gz
$ ./macos worker 192.168.64.5 ubuntu --hostname=k8s-worker01 --master-addr=192.168.64.100:8443 --dns-ip=10.96.0.2 --kube-proxy-mode=ipvs --binaries-url=http://192.168.1.6:8888/binaries/kubernetes/kubernetes-server-v1.23.3-linux-arm64.tar.gz
```

### 一次性工作

```bash
$ kubectl create clusterrolebinding kubelet-bootstrap --clusterrole=system:node-bootstrapper --user=kubelet-bootstrap
$ kubectl create clusterrolebinding kubernetes-admin --clusterrole=cluster-admin --user=kubernetes
```

### 接受新加入节点申请

```bash
$ kubectl get csr | grep Pending | awk '{print $1}' | xargs kubectl certificate approve
$ kubectl get nodes
```

> 如果找不到，可以重启master服务，并且配置上对应的/etc/hosts。


### 部署`CNI`插件

#### Calico

```bash
$ kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
$ kubectl set env daemonset/calico-node -n kube-system CALICO_IPV4POOL_CIDR="10.244.0.0/16"
```

### 安装`Helm`

```bash
# ./macos helm 192.168.64.11 ubuntu --binaries-url=https://get.helm.sh/helm-v3.8.0-linux-arm64.tar.gz
$ ./macos helm 192.168.64.11 ubuntu --binaries-url=http://192.168.1.6:8888/binaries/helm/helm-v3.8.0-linux-arm64.tar.gz
```

### 部署`CoreDNS`

```bash
$ helm repo add coredns https://coredns.github.io/helm
$ helm repo update
$ helm search repo coredns

$ helm -n kube-system install coredns coredns/coredns --set service.clusterIP=10.96.0.2
```

### 测试集群工作
```bash
$ kubectl run cirros-$RANDOM --rm -it --image=cirros -- sh
```

```bash
$ curl -i -k https://kubernetes
$ curl -i -k https://www.bing.com
```

## 新增`master`节点为`worker`节点

```bash
$ ./macos docker 192.168.64.13 ubuntu
$ ./macos docker 192.168.64.12 ubuntu

$ ./macos worker 192.168.64.13 ubuntu --hostname=k8s-master03 --master-addr=192.168.64.100:8443 --dns-ip=10.96.0.2 --kube-proxy-mode=ipvs --binaries-url=http://192.168.1.6:8888/binaries/kubernetes/kubernetes-server-v1.23.3-linux-arm64.tar.gz
$ ./macos worker 192.168.64.12 ubuntu --hostname=k8s-master02 --master-addr=192.168.64.100:8443 --dns-ip=10.96.0.2 --kube-proxy-mode=ipvs --binaries-url=http://192.168.1.6:8888/binaries/kubernetes/kubernetes-server-v1.23.3-linux-arm64.tar.gz
```

```bash
$ kubectl get csr | grep Pending | awk '{print $1}' | xargs kubectl certificate approve
$ kubectl get nodes
```