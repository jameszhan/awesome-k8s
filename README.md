

## 二进制安装高可用K8S集群

```bash
$ cd install-binaries/ansible

$ ansible-playbook -i hosts etcd.yml -u deploy -v

$ ansible-playbook -i hosts k8s-master.yml -u deploy -v
$ ansible-playbook -i hosts k8s-ha.yml -u deploy -v

$ ansible-playbook -i hosts k8s-node.yml -u deploy -v
```