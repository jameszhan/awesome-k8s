#### 部署一个图片服务应用

```bash
$ kubectl create configmap nginx-server-config -n geek-apps --from-file=templates/config/default.conf
$ kubectl get cm nginx-server-config -n geek-apps -o yaml

$ kubectl apply -f templates/nginx-gallery.deploy.yaml

$ open https://gallery.zizhizhan.com
```

#### 强制更新部署

```bash
$ kubectl replace --force -f templates/nginx-gallery.deploy.yaml
```