#### 准备工作(可选)

```bash
$ ansible -i hosts all -m reboot -u deploy --become -v
$ ansible -m script -a 'scripts/kubernetes-service.sh' -i hosts all -u deploy --become -v

$ ansible -i hosts all -m shell -a "ipvsadm -Ln" -u deploy --become -v
```

```bash
$ sudo ipvsadm -Ln

$ nc -vz 192.168.1.129 443
$ curl -i --cacert /etc/kubernetes/ssl/ca.pem --cert /etc/kubernetes/ssl/admin.pem --key /etc/kubernetes/ssl/admin-key.pem https://192.168.1.129/version
```

#### Calico

```bash
$ ansible -i hosts k8s_nodes -m shell -a 'rm -vrf /etc/cni/net.d/*' -u deploy --become -v
$ ansible -i hosts k8s_nodes -m shell -a 'rm -vrf /var/lib/cni/calico' -u deploy --become -v
$ ansible -i hosts k8s_nodes -m shell -a 'systemctl restart kubelet' -u deploy --become -v

$ curl https://docs.projectcalico.org/manifests/calico-etcd.yaml -o calico-etcd.yaml

$ ansible-playbook -i hosts deploy-calico.yml -u deploy -v

$ ansible-playbook -i hosts deploy-coredns.yml -u deploy -v
```