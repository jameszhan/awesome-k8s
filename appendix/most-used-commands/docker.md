
```bash
$ docker login --username=zizhi****@gmail.com registry.cn-shenzhen.aliyuncs.com
$ sudo docker login --username=zizhi****@gmail.com registry.cn-shenzhen.aliyuncs.com
$ sudo docker login --username=****@gmail.com registry.cn-shenzhen.aliyuncs.com
```

```bash
$ docker run -it --rm debian:stretch-slim bash
$ docker run -it --rm busybox sh
$ docker run -it --rm cirros sh


$ docker pull google/cadvisor

$ docker run \
  --volume=/var/run:/var/run:rw \
  --volume=/sys/fs/cgroup/:/sys/fs/cgroup:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --publish=8080:8080 \
  --detach=true \
  google/cadvisor

$ curl -i http://192.168.1.95:8080
```

#### 网络管理

```bash
$ sudo docker run -it busybox ip addr show
$ sudo docker run --net=none -it busybox ip addr show
```

##### Install Docker Compose

```bash
$ sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /opt/bin/docker-compose
$ sudo chmod +x /opt/bin/docker-compose
$ docker-compose --version
```

#### `CRI`分析

```bash
$ systemctl status docker.service
$ systemctl status docker.socket
$ systemctl status containerd.service
```

- `docker.service`: `/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock`
- `docker.socket`: `/var/run/docker.sock`
- `containerd.service`: `/usr/bin/containerd`


#### 导出镜像

```bash
$ sudo docker pull busybox
$ sudo docker save -o busybox.tar busybox:latest

$ sudo docker pull debian:buster-slim
$ sudo docker save -o debian.tar debian:buster-slim

$ sudo docker pull ubuntu:focal
$ sudo docker save -o ubuntu.tar ubuntu:focal
```

##### `chroot`实践

```bash
$ sudo chown -R james:sudo debian.tar
$ mkdir debian
$ tar xvf debian.tar -C debian
$ cd debian
$ mkdir rootfs
$ tar xvf 9b972f928131fd1fbbf16b7ea906a874e6be6cb13320e791b6d250bfce44b66a/layer.tar -C rootfs
$ sudo chroot rootfs /bin/bash -i
```

```bash
$ cat /etc/os-release 
```


#### 查看镜像构建详细记录

使用如下命令，可以清楚地查看到`nginx`镜像使用了哪些`image layer`。

```bash
$ docker history nginx
```