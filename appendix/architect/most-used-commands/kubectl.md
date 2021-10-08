```bash
$ kubectl delete cm kubernetes-services-endpoint
```

```bash
$ kubectl get svc --all-namespaces

$ kubectl set env daemonset/calico-node -n kube-system IP_AUTODETECTION_METHOD=can-reach=www.baidu.com
# eth0,enp1s0,ens33
$ kubectl set env daemonset/calico-node -n kube-system IP_AUTODETECTION_METHOD=interface="(eth0|enp1s0|ens33)"
```

```bash
$ kubectl run my-nginx --image=nginx --port=80
$ kubectl port-forward --address 0.0.0.0 pod/my-nginx 8080:80
```

```bash
$ kubectl config view -o jsonpath='{.clusters[0].cluster.server}'
```

```bash
$ kubectl get serviceaccount -A
$ kubectl get role -A
$ kubectl get clusterrole -A
$ kubectl get clusterrolebinding -A -o wide
```

```bash
$ kubectl run cirros-$RANDOM --rm -it --image=cirros -- sh

$ kubectl run my-nginx --image=nginx --port=80
$ kubectl port-forward --address 0.0.0.0 pod/my-nginx 8080:80

$ kubectl create deployment nginx --image=nginx
```