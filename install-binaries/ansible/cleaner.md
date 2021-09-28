#### 恢复原始配置

```bash
$ ansible -m script -a 'cleaner/clean-setup-once.sh' -i hosts all -u deploy --become -v
$ ansible -i hosts all -m reboot -u deploy --become -v
```


#### 清理node节点

```bash
$ ansible -m script -a 'cleaner/clean-kubelet.sh' -i hosts k8s_nodes -u deploy --become -v
$ ansible -m script -a 'cleaner/clean-docker.sh' -i hosts k8s_nodes -u deploy --become -v
$ ansible -i hosts k8s_nodes -m reboot -u deploy --become -v
```

#### 清理ha配置

```bash
$ ansible -m script -a 'cleaner/clean-ha.sh' -i hosts k8s_masters -u deploy --become -v
```

#### 清理master节点

```bash
$ ansible -m script -a 'cleaner/clean-k8s-master.sh' -i hosts k8s_masters -u deploy --become -v

$ ansible -i hosts k8s_masters -m reboot -u deploy --become -v
```

#### 清理etcd节点

```bash
$ ansible -m script -a 'cleaner/clean-etcd.sh' -i hosts k8s_masters -u deploy --become -v

$ ansible -i hosts k8s_masters -m reboot -u deploy --become -v
```