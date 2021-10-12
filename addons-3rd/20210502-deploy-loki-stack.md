### Deploy Loki to your cluster

```bash
$ helm repo add grafana https://grafana.github.io/helm-charts
$ helm repo update

$ helm search repo grafana

$ helm template grafana/loki
$ helm template grafana/loki-stack --namespace=loki-stack

$ kubectl create ns loki-stack

$ helm upgrade --install --namespace=loki-stack loki grafana/loki-stack --set grafana.enabled=true,prometheus.enabled=true,prometheus.alertmanager.persistentVolume.enabled=false,prometheus.server.persistentVolume.enabled=false,loki.persistence.enabled=true,loki.persistence.storageClassName=nfs-csi,loki.persistence.size=16Gi,loki.securityContext.runAsGroup=0,loki.securityContext.runAsUser=0,loki.securityContext.runAsNonRoot=false
```

#### 其他安装选项

```bash
# 删除历史安装，如有必要
$ helm uninstall loki -n loki-stack
$ kubectl delete pvc storage-loki-0 -n loki-stack

# Deploy with default config
$ helm upgrade --install loki grafana/loki-stack

# Deploy in a custom namespace
$ helm upgrade --install loki --namespace=loki grafana/loki

# Deploy with custom config
$ helm upgrade --install loki grafana/loki --set "key1=val1,key2=val2,..."

# Deploy Loki Stack (Loki, Promtail, Grafana, Prometheus)
$ helm upgrade --install loki grafana/loki-stack --set grafana.enabled=true,prometheus.enabled=true,prometheus.alertmanager.persistentVolume.enabled=false,prometheus.server.persistentVolume.enabled=false

# Deploy Loki Stack (Loki, Promtail, Grafana, Prometheus) with persistent volume claim
$ helm upgrade --install loki grafana/loki-stack --set grafana.enabled=true,prometheus.enabled=true,prometheus.alertmanager.persistentVolume.enabled=false,prometheus.server.persistentVolume.enabled=false,loki.persistence.enabled=true,loki.persistence.storageClassName=standard,loki.persistence.size=5Gi

# Deploy Loki Stack (Loki, Fluent Bit, Grafana, Prometheus)
$ helm upgrade --install loki grafana/loki-stack \
  --set fluent-bit.enabled=true,promtail.enabled=false,grafana.enabled=true,prometheus.enabled=true,prometheus.alertmanager.persistentVolume.enabled=false,prometheus.server.persistentVolume.enabled=false
```

### 检查安装结果

```bash
$ helm list -n loki-stack

$ kubectl get pods -n loki-stack -o wide
$ kubectl get svc -n loki-stack -o wide
$ kubectl get pvc -n loki-stack -o wide\

$ kubectl port-forward --namespace loki-stack service/loki-grafana 8080:80
$ open http://localhost:8080/
# 获取登陆密码
$ kubectl get secret loki-grafana --namespace loki-stack -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

### 配置外部访问

```bash
$ kubectl apply -f templates/loki-stack/loki-stack.yml

$ kubectl get svc -n geek-apps
$ kubectl get ingress -n geek-apps

$ open https://grafana.zizhizhan.com:8443
# 获取admin密码
$ kubectl get secret loki-grafana -n loki-stack -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

### 配置监控

#### 配置`Prometheus`

- Create -> [Import](https://grafana.zizhizhan.com:8443/dashboard/import) -> 315 -> 选择`Prometheus` -> Import
- Configuration -> [Data sources](https://grafana.zizhizhan.com:8443/datasources) -> 选择`Prometheus` -> Dashboards -> Import

### 参考资料

- [Install Loki with Helm](https://grafana.com/docs/loki/latest/installation/helm/)
- [Helm Charts](https://grafana.github.io/helm-charts)
