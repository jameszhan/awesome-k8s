
### 安装`etcd`服务

> 如果业务系统要使用`etcd`集群，最好单独安装，不要使用`k8s`集群自带的`etcd`服务。

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm search repo etcd
$ helm repo update

$ mkdir -p templates/etcd
$ helm show values bitnami/etcd > templates/etcd/etcd-values.yaml

$ helm -n geek-apps uninstall etcd
$ helm -n geek-apps install etcd bitnami/etcd \
    --set persistence.enabled=true \
    --set persistence.storageClass=nfs-csi \
    --set volumePermissions.enabled=true \
    --set persistence.size=8Gi

# kubectl scale --replicas 3 statefulset etcd -n geek-apps
```

### 测试服务

#### 集群内部测试

```bash
$ kubectl run etcd-client --restart='Never' --image docker.io/bitnami/etcd:3.5.1-debian-10-r0 --env ROOT_PASSWORD=$(kubectl get secret --namespace geek-apps etcd -o jsonpath="{.data.etcd-root-password}" | base64 --decode) --env ETCDCTL_ENDPOINTS="etcd.geek-apps.svc.cluster.local:2379" --namespace geek-apps --command -- sleep infinity
$ kubectl exec --namespace geek-apps -it etcd-client -- bash
```

```bash
$ etcdctl --user root:$ROOT_PASSWORD endpoint health
etcd.geek-apps.svc.cluster.local:2379 is healthy: successfully committed proposal: took = 5.63007ms

$ etcdctl --user root:$ROOT_PASSWORD put /message Hello
OK
$ etcdctl --user root:$ROOT_PASSWORD get /message
/message
Hello
```

#### 集群外部测试

> 设置`K8S DNS`作为本地DNS

##### On Linux

编辑`/etc/resolv.conf`，在文件中添加如下信息：

```ini
nameserver 192.168.1.130
search dev.svc.cluster.local svc.cluster.local cluster.local
options ndots:5
```

##### On macOS

系统偏好设置-网络-高级-DNS

![DNS Config on macOS](https://gallery.zizhizhan.com:8443/images/awesome-k8s/originals/dns-on-macos.png)

##### On Windows

快速打开网络连接(或者`Win+r`输入`ncpa.cpl`)-选择本地以太网-右键属性-选择Internet协议版本4(TCP/IPv4)，只填写当前需要连接的DNS即可。

![DNS Config on Windows](https://gallery.zizhizhan.com:8443/images/awesome-k8s/originals/dns-on-windows.png)

```bash
$ nc -vz etcd.geek-apps.svc.cluster.local 2379
$ nc -vz etcd.geek-apps.svc.cluster.local 2380

$ brew install ectd
$ export ETCD_ROOT_PASSWORD=$(kubectl get secret --namespace geek-apps etcd -o jsonpath="{.data.etcd-root-password}" | base64 --decode)
$ etcdctl --user root:$ROOT_PASSWORD endpoint health

$ etcdctl --user root:$ROOT_PASSWORD put /message Hello
$ etcdctl --user root:$ROOT_PASSWORD get /message
```