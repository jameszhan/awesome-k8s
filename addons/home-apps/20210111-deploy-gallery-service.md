
#### 创建`BasicAuth`密码

```bash
$ echo "admin:`openssl passwd -crypt YOURPASS`" > templates/nginx-conf/auth.users
```

#### 部署一个图片服务应用

```bash
$ kubectl create configmap nginx-basicauth-conf -n geek-apps --from-file=default.conf=templates/nginx-conf/basicauth.conf
$ kubectl create configmap nginx-auth-users -n geek-apps --from-file=templates/nginx-conf/auth.users

$ kubectl get cm nginx-basicauth-conf -n geek-apps -o yaml
$ kubectl get cm nginx-auth-users -n geek-apps -o yaml

$ kubectl apply -f templates/nginx-gallery.deploy.yaml

# 允许访问图片文件，不允许浏览目录
$ open https://gallery.zizhizhan.com/dedao/daily-listening/1568467861548.png

# 允许浏览目录，但需要认证
$ open https://admin.zizhizhan.com
```

#### 强制更新部署

```bash
$ kubectl replace --force -f templates/nginx-gallery.deploy.yaml
```