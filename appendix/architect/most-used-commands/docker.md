
```bash
$ docker login --username=zizhi****@gmail.com registry.cn-shenzhen.aliyuncs.com
$ sudo docker login --username=zizhi****@gmail.com registry.cn-shenzhen.aliyuncs.com
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