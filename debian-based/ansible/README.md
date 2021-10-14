## TL;NR

```bash
# 新增用户
$ ansible-playbook -i k8s-local.cfg -c paramiko --ask-pass --ask-become-pass create-user.yml -v
# 快速部署本地集群
$ ansible-playbook -i k8s-local.cfg k8s-local.yml -u deploy -v
```

| HOST-NAME   | ROLES                | VERSION | INTERNAL-IP   | OS-IMAGE           | 
| ----------- | -------------------- | ------- | ------------- | ------------------ | 
| k8s-node001 | control-plane,master | v1.22.2 | 192.168.1.111 | Ubuntu 20.04.3 LTS | 
| k8s-node002 | worker               | v1.22.2 | 192.168.1.112 | Ubuntu 20.04.3 LTS | 
| k8s-node003 | worker               | v1.22.2 | 192.168.1.113 | Ubuntu 20.04.3 LTS | 

## 安装步骤分解

### Prerequisites

#### 新增`deploy`用户

```bash
$ ansible-playbook -i k8s-local.cfg -c paramiko --ask-pass --ask-become-pass create-user.yml -v
```

#### 安装必要软件

```bash
$ ansible-playbook -i k8s-local.cfg setup-once.yml -u deploy -v

# 重启服务
$ ansible -i k8s-local.cfg all -m reboot -u deploy --become -v
```

#### 时间同步检查

```bash
$ ansible -i k8s-local.cfg all -m shell -a 'chronyc sources -v' -u deploy -v
$ ansible -i k8s-local.cfg all -m shell -a 'chronyc sourcestats' -u deploy -v
```

### 清理历史安装记录

#### 清理`k8s`节点安装记录

参考[cleaner.md](cleaner.md)

### 执行安装

#### 安装`etcd`集群(可选)

```bash
$ ansible-playbook -i k8s-local.cfg -l etcd_servers etcd.yml -u deploy -v

$ ETCDCTL_API=3 etcdctl --endpoints=http://k8s-node001:2379 endpoint health
$ ETCDCTL_API=3 etcdctl --write-out=table --endpoints=http://192.168.1.111:2379,http://192.168.1.112:2379,http://192.168.1.113:2379 endpoint health
```

#### 安装`docker`

```bash
# 安装docker
$ ansible-playbook -i k8s-local.cfg -l k8s_nodes docker.yml -u deploy -v
$ ansible -i k8s-local.cfg all -m shell -a 'systemctl status docker' -u deploy -v
```

#### 利用`kubeadm`安装`k8s`集群

目标机器上安装以下的软件包：
- `kubeadm`: 用来初始化集群的指令。
- `kubelet`: 在集群中的每个节点上用来启动 Pod 和容器等。
- `kubectl`: 用来与集群通信的命令行工具。

> `kubeadm`不能帮你安装或者管理`kubelet`或`kubectl`，所以你需要确保它们与通过`kubeadm`安装的控制平面的版本相匹配。 如果不这样做，则存在发生版本偏差的风险，可能会导致一些预料之外的错误和问题。

```bash
$ ansible-playbook -i k8s-local.cfg k8s-init.yml -u deploy -vv

$ ansible -i k8s-local.cfg all -m shell -a 'docker images' -u deploy -v
```

`1.22.2`版本会用到如下镜像，正常国内无法下载，我们可以从`registry.cn-hangzhou.aliyuncs.com/google_containers`下载。

- `k8s.gcr.io/kube-apiserver:v1.22.2`
- `k8s.gcr.io/kube-controller-manager:v1.22.2`
- `k8s.gcr.io/kube-scheduler:v1.22.2`
- `k8s.gcr.io/kube-proxy:v1.22.2`
- `k8s.gcr.io/pause:3.5`
- `k8s.gcr.io/etcd:3.5.0-0`
- `k8s.gcr.io/coredns/coredns:v1.8.4`

进入`master`节点，执行下列命令:

```bash
$ mkdir -p $HOME/.kube
$ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
$ sudo chown $(id -u):$(id -g) $HOME/.kube/config

# 通过命令获取加入集群的token
$ kubeadm token create --print-join-command
```

记录下加入集群的令牌，如下例所示，在响应的`worker`节点上执行即可: 

```bash
$ sudo kubeadm join 192.168.1.111:6443 --token 0lnggp.9gsspi36onqd712y \
    --discovery-token-ca-cert-hash sha256:dcffb0f541a1ea21c8b7baf24fbfc20377b1ddb19af214f693358678f56bf221
```

检查集群节点

```bash
$ kubectl get nodes -o wide
NAME          STATUS   ROLES                  AGE   VERSION   INTERNAL-IP     EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION     CONTAINER-RUNTIME
k8s-node001   Ready    control-plane,master   20m   v1.22.2   192.168.1.111   <none>        Ubuntu 20.04.3 LTS   5.4.0-88-generic   docker://20.10.9
k8s-node002   Ready    <none>                 16m   v1.22.2   192.168.1.112   <none>        Ubuntu 20.04.3 LTS   5.4.0-88-generic   docker://20.10.9
k8s-node003   Ready    <none>                 16m   v1.22.2   192.168.1.113   <none>        Ubuntu 20.04.3 LTS   5.4.0-88-generic   docker://20.10.9

# 启用Flannel插件
$ kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

#### 升级`k8s`集群

在`group_vars/k8s_vars.yml`中指定好要升级的`target_version`，并且准备好相关的`docker`镜像.

```bash
$ ansible-playbook -i k8s-local.cfg k8s-upgrade.yml -u deploy -vv
```
