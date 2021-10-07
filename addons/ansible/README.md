#### Calico

```bash
$ curl https://docs.projectcalico.org/manifests/calico.yaml -o calico.yaml
$ kubectl apply -f calico.yaml
```

```bash
$ ansible-playbook -i hosts deploy-calico.yml -u deploy -v
```

### CoreDNS

```bash
$ ansible-playbook -i hosts deploy-coredns.yml -u deploy -v
```