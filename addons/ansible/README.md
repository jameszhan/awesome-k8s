#### Calico

```bash
$ curl https://docs.projectcalico.org/manifests/calico.yaml -o calico.yaml
$ kubectl apply -f calico.yaml
```

```bash
$ ansible-playbook -i hosts deploy-calico.yml -u deploy -v
```

#### CoreDNS

```bash
$ ansible-playbook -i hosts deploy-coredns.yml -u deploy -v
```

#### Metrics Server

```bash
$ ansible-playbook -i hosts deploy-metrics-server.yml -u deploy -v
```

#### 参考

- [Calico](https://docs.projectcalico.org/)
- [CoreDNS](https://coredns.io/)
- [Kubernetes Metrics Server](https://github.com/kubernetes-sigs/metrics-server)