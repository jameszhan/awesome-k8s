## 部署和安装

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
$ helm upgrade --install loki --namespace=loki-stack grafana/loki

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
$ kubectl get pvc -n loki-stack -o wide

$ kubectl port-forward -n loki-stack service/loki-prometheus-server 8080:80
$ curl -v http://localhost:8080/metrics
$ open http://localhost:8080/graph
$ open http://localhost:8080/targets

$ kubectl port-forward -n loki-stack service/loki-grafana 8080:80
$ open http://localhost:8080/
# 获取登陆密码
$ kubectl get secret loki-grafana -n loki-stack -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
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

## 配置监控

### 配置`Prometheus`

- Create -> [Import](https://grafana.zizhizhan.com:8443/dashboard/import) -> 315 -> 选择`Prometheus` -> Import
- Configuration -> [Data sources](https://grafana.zizhizhan.com:8443/datasources) -> 选择`Prometheus` -> Dashboards -> Import

### 支持地理位置信息统计

#### `geoip`指令

```conf
geoip_country       /etc/nginx/geoip/GeoIP.dat;
geoip_city          /etc/nginx/geoip/GeoLiteCity.dat;
geoip_org           /etc/nginx/geoip/GeoIPASNum.dat;
geoip_proxy_recursive on;
```
##### geoip_country

- `$geoip_country_code`: 双字符国家代码，比如“RU”，“US”。
- `$geoip_country_code3`: 三字符国家代码，比如“RUS”，“USA”。
- `$geoip_country_name`: 国家名称，比如“Russian Federation”，“United States”。

##### geoip_city

- `$geoip_area_code`: 电话区号（仅美国）该变量由于相应的数据库会过时，所以信息可能过时
- `$geoip_city_continent_code`: 两字母的大陆代码，如“EU”，“NA”
- `$geoip_city_country_code`: 两字母的国家代码，如“RU”，“US”
- `$geoip_city_country_code3`: 三字母的国家代码，如“RUS”，“USA”
- `$geoip_city_country_name`: 国家名，例如“Russian Federation”，“United States”
- `$geoip_dma_code`: 美国DMA地区代码（亦称“地铁代码”），依据Google AdWords API geotargeting
- `$geoip_latitude`: 纬度
- `$geoip_longitude`: 经度
- `$geoip_region`: 两标识符的国家区域代码（区域、范围、州、省、联邦），例如“48”、“DC”
- `$geoip_region_name`: 国家区域名（区域、范围、州、省、联邦），例如“Moscow City”，“District of Columbia”
- `$geoip_city`: 城市名，例如“Moscow”，“Washington”
- `$geoip_postal_code`: 邮政编码

##### geoip_org

指定数据库用于决定依赖于客户端IP地址的机构。下面的变量在使用数据库时可用

- `$geoip_org`: 组织名，例如“The University of Melbourne”

#### 更新`nginx`配置

```bash
$ kubectl get cm ingress-nginx-controller -n ingress-nginx -o yaml
$ kubectl get cm ingress-controller-leader -n ingress-nginx -o yaml

$ kubectl apply -f templates/ingress-nginx/controller-configmap.yaml
$ kubectl get cm ingress-nginx-controller -n ingress-nginx -o yaml
```

确认`nginx`配置，确认如下`proxy_set_header`都已经成功设置。

```bash
$ kubectl exec -n ingress-nginx -it ingress-nginx-controller-97d87b6ff-b8wmq -- cat /etc/nginx/nginx.conf
```

```conf
proxy_set_header Host $http_host;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_set_header X-Forwarded-Proto $scheme;
```

### 参考资料

- [Install Loki with Helm](https://grafana.com/docs/loki/latest/installation/helm/)
- [NGINX Ingress Controller ConfigMaps](https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/configmap/)
- [Helm Charts](https://grafana.github.io/helm-charts)