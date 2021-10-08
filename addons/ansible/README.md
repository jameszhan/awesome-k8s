#### Calico

```bash
$ curl https://docs.projectcalico.org/manifests/calico.yaml -o calico.yaml
$ kubectl apply -f calico.yaml
```

```bash
$ ansible-playbook -i hosts deploy-calico.yml -u deploy -v
```

#### CoreDNS

```bash
$ ansible-playbook -i hosts deploy-coredns.yml -u deploy -v
```

#### Metrics Server

```bash
$ ansible-playbook -i hosts deploy-metrics-server.yml -u deploy -v
```

#### Kubernetes Dashboard

```bash
$ kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.3.1/aio/deploy/recommended.yaml

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

# 获取登陆token
$ kubectl -n kubernetes-dashboard get secret $(kubectl -n kubernetes-dashboard get sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}"
```

#### 参考

- [Calico](https://docs.projectcalico.org/)
- [CoreDNS](https://coredns.io/)
- [Kubernetes Metrics Server](https://github.com/kubernetes-sigs/metrics-server)
- [Kubernetes Dashboard](https://github.com/kubernetes/dashboard)