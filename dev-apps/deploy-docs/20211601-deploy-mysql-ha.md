## TL;DR

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install mysql bitnami/mysql
```

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm search repo mysql
$ helm repo update

$ mkdir -p templates/mysql
$ helm show values bitnami/mysql > templates/mysql/mysql-values.yaml

$ helm -n geek-apps uninstall mysql 
$ helm -n geek-apps install mysql bitnami/mysql \
    --set architecture=replication \
    --set auth.rootPassword=root \
    --set auth.database=authdb \
    --set auth.replicationPassword=root \
    --set metrics.enabled=true \
    --set volumePermissions.enabled=true \
    --set global.storageClass=nfs-csi \
    --set primary.persistence.size=32Gi \
    --set secondary.persistence.size=16Gi

$ kubectl get pods -w --namespace geek-apps -o wide
```


```bash
$ MYSQL_ROOT_PASSWORD=$(kubectl get secret --namespace geek-apps mysql -o jsonpath="{.data.mysql-root-password}" | base64 --decode)

$ mysql -h mysql-primary.geek-apps.svc.cluster.local -uroot -p"$MYSQL_ROOT_PASSWORD"
$ mysql -h mysql-secondary.geek-apps.svc.cluster.local -uroot -p"$MYSQL_ROOT_PASSWORD"
```

