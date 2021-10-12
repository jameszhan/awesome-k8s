
#### `TCP/IP`

##### 01. `TCP`协议中是不是所有执行主动关闭的`Socket`都会进入`TIME_WAIT`状态呢？

> 主动关闭的一方在发送最后一个`ACK`后就会进入`TIME_WAIT`状态，并停留`2MSL(报文最大生存)`时间，这是`TCP/IP`必不可少的，也就是说这一点是"解决"不了的。`TCP/IP`设计者如此设计，主要原因有两个：
- 防止上一次连接中的包迷路后重新出现，影响新的连接(经过`2MSL`时间后，上一次连接中所有重复的包都会消失)。
- 为了可靠地关闭`TCP`连接。主动关闭方发送的最后一个`ACK(FIN)`有可能会丢失，如果丢失，被动方会重新发送`FIN`，这时如果主动方处于`CLOSED`状态，就会响应`RST`而不是`ACK`。所以主动方要处于`TIME_WAIT`状态，而不能是`CLOSED`状态。另外，`TIME_WAIT`并不会占用很大的资源，除非受到攻击。

##### 02. 大家来思考一个问题：为什么`TIME_WAIT`状态还需要等`2MSL(报文最大生存时间)`后才能返回到CLOSED状态呢？

> 答案是虽然双方都同意关闭连接了，而且握手的4个报文也都协调好并发送完毕，按理可以直接回到`CLOSED`状态(就好比从`SYN_SEND`状态到`ESTABLISH`状态一样)，但是因为我们必须要假设网络是不可靠的，你无法保证最后发送的`ACK`报文一定会被对方收到，比如对方正处于`LAST_ACK`状态下的`Socket`可能会因为超时未收到`ACK`报文，这时就需要重发`FIN`报文，所以这个`TIME_WAIT`状态的作用就是用来重发可能丢失了的`ACK`报文的。

##### 03.如何查看进程打开的`socket`数量？

> `ls -l /proc/832/fd | grep socket | wc -l`


#### `Docker`

##### 如何免`sudo`权限运行`docker`命令?

```bash
$ sudo usermod -aG docker james
```

##### 如何清理所有已退出的容器

```bash
$ docker rm -v $(docker ps -a -q -f status=exited)
```

> `docker system prune --all` will delete ALL dangling data.

#### `Kubernetes`

##### `kubectl get cs`状态为`Unhealthy`

```bash
$ kubectl get cs
Warning: v1 ComponentStatus is deprecated in v1.19+
NAME                 STATUS      MESSAGE                                                                                       ERROR
controller-manager   Unhealthy   Get "http://127.0.0.1:10252/healthz": dial tcp 127.0.0.1:10252: connect: connection refused
scheduler            Unhealthy   Get "http://127.0.0.1:10251/healthz": dial tcp 127.0.0.1:10251: connect: connection refused
etcd-0               Healthy     {"health":"true"}
```

```bash
# 注释掉 - --port=0
$ sudo vim /etc/kubernetes/manifests/kube-controller-manager.yaml  
$ sudo vim /etc/kubernetes/manifests/kube-scheduler.yaml
$ sudo systemctl restart kubelet.service
```
> 注：不处理也没有关系，这个API已经计划移除了。

#####  unable to do port forwarding: socat not found

```bash
$ sudo apt -y update && sudo apt -y install socat
```

##### Failed to set bridge addr cni0

> 删除错误网卡，他会自动重建

```bash
$ sudo ifconfig cni0 down
$ sudo ip link delete cni0
```

#### `GIT`

##### 如何设置全局`gitignore`?

```bash
$ git config core.filemode false

# 设置全局gitignore
$ touch ~/.gitignore_global
$ git config --global core.excludesfile ~/.gitignore_global
$ git config --get core.excludesfile
```

##### 在使用`git`拉取`github`代码时候，`clone`失败并出现以下错误

> `fatal: unable to access` '`https://github.com/xxx/xxx.git/`': `LibreSSL SSL_connect: SSL_ERROR_SYSCALL in connection to github.com:443`

- 出现原因: 之前设置了https的代理
- 解决方法: 取消https和http代理

```bash
$ git config --global --unset http.proxy
$ git config --global --unset https.proxy
$ git config --global --list
```

##### `git clone`失败`fatal: early EOF`

> 这是由于`git`的缓存空间不够，可以尝试将`http.postBuffer`提高(提高到`500Mb`)

```bash
$ git config --global http.postBuffer 524288000
```

##### `github.io`被劫持到`127.0.0.1`

常见的公共 DNS

| Provider   | 主地址       | 备份地址  |
| ---------- | ------------ | --------- |
| 阿里       | 223.5.5.5    | 223.6.6.6 |
| 百度       | 180.76.76.76 |           |
| 腾讯       | 119.29.29.29 |           |
| 谷歌       | 8.8.8.8      | 8.8.4.4   |
| 微软       | 4.2.2.1      | 4.2.2.2   |
| CloudFlare | 1.1.1.1      | 1.0.0.1   |

定位`github.io`被劫持问题

```bash
$ ping github.io
$ nslookup github.io
$ dig github.io

$ dig github.io @8.8.8.8
$ dig github.io @223.5.5.5
```

##### 如何加速`github.com`的访问?

利用 [IPAddress.com](https://www.ipaddress.com/) 查询以下三个地址：
- github.com
- assets-cdn.github.com
- github.global.ssl.fastly.net

根据查询到的地址，新增`/etc/hosts`配置

```hosts
140.82.112.4    github.com

185.199.108.153 assets-cdn.github.com
185.199.109.153 assets-cdn.github.com
185.199.110.153 assets-cdn.github.com
185.199.111.153 assets-cdn.github.com

199.232.69.194  github.global.ssl.fastly.net
```

如果某个仓库拉取慢，这里提供两个最常用的镜像地址：

- https://github.com.cnpmjs.org
- https://hub.fastgit.org
- [GitHub 下载加速](https://toolwa.com/github/)


#### `libvirt`

##### How to use virsh without sudo?

```bash
$ source /etc/profile.d/libvirt-uri.sh
```