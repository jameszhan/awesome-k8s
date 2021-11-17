```bash
$ ansible-playbook -i hosts gathering-facts.yml -u deploy -v 
```

```bash
$ ansible -m shell -a 'mkdir -p /opt/bin' -i hosts all -u deploy --become -v
$ ansible -m shell -a 'chmod g+w /opt/bin' -i hosts all -u deploy --become -v
$ ansible -m shell -a 'chown -R root:sudo /opt/bin' -i hosts all -u deploy --become -v

$ for h in k8s-master01 k8s-master02 k8s-master03 k8s-node021 k8s-node022; do scp /opt/bin/update-system.sh deploy@$h:/opt/bin; done
$ ansible -m shell -a 'bash /opt/bin/update-system.sh' -i hosts all -u deploy --become -v
```

#### 清理node节点

```bash
$ ansible -m script -a 'cleaner/clean-k8s-node.sh' -i hosts k8s_nodes -u deploy --become -v
$ ansible -m script -a 'cleaner/clean-docker.sh' -i hosts k8s_nodes -u deploy --become -v

# 或者
$ cd ../../debian-based/ansible && ansible -m script -a 'cleaner/clean-docker.sh' -i hosts k8s_nodes -u deploy --become -v && cd ../../install-binaries/ansible

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

#### 清除通用设置

```bash
$ ansible -m shell -a "ls /etc/modules-load.d/" -i hosts all -u deploy --become -v
$ ansible -m shell -a "ls /etc/sysctl.d/" -i hosts all -u deploy --become -v
$ ansible -m shell -a "ls /etc/chrony/" -i hosts all -u deploy --become -v

$ ansible -m shell -a "rm -vrf /var/log/journal" -i hosts all -u deploy --become -v
```

```bash
$ ansible -m script -a 'cleaner/clean-setup-once.sh' -i hosts all -u deploy --become -v

$ ansible -m shell -a "iptables -L" -i hosts all -u deploy --become -v
$ ansible -m shell -a "iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X" -i hosts all -u deploy --become -v
$ ansible -m shell -a "iptables -L" -i hosts all -u deploy --become -v

$ ansible -i hosts all -m reboot -u deploy --become -v
```
