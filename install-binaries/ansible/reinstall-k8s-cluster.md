#### Remove k8s-master cluster

```bash
$ ansible -i hosts all -m shell -a "systemctl stop kube-scheduler" -u deploy --become -vvv
$ ansible -i hosts all -m shell -a "systemctl disable kube-scheduler" -u deploy --become -vvv
$ ansible -i hosts all -m shell -a "rm /usr/lib/systemd/system/kube-scheduler.service" -u deploy --become -vvv

$ ansible -i hosts all -m shell -a "systemctl stop kube-controller-manager" -u deploy --become -vvv
$ ansible -i hosts all -m shell -a "systemctl disable kube-controller-manager" -u deploy --become -vvv
$ ansible -i hosts all -m shell -a "rm /usr/lib/systemd/system/kube-controller-manager.service" -u deploy --become -vvv

$ ansible -i hosts all -m shell -a "systemctl stop kube-apiserver" -u deploy --become -vvv
$ ansible -i hosts all -m shell -a "systemctl disable kube-apiserver" -u deploy --become -vvv
$ ansible -i hosts all -m shell -a "rm /usr/lib/systemd/system/kube-apiserver.service" -u deploy --become -vvv

$ ansible -i hosts all -m shell -a "rm -fr /etc/kubernetes" -u deploy --become  -vvv
$ ansible -i hosts all -m shell -a "rm -fr /var/log/kubernetes" -u deploy -v --become
$ ansible -i hosts all -m shell -a "rm /tmp/kube-*" -u deploy --become -vvv
$ ansible -i hosts all -m shell -a "rm -fr /tmp/kubernetes" -u deploy -v --become
$ ansible -i hosts all -m shell -a "rm -fr /home/deploy/.kube" -u deploy -v --become
```

#### Remove etcd cluster

```bash
$ ansible -i hosts all -m shell -a "systemctl stop etcd" -u deploy --become -vvv
$ ansible -i hosts all -m shell -a "systemctl disable etcd" -u deploy --become -vvv
$ ansible -i hosts all -m shell -a "rm /usr/lib/systemd/system/etcd.service" -u deploy --become -vvv

$ ansible -i hosts all -m shell -a "rm -fr /etc/etcd" -u deploy --become  -vvv
$ ansible -i hosts all -m shell -a "rm -fr /var/lib/etcd" -u deploy -v --become
$ ansible -i hosts all -m shell -a "rm -fr /usr/local/bin/*" -u deploy -v --become
$ ansible -i hosts all -m shell -a "rm -fr /tmp/etcd*" -u deploy -v --become
```

#### 更新并重启

```bash
$ ansible -i hosts all -m shell -a "/opt/bin/update-system.sh" -u deploy -v --become
$ ansible -i hosts all -m shell -a "reboot" -u deploy -v --become
```

#### Install Ectd Cluster

```bash
$ ansible-playbook -i hosts etcd.yml -u deploy -v

$ ETCDCTL_API=3 etcdctl --write-out=table --cacert=/tmp/etcd/ssl/ca.pem --cert=/tmp/etcd/ssl/etcd.pem --key=/tmp/etcd/ssl/etcd-key.pem --endpoints=https://192.168.1.61:2379,https://192.168.1.62:2379,https://192.168.1.63:2379 endpoint health
```

```bash
$ netstat -tunlp
$ ss -antulp

$ ETCDCTL_API=3 /usr/local/bin/etcdctl --write-out=table --endpoints=http://127.0.0.1:2379 endpoint health
$ ETCDCTL_API=3 /usr/local/bin/etcdctl --write-out=table --cacert=/etc/etcd/ssl/ca.pem --cert=/etc/etcd/ssl/etcd.pem --key=/etc/etcd/ssl/etcd-key.pem --endpoints=http://127.0.0.1:2379 endpoint health
$ ETCDCTL_API=3 /usr/local/bin/etcdctl --write-out=table --cacert=/etc/etcd/ssl/ca.pem --cert=/etc/etcd/ssl/etcd.pem --key=/etc/etcd/ssl/etcd-key.pem --endpoints=https://192.168.1.61:2379,https://192.168.1.62:2379,https://192.168.1.63:2379 endpoint health
```

