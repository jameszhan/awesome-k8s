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

#### Kuboard

```bash
$ sudo docker run -d \
  --restart=unless-stopped \
  --name=kuboard \
  -p 80:80/tcp \
  -p 10081:10081/tcp \
  -e KUBOARD_ENDPOINT="http://192.168.1.118:80" \
  -e KUBOARD_AGENT_SERVER_TCP_PORT="10081" \
  -v /root/kuboard-data:/data \
  eipwork/kuboard:v3

$ ansible-playbook -i hosts deploy-kuboard.yml -u deploy -v
```

#### 参考

- [Calico](https://docs.projectcalico.org/)
- [CoreDNS](https://coredns.io/)
- [Kubernetes Metrics Server](https://github.com/kubernetes-sigs/metrics-server)
- [Kuboard](https://kuboard.cn/)