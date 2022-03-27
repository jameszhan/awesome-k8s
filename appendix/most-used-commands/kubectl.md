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

#### `k8s node selector`

```bash
$ kubectl get node --show-labels

$ kubectl label node k8s-node001 cpu=R7-5700U
$ kubectl label node k8s-node002 cpu=R7-5700U
$ kubectl label node k8s-node003 cpu=R7-5700U
$ kubectl label node k8s-node005 cpu=R7-5700U
$ kubectl label node k8s-node006 cpu=R7-5700U
$ kubectl label node k8s-node007 cpu=R7-5700U
$ kubectl label node k8s-node008 cpu=R7-5700U

$ kubectl get  node --show-labels

$ kubectl label node k8s-node031 cpu=J1900
$ kubectl label node k8s-node032 cpu=J1900
$ kubectl label node k8s-node033 cpu=J1900
$ kubectl get node --show-labels
```

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ai-notebook
  namespace: geek-apps
spec:
  replicas: 1
  selector:
    matchLabels:
      ...
  template:
    metadata:
      labels:
        ...
    spec:
      containers:
        ...
      volumes:
        ...
      nodeSelector: 
        cpu: R7-5700U
EOF
```

#### `k8s service`负载均衡检查

```bash
$ kubectl describe svc default-backend-service -n geek-apps

$ kubectl run cirros-$RANDOM --rm -it --image=cirros -- sh
```

检查`x_host`字段

```bash
$ ping default-backend-service.geek-apps.svc.cluster.local
$ for loop in 1 2 3 4 5 6; do curl -I http://default-backend-service.geek-apps.svc.cluster.local/; done
```

#### 修改配置

编辑`ingress-nginx-controller`服务配置

```bash
$ kubectl edit svc ingress-nginx-controller -n ingress-nginx
```
在`clusterIP`基础上新增一个`externalIP`。

```yaml
spec:
  clusterIP: 192.168.1.203
  clusterIPs:
  - 192.168.1.203
  externalIPs:
  - 192.168.1.100
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
$ kubectl get all -o wide -A
$ kubectl get cm -o wide -A
$ kubectl get deploy -o wide -A
$ kubectl get svc -o wide -A
$ kubectl get pod -o wide -A
$ kubectl get secret -o wide -A

$ kubectl get deployment -o wide -n geek-apps
$ kubectl get service -o wide -n geek-apps
$ kubectl get pod -o wide -n geek-apps

$ kubectl get service -A
$ kubectl get endpoints -A
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

$ kubectl logs -f svc/kubernetes-dashboard -n kubernetes-dashboard
```

```bash
$ kubectl create secret tls star.zizhizhan.com-tls --cert=./fullchain1.pem --key=./privkey1.pem -n geek-apps

$ kubectl describe secret star.zizhizhan.com-tls -n geek-apps
$ kubectl get secret star.zizhizhan.com-tls -n geek-apps -o yaml

$ kubectl delete ingress pkm-ingress -n geek-apps


$ kubectl get all --all-namespaces -o wide
$ kubectl cluster-info dump

$ kubectl delete replicationcontroller default-http-backend -n geek-apps
```

`kubectl run NAME --image=image [--env="key=value"] [--port=port] [--replicas=replicas] [--dry-run=bool] [--overrides=inline-json] [--command] -- [COMMAND] [args...] [options]`

```bash
kubectl get pod --all-namespaces --show-labels

# kubectl run -i -t busybox --image=busybox --rm --restart=Never
# kubectl delete pod busybox

kubectl run nginx-app --image=nginx:alpine --port=80

kubectl run nginx --image=nginx:alpine --port=80 --restart=Never

kubectl get pods
```

#### 访问指定集群 

- [配置对多集群的访问](https://kubernetes.io/zh/docs/tasks/access-application-cluster/configure-access-multiple-clusters/)
- [使用 kubeconfig 文件组织集群访问](https://kubernetes.io/zh/docs/concepts/configuration/organize-cluster-access-kubeconfig/)

```bash
$ kubectl --kubeconfig=/opt/etc/kube/config get nodes
$ KUBECONFIG=/opt/etc/kube/config kubectl cluster-info
$ KUBECONFIG=/opt/etc/kube/config kubectl config view
```

```bash
$ ETCDCTL_API=3 /usr/local/bin/etcdctl \
  --cacert=/etc/etcd/ssl/ca.pem \
  --cert=/etc/etcd/ssl/etcd.pem \
  --key=/etc/etcd/ssl/etcd-key.pem \
  --endpoints=https://192.168.1.61:2379,https://192.168.1.62:2379,https://192.168.1.63:2379 \
  get /registry/pods/geek-apps/nacos-0 --prefix
```

#### 删除资源



```bash
# 删除POD
$ kubectl delete pod PODNAME --force --grace-period=0

# 删除NAMESPACE
$ kubectl delete namespace NAMESPACENAME --force --grace-period=0
```

```bash
# 删除default namespace下的pod名为pod-to-be-deleted-0
$ ETCDCTL_API=3 etcdctl del /registry/pods/default/pod-to-be-deleted-0

# 删除需要删除的NAMESPACE
$ etcdctl del /registry/namespaces/NAMESPACENAME
```