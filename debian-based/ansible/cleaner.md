
#### 清理node节点

```bash
$ ansible -i k8s-local.cfg k8s_nodes -m script -a 'cleaner/clean-docker.sh' -u deploy -v
$ ansible -i k8s-local.cfg k8s_nodes -m script -a 'cleaner/clean-k8s-node.sh' -u deploy -v

$ ansible -i k8s-local.cfg all -m script -a "/opt/bin/update-system.sh" -u deploy --become -v
$ ansible -i k8s-local.cfg k8s_nodes -m reboot -u deploy --become -v
```