#### `CRI`分析

```bash
$ systemctl status docker.service
$ systemctl status docker.socket
$ systemctl status containerd.service
```

- `docker.service`: `/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock`
- `docker.socket`: `/var/run/docker.sock`
- `containerd.service`: `/usr/bin/containerd`


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