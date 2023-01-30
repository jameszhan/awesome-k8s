# `k8s` 部署单节点 `Redis`

```bash
$ kubectl apply -n geek-apps -f templates/redis-standalone/redis-standalone-conf.yaml
$ kubectl apply -n geek-apps -f templates/redis-standalone/redis-standalone-deploy.yaml
$ kubectl apply -n geek-apps -f templates/redis-standalone/redis-standalone-service.yaml
```

