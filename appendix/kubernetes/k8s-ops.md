
```bash
$ kubectl delete cm kubernetes-services-endpoint
```

```bash
$ kubectl get svc --all-namespaces

$ kubectl set env daemonset/calico-node -n kube-system IP_AUTODETECTION_METHOD=can-reach=www.baidu.com
# eth0,enp1s0,ens33
$ kubectl set env daemonset/calico-node -n kube-system IP_AUTODETECTION_METHOD=interface="(eth0|enp1s0|ens33)"
```
