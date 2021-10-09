

### Install Ansible

```bash
$ python -m ensurepip
$ python -m pip install -v --upgrade ansible
$ ansible --version
```

### Ansible 常用模块
- setup
- copy
- synchronize
- file
- ping
- group
- user
- shell
- script
- get_url
- yum
- cron
- service

### 命令实操

```bash
$ ansible-doc -s command
$ ansible-doc -s shell
$ ansible-doc -s script
```

```bash
$ ansible -i hosts all -m shell -a "ipvsadm -Ln" -u deploy --become -v
```

```bash
$ ansible -i hosts k8s_nodes -m shell -a 'rm -vrf /etc/cni/net.d/*' -u deploy --become -v
$ ansible -i hosts k8s_nodes -m shell -a 'rm -vrf /var/lib/cni/calico' -u deploy --become -v
$ ansible -i hosts k8s_nodes -m shell -a 'systemctl restart kubelet' -u deploy --become -v

# $ ansible -i hosts k8s_nodes -m shell -a "apt -y install apt-transport-https ca-certificates curl gnupg lsb-release" -u deploy --become -v
$ ansible -i hosts all -m apt -a "name=rsync state=latest autoremove=yes" -u deploy --become -v
# Fix reboot shutdown missing
$ ansible -i hosts all -m apt -a "name=systemd-sysv state=latest autoremove=yes" -u deploy --become -v
```

#### Remove Docker

```bash
$ ansible -i hosts k8s_nodes -m systemd -a "name=docker state=stopped enabled=no" -u deploy --become -v
$ ansible -i hosts k8s_nodes -m systemd -a "name=docker.socket state=stopped enabled=no" -u deploy --become -v
$ ansible -i hosts k8s_nodes -m systemd -a "name=containerd state=stopped enabled=no" -u deploy --become -v
$ ansible -i hosts k8s_nodes -m systemd -a "daemon_reload=yes" -u deploy --become -v

$ ansible -i hosts k8s_nodes -m shell -a "rm -v /usr/lib/systemd/system/docker.service" -u deploy --become -v
$ ansible -i hosts k8s_nodes -m shell -a "rm -v /usr/lib/systemd/system/docker.socket" -u deploy --become -v
$ ansible -i hosts k8s_nodes -m shell -a "rm -v /usr/lib/systemd/system/containerd.service" -u deploy --become -v

$ ansible -i hosts k8s_nodes -m shell -a "rm -vrf /run/docker" -u deploy --become -v
$ ansible -i hosts k8s_nodes -m shell -a "rm -vrf /run/containerd" -u deploy --become -v

$ ansible -i hosts k8s_nodes -m shell -a "rm -vr /etc/docker" -u deploy --become -v
$ ansible -i hosts k8s_nodes -m shell -a "rm -vrf /var/lib/docker" -u deploy --become -v
$ ansible -i hosts k8s_nodes -m shell -a "rm -vrf /var/lib/containerd" -u deploy --become -v
$ ansible -i hosts k8s_nodes -m shell -a "rm -vrf /var/lib/dockershim" -u deploy --become -v
```

#### Remove k8s-master cluster

```bash
$ ansible -i hosts all -m shell -a "systemctl stop kube-scheduler" -u deploy --become -vvv
$ ansible -i hosts all -m shell -a "systemctl disable kube-scheduler" -u deploy --become -vvv
$ ansible -i hosts all -m shell -a "rm /usr/lib/systemd/system/kube-scheduler.service" -u deploy --become -vvv

$ ansible -i hosts all -m shell -a "systemctl stop kube-controller-manager" -u deploy --become -vvv
$ ansible -i hosts all -m shell -a "systemctl disable kube-controller-manager" -u deploy --become -vvv
$ ansible -i hosts all -m shell -a "rm /usr/lib/systemd/system/kube-controller-manager.service" -u deploy --become -vvv

$ ansible -i hosts all -m shell -a "systemctl stop kube-apiserver" -u deploy --become -vvv
$ ansible -i hosts all -m shell -a "systemctl disable kube-apiserver" -u deploy --become -vvv
$ ansible -i hosts all -m shell -a "rm /usr/lib/systemd/system/kube-apiserver.service" -u deploy --become -vvv

$ ansible -i hosts all -m shell -a "rm -fr /etc/kubernetes" -u deploy --become  -vvv
$ ansible -i hosts all -m shell -a "rm -fr /var/log/kubernetes" -u deploy -v --become
$ ansible -i hosts all -m shell -a "rm /tmp/kube-*" -u deploy --become -vvv
$ ansible -i hosts all -m shell -a "rm -fr /tmp/kubernetes" -u deploy -v --become
$ ansible -i hosts all -m shell -a "rm -fr /home/deploy/.kube" -u deploy -v --become
```

#### Remove etcd cluster

```bash
$ ansible -i hosts all -m shell -a "systemctl stop etcd" -u deploy --become -vvv
$ ansible -i hosts all -m shell -a "systemctl disable etcd" -u deploy --become -vvv
$ ansible -i hosts all -m shell -a "rm /usr/lib/systemd/system/etcd.service" -u deploy --become -vvv

$ ansible -i hosts all -m shell -a "rm -fr /etc/etcd" -u deploy --become  -vvv
$ ansible -i hosts all -m shell -a "rm -fr /var/lib/etcd" -u deploy -v --become
$ ansible -i hosts all -m shell -a "rm -fr /usr/local/bin/*" -u deploy -v --become
$ ansible -i hosts all -m shell -a "rm -fr /tmp/etcd*" -u deploy -v --become
```

#### 更新并重启

```bash
$ ansible -i hosts all -m shell -a "/opt/bin/update-system.sh" -u deploy -v --become
$ ansible -i hosts all -m shell -a "reboot" -u deploy -v --become
$ ansible -i hosts k8s_nodes -m reboot -u deploy --become -v
```

#### 安装服务


```bash
# Install Ectd Cluster
$ ansible-playbook -i hosts etcd.yml -u deploy -v

# Install k8s Master Cluster
$ ansible-playbook -i hosts k8s-master.yml -u deploy -v

# Install k8s Node Cluster
$ ansible-playbook -i hosts k8s-node.yml -u deploy -v
```

```bash
$ ansible -vvv -m script -a '/opt/bin/update-system.sh' k8s

$ ansible -m shell -a 'ip address show enp1s0' k8s
```


```bash
$ ansible -m command -a 'reboot' --become k8s

$ ansible -m shell -a 'virsh list --name | xargs -i virsh shutdown {}' hostos

$ ansible -m script -a '/opt/bin/update-system.sh' hostos
$ ansible -m script -a '/opt/bin/update-system.sh' k8s
```





```bash
$ ansible k8s --list-hosts
$ ansible k8s -m script -a '/opt/bin/update-system.sh'

$ ansible proxy-server.local -m script -a '/opt/bin/update-system.sh'
```

#### Kubernetes Cluster Restart

```bash
$ ansible -m command -a 'reboot' --become k8s

$ ansible -m command -a 'swapoff -a' --become k8s
```