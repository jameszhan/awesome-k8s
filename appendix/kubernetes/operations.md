
```bash
$ kubectl get serviceaccount -A
$ kubectl get role -A
$ kubectl get clusterrole -A
$ kubectl get clusterrolebinding -A -o wide
```

> `CirrOS`是设计用来进行云计算环境测试的`Linux`微型发行版，它拥有HTTP客户端工具。

```bash
$ kubectl run cirros-$RANDOM --rm -it --image=cirros -- sh
```

```bash
$ ansible -i hosts k8s_nodes -m shell -a 'rm -vrf /etc/cni/net.d/*' -u deploy --become -v
$ ansible -i hosts k8s_nodes -m shell -a 'rm -vrf /var/lib/cni/calico' -u deploy --become -v
$ ansible -i hosts k8s_nodes -m shell -a 'systemctl restart kubelet' -u deploy --become -v


$ curl -i --cacert /etc/kubernetes/ssl/ca.pem --cert /etc/kubernetes/ssl/kubelet.crt --key /etc/kubernetes/ssl/kubelet.key https://192.168.1.61:6443
```