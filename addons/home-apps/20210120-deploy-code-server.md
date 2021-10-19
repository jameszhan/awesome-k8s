#### 安装`code-server`

```bash
$ curl -fOL https://github.com/cdr/code-server/releases/download/v$VERSION/code-server_$VERSION_amd64.deb
$ sudo dpkg -i code-server_$VERSION_amd64.deb
```

#### 配置systemd服务

为避免用户有过大的权限，应该设置一个独立用户`code`，如已经创建，则忽略。

```bash
$ sudo useradd -m -s /bin/bash code
$ sudo usermod -aG www-data code
$ mkdir -p /opt/omnifocus/codehub/code-server
$ mkdir -p /opt/var/codeserver/extensions

$ sudo chown -R code:code /opt/var/codeserver/extensions
$ sudo chown -R code:code /opt/omnifocus/codehub/code-server

$ sudo su - code
$ mkdir -p ~/.config/code-server
$ cat <<EOF | tee ~/.config/code-server/config.yaml
bind-addr: 0.0.0.0:8080
auth: password
password: YOUR-PASSWORD
cert: false
user-data-dir: /opt/omnifocus/codehub/code-server
extensions-dir: /opt/var/codeserver/extensions
EOF
# 返回sudo用户
$ exit

$ sudo systemctl enable --now code-server@code
```

#### 配置`ingress`服务

```bash
$ kubectl apply -f templates/code-server.deploy.yaml

$ open https://code.zizhizhan.com
```

#### 参考资料

- [code-server](https://github.com/cdr/code-server)
- [Install code-server](https://coder.com/docs/code-server/latest/install)
