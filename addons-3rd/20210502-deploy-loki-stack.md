#### Deploy Loki-Stack to k8s cluster

```bash
$ helm repo add grafana https://grafana.github.io/helm-charts
$ helm repo update

$ helm search repo grafana

$ helm template grafana/loki
$ helm template grafana/loki-stack --namespace=loki-stack

$ kubectl create ns loki-stack
$ helm upgrade --install --namespace=loki-stack loki grafana/loki-stack --set grafana.enabled=true,prometheus.enabled=true,prometheus.alertmanager.persistentVolume.enabled=false,prometheus.server.persistentVolume.enabled=false,loki.persistence.enabled=true,loki.persistence.storageClassName=nfs-csi,loki.persistence.size=16Gi
```






[Install Loki with Helm](https://grafana.com/docs/loki/latest/installation/helm/)


```bash
$ helm repo add grafana https://grafana.github.io/helm-charts
$ helm repo update

$ cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolume
metadata:  
  name: loki-pv
  labels:
    app: loki
spec:  
  capacity:    
    storage: 16Gi  
  accessModes:    
    - ReadWriteOnce  
  persistentVolumeReclaimPolicy: Retain  
  storageClassName: nfs
  mountOptions:
    - hard
    - nfsvers=4.1
  nfs:    
    path: /volume1/shared/k8s/appdata
    server: 192.168.1.6
EOF

$ kubectl get pv -o wide
```



```bash
$ helm repo add grafana https://grafana.github.io/helm-charts
$ helm repo update
$ helm search repo grafana
$ helm template grafana/loki
$ helm template grafana/loki-stack

$ helm upgrade --install --namespace=geek-apps loki grafana/loki-stack --set loki.persistence.enabled=true,loki.persistence.storageClassName=standard,loki.persistence.size=5Gi

# Deploy Loki Stack (Loki, Promtail, Prometheus)
$ helm upgrade --install --namespace=geek-apps loki grafana/loki-stack --set grafana.enabled=false,prometheus.enabled=true,prometheus.alertmanager.persistentVolume.enabled=false,prometheus.server.persistentVolume.enabled=false

$ kubectl create ns loki-stack
# Deploy Loki Stack (Loki, Promtail, Grafana, Prometheus) with persistent volume claim
$ helm upgrade --install --namespace=loki-stack loki-stack grafana/loki-stack --set grafana.enabled=true,prometheus.enabled=true,prometheus.alertmanager.persistentVolume.enabled=false,prometheus.server.persistentVolume.enabled=false

$ helm delete loki-stack -n loki-stack
$ helm upgrade --install --namespace=loki-stack loki grafana/loki-stack --set grafana.enabled=true,prometheus.enabled=true,prometheus.alertmanager.persistentVolume.enabled=false,prometheus.server.persistentVolume.enabled=false

$ helm upgrade --install --namespace=loki-stack loki grafana/loki-stack --set grafana.enabled=true,prometheus.enabled=true,prometheus.alertmanager.persistentVolume.enabled=false,prometheus.server.persistentVolume.enabled=false,loki.persistence.enabled=true,loki.persistence.storageClassName=nfs,loki.persistence.size=16Gi



$ kubectl get all -n loki-stack -o wide
$ kubectl get service -n loki-stack -o wide
NAME                            TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE     SELECTOR
loki                            ClusterIP   10.107.60.119    <none>        3100/TCP   8m22s   app=loki,release=loki
loki-grafana                    ClusterIP   10.111.89.36     <none>        80/TCP     8m22s   app.kubernetes.io/instance=loki,app.kubernetes.io/name=grafana
loki-headless                   ClusterIP   None             <none>        3100/TCP   8m22s   app=loki,release=loki
loki-kube-state-metrics         ClusterIP   10.108.143.229   <none>        8080/TCP   8m22s   app.kubernetes.io/instance=loki,app.kubernetes.io/name=kube-state-metrics
loki-prometheus-alertmanager    ClusterIP   10.102.3.8       <none>        80/TCP     8m22s   app=prometheus,component=alertmanager,release=loki
loki-prometheus-node-exporter   ClusterIP   None             <none>        9100/TCP   8m22s   app=prometheus,component=node-exporter,release=loki
loki-prometheus-pushgateway     ClusterIP   10.98.45.111     <none>        9091/TCP   8m22s   app=prometheus,component=pushgateway,release=loki
loki-prometheus-server          ClusterIP   10.100.225.13    <none>        80/TCP     8m22s   app=prometheus,component=server,release=loki

$ kubectl port-forward --namespace loki-stack service/loki-grafana 8080:80
$ kubectl get secret loki-grafana --namespace loki-stack -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

#### Bind the Ingress

```bash
$ kubectl apply -f templates/ingress/loki-stack.yml

$ kubectl get svc -A
$ kubectl get ingress -A
```


[Install Loki with Helm](https://grafana.com/docs/loki/latest/installation/helm/)

#### Deploy Grafana

```bash
$ helm install loki-grafana --namespace geek-apps grafana/grafana
$ kubectl get secret loki-grafana --namespace geek-apps -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
$ kubectl port-forward --namespace geek-apps service/loki-grafana 3000:80

$ kubectl describe ingress grafana-ingress -n geek-apps
$ kubectl delete ingress grafana-ingress -n geek-apps
$ cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: grafana-ingress
  namespace: geek-apps
spec:
  rules:
  - host: grafana.zizhizhan.com
    http:
      paths:
      - pathType: Prefix
        path: "/"
        backend:
          service:
            name: loki-grafana
            port:
              number: 80
EOF

$ curl -i https://grafana.zizhizhan.com
```

#### Deploy Loki-Stack to k8s cluster

```bash
$ helm delete -n geek-apps loki
$ helm delete -n geek-apps loki-grafana

$ kubectl get replicaset -A -o wide
$ kubectl get daemonset -A -o wide
$ kubectl get deployment -A -o wide
$ kubectl get statefulset -A -o wide
$ kubectl get service -A -o wide
$ kubectl get configmap -A -o wide
$ kubectl get secret -A -o wide

$ kubectl delete -f templates/prometheus/prometheus.configmap.yml
$ kubectl delete -f templates/prometheus/prometheus.rbac.yml
$ kubectl delete -f templates/prometheus/prometheus.deployment.yml
$ kubectl delete -f templates/prometheus/prometheus.service.yml

$ kubectl delete -f templates/grafana/grafana.service.yml
$ kubectl delete -f templates/grafana/grafana.deployment.yml
```

```bash
$ helm repo add grafana https://grafana.github.io/helm-charts
$ helm repo update
$ helm search repo grafana
$ helm template grafana/loki
$ helm template grafana/loki-stack

$ helm upgrade --install --namespace=geek-apps loki grafana/loki-stack --set oki.persistence.enabled=true,loki.persistence.storageClassName=standard,loki.persistence.size=5Gi
# Deploy Loki Stack (Loki, Promtail, Prometheus)
$ helm upgrade --install --namespace=geek-apps loki grafana/loki-stack --set grafana.enabled=false,prometheus.enabled=true,prometheus.alertmanager.persistentVolume.enabled=false,prometheus.server.persistentVolume.enabled=false

$ helm delete -n geek-apps loki
$ kubectl create ns loki-stack
# Deploy Loki Stack (Loki, Promtail, Grafana, Prometheus) with persistent volume claim
$ helm upgrade --install --namespace=loki-stack loki-stack grafana/loki-stack --set grafana.enabled=true,prometheus.enabled=true,prometheus.alertmanager.persistentVolume.enabled=false,prometheus.server.persistentVolume.enabled=false

$ helm delete loki-stack -n loki-stack
$ helm upgrade --install --namespace=loki-stack loki grafana/loki-stack --set grafana.enabled=true,prometheus.enabled=true,prometheus.alertmanager.persistentVolume.enabled=false,prometheus.server.persistentVolume.enabled=false

$ helm upgrade --install --namespace=loki-stack loki grafana/loki-stack --set grafana.enabled=true,prometheus.enabled=true,prometheus.alertmanager.persistentVolume.enabled=false,prometheus.server.persistentVolume.enabled=false,loki.persistence.enabled=true,loki.persistence.storageClassName=nfs,loki.persistence.size=16Gi

$ cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolume
metadata:  
  name: loki-pv
  labels:
    app: loki
spec:  
  capacity:    
    storage: 16Gi  
  accessModes:    
    - ReadWriteOnce  
  persistentVolumeReclaimPolicy: Retain  
  storageClassName: nfs
  mountOptions:
    - hard
    - nfsvers=4.1
  nfs:    
    path: /volume1/shared/appdata
    server: 192.168.1.6
EOF

$ kubectl get all -n loki-stack -o wide
$ kubectl get service -n loki-stack -o wide
NAME                            TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE     SELECTOR
loki                            ClusterIP   10.107.60.119    <none>        3100/TCP   8m22s   app=loki,release=loki
loki-grafana                    ClusterIP   10.111.89.36     <none>        80/TCP     8m22s   app.kubernetes.io/instance=loki,app.kubernetes.io/name=grafana
loki-headless                   ClusterIP   None             <none>        3100/TCP   8m22s   app=loki,release=loki
loki-kube-state-metrics         ClusterIP   10.108.143.229   <none>        8080/TCP   8m22s   app.kubernetes.io/instance=loki,app.kubernetes.io/name=kube-state-metrics
loki-prometheus-alertmanager    ClusterIP   10.102.3.8       <none>        80/TCP     8m22s   app=prometheus,component=alertmanager,release=loki
loki-prometheus-node-exporter   ClusterIP   None             <none>        9100/TCP   8m22s   app=prometheus,component=node-exporter,release=loki
loki-prometheus-pushgateway     ClusterIP   10.98.45.111     <none>        9091/TCP   8m22s   app=prometheus,component=pushgateway,release=loki
loki-prometheus-server          ClusterIP   10.100.225.13    <none>        80/TCP     8m22s   app=prometheus,component=server,release=loki

$ kubectl port-forward --namespace loki-stack service/loki-grafana 8080:80
$ kubectl get secret loki-grafana --namespace loki-stack -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

#### Bind the Ingress

```bash
$ cat <<EOF | kubectl apply -f -
kind: Service
apiVersion: v1
metadata:
  name: loki-grafana
  namespace: geek-apps
spec:
  type: ExternalName
  externalName: loki-grafana.loki-stack.svc.cluster.local
  ports:
  - port: 80
EOF

$ kubectl delete ingress grafana-ingress -n geek-apps
$ cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: grafana-ingress
  namespace: geek-apps
spec:
  tls:
  - hosts:
      - grafana.zizhizhan.com
    secretName: star.zizhizhan.com-tls
  rules:
  - host: grafana.zizhizhan.com
    http:
      paths:
      - path: /
        pathType: ImplementationSpecific
        backend:
          service:
            name: loki-grafana
            port:
              number: 80
EOF
```