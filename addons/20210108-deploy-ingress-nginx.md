## TL;NR

```bash
$ helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

# 按需调整配置
$ helm show values ingress-nginx/ingress-nginx > templates/ingress-nginx-values.yaml

$ helm template -f templates/ingress-nginx-values.yml -n ingress-nginx --debug ingress-nginx ingress-nginx/ingress-nginx
```

## 部署`ingress-nginx`

### 准备工作

#### 准备镜像

```bash
# k8s.gcr.io/ingress-nginx/kube-webhook-certgen:v1.0@sha256:f3b6b39a6062328c095337b4cadcefd1612348fdd5190b1dcbcb9b9e90bd8068
# sha256:597784742b823bfab67dc1a987fd889a30119059ecf51bf7ba9a0958bab88dc7
$ docker pull registry.cn-shenzhen.aliyuncs.com/jameszhan/ingress-nginx_kube-webhook-certgen:v1.0

# k8s.gcr.io/ingress-nginx/controller:v1.0.3@sha256:4ade87838eb8256b094fbb5272d7dda9b6c7fa8b759e6af5383c1300996a7452
# sha256:8b1011b1f6f3be2c9180bffe2313b8ee55213f965b40d1c99a77e3688a4778ab
$ docker pull registry.cn-shenzhen.aliyuncs.com/jameszhan/ingress-nginx-controller:v1.0.3

# k8s.gcr.io/defaultbackend-amd64:1.5
# sha256:234a69266f80d440161d89c4603a37a0e6514d5a503d0dddfaf17945a2acfc79
$ docker pull registry.cn-shenzhen.aliyuncs.com/jameszhan/defaultbackend-amd64:1.5
```

#### 准备`Helm chart`

```bash
$ helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
$ helm repo update

$ helm search repo ingress-nginx

# 按需调整配置
$ helm show values ingress-nginx/ingress-nginx > templates/ingress-nginx-values.yaml

# 安装前先需要替换准备好的镜像
$ helm template -f templates/ingress-nginx-values.yml -n ingress-nginx --debug ingress-nginx ingress-nginx/ingress-nginx
```

### 安装及升级

#### 安装`ingress-nginx`

```bash
# helm pull ingress-nginx/ingress-nginx
$ helm uninstall ingress-nginx -n ingress-nginx 
# helm install ingress-nginx ingress-nginx/ingress-nginx
$ helm install -f templates/ingress-nginx-values.yml --create-namespace -n ingress-nginx --debug ingress-nginx ingress-nginx/ingress-nginx
# [install-notes](../../appendix/templates/banners/ingress-nginx-install-notes.txt)
```

#### 下载到本地安装(可选)

```bash
$ helm pull ingress-nginx/ingress-nginx
$ tar -zxvf ingress-nginx-3.12.0.tgz

# 根据需要调整ingress-nginx/values.yaml中的配置
$ helm install -f ingress-nginx/values.yaml ingress-nginx/ingress-nginx --n geek-apps --generate-name
```

#### 升级`ingress-nginx`

```bash
$ helm upgrade -f templates/ingress-nginx-values.yml -n ingress-nginx --debug ingress-nginx ingress-nginx/ingress-nginx
```

## 更新`ingress`配置

### 启用`IP`及`GEO`日志

```bash
$ kubectl get cm ingress-nginx-controller -n ingress-nginx -o yaml
$ kubectl apply -f templates/ingress-nginx/controller-configmap.yaml
$ kubectl get cm ingress-nginx-controller -n ingress-nginx -o yaml

$ kubectl logs -f pod/ingress-nginx-controller-97d87b6ff-4r8r6 -n ingress-nginx
$ kubectl logs -f pod/ingress-nginx-controller-97d87b6ff-cd7s5 -n ingress-nginx
```

## 证书管理

```bash
$ kubectl get secret ingress-nginx-admission -n ingress-nginx -o yaml

# 查看已有证书
$ kubectl get secret --field-selector type=kubernetes.io/tls -A
```

### 导入`DNSPod`证书

