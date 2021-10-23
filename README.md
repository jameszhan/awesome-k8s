## 准备工作

### 本地开发环境设置

详细参考: `appendix/setup-dev-env.md`。

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

## 二进制安装高可用`k8s`集群

### 准备工作

![k8s ha cluster](https://gallery.zizhizhan.com:8443/images/k8s/kubeadm-ha-topology-external-etcd.svg)

进入安装脚本目录

```bash
$ cd install-binaries/ansible
```

#### 软件版本

| 操作系统                                               | 版本                       | 用途                     |
| ----------------------------------------------------- | ------------------------- | ------------------------ |
| Debian                                                | 11 (bullseye)             | etcd集群和k8s master集群 |
| Ubuntu Server                                         | 20.04.3 LTS (Focal Fossa) | k8s worker节点           |
| kube-apiserver<br />kube-controller-manager<br />kube-scheduler | v1.21.4         | k8s master 服务          |
| kubelet<br />kube-proxy                               | v1.21.4                   | k8s worker 服务          |
| kubectl                                               | v1.21.4/v1.22.2           | k8s 客户端               |
| etcd                                                  | 3.5.0                     | 集群协调监控及数据服务      |
| haproxy                                               | 2.2.9-2+deb11u2           | 负载均衡服务               |
| keepalived                                            | v2.1.5                    | 高可用服务                |
| docker                                                | 20.10.9                   | CRI服务                  |
| calico                                                | v3.20.1                   | CNI vRouter服务          |
| coredns                                               | v1.8.0                    | 集群DNS服务               |
| metrics-server                                        | v0.5.1                    | 集群容器监控服务           |
| kubernetes-dashboard                                  | v2.3.1                    | 集群Web UI               |

#### 配置清单

| role       | ip            | hostname          | port                         | 机器配置   | 主要软件                                              |
| ---------- | ------------- | ----------------- | ---------------------------- | ---------- | ----------------------------------------------------- |
| etcd       | 192.168.1.61  | k8s-master01      | 2379,2380                    | 2C/4G/32G  | etcd                                                  |
| etcd       | 192.168.1.62  | k8s-master02      | 2379,2380                    | 2C/4G/32G  | etcd                                                  |
| etcd       | 192.168.1.63  | k8s-master03      | 2379,2380                    | 2C/4G/32G  | etcd                                                  |
| k8s-master | 192.168.1.61  | k8s-master01      | 6443,10251,10252,10257,10259 | 2C/4G/32G  | kube-apiserver,kube-controller-manager,kube-scheduler |
| k8s-master | 192.168.1.62  | k8s-master02      | 6443,10251,10252,10257,10259 | 2C/4G/32G  | kube-apiserver,kube-controller-manager,kube-scheduler |
| k8s-master | 192.168.1.63  | k8s-master03      | 6443,10251,10252,10257,10259 | 2C/4G/32G  | kube-apiserver,kube-controller-manager,kube-scheduler |
| HA         | 192.168.1.61  | k8s-master01      | 8443,33305                   | 2C/4G/32G  | haproxy,keepalived                                    |
| HA         | 192.168.1.62  | k8s-master02      | 8443,33305                   | 2C/4G/32G  | haproxy,keepalived                                    |
| HA         | 192.168.1.63  | k8s-master03      | 8443,33305                   | 2C/4G/32G  | haproxy,keepalived                                    |
| VIP        | 192.168.1.100 | k8s-master[01-03] | 8443                         |            | keepalived                                            |
| k8s-worker | 192.168.1.101 | k8s-node021       | 10248,10249,10250,10256      | 2C/4G/128G | docker,kubelet,kube-proxy                             |
| k8s-worker | 192.168.1.102 | k8s-node022       | 10248,10249,10250,10256      | 2C/4G/128G | docker,kubelet,kube-proxy                             |
| k8s-worker | 192.168.1.111 | k8s-node001       | 10248,10249,10250,10256      | 4C/8G/64G  | docker,kubelet,kube-proxy                             |
| k8s-worker | 192.168.1.112 | k8s-node002       | 10248,10249,10250,10256      | 4C/8G/64G  | docker,kubelet,kube-proxy                             |
| k8s-worker | 192.168.1.113 | k8s-node003       | 10248,10249,10250,10256      | 4C/16G/64G | docker,kubelet,kube-proxy                             |
| NAS/iSCSI  | 192.168.1.6   | synology-dsm      | 111,892,2049,3260            | 2C/8G/16T  | dsm 7.0                                               |

#### 子网划分

| 网段信息                | 配置             |
| --------------------- | ---------------- |
| Host Network Range    | 192.168.1.1/24   |
| Pod Network Range     | 10.244.0.0/16    |
| Service Network Range | 192.168.1.128/25 |
| API SERVER VIP        | 192.168.1.100/32 |
| API SERVER IP         | 192.168.1.129/32 |
| DNS IP                | 192.168.1.130/32 |

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

$ ETCDCTL_API=3 /usr/local/bin/etcdctl --write-out=table \
    --endpoints=https://192.168.1.61:2379,https://192.168.1.62:2379,https://192.168.1.63:2379 \
    --cacert=/etc/etcd/ssl/ca.pem \
    --cert=/etc/etcd/ssl/etcd.pem \
    --key=/etc/etcd/ssl/etcd-key.pem \
    endpoint status
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
$ curl --insecure https://192.168.1.100:8443/
$ curl -i --cacert /etc/kubernetes/ssl/ca.pem --cert /etc/kubernetes/ssl/admin.pem --key /etc/kubernetes/ssl/admin-key.pem https://192.168.1.100:8443/version
$ curl -i --cacert /etc/kubernetes/ssl/ca.pem --cert /etc/kubernetes/ssl/admin.pem --key /etc/kubernetes/ssl/admin-key.pem https://192.168.1.100:8443/healthz
$ curl -i --cacert /etc/kubernetes/ssl/ca.pem --cert /etc/kubernetes/ssl/admin.pem --key /etc/kubernetes/ssl/admin-key.pem https://192.168.1.100:8443/livez
$ curl -i --cacert /etc/kubernetes/ssl/ca.pem --cert /etc/kubernetes/ssl/admin.pem --key /etc/kubernetes/ssl/admin-key.pem https://192.168.1.100:8443/readyz

$ kubectl cluster-info
$ kubectl get componentstatuses
$ kubectl get all --all-namespaces
$ kubectl get ep --all-namespaces
$ kubectl describe svc kubernetes

$ nc -vz 192.168.1.100 8443
```

#### 安装 `k8s-worker` 集群

> 确认`kubelet`服务启动成功后，需要到`master`节点上`Approve`一下`bootstrap`请求

```bash
# 二进制安装docker
$ ansible-playbook -i hosts docker.yml -u deploy -v

# 或者Debian系也可以使用apt安装
$ cd ../../debian-based/ansible && ansible-playbook -i hosts docker.yml -u deploy -v && cd ../../install-binaries/ansible

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

### 安装`Addons`

详情参考: [Install Addons](addons/)

#### 部署`CNI`插件

> 选择一种安装即可

##### Calico

```bash
$ kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
```

##### Flannel

```bash
$ kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

#### 安装其他组件(可选)

##### CoreDNS

```bash
$ helm repo add coredns https://coredns.github.io/helm
$ helm -n kube-system install coredns coredns/coredns
```

##### Metrics Server

```bash
$ kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml 
```

##### CSI NFS driver

```bash
$ git clone https://github.com/kubernetes-csi/csi-driver-nfs.git
$ cd csi-driver-nfs/deploy

$ kubectl apply -f rbac-csi-nfs-controller.yaml
$ kubectl apply -f csi-nfs-driverinfo.yaml
$ kubectl apply -f csi-nfs-controller.yaml
$ kubectl apply -f csi-nfs-node.yaml
```

##### NFS Subdirectory External Provisioner

```bash
$ helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
$ helm install -n kube-system nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner
```

##### Kubernetes Dashboard

```bash
$ kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.3.1/aio/deploy/recommended.yaml
```

##### Ingress Nginx

```bash
$ helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
$ helm template -n ingress-nginx --debug ingress-nginx ingress-nginx/ingress-nginx
```

```bash
# 部署Calico，按需调整calico.yaml配置
$ curl https://docs.projectcalico.org/manifests/calico.yaml -o calico.yaml
$ kubectl apply -f calico.yaml

# 部署CoreDNS
$ ansible-playbook -i hosts deploy-coredns.yml -u deploy -v

# 部署Metrics Server
$ ansible-playbook -i hosts deploy-metrics-server.yml -u deploy -v
```

测试服务 `ssh deploy@k8s-master01`

```bash
$ cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  selector:
    matchLabels:
      app: nginx
  replicas: 2
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.21
        ports:
        - containerPort: 80

--- 
apiVersion: v1 
kind: Service
metadata:
  name: nginx-service
spec:
  ports:
  - port: 80
    targetPort: 80
    protocol: TCP
  selector:
    app: nginx
EOF

$ curl -i -v http://nginx-service

$ kubectl delete deployment nginx-deployment
$ kubectl delete service nginx-service
```

测试访问集群内服务

```bash
$ kubectl proxy --port=8080 &
$ curl -i http://localhost:8080/api/

$ TOKEN=$(kubectl describe secret $(kubectl get secrets | grep default | cut -f1 -d ' ') | grep -E '^token' | cut -f2 -d':' | tr -d ' ')
$ curl -k -v https://192.168.1.100:8443/api/ --header "Authorization: Bearer $TOKEN"
```

#### 添加新`worker`节点

在 `hosts` 中增加如下记录:

```ini
[k8s_new_nodes]
k8s-node006 ansible_host=192.168.1.116 node_host=192.168.1.116 role=worker
k8s-node007 ansible_host=192.168.1.117 node_host=192.168.1.117 role=worker
```

执行`playbook`脚本，详情可以参考[add-worker-to-cluster](appendix/kubernetes/add-worker-to-cluster.md).

```bash
# 添加deploy用户
$ ansible-playbook -i hosts -l k8s_new_nodes -c paramiko --ask-pass --ask-become-pass user-deploy.yml -v

# 初始化必要配置
$ ansible-playbook -i hosts -l k8s_new_nodes setup-once.yml -u deploy -v

# 安装docker
$ ansible-playbook -i hosts -l k8s_new_nodes docker.yml -u deploy -v

# 安装kubelet和kube-proxy
$ ansible-playbook -i hosts -l k8s_new_nodes k8s-node.yml -u deploy -v

# 重启节点服务器
$ ansible -i hosts k8s_new_nodes -m reboot -u deploy --become -v
```