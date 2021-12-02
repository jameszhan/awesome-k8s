## TL;DR

```bash
$ wget https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml --output-document=templates/metrics-server.yaml
$ kubectl apply -f templates/metrics-server.yaml
```

#### Most useful flags:

```bash
$ kubectl edit deployment metrics-server -n kube-system
```

- `--kubelet-preferred-address-types` - The priority of node address types used when determining an address for connecting to a particular node (default [Hostname,InternalDNS,InternalIP,ExternalDNS,ExternalIP])
- `--kubelet-insecure-tls` - Do not verify the CA of serving certificates presented by Kubelets. For testing purposes only.
- `--requestheader-client-ca-file` - Specify a root certificate bundle for verifying client certificates on incoming requests.

建议加上`--kubelet-insecure-tls`参数，取消证书双向验证。




> 国内用户可以把`image`从`k8s.gcr.io/metrics-server/metrics-server:v0.5.2`替换为`registry.cn-hangzhou.aliyuncs.com/google_containers/metrics-server:v0.5.2`。

[metrics-server]: https://github.com/kubernetes-sigs/metrics-server "Kubernetes Metrics Server"