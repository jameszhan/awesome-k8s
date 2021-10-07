## 环境准备
### 子网划分

| 网段信息     | 配置           |
| ------------| --------------|
| Host 网段    | 192.168.1.1/24 |
| Pod 网段     | 10.244.0.0/16  |
| Service 网段 | 10.96.0.0/12   |

### 准备通用环境

#### 创建新用户`deploy`

在创建新用户前，你只需要有任意一个用户可以免登到对应的服务器上即可。

```bash
$ ansible-playbook -i hosts -c paramiko --ask-pass --ask-become-pass user-deploy.yml -v
```

详细脚本过程参考：

- [Ubuntu 环境下新增新用户](01.add-deploy-user.md)


## 附录

### 快速操作

#### 检查服务

```bash
$ ansible -m shell -a "systemctl status chrony" -i hosts all -u deploy --become -v
$ ansible -m shell -a "chronyc tracking" -i hosts all -u deploy --become -v

$ ansible -m shell -a "docker ps" -i hosts k8s_nodes -u deploy -v
$ ansible -m shell -a "systemctl status docker" -i hosts k8s_nodes -u deploy --become -v

$ ansible -m shell -a "journalctl -xe" -i hosts k8s_nodes -u deploy --become -v
```

#### 重置防火墙设置

```bash
$ ansible -m shell -a "iptables -L" -i hosts all -u deploy --become -v
$ ansible -m shell -a "iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X" -i hosts all -u deploy --become -v
$ ansible -m shell -a "iptables -P INPUT ACCEPT && iptables -P FORWARD ACCEPT && iptables -P OUTPUT ACCEPT && iptables -F" \
    -i hosts all -u deploy --become -v
$ ansible -m shell -a "iptables -t nat -nL" -i hosts all -u deploy --become -v
```

#### 集群设定

```bash
$ kubectl api-resources
$ kubectl get clusterroles 
$ kubectl create clusterrolebinding kube-proxy-binding --clusterrole=system:node-proxier --user=kube-proxy
```

### 快速命令

#### 重启服务

```bash
$ ansible -i hosts all -m reboot -u deploy --become -v

$ ansible -i hosts k8s_nodes -m reboot -u deploy --become -v

$ ansible -i hosts k8s_masters -m reboot -u deploy --become -v
```

#### 批量设置免登

```bash
$ for h in k8s-master01 k8s-master02 k8s-master03; do ssh-copy-id -i ~/.ssh/id_rsa.pub james@$h; done
```



