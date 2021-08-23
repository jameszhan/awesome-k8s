

```bash
$ apt -y install sudo
$ usermod -a -G sudo james
$ echo 'james ALL = (ALL) NOPASSWD: ALL' > /etc/sudoers.d/james
```

```bash
# 设置当前时区
$ timedatectl
$ sudo timedatectl set-timezone Asia/Shanghai

# 设置本地化参数。
$ sudo dpkg-reconfigure locales
$ localectl
# $ sudo localectl set-locale LANG=zh_CN.utf8
$ sudo localectl set-locale LANG=en_US.UTF-8
$ sudo localectl set-keymap en_US
```