# 配置你的服务器-k8s环境

## 环境说明

- 服务端操作系统: Ubuntu Server 20.04
- 服务端k8s: MicroK8s v1.22.2

## 安装k8s

### 安装前准备

- [x] 确保snap已安装，如果未安装，可以使用如下命令安装:
  
```bash
$ sudo apt -y install snapd
$ sudo snap refresh
```

### 安装MicroK8S

<del>由于BFW的限制，某些镜像不能顺利下载，会导致安装失败，建议先从1.18版本安装，再逐步升级到1.22。</del>

#### 安装 microK8S v1.22

```bash
$ sudo snap remove microk8s
$ sudo snap info microk8s
$ sudo snap install microk8s --classic --channel=1.22/stable

# 检查状态
$ microk8s.status
# 定位失败原因
$ microk8s.inspect

# 等待节点Ready
$ microk8s.kubectl get nodes -o wide
```

在不翻墙情况下，正常pod都是不能正常启动的，需要我们手动导入镜像。

```bash
$ microk8s.ctr images pull registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.1
$ microk8s.ctr images tag registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.1 k8s.gcr.io/pause:3.1
$ microk8s.ctr images list
```

##### 升级到1.22

```bash
$ sudo snap refresh microk8s --classic --channel=1.22/stable
$ microk8s.kubectl version
$ microk8s.kubectl get all -A -o wide
```

#### 后续配置

##### 配置alias

```bash
$ alias kubectl='microk8s.kubectl'
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







