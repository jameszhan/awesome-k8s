## 添加`Helm Chart`仓库

```bash
$ helm repo add rancher-stable https://releases.rancher.com/server-charts/stable

# 内用户，可以使用放在国内的 Rancher Chart 加速安装
$ helm repo add rancher-stable http://rancher-mirror.oss-cn-beijing.aliyuncs.com/server-charts/stable

$ helm repo update
$ helm search repo rancher-stable
```

## 为`Rancher`创建`Namespace`

```bash
$ kubectl create namespace cattle-system
```

## 通过`Helm`安装`Rancher`

```bash
# 使用已有证书
$ cd /opt/etc/certs/star.zizhizhan.com
$ cp fullchain1.pem tls.crt
$ cp privkey1.pem tls.key
$ kubectl -n cattle-system create secret tls tls-rancher-ingress --cert=tls.crt --key=tls.key
$ kubectl -n cattle-system get secret tls tls-rancher-ingress -o yaml

# 安装rancher
$ helm show values rancher-stable/rancher
$ helm upgrade --install rancher rancher-stable/rancher \
    --namespace cattle-system \
    --set hostname=rancher.zizhizhan.com \
    --set replicas=2 \
    --set ingress.tls.source=secret

# 增加 kubernetes.io/ingress.class: nginx 到 annotations
$ kubectl -n cattle-system edit ingress rancher 
```

## 使用`Rancher`服务

```bash
# 初始化Rancher，现获取secret
$ kubectl get secret --namespace cattle-system bootstrap-secret -o go-template='{{.data.bootstrapPassword|base64decode}}{{ "\n" }}'

# 把上面获取到的secret作为setup的参数，然后访问地址
$ open https://rancher.zizhizhan.com/dashboard/?setup=YOUR-SECRET
```

> 访问 `https://rancher.zizhizhan.com/g/clusters` 管理集群

## 移除`Rancher`服务

下载[system-tools](https://github.com/rancher/system-tools/releases)，`system-tools`是`Rancher`自带的运维工具，您可以使用系统工具管理`RKE`集群和高可用集群。系统工具提供了`logs`、`stats`和`remove`三类指令，分别对应以下三种用途：
- 收集`Kubernetes`日志：从节点收集`Kubernetes`集群组件的日志。
- 查看节点系统指标：从节点收集系统指标。
- 移除`Kubernetes`资源：移除`Kubernetes`集群内`Rancher`创建的资源。

此处我们主要用其移除功能，下载好对应的`system-tools`文件后，把其命名为`system-tools`，并赋予其可执行权限。

```bash
$ system-tools remove --kubeconfig ~/.kube/config -n cattle-system
```