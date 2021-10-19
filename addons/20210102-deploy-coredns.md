## TL;DR

```bash
$ helm repo add coredns https://coredns.github.io/helm

$ helm repo update
$ helm search repo coredns

# helm pull coredns/coredns
# 按需调整配置
$ helm show values coredns/coredns > templates/coredns-values.yaml

$ helm -n kube-system install -f templates/coredns-values.yaml coredns coredns/coredns
```

## 测试服务

```bash
$ kubectl run -it --rm --restart=Never --image=infoblox/dnstools:latest dnstools

$ nslookup kubernetes
$ nslookup kubernetes.default.svc.cluster.local

$ curl -i -k https://kubernetes
```