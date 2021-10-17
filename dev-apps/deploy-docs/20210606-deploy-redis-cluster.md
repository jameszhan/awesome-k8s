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
    --set global.storageClass=nfs-csi \
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

$ redis-cli -c -h redis-cluster.geek-apps.svc.cluster.local -a $REDIS_PASSWORD
```

```bash
$ cluster info
$ cluster nodes
```

9890e45f2051fdf53d8d1a9b79506f6339e8ee1b 10.244.88.80:6379@16379 myself,slave a30311bb47f128e3d83345d67bb086e5f63d748e 0 1634439988000 2 connected
04f3ece1597e89667a83298a039636aa96595b1d 10.244.150.203:6379@16379 slave 92079d23f40eaf2d235aa22670c3f656269f89c8 0 1634439992663 1 connected
0aedc945ce7c702c4afc0141038504bfbebe628b 10.244.19.71:6379@16379 slave 3fe70e52d6eaeccbbe654aa36616fcb972a18fe3 0 1634439993667 3 connected
3fe70e52d6eaeccbbe654aa36616fcb972a18fe3 10.244.6.140:6379@16379 master - 0 1634439993000 3 connected 10923-16383
a30311bb47f128e3d83345d67bb086e5f63d748e 10.244.88.218:6379@16379 master - 0 1634439993000 2 connected 5461-10922
92079d23f40eaf2d235aa22670c3f656269f89c8 10.244.38.145:6379@16379 master - 0 1634439994674 1 connected 0-5460