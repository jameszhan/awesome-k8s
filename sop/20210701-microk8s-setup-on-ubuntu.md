# 快速搭建`microk8s`环境

## TL;DR

### 基于`Ansible`

```bash
$ cd debian-based/ansible

# 新增deploy用户
$ ansible-playbook -i k8s-local.cfg -c paramiko --ask-pass --ask-become-pass create-user.yml -v

# 快速部署本地集群
$ ansible-playbook -i k8s-local.cfg microk8s_init.yml -u deploy -v
```

本例中`k8s-local.cfg`主要配置内容如下:

```ini
[microk8s]
k8s-node003 ansible_host=192.168.1.59
```

### 基于`SSHKit`

```bash
# 新增deploy用户
$ ./awesome user ubuntu-desktop.local deploy
# 快速部署本地集群
$ ./awesome microk8s ubuntu-desktop.local james --channel=1.23/stable
```

## 环境说明

- 服务端操作系统: Ubuntu 20.04.3 LTS
- 服务端`k8s`: MicroK8s v1.23.1

## 安装k8s

### 安装前准备

- [x] 确保`snap`已安装，如果未安装，可以使用如下命令安装:
  
```bash
$ sudo apt -y install snapd
$ sudo snap refresh
```

### 安装MicroK8S

#### 安装 microK8S v1.23

```bash
# 查看可安装的版本
$ sudo snap info microk8s

$ sudo snap remove microk8s
$ sudo snap install microk8s --classic --channel=1.23/stable

# 检查状态
$ microk8s.status

# 定位失败原因
$ microk8s.inspect

# 等待节点Ready
$ microk8s.kubectl get nodes -o wide
```

在不翻墙情况下，正常`pod`都是不能正常启动的，需要我们手动导入镜像。

```bash
$ microk8s.ctr images pull registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.1
$ microk8s.ctr images tag registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.1 k8s.gcr.io/pause:3.1
$ microk8s ctr images pull registry.cn-hangzhou.aliyuncs.com/google_containers/metrics-server:v0.5.2
$ microk8s ctr images tag registry.cn-hangzhou.aliyuncs.com/google_containers/metrics-server:v0.5.2 k8s.gcr.io/metrics-server/metrics-server:v0.5.2

$ microk8s.ctr images list
```

#### 后续配置

##### 配置`alias`

```bash
$ alias kubectl='microk8s.kubectl'
$ sudo usermod -a -G microk8s deploy
```

##### 配置私有镜像库

如果想使用私有镜像仓库，可以使用如下方式添加。

```bash
$ sudo su - root
# 增加本地DNS配置

# 如果有安装docker请增加如下配置
$ cat <<EOF > /etc/docker/daemon.json
{
    "insecure-registries" : ["localhost:32000"]
}
EOF
```

##### microK8s 镜像配置私有镜像库

编辑`containerd-template.toml`文件， 在节点`[plugins.cri.registry.mirrors]`下增加如下内容:

```bash
$ vim /var/snap/microk8s/current/args/containerd-template.toml
```
```toml
[plugins.cri.registry.mirrors."localhost:32000"]
  endpoint = ["http://localhost:32000"]
```

重启`microK8s`服务

```bash
$ microk8s.stop
$ microk8s.start
```







