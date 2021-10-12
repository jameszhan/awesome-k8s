#### 快速启动一个`Pod`

```bash
$ kubectl apply -f templates/hello-nginx.yml

$ kubectl port-forward --address 0.0.0.0 pod/hello-nginx 8080:80

$ curl -v http://localhost:8080

$ kubectl delete pod/hello-nginx 
```

#### 测试`NFS`挂载

```bash
$ kubectl apply -f templates/hello-nfs-deploy.yml

$ kubectl get pod | grep -E '^hello-nfs-' | awk '{print $1}' | xargs -i kubectl exec -it {} -- cat /dir/data

$ kubectl delete -f templates/hello-nfs-deploy.yml
```

#### 部署一个图片服务应用

```bash
$ kubectl create configmap nginx-server-config -n geek-apps --from-file=templates/default.conf
$ kubectl get cm nginx-server-config -n geek-apps -o yaml

$ kubectl apply -f nginx-gallery.deployment.yml
```

强制更新部署

```bash
$ kubectl replace --force -f nginx-gallery.deploy.yaml
```