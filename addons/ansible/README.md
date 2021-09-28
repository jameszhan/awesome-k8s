
#### Calico

```bash
$ curl https://docs.projectcalico.org/manifests/calico-etcd.yaml -o calico-etcd-origin.yaml

ETCD_CA=$(cat /etc/etcd/ssl/ca.pem | base64 | tr -d '\n')
ETCD_CERT=$(cat /etc/etcd/ssl/etcd.pem | base64 | tr -d '\n')
ETCD_KEY=$(cat /etc/etcd/ssl/etcd-key.pem | base64 | tr -d '\n')
```

```bash
$ ansible-playbook -i hosts deploy-calico.yml -u deploy -v
```