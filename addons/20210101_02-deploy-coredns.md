## TL;DR

```bash
$ helm repo add coredns https://coredns.github.io/helm

$ helm repo update
$ helm search repo coredns

# helm pull coredns/coredns
# 按需调整配置
$ helm show values coredns/coredns > templates/coredns-values.yaml

# 安装前先需要替换准备好的镜像
$ helm  -n kube-system install -f templates/coredns-values.yaml coredns coredns/coredns
```

