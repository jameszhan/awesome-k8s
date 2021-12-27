#### 创建新用户`deploy`

在创建新用户前，你只需要有任意一个用户可以免登到对应的服务器上即可。

```bash
$ ansible-playbook -i hosts -c paramiko --ask-pass --ask-become-pass user-deploy.yml -v
$ ansible -i hosts all -m ping -u deploy
```

#### 更新系统

```bash
$ ansible -i hosts k8s_nodes -m script -a "/opt/bin/update-system.sh" -u deploy -v
$ ansible -i hosts k8s_nodes -m reboot -u deploy --become -v
```