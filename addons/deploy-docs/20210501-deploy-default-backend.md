## 部署`Nginx`服务

### 配置`Nginx`服务

```bash
$ kubectl create configmap default-nginx-conf -n geek-apps --from-file=default.conf=templates/config/default-nginx.conf
$ kubectl get cm default-nginx-conf -n geek-apps  -o yaml

$ kubectl apply -f templates/default-backend-deploy.yaml

$ kubectl get services -n geek-apps -o wide
$ kubectl get endpoints -n geek-apps -o wide
$ kubectl get ingress -n geek-apps -o wide
```

### 测试Nginx服务

```bash
$ kubectl run cirros-$RANDOM -n geek-apps --rm -it --image=cirros -- sh
```

```bash
$ curl -i http://nginx-pkm-service/
$ wget -O - nginx-pkm-service
```