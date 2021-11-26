## 部署`Default Backend Nginx`服务

### 导入`Nginx`配置

```bash
$ kubectl create configmap nginx-autoindex-conf -n geek-apps --from-file=default.conf=templates/nginx-conf/autoindex.conf
$ kubectl get cm nginx-autoindex-conf -n geek-apps -o yaml
```

### 部署`defaultBackend`服务

```bash
$ kubectl apply -f templates/default-backend.deploy.yaml

$ kubectl get pv
$ kubectl get pvc -n geek-apps

$ kubectl get services -n geek-apps -o wide
$ kubectl get endpoints -n geek-apps -o wide
$ kubectl get ingress -n geek-apps -o wide
```

#### 测试`Nginx`服务

```bash
$ kubectl run cirros-$RANDOM -n geek-apps --rm -it --image=cirros -- sh
```

```bash
$ curl -v http://default-backend-service/
$ wget -O - default-backend-service
```

#### 访问`Ingress`服务

```bash
$ open https://dl.zizhizhan.com
$ open https://dl2.zizhizhan.com
```