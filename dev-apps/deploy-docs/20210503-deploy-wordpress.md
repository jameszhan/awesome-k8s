

### 部署前准备

#### 创建数据库

```sql
CREATE DATABASE IF NOT EXISTS wordpress DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
GRANT ALL PRIVILEGES ON wordpress.* TO deploy@'192.168.1.%' IDENTIFIED BY 'YOUR-PASSWORD' WITH GRANT OPTION;
```

#### 熟悉相关配置

- [Docker Image for WordPress](https://github.com/bitnami/bitnami-docker-wordpress): 可以查询WP相关环境变量配置
- [Wordpress Helm Chart](https://github.com/bitnami/charts/tree/master/bitnami/wordpress): 可以查看chart相关配置

#### 准备`Helm`资源

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm search repo wordpress
$ helm repo update

$ mkdir -p templates/wordpress
$ helm show values bitnami/wordpress > templates/wordpress/wordpress-values.yaml
```
> 按需定制相关`values`, 本例采用外部数据库，使用`csi-driver-nfs`挂载目录，并且启用`ingress`。

### 执行部署

#### 确认配置

```bash
$ helm template -f templates/wordpress/wordpress-values.yaml -n geek-apps wordpress bitnami/wordpress
```

#### 执行安装

```bash
$ helm upgrade --install -f templates/wordpress/wordpress-values.yaml -n geek-apps wordpress bitnami/wordpress
```

> 安装完提示如下：

Your WordPress site can be accessed through the following DNS name from within your cluster:

```conf
wordpress.geek-apps.svc.cluster.local (port 80)
```

To access your WordPress site from outside the cluster follow the steps below:

1. Get the WordPress URL and associate WordPress hostname to your cluster external IP:

```bash
export CLUSTER_IP=$(minikube ip) # On Minikube. Use: `kubectl cluster-info` on others K8s clusters
echo "WordPress URL: http://blog.zizhizhan.com/"
echo "$CLUSTER_IP  blog.zizhizhan.com" | sudo tee -a /etc/hosts
```

2. Open a browser and access WordPress using the obtained URL.

3. Login with the following credentials below to see your blog:
```bash
echo Username: james
echo Password: $(kubectl get secret --namespace geek-apps wordpress -o jsonpath="{.data.wordpress-password}" | base64 --decode)
```

You can access Apache Prometheus metrics following the steps below:

1. Get the Apache Prometheus metrics URL by running:
```bash
kubectl port-forward --namespace geek-apps svc/wordpress-metrics 9117:9117 &
echo "Apache Prometheus metrics URL: http://127.0.0.1:9117/metrics"
```

2. Open a browser and access Apache Prometheus metrics using the obtained URL.