#### Install k8s Master Cluster

```bash
$ ansible-playbook -i hosts k8s-master.yml -u deploy -v
```

```bash
$ ETCDCTL_API=3 /usr/local/bin/etcdctl --write-out=table --cacert=/etc/kubernetes/ssl/ca.pem --cert=/etc/etcd/ssl/etcd.pem --key=/etc/etcd/ssl/etcd-key.pem --endpoints=https://192.168.1.61:2379,https://192.168.1.62:2379,https://192.168.1.63:2379 endpoint health

$ curl --insecure https://192.168.1.61:6443/
$ curl --insecure https://192.168.1.62:6443/
$ curl --insecure https://192.168.1.63:6443/

$ kubectl cluster-info
$ kubectl get componentstatuses
$ kubectl get all --all-namespaces
```

##### 重启服务

```bash
$ sudo systemctl restart kube-scheduler
$ sudo systemctl restart kube-controller-manager
$ sudo systemctl restart kube-apiserver
$ sudo systemctl restart etcd

$ systemctl status etcd
$ systemctl status kube-apiserver
$ systemctl status kube-controller-manager
$ systemctl status kube-scheduler
```

#### Remove Docker

```bash
$ ansible -i hosts k8s_nodes -m systemd -a "name=docker state=stopped enabled=no" -u deploy --become -v
$ ansible -i hosts k8s_nodes -m systemd -a "name=docker.socket state=stopped enabled=no" -u deploy --become -v
$ ansible -i hosts k8s_nodes -m systemd -a "name=containerd state=stopped enabled=no" -u deploy --become -v
$ ansible -i hosts k8s_nodes -m systemd -a "daemon_reload=yes" -u deploy --become -v

$ ansible -i hosts k8s_nodes -m shell -a "rm -v /usr/lib/systemd/system/docker.service" -u deploy --become -v
$ ansible -i hosts k8s_nodes -m shell -a "rm -v /usr/lib/systemd/system/docker.socket" -u deploy --become -v
$ ansible -i hosts k8s_nodes -m shell -a "rm -v /usr/lib/systemd/system/containerd.service" -u deploy --become -v

$ ansible -i hosts k8s_nodes -m shell -a "rm -vrf /run/docker" -u deploy --become -v
$ ansible -i hosts k8s_nodes -m shell -a "rm -vrf /run/containerd" -u deploy --become -v

$ ansible -i hosts k8s_nodes -m shell -a "rm -vr /etc/docker" -u deploy --become -v
$ ansible -i hosts k8s_nodes -m shell -a "rm -vrf /var/lib/docker" -u deploy --become -v
$ ansible -i hosts k8s_nodes -m shell -a "rm -vrf /var/lib/containerd" -u deploy --become -v
$ ansible -i hosts k8s_nodes -m shell -a "rm -vrf /var/lib/dockershim" -u deploy --become -v

$ ansible -i hosts k8s_nodes -m reboot -u deploy --become -v
```

#### Install k8s Node Cluster

```bash
# $ ansible -i hosts k8s_nodes -m shell -a "apt -y install apt-transport-https ca-certificates curl gnupg lsb-release" -u deploy --become -v
$ ansible -i hosts all -m apt -a "name=rsync state=latest autoremove=yes" -u deploy --become -v
# Fix reboot shutdown missing
$ ansible -i hosts all -m apt -a "name=systemd-sysv state=latest autoremove=yes" -u deploy --become -v


$ ansible-playbook -i hosts k8s-node.yml -u deploy -v
```

$ curl -i --cacert /etc/kubernetes/ssl/ca.pem --cert /etc/kubernetes/ssl/kubelet.crt --key /etc/kubernetes/ssl/kubelet.key https://192.168.1.61:6443
