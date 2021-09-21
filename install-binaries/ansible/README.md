## 准备通用环境

#### 安装`Ansible`

以下命令都是基于[ansible](https://docs.ansible.com/ansible/latest/installation_guide/index.html)来执行，如果你本地安装了python，可以使用命令`python -m pip install ansible`来安装。

#### 准备安装文件

> 为了加快安装速度，建议提前把一下文件下载到本地。
```conf
binaries
└── x86_64
    ├── cfssl
    │   ├── cfssl-certinfo_1.6.1_linux_amd64
    │   ├── cfssl-newkey_1.6.1_linux_amd64
    │   ├── cfssl-scan_1.6.1_linux_amd64
    │   ├── cfssl-bundle_1.6.1_linux_amd64
    │   ├── mkbundle_1.6.1_linux_amd64
    │   ├── multirootca_1.6.1_linux_amd64
    │   ├── cfssl_1.6.1_linux_amd64
    │   └── cfssljson_1.6.1_linux_amd64
    ├── docker
    │   ├── docker-19.03.9.tgz
    │   ├── docker-20.10.8.tgz
    │   ├── docker-rootless-extras-19.03.9.tgz
    │   └── docker-rootless-extras-20.10.8.tgz
    ├── etcd
    │   └── etcd-v3.5.0-linux-amd64.tar.gz
    └── kubernetes
        ├── kubernetes-server-v1.19.13-linux-amd64.tar.gz
        ├── kubernetes-server-v1.20.10-linux-amd64.tar.gz
        ├── kubernetes-server-v1.21.2-linux-amd64.tar.gz
        ├── kubernetes-server-v1.21.4-linux-amd64.tar.gz
        └── kubernetes-server-v1.22.1-linux-amd64.tar.gz
```

- [cfssl](https://github.com/cloudflare/cfssl/releases)
- [docker](https://download.docker.com/linux/static/stable/x86_64/)
- [etcd](https://github.com/etcd-io/etcd/releases)
- [kubernetes](https://storage.googleapis.com/kubernetes-release)

按以上目录结构组织文件，按以下方式启动本地文件服务
```bash
$ python -m http.server
```
修改`group_vars/global_vars.yml`中的`binaries_fs`为`http://[YOUR-IP]:8000`。

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



