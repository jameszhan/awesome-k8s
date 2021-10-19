## TL;DR

```bash
$ curl https://docs.projectcalico.org/manifests/calico.yaml -o templates/calico.yaml
$ kubectl apply -f templates/calico.yaml
```

> 可以按需定制`calico.yaml`配置，比如引入新环境变量: 

```yaml
env:
  - name: IP_AUTODETECTION_METHOD
    value: "interface=(eth0|enp1s0|ens33)"
  - name: CALICO_IPV4POOL_CIDR
    value: "10.244.0.0/16"
```

当然新环境变量配置，也可以部署完成后再调整

```bash
$ kubectl set env daemonset/calico-node -n kube-system IP_AUTODETECTION_METHOD=interface="(eth0|enp1s0|ens33)"
$ kubectl set env daemonset/calico-node -n kube-system CALICO_IPV4POOL_CIDR=interface="10.244.0.0/16"
```