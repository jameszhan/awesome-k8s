# 通过`kubeadm`构建测试`k8s`集群

## TL;DR

```bash
# 新增deploy用户
$ ansible-playbook -i k8s-local.cfg -c paramiko --ask-pass --ask-become-pass create-user.yml -v
# 快速部署本地集群
$ ansible-playbook -i k8s-local.cfg k8s-local.yml -u deploy -v
```

本例中`k8s-local.cfg`主要配置内容如下:

```ini
[k8s_masters]
k8s-node001 ansible_host=192.168.1.111 role=master

[k8s_nodes]
k8s-node001 ansible_host=192.168.1.111 role=master
k8s-node002 ansible_host=192.168.1.112 role=worker
k8s-node003 ansible_host=192.168.1.113 role=worker
```

## 环境说明

- 服务端操作系统: Ubuntu Server 20.04
- 服务端`k8s`版本: v1.22.2

## 准备工作

### 服务器说明

| HOST-NAME   | ROLES                | VERSION | INTERNAL-IP   | OS-IMAGE           | 
| ----------- | -------------------- | ------- | ------------- | ------------------ | 
| k8s-node001 | control-plane,master | v1.22.2 | 192.168.1.111 | Ubuntu 20.04.3 LTS | 
| k8s-node002 | worker               | v1.22.2 | 192.168.1.112 | Ubuntu 20.04.3 LTS | 
| k8s-node003 | worker               | v1.22.2 | 192.168.1.113 | Ubuntu 20.04.3 LTS | 

### 新增用户`deploy`

#### 创建新用户`deploy`

```bash
$ sudo userdel -r deploy
$ # sudo adduser --home /home/deploy --ingroup users --uid 1001 --shell /bin/bash deploy
$ sudo useradd -m -s /bin/bash -u 1001 deploy

$ sudo usermod -aG sudo deploy
$ sudo usermod -aG adm deploy
$ sudo usermod -a -G users deploy
```

#### 配置`sudo`免密

```bash
$ echo 'deploy ALL = (ALL) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/deploy > /dev/null
```

#### 配置登陆免密

把本地的公私钥复制到`/home/deploy/.ssh`目录下，并把公钥`id_rsa.pub`内容复制到`/home/deploy/.ssh/authorized_keys`，也可以使用`ssh-copy-id`来同步。

> 如果本地没有密钥对，可以使用命令`ssh-keygen -t rsa -C "YOUR-EMAIL@gmail.com"`生成。

```bash
$ ssh-copy-id -i ~/.ssh/id_rsa.pub deploy@K8S-NODE-IP
```
> 这种方式需要提前为`deploy`设置密码。

#### 同步本地公私钥到服务器机器(可选)

> 之所以要把本地公私钥同步到服务器，是方便服务器之间相互时间免密登陆，并且可以免于配置GitHub等外部服务的权限。

```bash
$ scp ~/.ssh/id_rsa deploy@K8S-NODE-IP:/home/deploy/.ssh/
$ scp ~/.ssh/id_rsa.pub deploy@K8S-NODE-IP:/home/deploy/.ssh/
```

登陆服务器，调整私钥文件权限

```bash
$ chmod go-rwx ~/.ssh/id_rsa
```

### 安装前的必要设置

`ssh deploy@8S-NODE-IP`进入目标机器

#### 安装必要软件

```bash
$ sudo apt -y update
$ sudo apt -y install coreutils procps libseccomp2 net-tools sysstat rsync bash-completion socat

# 启用 kubectl 自动补全功能
$ echo 'source <(kubectl completion zsh)' >> ~/.bashrc
```

#### 禁用虚拟内存

```bash
$ sudo swapoff -a

# 永久禁用虚拟内存
$ sudo sed -i -r "/(.*)swap(.*)swap(.*)/d" /etc/fstab
$ sysctl -w vm.swappiness=0
```

## 安装`Kubernetes`集群

### 安装`Docker`

详情参考: [Install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/)

