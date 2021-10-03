

```bash
$ kubectl get deployment.apps/calico-kube-controllers -n kube-system -o yaml

$ kubectl get daemonset.apps/calico-node -n kube-system -o yaml

$ kubectl get cm calico-config -n kube-system -o yaml

$ kubectl get secret calico-etcd-secrets -n kube-system -o yaml
```