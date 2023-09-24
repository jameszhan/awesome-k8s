## 创建新用户

> 以下操作基于`root`用户

```bash
# 创建新用户
$ useradd -m -s /bin/bash -u 1000 ubuntu
$ mkdir /home/ubuntu/.ssh
$ cp /root/.ssh/authorized_keys /home/ubuntu/.ssh
$ chown -R ubuntu:ubuntu /home/ubuntu/.ssh

# 配置`sudo`免密
$ echo 'ubuntu ALL = (ALL) NOPASSWD: ALL' | tee /etc/sudoers.d/ubuntu > /dev/null

$ su - ubuntu
```