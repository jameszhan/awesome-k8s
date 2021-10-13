#### Prerequisites

新增`deploy`用户

```bash
$ ansible-playbook -i k8s-local.cfg -c paramiko --ask-pass --ask-become-pass create-user.yml -v
```

安装必要软件

```bash
$ ansible-playbook -i k8s-local.cfg setup-once.yml -u deploy -v

# 重启服务
$ ansible -i k8s-local.cfg all -m reboot -u deploy --become -v
```


```bash
# 安装etcd
$ ansible-playbook -i hosts -l k8s_workers docker.yml -u deploy -v

# 安装docker
$ ansible-playbook -i hosts -l k8s_workers docker.yml -u deploy -v
```


#### 时间同步检查

```bash
$ ansible -i k8s-local.hosts all -m shell -a 'chronyc sources -v' -u deploy --become -v
$ ansible -i k8s-local.hosts all -m shell -a 'chronyc sourcestats' -u deploy --become -v
```