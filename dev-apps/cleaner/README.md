#### Remove Nacos

```bash
$ kubectl delete statefulset nacos -n geek-apps
$ kubectl delete cm nacos-cm -n geek-apps
$ kubectl delete svc nacos-headless -n geek-apps
$ kubectl delete svc nacos-service -n geek-apps
$ kubectl delete ingress nacos-ingress -n geek-apps
```