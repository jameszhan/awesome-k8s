

```bash
$ kubectl create configmap nginx-server-config --from-file=./nginx/default.conf

# 卸载所有服务
$ ls *.yml | xargs -i  microk8s.kubectl delete -f {}
```


```bash
$ ansible-playbook -i hosts microk8s_init.yml -v
```