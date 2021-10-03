
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