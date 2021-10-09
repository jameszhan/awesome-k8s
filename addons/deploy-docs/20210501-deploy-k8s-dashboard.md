
#### 快速部署`Kubernetes Dashboard`


```bash
$ export KUBECONFIG=/opt/etc/kube/config:$HOME/.kube/config

$ wget https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml -O kubernetes-dashboard.yml
$ kubectl apply -f templates/kubernetes-dashboard.yml

$ kubectl proxy
$ open http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/
```
#### 创建管理账户

```bash
$ kubectl -n kubernetes-dashboard delete serviceaccount admin-user
$ kubectl -n kubernetes-dashboard delete clusterrolebinding admin-user

$ cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
EOF

$ cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
EOF

$ kubectl -n kubernetes-dashboard get secret $(kubectl -n kubernetes-dashboard get sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}"
```

#### Kubernetes Observability

```bash
$ dig -t A kubernetes-dashboard.kubernetes-dashboard.svc.cluster.local @192.168.1.130
$ dig -t A kubernetes-dashboard.geek-apps.svc.cluster.local @192.168.1.130
$ dig -t A kubernetes-dashboard @192.168.1.130


$ kubectl run cirros-$RANDOM --rm -it --image=cirros -- sh
```
> 提示：CirrOS是设计用来进行云计算环境测试的Linux微型发行版，它拥有HTTP客户端工具curl等。

```bash
$ curl -v -k https://kubernetes-dashboard.kubernetes-dashboard.svc.cluster.local
$ curl -v -k kubernetes-dashboard.geek-apps.svc.cluster.local
```

#### 参考资料

- [Kubernetes Dashboard](https://github.com/kubernetes/dashboard)
