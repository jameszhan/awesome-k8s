

```bash
$ docker run -it --rm debian:stretch-slim bash
$ docker run -it --rm busybox sh
$ docker run -it --rm cirros sh
```


免`sudo`权限运行`docker`命令

```bash
$ sudo usermod -aG docker james
```


##### Install Docker Compose

```bash
$ sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /opt/bin/docker-compose
$ sudo chmod +x /opt/bin/docker-compose
$ docker-compose --version
```