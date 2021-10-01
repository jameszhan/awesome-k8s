## 准备工作

### 创建新用户`deploy`

```bash
$ cd install-binaries/ansible

$ ansible-playbook -i hosts -c paramiko --ask-pass --ask-become-pass user-deploy.yml -v

# 测试新增用户效果
$ ansible -i hosts all -m ping -u deploy
```

### 通用设置

```bash
$ cd install-binaries/ansible

$ ansible-playbook -i hosts setup-once.yml -u deploy -v

# 重启服务
$ ansible -i hosts all -m reboot -u deploy --become -v
```

## 二进制安装高可用 K8S 集群

### 准备工作

进入安装脚本目录

```bash
$ cd install-binaries/ansible
```

| role       | ip            | hostname          | port                         | 机器配置   | 主要软件                                              |
| ---------- | ------------- | ----------------- | ---------------------------- | ---------- | ----------------------------------------------------- |
| etcd       | 192.168.1.61  | k8s-master01      | 2379,2380                    | 2C/4G/32G  | etcd                                                  |
| etcd       | 192.168.1.62  | k8s-master02      | 2379,2380                    | 2C/4G/32G  | etcd                                                  |
| etcd       | 192.168.1.63  | k8s-master03      | 2379,2380                    | 2C/4G/32G  | etcd                                                  |
| k8s-master | 192.168.1.61  | k8s-master01      | 6443,10251,10252,10257,10259 | 2C/4G/32G  | kube-apiserver,kube-controller-manager,kube-scheduler |
| k8s-master | 192.168.1.62  | k8s-master02      | 6443,10251,10252,10257,10259 | 2C/4G/32G  | kube-apiserver,kube-controller-manager,kube-scheduler |
| k8s-master | 192.168.1.63  | k8s-master03      | 6443,10251,10252,10257,10259 | 2C/4G/32G  | kube-apiserver,kube-controller-manager,kube-scheduler |
| HA         | 192.168.1.61  | k8s-master01      | 8443,33305                   | 2C/4G/32G  | haproxy,keepalived           |
| HA         | 192.168.1.62  | k8s-master02      | 8443,33305                   | 2C/4G/32G  | haproxy,keepalived           |
| HA         | 192.168.1.63  | k8s-master03      | 8443,33305                   | 2C/4G/32G  | haproxy,keepalived           |
| VIP        | 192.168.1.200 | k8s-master[01-03] | 8443                         |            | keepalived                   |
| k8s-worker | 192.168.1.111 | k8s-node001       | 10248,10249,10250,10256      | 4C/8G/64G  | docker,kubelet,kube-proxy    |
| k8s-worker | 192.168.1.112 | k8s-node002       | 10248,10249,10250,10256      | 4C/8G/64G  | docker,kubelet,kube-proxy    |
| k8s-worker | 192.168.1.113 | k8s-node003       | 10248,10249,10250,10256      | 4C/16G/64G | docker,kubelet,kube-proxy    |
| k8s-worker | 192.168.1.101 | k8s-node021       | 10248,10249,10250,10256      | 2C/4G/128G | docker,kubelet,kube-proxy    |
| k8s-worker | 192.168.1.102 | k8s-node022       | 10248,10249,10250,10256      | 2C/4G/128G | docker,kubelet,kube-proxy    |
| NAS/iSCSI  | 192.168.1.6   | synology-dsm      | 111,892,2049,3260            | 2C/8G/16T  | dsm 7.0    |

### 安装系统服务

#### 安装 `etcd` 集群

```bash
$ ansible-playbook -i hosts etcd.yml -u deploy -v
```

测试服务 `ssh deploy@k8s-master01`

```bash
# 测试etcd
$ ETCDCTL_API=3 /usr/local/bin/etcdctl --write-out=table --endpoints=http://127.0.0.1:2379 endpoint health
$ ETCDCTL_API=3 /usr/local/bin/etcdctl --write-out=table --cacert=/etc/etcd/ssl/ca.pem --cert=/etc/etcd/ssl/etcd.pem --key=/etc/etcd/ssl/etcd-key.pem --endpoints=https://192.168.1.61:2379,https://192.168.1.62:2379,https://192.168.1.63:2379 endpoint health
```

#### 安装 `k8s-master` 集群

```bash
$ ansible-playbook -i hosts k8s-master.yml -u deploy -v
$ ansible-playbook -i hosts k8s-ha.yml -u deploy -v
```

测试服务 `ssh deploy@k8s-master01`

```bash
# 测试k8s-master
$ curl --insecure https://192.168.1.61:6443/
$ curl --insecure https://192.168.1.62:6443/
$ curl --insecure https://192.168.1.63:6443/

$ curl -i --cacert /etc/kubernetes/ssl/ca.pem --cert /etc/kubernetes/ssl/admin.pem --key /etc/kubernetes/ssl/admin-key.pem https://192.168.1.61:6443
$ curl -i --cacert /etc/kubernetes/ssl/ca.pem --cert /etc/kubernetes/ssl/admin.pem --key /etc/kubernetes/ssl/admin-key.pem https://192.168.1.62:6443/version

# 测试高可用集群
$ curl --insecure https://192.168.1.200:8443/
$ curl -i --cacert /etc/kubernetes/ssl/ca.pem --cert /etc/kubernetes/ssl/admin.pem --key /etc/kubernetes/ssl/admin-key.pem https://192.168.1.200:8443/version

$ kubectl cluster-info
$ kubectl get componentstatuses
$ kubectl get all --all-namespaces
```

#### 安装 `k8s-worker` 集群

>  确认`kubelet`服务启动成功后，需要到`master`节点上`Approve`一下`bootstrap`请求

```bash
# 二进制安装docker
$ ansible-playbook -i hosts docker.yml -u deploy -v

# 或者Debian系也可以使用apt安装
cd ../../debian-based/ansible && ansible-playbook -i hosts docker.yml -u deploy -v && cd ../../install-binaries/ansible

# 安装kube-proxy,kubelet
$ ansible-playbook -i hosts k8s-node.yml -u deploy -v
```

测试服务 `ssh deploy@k8s-master01`

```bash
# 接受新加入节点申请
$ kubectl get csr | grep Pending | awk '{print $1}' | xargs kubectl certificate approve

$ kubectl get nodes

# 测试集群工作
$ kubectl run cirros-$RANDOM --rm -it --image=cirros -- sh
```