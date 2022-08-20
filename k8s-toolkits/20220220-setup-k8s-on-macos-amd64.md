# `macOS`本地部署`k8s`集群

## 环境说明

| 组件                     | 版本                  | 用途                        | 安装位置                                         |
| ----------------------- | --------------------- | -------------------------- | ----------------------------------------------- |
| macOS                   | macOS Monterey 12.1 | 宿主机操作系统                | -                                               |
| Homebrew                | 3.3.15                | 包管理工具                   | macOS                                           |
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

准备`cloud-init`文件

```bash
# 生成证书，方便免密登录
$ ssh-keygen -t ed25519 -C "zizhizhan@gmail.com"
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

安装虚拟机

```bash
$ multipass launch --name=k8s-node01 --cpus=2 --mem=2G --disk=32G --cloud-init=/opt/etc/cloud-init/multipass.yml focal
$ multipass launch --name=k8s-node02 --cpus=2 --mem=2G --disk=32G --cloud-init=/opt/etc/cloud-init/multipass.yml focal
$ multipass launch --name=k8s-node03 --cpus=2 --mem=2G --disk=32G --cloud-init=/opt/etc/cloud-init/multipass.yml focal

$ multipass list

$ ssh ubuntu@`multipass list | grep k8s-node01 | awk '{print $3}'`
$ ssh ubuntu@`multipass list | grep k8s-node02 | awk '{print $3}'`
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
$ ./macos setup 192.168.64.5 ubuntu
$ ./macos setup 192.168.64.6 ubuntu
$ ./macos setup 192.168.64.7 ubuntu
```

### 安装[etcd](https://github.com/etcd-io/etcd/releases)集群

#### 执行安装脚本

```bash
$ ./macos etcd 192.168.64.5 ubuntu --name=etcd01 --clusterips=192.168.64.5,192.168.64.6,192.168.64.7 --binaries-url=https://github.com/etcd-io/etcd/releases/download/v3.5.2/etcd-v3.5.2-linux-amd64.tar.gz
$ multipass exec k8s-node01 /usr/local/bin/etcdctl version

$ ./macos etcd 192.168.64.6 ubuntu --name=etcd02 --clusterips=192.168.64.5,192.168.64.6,192.168.64.7 --binaries-url=https://github.com/etcd-io/etcd/releases/download/v3.5.2/etcd-v3.5.2-linux-amd64.tar.gz
$ multipass exec k8s-node02 /usr/local/bin/etcdctl version

$ ./macos etcd 192.168.64.7 ubuntu --name=etcd03 --clusterips=192.168.64.5,192.168.64.6,192.168.64.7 --binaries-url=https://github.com/etcd-io/etcd/releases/download/v3.5.2/etcd-v3.5.2-linux-amd64.tar.gz
$ multipass exec k8s-node03 /usr/local/bin/etcdctl version
```

#### 测试`etcd`集群

```bash
$ ETCDCTL_API=3 etcdctl --write-out=table \
  --cacert=/opt/etc/cfssl/etcd/ca.pem \
  --cert=/opt/etc/cfssl/etcd/etcd.pem \
  --key=/opt/etc/cfssl/etcd/etcd-key.pem \
  --endpoints=https://192.168.64.5:2379,https://192.168.64.6:2379,https://192.168.64.7:2379 endpoint health

$ ETCDCTL_API=3 etcdctl --write-out=table \
  --cacert=/opt/etc/cfssl/etcd/ca.pem \
  --cert=/opt/etc/cfssl/etcd/etcd.pem \
  --key=/opt/etc/cfssl/etcd/etcd-key.pem \
  --endpoints=https://192.168.64.5:2379,https://192.168.64.6:2379,https://192.168.64.7:2379 endpoint status

$ ETCDCTL_API=3 etcdctl --write-out=table \
  --cacert=/opt/etc/cfssl/etcd/ca.pem \
  --cert=/opt/etc/cfssl/etcd/etcd.pem \
  --key=/opt/etc/cfssl/etcd/etcd-key.pem \
  --endpoints=https://192.168.64.5:2379,https://192.168.64.6:2379,https://192.168.64.7:2379 member list

