## TL;DR

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/redis-cluster
```

### 安装`Redis-Cluster`

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm repo update
$ helm search repo redis

$ mkdir -p templates/redis-cluster
$ helm show values bitnami/redis-cluster > templates/redis-cluster/redis-cluster-values.yaml

$ helm -n geek-apps uninstall redis-cluster 

$ helm -n geek-apps install redis-cluster bitnami/redis-cluster \
    --set persistence.enabled=true \
    --set global.storageClass=ceph-rbd \
    --set persistence.size=8Gi \
    --set volumePermissions.enabled=true \
    --set cluster.init=ture \
    --set cluster.nodes=6 \
    --set cluster.replicas=1 \
    --set metrics.enabled=true

$ kubectl get pods -w --namespace geek-apps -o wide
```

### 测试安装效果

```bash  
$ export REDIS_PASSWORD=$(kubectl get secret --namespace "geek-apps" redis-cluster -o jsonpath="{.data.redis-password}" | base64 --decode)
$ kubectl run --namespace geek-apps redis-cluster-client --rm --tty -i --restart='Never' \
    --env REDIS_PASSWORD=$REDIS_PASSWORD \
    --image docker.io/bitnami/redis-cluster:6.2.6-debian-10-r0 -- bash
```

```bash
$ redis-cli -c -h redis-cluster.geek-apps.svc.cluster.local -a $REDIS_PASSWORD
$ redis-cli -c -h redis-cluster-0.redis-cluster-headless.geek-apps.svc.cluster.local -a $REDIS_PASSWORD
$ redis-cli -c -h redis-cluster-1.redis-cluster-headless.geek-apps.svc.cluster.local -a $REDIS_PASSWORD
$ redis-cli -c -h redis-cluster-2.redis-cluster-headless.geek-apps.svc.cluster.local -a $REDIS_PASSWORD
$ redis-cli -c -h redis-cluster-3.redis-cluster-headless.geek-apps.svc.cluster.local -a $REDIS_PASSWORD
$ redis-cli -c -h redis-cluster-4.redis-cluster-headless.geek-apps.svc.cluster.local -a $REDIS_PASSWORD
$ redis-cli -c -h redis-cluster-5.redis-cluster-headless.geek-apps.svc.cluster.local -a $REDIS_PASSWORD

$ redis-cli -c -h redis-cluster-0.redis-cluster-headless -a $REDIS_PASSWORD
$ redis-cli -c -h redis-cluster -a $REDIS_PASSWORD
```

```bash
$ cluster info
$ cluster nodes
```