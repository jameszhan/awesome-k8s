## 准备通用环境

#### 安装`Ansible`

以下命令都是基于[ansible](https://docs.ansible.com/ansible/latest/installation_guide/index.html)来执行，如果你本地安装了python，可以使用命令`python -m pip install ansible`来安装。

#### 创建新用户`deploy`

在创建新用户前，你只需要有任意一个用户可以免登到对应的服务器上即可。

```bash
$ ansible-playbook -i hosts -c paramiko --ask-pass --ask-become-pass user-deploy.yml -v

$ ansible -i hosts all -m ping -u deploy

$ ansible -i hosts all -m apt 
```

#### 安装etcd

```bash
$ ansible -i hosts all -m shell -a "systemctl stop etcd" -u deploy -v --become
$ ansible -i hosts all -m shell -a "systemctl disable etcd" -u deploy -v --become
$ ansible -i hosts all -m shell -a "rm -fr /etc/etcd" -u deploy -v --become
$ ansible -i hosts all -m shell -a "rm -fr /var/lib/etcd" -u deploy -v --become

$ ansible-playbook -i hosts etcd.yml -u deploy -v
```

```bash
$ ETCDCTL_API=3 /usr/local/bin/etcdctl --write-out=table --cacert=/etc/etcd/ssl/ca.pem --cert=/etc/etcd/ssl/etcd.pem --key=/etc/etcd/ssl/etcd-key.pem --endpoints=https://192.168.1.61:2379,https://192.168.1.62:2379,https://192.168.1.63:2379 endpoint health
```

#### 批量设置免登

```bash
$ for h in k8s-master01 k8s-master02 k8s-master03; do ssh-copy-id -i ~/.ssh/id_rsa.pub james@$h; done
```