```bash
# 安装前准备
$ sudo apt remove docker docker-engine docker.io containerd runc
$ sudo apt -y update
$ sudo apt -y install apt-transport-https ca-certificates curl gnupg lsb-release

# 配置docker apt源
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
$ echo \
     "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] http://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu \
     $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 安装docker
$ sudo apt -y update
$ sudo apt -y install docker-ce docker-ce-cli containerd.io

# 配置用户免sudo使用docker命令
$ sudo usermod -aG docker deploy

# 配置/etc/docker/daemon.json
$ cat <<EOF | sudo tee /etc/docker/daemon.json > /dev/null
{
  "data-root": "/var/lib/docker",
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "200m",
    "max-file": "5"
  },
  "default-ulimits": {
    "nofile": {
      "Name": "nofile",
      "Hard": 655360,
      "Soft": 655360
    },
    "nproc": {
      "Name": "nproc",
      "Hard": 655360,
      "Soft": 655360
    }
  },
  "live-restore": true,
  "oom-score-adjust": -1000,
  "max-concurrent-downloads": 10,
  "max-concurrent-uploads": 10,
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ],
  "exec-opts": [
    "native.cgroupdriver=systemd"
  ]
}
EOF

# 重启docker服务
$ sudo systemctl daemon-reload
$ sudo systemctl restart docker
```

### 安装`k8s`集群

详情参考: [Installing kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)

#### 安装`kubelet`,`kubeadm`和`kubectl`

```bash
# 安装前准备
$ sudo apt -y update
$ sudo apt -y install apt-transport-https ca-certificates curl

# 配置kubernetes apt源
$ sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg
$ echo \
     "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://mirrors.aliyun.com/kubernetes/apt/ \
     kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list > /dev/null

# 安装kubelet kubeadm, kubectl
$ sudo apt -y update
$ sudo apt -y install -y kubelet kubeadm kubectl
$ sudo apt hold kubelet kubeadm kubectl
```

#### 准备`GFW`无法访问镜像

```bash
$ sudo kubeadm config images list

$ docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-apiserver:v1.22.2
$ docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-controller-manager:v1.22.2
$ docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-scheduler:v1.22.2
$ docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy:v1.22.2
$ docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.5
$ docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/etcd:3.5.0-0
$ docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:v1.8.4

$ docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-apiserver:v1.22.2 k8s.gcr.io/kube-apiserver:v1.22.2
$ docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-controller-manager:v1.22.2 k8s.gcr.io/kube-controller-manager:v1.22.2
$ docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-scheduler:v1.22.2 k8s.gcr.io/kube-scheduler:v1.22.2
$ docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy:v1.22.2 k8s.gcr.io/kube-proxy:v1.22.2
$ docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.5 k8s.gcr.io/pause:3.5
$ docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/etcd:3.5.0-0 k8s.gcr.io/etcd:3.5.0-0
$ docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:v1.8.4 k8s.gcr.io/coredns/coredns:v1.8.4
```

#### 配置`control-plane`和`master`

```bash
$ sudo kubeadm reset --force

# sudo kubeadm init --apiserver-advertise-address 192.168.64.7 --pod-network-cidr 10.244.0.0/16 --kubernetes-version v1.15.0 --ignore-preflight-errors=all
$ sudo kubeadm init --pod-network-cidr 10.244.0.0/16

$ mkdir -p $HOME/.kube
$ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
$ sudo chown $(id -u):$(id -g) $HOME/.kube/config

$ kubectl get pod -n kube-system -o wide
```

#### 配置`worker`

在`master`节点上通过命令`kubeadm token create --print-join-command`获取加入指令，并在`worker`节点执行。如下例所示:

```bash
$ sudo kubeadm join 192.168.1.161:6443 --token 6fc0hl.3f5tp9d3i8gl3wsd \
     --discovery-token-ca-cert-hash sha256:e0ef78d79f73d2efe0e1d5706e49cef2129b684d4b07b008b43a55c58958dd86
```

加入完成后，可以通过命令`kubectl get nodes`检查node是否已经ready。

#### 安装`flannel`

```bash
$ kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
$ kubectl get pod -n kube-system -o wide
```

#### 安装`helm`

```bash
$ curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
$ sudo apt-get install apt-transport-https --yes
$ echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
$ sudo apt -y update
$ sudo apt -y install helm
```

### 加入节点到已有集群

从`master`节点复制`/etc/kubernetes/admin.conf`到`worker`节点`$HOME/.kube/config`，然后执行下述命令:

```bash
$ sudo kubeadm reset
$ kubeadm token create --print-join-command | sudo bash

$ kubectl get nodes
```

## 升级`k8s`

查看升级计划及变更的镜像

```bash
$ sudo kubeadm upgrade plan
$ sudo kubeadm upgrade apply v1.22.2
$ kubeadm config images list
```

升级`k8s`集群

在`group_vars/k8s_vars.yml`中指定好要升级的`target_version`，并且准备好相关的`docker`镜像.

```bash
$ ansible-playbook -i k8s-local.cfg k8s-upgrade.yml -u deploy -vv
```

```bash
$ sudo kubeadm upgrade node
```