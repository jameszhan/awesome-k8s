

```bash
$ wget --output-document=calico-v3.19.yaml https://docs.projectcalico.org/v3.19/manifests/calico.yaml

$ wget --output-document=calico-v3.20.yaml https://docs.projectcalico.org/v3.20/manifests/calico.yaml

$ curl https://docs.projectcalico.org/manifests/calico-etcd.yaml -o calico-etcd.yaml

$ curl https://docs.projectcalico.org/manifests/calicoctl.yaml -O

$ curl  https://docs.projectcalico.org/archive/v3.20/manifests/tigera-operator.yaml -O    
```

```bash
$ cat <<EOF | kubectl apply -f -
kind: ConfigMap
apiVersion: v1
metadata:
  name: kubernetes-services-endpoint
  namespace: kube-system
data:
  KUBERNETES_SERVICE_HOST: "192.168.1.100"
  KUBERNETES_SERVICE_PORT: "8443"
EOF
```