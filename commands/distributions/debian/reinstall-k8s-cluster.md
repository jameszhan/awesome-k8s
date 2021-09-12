


#### Remove etcd cluster

```bash
$ ansible -i hosts all -m shell -a "systemctl stop etcd" -u deploy -v --become
$ ansible -i hosts all -m shell -a "systemctl disable etcd" -u deploy -v --become

$ ansible -i hosts all -m shell -a "rm -fr /etc/etcd/ssl" -u deploy -v --become
$ ansible -i hosts all -m shell -a "rm -fr /var/lib/etcd" -u deploy -v --become
$ ansible -i hosts all -m shell -a "rm -fr /usr/local/bin/*" -u deploy -v --become
$ ansible -i hosts all -m shell -a "rm -fr /tmp/etcd*" -u deploy -v --become
$ ansible -i hosts all -m shell -a "rm -fr /tmp/kubernetes" -u deploy -v --become
$ ansible -i hosts all -m shell -a "rm -fr /etc/kubernetes" -u deploy -v --become

$ ansible -i hosts all -m shell -a "/opt/bin/update-system.sh" -u deploy -v --become
```

#### Install Ectd Cluster

```bash
$ ansible-playbook -i hosts k8s-deploy.yml -u deploy -v

$ curl --insecure https://192.168.1.61:6443/
$ curl --insecure https://192.168.1.62:6443/
$ curl --insecure https://192.168.1.63:6443/
```

```bash
$ netstat -tunlp
$ ss -antulp

$ ETCDCTL_API=3 /usr/local/bin/etcdctl --write-out=table --cacert=/etc/etcd/ssl/ca.pem --cert=/etc/etcd/ssl/etcd.pem --key=/etc/etcd/ssl/etcd-key.pem --endpoints=http://127.0.0.1:2379 endpoint health

$ ETCDCTL_API=3 /usr/local/bin/etcdctl --write-out=table --cacert=/etc/kubernetes/ssl/ca.pem --cert=/etc/etcd/ssl/etcd.pem --key=/etc/etcd/ssl/etcd-key.pem --endpoints=https://192.168.1.61:2379,https://192.168.1.62:2379,https://192.168.1.63:2379 endpoint health

$ ETCDCTL_API=3 /usr/local/bin/etcdctl --write-out=table --cacert=/etc/etcd/ssl/ca.pem --cert=/etc/etcd/ssl/etcd.pem --key=/etc/etcd/ssl/etcd-key.pem --endpoints=https://192.168.1.61:2379,https://192.168.1.62:2379,https://192.168.1.63:2379 endpoint health
```

```bash
$ sudo systemctl restart kube-scheduler
$ sudo systemctl restart kube-controller-manager
$ sudo systemctl restart kube-apiserver
$ sudo systemctl restart etcd

$ systemctl status etcd
$ systemctl status kube-apiserver
$ systemctl status kube-controller-manager
$ systemctl status kube-scheduler

$ kubectl cluster-info
$ kubectl get componentstatuses
$ kubectl get all --all-namespaces
```