$ ETCDCTL_API=3 etcdctl --write-out=json \
  --cacert=/opt/etc/cfssl/etcd/ca.pem \
  --cert=/opt/etc/cfssl/etcd/etcd.pem \
  --key=/opt/etc/cfssl/etcd/etcd-key.pem \
  --endpoints=https://192.168.64.5:2379,https://192.168.64.6:2379,https://192.168.64.7:2379 get '' --prefix | jq .

$ curl -i --cacert /opt/etc/cfssl/etcd/ca.pem --cert /opt/etc/cfssl/etcd/etcd.pem --key /opt/etc/cfssl/etcd/etcd-key.pem https://192.168.64.5:2379/version
$ curl -i --cacert /opt/etc/cfssl/etcd/ca.pem --cert /opt/etc/cfssl/etcd/etcd.pem --key /opt/etc/cfssl/etcd/etcd-key.pem https://192.168.64.6:2379/health
```

### 安装`k8s-master`

#### 执行安装脚本

```bash
$ ./macos master 192.168.64.5 ubuntu --clusterips=192.168.64.5,192.168.64.6,192.168.64.7 --binaries-url=https://storage.googleapis.com/kubernetes-release/release/v1.23.4/kubernetes-server-linux-amd64.tar.gz
$ curl -i --cacert /opt/etc/cfssl/etcd/ca.pem --cert /opt/etc/cfssl/master/admin.pem --key /opt/etc/cfssl/master/admin-key.pem https://192.168.64.5:6443/version

$ ./macos master 192.168.64.6 ubuntu --clusterips=192.168.64.5,192.168.64.6,192.168.64.7 --binaries-url=https://storage.googleapis.com/kubernetes-release/release/v1.23.4/kubernetes-server-linux-amd64.tar.gz
$ curl -i --cacert /opt/etc/cfssl/etcd/ca.pem --cert /opt/etc/cfssl/master/admin.pem --key /opt/etc/cfssl/master/admin-key.pem https://192.168.64.6:6443/version

$ ./macos master 192.168.64.7 ubuntu --clusterips=192.168.64.5,192.168.64.6,192.168.64.7 --binaries-url=https://storage.googleapis.com/kubernetes-release/release/v1.23.4/kubernetes-server-linux-amd64.tar.gz
$ curl -i --cacert /opt/etc/cfssl/etcd/ca.pem --cert /opt/etc/cfssl/master/admin.pem --key /opt/etc/cfssl/master/admin-key.pem https://192.168.64.7:6443/version
```

#### 配置`HA`

```bash
$ ./macos ha 192.168.64.5 ubuntu --virtual-ip=192.168.64.100 --keepalived-state=MASTER --keepalived-priority=200 --link-interface=enp0s2 --clusterips=192.168.64.5,192.168.64.6,192.168.64.7 --clusternames=k8s-node01,k8s-node02,k8s-node03
$ curl -i http://192.168.64.5:33305/monitor
$ curl -i --cacert /opt/etc/cfssl/etcd/ca.pem --cert /opt/etc/cfssl/master/admin.pem --key /opt/etc/cfssl/master/admin-key.pem https://192.168.64.5:8443/version

$ ./macos ha 192.168.64.6 ubuntu --virtual-ip=192.168.64.100 --keepalived-state=BACKUP --keepalived-priority=150 --link-interface=enp0s2 --clusterips=192.168.64.5,192.168.64.6,192.168.64.7 --clusternames=k8s-node01,k8s-node02,k8s-node03
$ curl -i http://192.168.64.6:33305/monitor
$ curl -i --cacert /opt/etc/cfssl/etcd/ca.pem --cert /opt/etc/cfssl/master/admin.pem --key /opt/etc/cfssl/master/admin-key.pem https://192.168.64.6:8443/version

$ ./macos ha 192.168.64.7 ubuntu --virtual-ip=192.168.64.100 --keepalived-state=BACKUP --keepalived-priority=100 --link-interface=enp0s2 --clusterips=192.168.64.5,192.168.64.6,192.168.64.7 --clusternames=k8s-node01,k8s-node02,k8s-node03
$ curl -i http://192.168.64.7:33305/monitor
$ curl -i --cacert /opt/etc/cfssl/etcd/ca.pem --cert /opt/etc/cfssl/master/admin.pem --key /opt/etc/cfssl/master/admin-key.pem https://192.168.64.7:8443/version

