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



```bash
$ ansible -i hosts all -m shell -a "rm -fr /etc/etcd/ssl" -u deploy -v --become
$ ansible -i hosts all -m shell -a "rm -fr /usr/local/bin/kubernetes" -u deploy -v --become

$ ansible-playbook -i hosts k8s-deploy.yml -u deploy -v
```

#### 批量设置免登

```bash
$ for h in k8s-master01 k8s-master02 k8s-master03; do ssh-copy-id -i ~/.ssh/id_rsa.pub james@$h; done
```



