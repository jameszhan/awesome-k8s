#### 配置自动补全

```bash
$ sudo apt -y install bash-completion
# 启用 zsh 自动补全功能
$ echo 'source <(kubectl completion zsh)' >> ~/.zshrc
```

#### 检查当前集群

```bash
$ kubectl cluster-info
$ kubectl config view
```

#### 查看集群资源

```bash
$ kubectl api-resources -o wide

$ kubectl api-resources --namespaced=false --sort-by=kind -o wide
$ kubectl api-resources --namespaced=true --sort-by=kind -o wide
```

> 运行一个`proxy`到`Kubernetes API server`

```bash
$ kubectl proxy --port=8080

$ curl -i http://127.0.0.1:8080/healthz
$ curl -i http://127.0.0.1:8080/livez
$ curl -i http://127.0.0.1:8080/readyz

$ open http://localhost:8080/api/v1/namespaces/geek-apps/pods
$ open http://localhost:8080/api/v1/namespaces/geek-apps/services
$ open http://localhost:8080/api/v1/namespaces/geek-apps/services/default-backend-service
```

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

```bash
$ kubectl run busybox --image=busybox:latest -i --tty
$ kubectl attach busybox -c busybox -i -t
# nslookup kubernetes
$ kubectl delete pod busybox
```

```bash
$ kubectl get ingress -n geek-apps
$ kubectl get secret --field-selector type=kubernetes.io/tls -n geek-apps
```

```bash
$ kubectl get all -n kubernetes-dashboard -o wide

$ kubectl get ServiceAccount -n kubernetes-dashboard -o wide
$ kubectl describe serviceaccount kubernetes-dashboard -n kubernetes-dashboard
$ kubectl describe secret kubernetes-dashboard -n kubernetes-dashboard

$ kubectl get ClusterRoleBinding -o wide
$ kubectl get ClusterRoleBinding kubernetes-dashboard -o wide
$ kubectl describe ClusterRoleBinding kubernetes-dashboard

$ kubectl get ClusterRoleBinding cluster-admin -o wide
$ kubectl describe ClusterRoleBinding cluster-admin

$ kubectl logs -f svc/kubernetes-dashboard  -n kubernetes-dashboard
```

```bash
$ kubectl create secret tls star.zizhizhan.com-tls --cert=./fullchain1.pem --key=./privkey1.pem -n geek-apps

$ kubectl describe secret star.zizhizhan.com-tls -n geek-apps
$ kubectl get secret star.zizhizhan.com-tls -n geek-apps -o yaml

$ kubectl delete ingress pkm-ingress -n geek-apps
```

#### 访问指定集群 

- [配置对多集群的访问](https://kubernetes.io/zh/docs/tasks/access-application-cluster/configure-access-multiple-clusters/)
- [使用 kubeconfig 文件组织集群访问](https://kubernetes.io/zh/docs/concepts/configuration/organize-cluster-access-kubeconfig/)

```bash
$ kubectl --kubeconfig=/opt/etc/kube/config get nodes
$ KUBECONFIG=/opt/etc/kube/config kubectl cluster-info
$ KUBECONFIG=/opt/etc/kube/config kubectl config view
```


