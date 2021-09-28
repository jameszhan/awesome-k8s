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

## 二进制安装高可用K8S集群

```bash
$ cd install-binaries/ansible

$ ansible-playbook -i hosts etcd.yml -u deploy -v

$ ansible-playbook -i hosts k8s-master.yml -u deploy -v
$ ansible-playbook -i hosts k8s-ha.yml -u deploy -v

>  确认`kubelet`服务启动成功后，需要到`master`节点上`Approve`一下`bootstrap`请求。
$ ansible-playbook -i hosts k8s-node.yml -u deploy -v
```

测试服务`ssh deploy@k8s-master01`

```bash
# 测试etcd
$ ETCDCTL_API=3 /usr/local/bin/etcdctl --write-out=table --endpoints=http://127.0.0.1:2379 endpoint health
$ ETCDCTL_API=3 /usr/local/bin/etcdctl --write-out=table --cacert=/etc/etcd/ssl/ca.pem --cert=/etc/etcd/ssl/etcd.pem --key=/etc/etcd/ssl/etcd-key.pem --endpoints=https://192.168.1.61:2379,https://192.168.1.62:2379,https://192.168.1.63:2379 endpoint health

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

# 接受新加入节点申请
$ kubectl get csr | grep Pending | awk '{print $1}' | xargs kubectl certificate approv

$ kubectl get nodes

# 测试集群工作
￥ 
```