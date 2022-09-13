```bash
$ gem install thor
$ gem install sshkit
$ gem install sshkit-sudo
$ gem install ed25519
$ gem install bcrypt_pbkdf

$ chmod +x awesome
```

```bash
$ export SUDO_USER=james
$ ./awesome

# 创建新用户deploy
$ ./awesome user k8s-node005 deploy

# 进行必要设置
$ ./awesome setup k8s-node005 deploy
```