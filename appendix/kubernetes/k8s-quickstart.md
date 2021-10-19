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
