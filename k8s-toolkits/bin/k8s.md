```bash
$ gem install thor
$ gem install sshkit
$ gem install sshkit-sudo
$ gem install ed25519
$ gem install bcrypt_pbkdf
```

#### Setup User Deploy

```bash
$ export SUDO_USER=james
$ export SUDO_PASS=sudouserpass

$ ./k8s user 192.168.1.62 deploy
$ ./k8s user 192.168.1.111 deploy
$ ./k8s user 192.168.1.112 deploy
$ ./k8s user 192.168.1.119 deploy

$ ./k8s setup 192.168.1.62 deploy
$ ./k8s setup 192.168.1.111 deploy
$ ./k8s setup 192.168.1.112 deploy
$ ./k8s setup 192.168.1.119 deploy
```

