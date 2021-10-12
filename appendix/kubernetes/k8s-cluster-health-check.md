
```bash
$ curl --insecure https://192.168.1.61:6443/
$ curl --insecure https://192.168.1.62:6443/
$ curl --insecure https://192.168.1.63:6443/

$ kubectl cluster-info
$ kubectl get componentstatuses
$ kubectl get all --all-namespaces

$ nc -vz 192.168.1.129 443

$ curl -i --cacert /etc/kubernetes/ssl/ca.pem --cert /etc/kubernetes/ssl/admin.pem --key /etc/kubernetes/ssl/admin-key.pem https://192.168.1.129/version
$ curl -i --cacert /etc/kubernetes/ssl/ca.pem --cert /etc/kubernetes/ssl/kubelet.crt --key /etc/kubernetes/ssl/kubelet.key https://192.168.1.61:6443
```

#### `master node`

```bash
$ sudo netstat -tunlp
$ sudo ss -ntulp

$ journalctl -fu haproxy
$ journalctl -fu keepalived
$ journalctl -fu etcd
$ journalctl -fu kube-apiserver
$ journalctl -fu kube-scheduler
$ journalctl -fu kube-controller-manager
$ journalctl -fu chronyd
```

#### `worker node`

```bash
$ sudo netstat -tunlp
$ sudo ss -ntulp

$ journalctl -fu kubelet
$ journalctl -fu kube-proxy
$ journalctl -fu chronyd
```