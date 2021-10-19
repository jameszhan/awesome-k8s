## TL;DR

```bash
$ kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.3.1/aio/deploy/recommended.yaml
```

#### 部署`Kubernetes Dashboard`

##### 通过`Helm`安装

```bash
$ helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
$ helm repo update

$ helm search repo kubernetes-dashboard
$ helm delete kubernetes-dashboard -n kube-system
$ helm install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard -n kube-system
```

##### `Helm`定制部署`dashboard`

```bash
$ helm delete kubernetes-dashboard -n kube-system
$ helm install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard \
     -n kube-system -f templates/kubernetes-dashboard-values.yaml
```

##### 极简方式安装(推荐)

```bash
$ kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.3.1/aio/deploy/recommended.yaml
$ kubectl describe svc kubernetes-dashboard -n kubernetes-dashboard

$ kubectl -n kubernetes-dashboard port-forward svc/kubernetes-dashboard 8443:443
$ open https://localhost:8443/
# 键盘输入`thisisunsafe`命令，可以解除Chrome对不信任签名网站的访问限制。

$ kubectl proxy --address=0.0.0.0
$ open -a 'Google Chrome' http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
```
> 注意：`proxy`方式将会出现无法正常登陆情况，推荐使用`port-forward`方式。

#### 创建管理账户

- [Creating sample user](https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md)

```bash
$ kubectl -n kubernetes-dashboard delete serviceaccount admin-user
$ kubectl -n kubernetes-dashboard delete clusterrolebinding admin-user

$ cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
---
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
```

##### 获取登陆`token`

```bash
$ kubectl -n kubernetes-dashboard get secret $(kubectl -n kubernetes-dashboard get sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}"
# 或者
$ kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}') | grep -E '^token' | cut -f2 -d':' | tr -d ' '
```

#### 参考资料

- [Kubernetes Dashboard](https://github.com/kubernetes/dashboard)