从[我的证书](https://console.cloud.tencent.com/ssl)下载对应的证书并解压。

```bash
$ unzip -d zizhizhan.com zizhizhan.com.zip
$ unzip -d www.zizhizhan.com www.zizhizhan.com.zip
$ unzip -d blog.zizhizhan.com blog.zizhizhan.com.zip
```

#### 导入`zizhizhan.com`证书

```bash
$ kubectl delete secret zizhizhan.com-tls -n geek-apps
$ kubectl create secret tls zizhizhan.com-tls --cert=zizhizhan.com/Nginx/1_zizhizhan.com_bundle.crt --key=zizhizhan.com/Nginx/2_zizhizhan.com.key -n geek-apps
$ kubectl get secret zizhizhan.com-tls -n geek-apps -o yaml
```

#### 导入`www.zizhizhan.com`证书

```bash
$ kubectl delete secret www.zizhizhan.com-tls -n geek-apps
$ kubectl create secret tls www.zizhizhan.com-tls --cert=www.zizhizhan.com/Nginx/1_www.zizhizhan.com_bundle.crt --key=www.zizhizhan.com/Nginx/2_www.zizhizhan.com.key -n geek-apps
$ kubectl get secret www.zizhizhan.com-tls -n geek-apps -o yaml
```

#### 导入`blog.zizhizhan.com`证书

```bash
$ kubectl delete secret blog.zizhizhan.com-tls -n geek-apps
$ kubectl create secret tls blog.zizhizhan.com-tls --cert=blog.zizhizhan.com/Nginx/1_blog.zizhizhan.com_bundle.crt --key=blog.zizhizhan.com/Nginx/2_blog.zizhizhan.com.key -n geek-apps
$ kubectl get secret blog.zizhizhan.com-tls -n geek-apps -o yaml
```

### 泛域名证书

> `DNSPod`不支持免费的泛域名证书，因此我们需要借助[Let's Encrypt](https://letsencrypt.org/)和`certbot`来创建。

#### 创建泛域名证书

##### 安装`certbot`

```bash
$ sudo snap install --classic certbot

$ certbot --version
```

##### 创建证书

```bash
$ dig -t txt _acme-challenge.zizhizhan.com @8.8.8.8
$ sudo certbot certonly -d "*.zizhizhan.com" --manual \
    --preferred-challenges dns \
    --email zhiqiangzhan@gmail.com \
    --server https://acme-v02.api.letsencrypt.org/directory \
    --dry-run

$ sudo certbot certonly -d "*.zizhizhan.com" --manual \
    --preferred-challenges dns \
    --email zhiqiangzhan@gmail.com \
    --server https://acme-v02.api.letsencrypt.org/directory

$ dig -t txt _acme-challenge.zizhizhan.com @8.8.8.8
# ;; ANSWER SECTION:
# _acme-challenge.zizhizhan.com. 599 IN	TXT	"7woEDmk_daN8oJWrP7UCEGymQNgZAf21GMX1AM6kTak"

# 生成文件如下
$ ls -lah /etc/letsencrypt/live/zizhizhan.com
lrwxrwxrwx 1 root root   37 10月  9 19:11 cert.pem -> ../../archive/zizhizhan.com/cert1.pem
lrwxrwxrwx 1 root root   38 10月  9 19:11 chain.pem -> ../../archive/zizhizhan.com/chain1.pem
lrwxrwxrwx 1 root root   42 10月  9 19:11 fullchain.pem -> ../../archive/zizhizhan.com/fullchain1.pem
lrwxrwxrwx 1 root root   40 10月  9 19:11 privkey.pem -> ../../archive/zizhizhan.com/privkey1.pem
```

##### 自动配置续期

```bash
$ sudo crontab -e
```

> 每隔`10`天，夜里`3`点整自动执行检查续期命令一次。

```crontab
0 3 */10 * * /snap/bin/certbot renew --renew-hook "echo \"renew success @ $(date)\" >> /tmp/certbot-renew.txt"
```

#### 导入证书

```bash
$ kubectl delete secret star.zizhizhan.com-tls -n geek-apps

$ mkdir star.zizhizhan.com

# 复制备份证书
$ sudo su
$ cp -r /etc/letsencrypt/archive/zizhizhan.com/*.pem star.zizhizhan.com/
$ chown -R james:sudo star.zizhizhan.com
$ exit

$ kubectl create secret tls star.zizhizhan.com-tls --cert=star.zizhizhan.com/fullchain1.pem --key=star.zizhizhan.com/privkey1.pem -n geek-apps
$ kubectl get secret star.zizhizhan.com-tls -n geek-apps -o yaml
```

## 配置`ingress-nginx`

### 代理集群外服务

#### 代理`Synology DSM`

```bash
$ kubectl apply -f templates/ingress/synology-dsm.yml

$ kubectl get ep -n geek-apps -o wide
$ kubectl get svc -n geek-apps -o wide
$ kubectl get ingress -n geek-apps -o wide

# 192.168.1.203 是 ingress-nginx-controller 服务的 CLUSTER-IP
$ curl -v -k -H "Host: dsm.zizhizhan.com" https://192.168.1.203

$ open https://dsm.zizhizhan.com

# 强制更新
$ kubectl replace --force -f templates/ingress/synology-dsm.yml
```

#### 代理小米路由器

```bash
$ kubectl apply -f templates/ingress/xiaomi-router.yml

$ kubectl get ep -n geek-apps -o wide
$ kubectl get svc -n geek-apps -o wide
$ kubectl get ingress -n geek-apps -o wide

$ curl -v -k -X GET \
    -H "Host: mi.zizhizhan.com" \
    https://192.168.1.203

$ open https://mi.zizhizhan.com

# 强制更新
$ kubectl replace --force -f templates/ingress/xiaomi-router.yml
```

### 代理集群内服务

#### 代理`Kubernetes Dashboard`

```bash
$ kubectl apply -f templates/ingress/kubernetes-dashboard.yml

$ kubectl get svc -n geek-apps
$ kubectl get ingress -n geek-apps
$ kubectl describe ingress -n geek-apps

$ open https://k8s.zizhizhan.com

$ curl -v -k -X GET \
    -H "Host: k8s.zizhizhan.com" \
    https://192.168.1.203
```

代理不同`NS`服务，`ingress`只能代理同`NS`服务，因此，需要在service层做一层转发。
Kubernetes Observability

```bash
$ dig -t A kubernetes-dashboard.kubernetes-dashboard.svc.cluster.local @192.168.1.130
$ dig -t A kubernetes-dashboard.geek-apps.svc.cluster.local @192.168.1.130

$ kubectl run cirros-$RANDOM --rm -it --image=cirros -- sh
```
> 提示：CirrOS是设计用来进行云计算环境测试的Linux微型发行版，它拥有HTTP客户端工具curl等。

```bash
$ curl -v -k https://kubernetes-dashboard.kubernetes-dashboard.svc.cluster.local
$ curl -v -k https://kubernetes-dashboard.geek-apps.svc.cluster.local
```

## 附录

#### 参考资料

- [Ingress Nginx](https://github.com/kubernetes/ingress-nginx)
- [DNSPod 我的证书](https://console.cloud.tencent.com/ssl)
- [Let's Encrypt 证书](https://letsencrypt.org/)
