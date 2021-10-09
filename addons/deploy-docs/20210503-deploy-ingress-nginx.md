
### 配置`ingress-nginx`

[Ingress Nginx](https://github.com/kubernetes/ingress-nginx)

#### 安装`ingress-nginx`

```bash
$ helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
$ helm repo update

$ helm search repo ingress-nginx

# helm pull ingress-nginx/ingress-nginx
$ helm template -f templates/ingress-nginx-values.yml -n ingress-nginx --debug ingress-nginx ingress-nginx/ingress-nginx
$ helm install -f templates/ingress-nginx-values.yml --create-namespace -n ingress-nginx --debug ingress-nginx ingress-nginx/ingress-nginx

$ kubectl --namespace ingress-nginx get services -o wide -w ingress-nginx-controller

$ kubectl apply -f templates/config/ingress-nginx/controller.yml
$ kubectl get cm ingress-nginx-controller -n ingress-nginx -o yaml

$ kubectl logs -f ingress-nginx-controller-768fdb7ccd-nsdpr -n ingress-nginx
```

#### 升级`ingress-nginx`

```bash
$ helm upgrade -f templates/ingress-nginx-values.yml --create-namespace -n ingress-nginx --debug ingress-nginx ingress-nginx/ingress-nginx
```

### 配置证书

```bash
$ kubectl create namespace geek-apps
$ kubectl get secret ingress-nginx-admission -n ingress-nginx -o yaml
$ kubectl get secret --field-selector type=kubernetes.io/tls -n geek-apps
$ kubectl get secret zizhizhan.com-tls -n geek-apps -o yaml
```

#### [DNSPod 证书](https://console.cloud.tencent.com/ssl)

##### `zizhizhan.com`

```bash
$ kubectl get secret -A --sort-by type
$ kubectl delete secret zizhizhan.com-tls -n geek-apps

$ cd /opt/var/certificates/zizhizhan.com/
$ kubectl create secret tls zizhizhan.com-tls --cert=Nginx/1_zizhizhan.com_bundle.crt --key=Nginx/2_zizhizhan.com.key -n geek-apps
$ kubectl get secret zizhizhan.com-tls -n geek-apps -o yaml
```

##### `blog.zizhizhan.com`

```bash
$ kubectl delete secret blog.zizhizhan.com-tls -n geek-apps
$ cd /opt/var/certificates/blog.zizhizhan.com/
$ kubectl create secret tls blog.zizhizhan.com-tls --cert=Nginx/1_blog.zizhizhan.com_bundle.crt --key=Nginx/2_blog.zizhizhan.com.key -n geek-apps
$ kubectl get secret blog.zizhizhan.com-tls -n geek-apps -o yaml
```

##### `www.zizhizhan.com`

```bash
$ cd /opt/var/certificates/www.zizhizhan.com/
$ kubectl create secret tls www.zizhizhan.com-tls --cert=Nginx/1_www.zizhizhan.com_bundle.crt --key=Nginx/2_www.zizhizhan.com.key -n geek-apps
$ kubectl get secret www.zizhizhan.com-tls -n geek-apps -o yaml
```

#### [Let's Encrypt 证书](https://letsencrypt.org/)

```bash
$ dig -t txt _acme-challenge.zizhizhan.com @8.8.8.8
$ sudo certbot certonly -d *.zizhizhan.com --manual \
    --preferred-challenges dns \
    --email zhiqiangzhan@gmail.com \
    --server https://acme-v02.api.letsencrypt.org/directory \
    --dry-run

$ sudo certbot certonly -d *.zizhizhan.com --manual \
    --preferred-challenges dns \
    --email zhiqiangzhan@gmail.com \
    --server https://acme-v02.api.letsencrypt.org/directory

$ dig -t txt _acme-challenge.zizhizhan.com @8.8.8.8
# ;; ANSWER SECTION:
# _acme-challenge.zizhizhan.com. 599 IN	TXT	"7woEDmk_daN8oJWrP7UCEGymQNgZAf21GMX1AM6kTak"

$ sudo su - root
$ mkdir -p /opt/var/letsencrypt
$ cp -r /etc/letsencrypt/archive/zizhizhan.com /opt/var/letsencrypt
$ chown -R james:sudo /opt/var/
$ exit

$ sudo crontab -e
```

> 每隔 10 天，夜里 3 点整自动执行检查续期命令一次。

```crontab
0 3 */10 * * /usr/bin/certbot renew --renew-hook "echo \"renew success @ $(date)\" >> /tmp/certbot-renew.txt"
```

```bash
$ scp -r k8s-node029:/opt/var/letsencrypt/zizhizhan.com /opt/var/certificates
$ mv zizhizhan.com star.zizhizhan.com

$ kubectl get secret -A --sort-by type
$ kubectl delete secret star.zizhizhan.com-tls -n geek-apps

$ cd /opt/var/certificates/star.zizhizhan.com/
$ kubectl create secret tls star.zizhizhan.com-tls --cert=fullchain1.pem --key=privkey1.pem -n geek-apps
```

### 配置`Nginx`

#### 代理已有服务

##### 代理`Synology DSM`

```bash
$ kubectl apply -f templates/ingress/synology-dsm.yml

$ kubectl get ep -n geek-apps -o wide
$ kubectl get svc -n geek-apps -o wide
$ kubectl get ingress -n geek-apps -o wide

$ open https://dsm.zizhizhan.com:8443
```

##### 代理小米路由器

```bash
$ kubectl apply -f templates/ingress/xiaomi-router.yml

$ kubectl get ep -n geek-apps -o wide
$ kubectl get svc -n geek-apps -o wide
$ kubectl get ingress -n geek-apps -o wide

$ open https://mi.zizhizhan.com

$ curl -i -X GET \
    -H "Host: mi.zizhizhan.com" \
    https://mi.zizhizhan.com:8443/
```

#### Kubernetes Observability
##### Kubernetes Dashboard

```bash
$ dig -t A kubernetes-dashboard.kubernetes-dashboard.svc.cluster.local @10.96.0.10
$ dig -t A kubernetes-dashboard.geek-apps.svc.cluster.local @10.96.0.10

$ kubectl run cirros-$RANDOM --rm -it --image=cirros -- sh
```
> 提示：CirrOS是设计用来进行云计算环境测试的Linux微型发行版，它拥有HTTP客户端工具curl等。

```bash
$ curl -i kubernetes-dashboard.kubernetes-dashboard.svc.cluster.local
$ curl -i kubernetes-dashboard.geek-apps.svc.cluster.local
```

```bash
$ kubectl apply -f templates/ingress/kubernetes-dashboard.yml

$ kubectl get svc -n geek-apps
$ kubectl get ingress -n geek-apps
$ kubectl describe ingress -n geek-apps

$ open https://k8s.zizhizhan.com:8443
$ kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')
```