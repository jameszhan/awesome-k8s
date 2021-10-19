## TL;DR

```bash
$ wget https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml --output-document=templates/metrics-server.yaml
$ kubectl apply -f templates/metrics-server.yaml
```

> 国内用户可以把`image`从`k8s.gcr.io/metrics-server/metrics-server:v0.5.1`替换为`registry.cn-hangzhou.aliyuncs.com/google_containers/metrics-server:v0.5.1`。