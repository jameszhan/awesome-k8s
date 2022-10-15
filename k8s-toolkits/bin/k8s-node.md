```bash
$ ./k8s docker 192.168.1.111 deploy
$ ssh k8s-node011 -t docker version
$ ssh k8s-node011 -t systemctl status docker

$ ./k8s docker 192.168.1.112 deploy
$ ./k8s docker 192.168.1.113 deploy
```