# 手动操作`SOP`

## 准备工作

```bash
$ gem install sshkit
$ gem install sshkit-sudo

$ gem install ed25519
$ gem install bcrypt_pbkdf
```

## 初始化新`K8S Worker`节点

创建新用户`deploy`

```bash
$ ./awesome user k8s-node003 deploy
$ ./awesome user k8s-node004 deploy
$ ./awesome user k8s-node008 deploy
$ ./awesome user k8s-node009 deploy
```

基础配置

```bash
$ ./awesome setup k8s-node003 deploy
$ ./awesome setup k8s-node004 deploy
$ ./awesome setup k8s-node008 deploy
$ ./awesome setup k8s-node009 deploy
```

`ntp`配置

```bash
$ ./awesome ntp k8s-node003 deploy
$ ./awesome ntp k8s-node004 deploy
$ ./awesome ntp k8s-node008 deploy
$ ./awesome ntp k8s-node009 deploy
```

内核优化

```bash
$ ./awesome kernel k8s-node003 deploy
$ ./awesome kernel k8s-node004 deploy
$ ./awesome kernel k8s-node008 deploy
$ ./awesome kernel k8s-node009 deploy
```

安装`docker`

```bash
$ ./awesome docker k8s-node003 deploy
$ ./awesome docker k8s-node004 deploy
$ ./awesome docker k8s-node008 deploy
$ ./awesome docker k8s-node009 deploy
$ ./awesome docker ubuntu-desktop.local james
$ ./awesome docker code-server.local james
```