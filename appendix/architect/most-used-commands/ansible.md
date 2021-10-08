

#### Install Ansible

```bash
$ python -m ensurepip
$ python -m pip install -v --upgrade ansible
$ ansible --version
```

#### Ansible 常用模块
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

#### 命令实操

```bash
$ ansible -i hosts all -m shell -a "ipvsadm -Ln" -u deploy --become -v
```

```bash
$ ansible -i hosts k8s_nodes -m shell -a 'rm -vrf /etc/cni/net.d/*' -u deploy --become -v
$ ansible -i hosts k8s_nodes -m shell -a 'rm -vrf /var/lib/cni/calico' -u deploy --become -v
$ ansible -i hosts k8s_nodes -m shell -a 'systemctl restart kubelet' -u deploy --become -v
```