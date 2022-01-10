# macOS 配置集群

## 准备虚拟机

### 准备工作

#### 安装`multipass`

```bash
$ brew install --cask multipass
$ multipass version
multipass   1.8.1+mac
multipassd  1.8.1+mac
```

#### 配置`cloud-init`

```bash
$ ssh-keygen -t ed25519 -C "zizhizhan@gmail.com"
$ ssh -T git@github.com
$ cat <<YAML >> /opt/etc/cloud-init/multipass.yaml
users:
  - name: ubuntu
    groups: [adm]
    sudo: ["ALL = (ALL) NOPASSWD: ALL"]
    shell: /bin/bash
    ssh-authorized-keys:
      - ssh-ed25519 AAAAC3EXAMPLE... zizhizhan@gmail.com
YAML
```

### 安装虚拟机

```bash
$ multipass find
$ multipass launch --name=k8s-master01 --cloud-init=/opt/etc/cloud-init/multipass.yaml focal
$ multipass launch --name=k8s-master02 --cloud-init=/opt/etc/cloud-init/multipass.yaml focal
$ multipass launch --name=k8s-master03 --cloud-init=/opt/etc/cloud-init/multipass.yaml focal
$ multipass list

$ ssh ubuntu@`multipass list | grep master01 | awk '{print $3}'`
$ ssh ubuntu@`multipass list | grep master02 | awk '{print $3}'`
$ ssh ubuntu@`multipass list | grep master03 | awk '{print $3}'`
```

## 安装`k8s`

### 安装`etcd`

```bash
$ brew install cfssl
$ cfssl version

$ gem install sshkit
$ gem install sshkit-sudo
$ gem install ed25519
$ gem install bcrypt_pbkdf

$ ./macos etcd 192.168.64.7 ubuntu --name=etcd01 --clusterips=192.168.64.7,192.168.64.8,192.168.64.9
```