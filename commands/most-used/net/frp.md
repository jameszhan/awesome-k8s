
[frp](https://github.com/fatedier/frp)

```bash
$ wget https://github.com/fatedier/frp/releases/download/v0.37.0/frp_0.37.0_linux_amd64.tar.gz
```


```bash
$ sudo vim /lib/systemd/system/frps.service

$ sudo systemctl start frps
$ sudo systemctl enable frps
$ sudo systemctl status frps
```

```conf
[Unit]
Description=frps service
After=network.target syslog.target
Wants=network.target

[Service]
Type=simple
ExecStart=/opt/local/shared/current/frp/frps -c /opt/local/shared/current/frp/frps.ini

[Install]
WantedBy=multi-user.target
```


```bash
$ nohup ./frpc -c ./frpc.ini &
```

```bash
$ ssh -oPort=6000 my.tencent.com

$ ssh -oPort=22222 frp.zizhizhan.com
```


```conf
[Unit]
Description=frpc service
After=network.target syslog.target
Wants=network.target

[Service]
Type=simple
ExecStart=/opt/local/shared/current/frp/frps -c /opt/local/shared/current/frp/frps.ini

[Install]
WantedBy=multi-user.target
```