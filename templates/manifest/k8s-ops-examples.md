

```bash
$ kubectl run cirros-$RANDOM --rm -it --image=cirros -- sh

$ kubectl run my-nginx --image=nginx --port=80
$ kubectl port-forward --address 0.0.0.0 pod/my-nginx 8080:80


$ kubectl create deployment nginx --image=nginx

```