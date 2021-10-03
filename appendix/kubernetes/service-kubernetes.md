

> 当我们部署好一个`k8s`集群之后，系统会自动在`default namespace`下创建一个`name`为`kubernetes`的`service`。
> `kubernetes service`的`ip`是`--service-cluster-ip-range`的第一个`ip`，并且该`service`没有设置`spec.selector`。理论上来说，对于没有设置`selector`的`service`，`kube-controller-manager`不会自动创建同名的`endpoints`资源出来。

```bash
$ kubectl get svc kubernetes -o yaml
$ kubectl get ep kubernetes -o yaml
```

```yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    component: apiserver
    provider: kubernetes
  name: kubernetes
  namespace: default
spec:
  clusterIP: 192.168.1.129
  clusterIPs:
  - 192.168.1.129
  ipFamilies:
  - IPv4
  ipFamilyPolicy: SingleStack
  ports:
  - name: https
    port: 443
    protocol: TCP
    targetPort: 6443
  sessionAffinity: None
  type: ClusterIP
status:
  loadBalancer: {}
```

```yaml
apiVersion: v1
kind: Endpoints
metadata:
  labels:
    endpointslice.kubernetes.io/skip-mirror: "true"
  name: kubernetes
  namespace: default
subsets:
- addresses:
  - ip: 192.168.1.61
  - ip: 192.168.1.62
  - ip: 192.168.1.63
  ports:
  - name: https
    port: 6443
    protocol: TCP
```