$ curl -i --cacert /opt/etc/cfssl/etcd/ca.pem --cert /opt/etc/cfssl/master/admin.pem --key /opt/etc/cfssl/master/admin-key.pem https://192.168.64.100:8443/version
```

### 管理集群

#### 安装`kubectl`

```bash
# Intel
$ curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/amd64/kubectl"

$ chmod +x kubectl

$ mkdir ~/.kube
$ multipass transfer k8s-node01:/home/ubuntu/.kube/config ~/.kube

$ kubectl version
Client Version: version.Info{Major:"1", Minor:"23", GitVersion:"v1.23.4", GitCommit:"e6c093d87ea4cbb530a7b2ae91e54c0842d8308a", GitTreeState:"clean", BuildDate:"2022-02-16T12:38:05Z", GoVersion:"go1.17.7", Compiler:"gc", Platform:"darwin/amd64"}
Server Version: version.Info{Major:"1", Minor:"23", GitVersion:"v1.23.4", GitCommit:"e6c093d87ea4cbb530a7b2ae91e54c0842d8308a", GitTreeState:"clean", BuildDate:"2022-02-16T12:32:02Z", GoVersion:"go1.17.7", Compiler:"gc", Platform:"linux/amd64"}
```

#### 安装`Helm`

```bash
$ brew install helm
$ helm version
version.BuildInfo{Version:"v3.8.0", GitCommit:"d14138609b01886f544b2025f5000351c9eb092e", GitTreeState:"clean", GoVersion:"go1.17.6"}
```

#### `k8s`集群管理

配置角色绑定，方便`worker`节点自动加入

```bash
$ kubectl create clusterrolebinding kubelet-bootstrap --clusterrole=system:node-bootstrapper --user=kubelet-bootstrap
$ kubectl create clusterrolebinding kubernetes-admin --clusterrole=cluster-admin --user=kubernetes
```

部署`CNI`插件`Calico`

```bash
$ kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
$ kubectl set env daemonset/calico-node -n kube-system CALICO_IPV4POOL_CIDR="10.244.0.0/16"
```

部署`CoreDNS`

```bash
$ helm repo add coredns https://coredns.github.io/helm
$ helm repo update
$ helm search repo coredns

$ helm -n kube-system install coredns coredns/coredns --set service.clusterIP=10.96.0.2
```

### 安装`k8s-worker`

#### 安装`docker`

```bash
$ ./macos docker 192.168.64.5 ubuntu
$ ./macos docker 192.168.64.6 ubuntu
$ ./macos docker 192.168.64.7 ubuntu
```

#### 安装`kubelet`和`kube-proxy`

```bash
$ ./macos worker 192.168.64.5 ubuntu --hostname=k8s-node01 --master-addr=192.168.64.100:8443 --dns-ip=10.96.0.2 --kube-proxy-mode=ipvs --binaries-url=https://storage.googleapis.com/kubernetes-release/release/v1.23.4/kubernetes-server-linux-amd64.tar.gz
$ ./macos worker 192.168.64.6 ubuntu --hostname=k8s-node02 --master-addr=192.168.64.100:8443 --dns-ip=10.96.0.2 --kube-proxy-mode=ipvs --binaries-url=https://storage.googleapis.com/kubernetes-release/release/v1.23.4/kubernetes-server-linux-amd64.tar.gz
$ ./macos worker 192.168.64.7 ubuntu --hostname=k8s-node03 --master-addr=192.168.64.100:8443 --dns-ip=10.96.0.2 --kube-proxy-mode=ipvs --binaries-url=https://storage.googleapis.com/kubernetes-release/release/v1.23.4/kubernetes-server-linux-amd64.tar.gz
```

#### 接受新加入节点申请

```bash
$ kubectl get csr | grep Pending | awk '{print $1}' | xargs kubectl certificate approve
$ kubectl get nodes
```

## 测试集群工作

```bash
$ kubectl get all -o wide
$ kubectl get nodes -o wide

$ kubectl run cirros-$RANDOM --rm -it --image=cirros -- sh
```

```bash
$ curl -i -k https://kubernetes
$ curl -i -k https://www.bing.com
```