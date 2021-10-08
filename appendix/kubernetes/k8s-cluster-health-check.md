
```bash
$ sudo netstat -tunlp
$ sudo ss -ntulp


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