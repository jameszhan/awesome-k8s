

```bash
$ systemctl status docker.service
$ systemctl status docker.socket
$ systemctl status containerd.service
```

- `docker.service`: `/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock`
- `docker.socket`: `/var/run/docker.sock`
- `containerd.service`: `/usr/bin/containerd`

