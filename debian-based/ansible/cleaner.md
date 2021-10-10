
#### 清理node节点

```bash
$ ansible -m script -a 'cleaner/clean-docker.sh' -i hosts k8s_nodes -u deploy -v
$ ansible -i hosts k8s_nodes -m reboot -u deploy --become -v
$ ansible -m shell -a "kubeadm reset" --become -v
$ ansible -m apt -a "name=kubectl,kubeadm,kubelet state=absent autoremove=yes" --become --vv k8s
```

