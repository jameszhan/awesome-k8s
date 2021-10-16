## TL;DR

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install zookeeper bitnami/zookeeper
```

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm search repo zookeeper
$ helm repo update

$ mkdir -p templates/zookeeper
$ helm show values bitnami/zookeeper > templates/zookeeper/zookeeper-values.yaml

$ helm -n geek-apps uninstall zookeeper 
$ helm -n geek-apps install zookeeper bitnami/zookeeper \
    --set global.storageClass=nfs-csi \
    --set persistence.enabled=true \
    --set persistence.size=8Gi \
    --set volumePermissions.enabled=true \
    --set replicaCount=3

$ kubectl get pods -w --namespace geek-apps -o wide
```


```bash
$ MYSQL_ROOT_PASSWORD=$(kubectl get secret --namespace geek-apps mysql -o jsonpath="{.data.mysql-root-password}" | base64 --decode)

$ mysql -h mysql-primary.geek-apps.svc.cluster.local -uroot -p"$MYSQL_ROOT_PASSWORD"
$ mysql -h mysql-secondary.geek-apps.svc.cluster.local -uroot -p"$MYSQL_ROOT_PASSWORD"
```

